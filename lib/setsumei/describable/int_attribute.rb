module Setsumei
  module Describable
    class IntAttribute

      def self.named name, options = {}
        Attribute.named name, new(options)
      end

      def self.new options = {}
        Attribute.new super(), options
      end

      def == other
        :int == other || IntAttribute == other
      end

      def cast value
        value.to_f.round
      end

    end
  end
end
