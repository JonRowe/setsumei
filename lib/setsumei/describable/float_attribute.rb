module Setsumei
  module Describable
    class FloatAttribute

      def FloatAttribute.named(name, options = {})
        new.tap do |attribute|
          attribute.name = name
        end
      end

      attr_accessor :name

      def is_an_attribute_of_type?(type)
        type == :float || type == self.class
      end

      def value_for(pre_type_cast_value)
        pre_type_cast_value.to_f
      end
    end
  end
end
