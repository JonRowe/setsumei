module Setsumei
  module Describable
    class IntAttribute
      def IntAttribute.named(name, options = {})
        new.tap do |attribute|
          attribute.name = name
        end
      end

      attr_accessor :name

      def is_an_attribute_of_type?(type)
        type == :int || type == self.class
      end

      def value_for(pre_type_cast_value)
        pre_type_cast_value.to_f.round
      end
    end
  end
end
