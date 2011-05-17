module Setsumei
  module Describable
    class StringAttribute
      def StringAttribute.named(name)
        new.tap do |attribute|
          attribute.name = name
        end
      end

      def StringAttribute.value_for(pre_type_cast_value)
        pre_type_cast_value.to_s
      end

      attr_accessor :name

      def is_an_attribute_of_type?(type)
        type == :string || type == self.class
      end
    end
  end
end
