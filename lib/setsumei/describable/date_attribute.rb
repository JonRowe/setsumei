module Setsumei
  module Describable
    class DateAttribute

      def self.new options = {}
        Attribute.new super(options.delete(:format)), options
      end

      def initialize format
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
