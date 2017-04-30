module Stats
  module Linux
    class Disk < Base
      SECTOR_SIZE=512
      SECTOR_SIZE.freeze
      def initialize(file='/proc/diskstat')
        collect(file)
      end

      def column_keys
        Stats::Linux::Disk.display_format
      end

      class << self
        def current(file='/proc/diskstats', sleep=1)
          b = read(file)
          sleep sleep
          a = read(file)
          diff(b, a)
        end

        def display_format
          %i(
            read
            write
            read_kbyte
            write_kbyte
          )
        end
        private
        def read(file)
          disks = ::File.read(file).chomp.split("\n").each_with_object(Hash.new { |h,k| h[k] = {} }) do |line,r|
            pattern = diskstat_format.values.join('\s+')
            if line =~ /^\s+#{pattern}$/
              next if $~[4].to_i == 0 || !device?($~[3])
              diskstat_format.keys.each_with_index do |k,i|
                r[$~[3]][k] = $~[i+1]
              end
            end
          end

          disks.each_with_object(Hash.new { |h,k| h[k] = {} }) do |d,r|
            d[1].each do |c|
              case c[0]
              when :rd_ios
                r[d[0]][:read] = c[1]
              when :wr_ios
                r[d[0]][:write] = c[1]
              when :rd_sec_or_wr_ios
                r[d[0]][:read_kbyte] = c[1].to_f * SECTOR_SIZE / 1024
              when :wr_sec
                r[d[0]][:write_kbyte] = c[1].to_f * SECTOR_SIZE / 1024
              end
            end
          end
        end

        def diff(before, after)
          r = []
          before.each_with_object(Hash.new { |h,k| h[k] = {}}) do |b,r|
            display_format.each do |k|
              r[b[0]][k] = after[b[0]][k].to_f - b[1][k].to_f
            end
          end
        end

        def diskstat_format
          {
            major: "([0-9]+)",
            minor: "([0-9]+)",
            dev_name: "([^\s]+)",
            rd_ios: "([0-9]+)",               # reads completed
            rd_merges_or_rd_sec: "([0-9]+)",  # of reads merged
            rd_sec_or_wr_ios: "([0-9]+)",     # of sectors read
            rd_ticks_or_wr_sec: "([0-9]+)",   # milliseconds spent reading
            wr_ios: "([0-9]+)",               # of writes completed
            wr_merges: "([0-9]+)",            # of writes merged
            wr_sec: "([0-9]+)",               # of sectors written
            wr_ticks: "([0-9]+)",             # of milliseconds spent writing
            ios_pgr: "([0-9]+)",              # of I/Os currently in progress
            tot_ticks: "([0-9]+)",            # of milliseconds spent doing I/Os
            rq_ticks: "([0-9]+)",             # of milliseconds spent doing I/Os
          }
        end
      end
    end
  end
end
