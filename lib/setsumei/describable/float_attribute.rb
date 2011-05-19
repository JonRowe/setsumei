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

      def set_value_on(object, options)
        object.send accessor, value_from_hash(options[:from_value_in])
      end

      private
        def accessor
          :"#{name}="
        end
        def value_from_hash(hash)
          value_for hash[ Build::Key.for name, given: hash.keys ]
        end
    end
  end
end
