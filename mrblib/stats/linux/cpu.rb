module Stats
  module Linux
    class CPU < Base
      COLUMNS={ user: 0, sys: 1, nice: 2, idle:3 }
      COLUMNS.freeze

      def initialize(file='/proc/stat')
        collect(file)
      end

      def column_keys
        COLUMNS.keys
      end

      private

      class << self
        def current(file='/proc/stat', sleep=1)
          before = parse_stats(file)
          sleep sleep
          after = parse_stats(file)
          calc(before, after)
        end

        private
        def read(file)
          ::File.read(file).chomp.split("\n")[0].split
        end

        def parse_stats(file)
          stat = read(file)
          if stat.size < 8
            raise "invalid number of cpu fields"
          end
          stat[1..-1]
        end

        def diff(before, after)
          r = []
          before.each_with_index do |b,i|
            r << after[i].to_i - b.to_i
          end
          r
        end

        def calc(before, after)
          d = diff(before, after)
          total = d.inject(0) {|sum,n| sum += n.to_i }

          # inject does not work with mrbtest
          result = {}
          COLUMNS.each do |v|
            result[v[0]] = sprintf("%3.2f",  d[v[1]] / total * 100.0).to_f
          end
          result
        end
      end
    end
  end
end
