module Setsumei
  module Describable
    class DateTimeAttribute

      def initialize type, format, parser
        @type, @parser = type, parser
        @format = format || '%Y-%m-%d %H:%M'
      end
      attr_reader :format, :type, :parser

      def == other
        type == other || self.class == other
      end

      def cast value
        parser.strptime value, format
      end

    end
  end
end
