module Setsumei
  module Describable
    class BooleanAttribute

      def BooleanAttribute.named(name, options = {})
        options = options.dup
        new.tap do |attribute|
          attribute.name = name
          options.delete(:as_a)
          attribute.options = options
        end
      end

      attr_accessor :name, :options

      def is_an_attribute_of_type?(type)
        type == :boolean || type == self.class
      end

      def value_for(pre_type_cast_value)
        pre_type_cast_value.to_s.downcase == "true" || pre_type_cast_value.to_s == "1"
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
