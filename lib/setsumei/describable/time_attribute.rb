module Setsumei
  module Describable
    class TimeAttribute

      def initialize format = nil
        @format = format || '%Y-%m-%d %H:%M'
      end
      attr_reader :format

      def == other
        :time == other || TimeAttribute == other
      end

      def cast value
        Time.strptime value, format
      end

    end
  end
end
