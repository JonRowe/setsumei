module Setsumei
  module Describable
    class IntAttribute
      def IntAttribute.named(name, options = {})
        options = options.dup
        new.tap do |attribute|
          attribute.name = name
          attribute.lookup_key = options.delete(:from_within)
          attribute.options = options.tap { |o| o.delete :as_a }
        end
      end

      attr_accessor :name, :options, :lookup_key

      def is_an_attribute_of_type?(type)
        type == :int || type == self.class
      end

      def value_for(pre_type_cast_value)
        pre_type_cast_value.to_f.round
      end

      def set_value_on(object, options)
        object.send accessor, value_from_hash(options[:from_value_in])
      end

      private
        def accessor
          :"#{name}="
        end
        def value_from_hash(hash)
          value_for hash[ key_for(hash)]
        end
        def key_for(hash)
          lookup_key || Build::Key.for(name, given: hash.keys)
        end
    end
  end
end
