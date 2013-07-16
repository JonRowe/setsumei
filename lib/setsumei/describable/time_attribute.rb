module Setsumei
  module Describable
    class TimeAttribute

      def self.named name, options = {}
        Attribute.named name, new(options)
      end

      def self.new options = {}
        Attribute.new super(options.delete(:format)), options
      end

      def initialize format
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
