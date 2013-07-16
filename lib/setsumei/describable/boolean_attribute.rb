module Setsumei
  module Describable
    class BooleanAttribute

      def self.named name, options = {}
        Attribute.named name, new(options)
      end

      def self.new options = {}
        Attribute.new super(), options
      end

      def == other
        :boolean == other || BooleanAttribute == other
      end

      def cast value
        value.to_s.downcase == "true" || value.to_s == "1"
      end

    end
  end
end
