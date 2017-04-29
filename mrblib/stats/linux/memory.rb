module Stats
  module Linux
    class Memory < Base
      def initialize(meminfo_file='/proc/meminfo')
        collect(meminfo_file, 1)
      end

      def column_keys
        %i(
          total
          use
          percent
        )
      end

      class << self
        def read(file)
          ::File.read(file).chomp.split("\n").each_with_object({}) do |line,r|
            if line =~ /(.+):\s+([0-9]+) kB$/
              k = $~[1].to_sym
              v = $~[2].to_f
              r[k] = v
            end
          end
        end

        def current(stat_file='/proc/meminfo')
          memory = read(stat_file)
          total = memory[:MemTotal]
          use = if memory.key?(:MemAvailable)
                  total - memory[:MemAvailable]
                else
                  total - memory[:MemFree] - memory.inject(0) do |r,m|
                    if m[0] =~ /^Active|^Inactive/
                      r += m[1]
                    end
                  end
                end
          { total: total, use: use, percent: sprintf("%3.2f",  use / total * 100).to_f }
        end
      end
    end
  end
end
