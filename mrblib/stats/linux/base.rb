module Stats
  module Linux
    class Base
      attr_accessor :history
      HISTORY_LIMIT=300 # 5min
      HISTORY_LIMIT.freeze

      private
      def collect(file, sec=0)
        @history ||= []
        _current = Proc.new do
          sleep sec if sec != 0
          begin
            @history << self.class.current(file)
            index = @history.size > HISTORY_LIMIT ? @history.size - HISTORY_LIMIT : 0
            @history = @history[index..-1]
          rescue => e
            puts e
          end
        end

        @_t = Thread.new(_current) do |current_proc|
          loop do
            current_proc.call
          end
        end
      end

      def average(frame=60)
        c = 0
        init = column_keys.each_with_object({}) {|k,r| r[k] = 0 }
        sum = @history.each_with_object(init) do |h,r|
          column_keys.each do |k|
            r[k] += h[k]
          end
          c += 1
          break if frame < c
        end

        sum.each_with_object({}) do |v,r|
          r[v[0]] = v[1] / c
        end
      end
    end
  end
end
