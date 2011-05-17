module Setsumei
  module Describable
    class BooleanAttribute

      def BooleanAttribute.named(name, options = {})
        new.tap do |attribute|
          attribute.name = name
        end
      end

      attr_accessor :name

      def is_an_attribute_of_type?(type)
        type == :boolean || type == self.class
      end

      def value_for(pre_type_cast_value)
        pre_type_cast_value.to_s.downcase == "true" || pre_type_cast_value.to_s == "1"
      end
    end
  end
end
