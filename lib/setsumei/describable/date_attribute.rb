module Setsumei
  module Describable
    class DateAttribute

      def initialize format = nil
        @format = format || '%Y-%m-%d'
      end
      attr_reader :format

      def == other
        :date == other || DateAttribute == other
      end

      def cast value
        Date.strptime value, format
      end

    end
  end
end
