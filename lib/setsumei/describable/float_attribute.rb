module Setsumei
  module Describable
    class FloatAttribute

      def self.new options = {}
        Attribute.new super(), options
      end

      def == other
        :float == other || FloatAttribute == other
      end

      def cast value
        value.to_f
      end

    end
  end
end
