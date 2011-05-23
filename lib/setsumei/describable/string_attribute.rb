module Setsumei
  module Describable
    class StringAttribute
      def StringAttribute.named(name,options = {})
        new.tap do |attribute|
          attribute.name = name
          attribute.options = options.dup.tap { |o| o.delete :as_a }
        end
      end

      attr_accessor :name, :options

      def is_an_attribute_of_type?(type)
        type == :string || type == self.class
      end

      def value_for(pre_type_cast_value)
        pre_type_cast_value.to_s
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
