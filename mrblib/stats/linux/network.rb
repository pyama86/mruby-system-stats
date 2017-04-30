module Stats
  module Linux
    class Network < Base
      def initialize(file='/proc/diskstat')
        collect(file)
      end

      def column_keys
        Stats::Linux::Network.display_format
      end

      class << self
        def current(file='/proc/net/dev', sleep=1)
          b = read(file)
          sleep sleep
          a = read(file)
          diff(b, a)
        end

        def display_format
          %i(
            receive_byte
            transmit_byte
          )
        end

        private
        def read(file)
          ::File.read(file).chomp.split("\n")[2..-1].each_with_object(Hash.new { |h,k| h[k] = {}}) do |line,r|
            sl = line.split
            dev = sl[0][0..-2].to_sym
            r[dev][:receive_byte] = sl[1]
            r[dev][:transmit_byte] = sl[9]
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
      end
    end
  end
end
