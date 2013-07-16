module Setsumei
  module Describable
    class Attribute

      def initialize name, type, options = {}
        self.name = name
        self.type = type
        self.lookup_key = options.delete(:from_within)
        self.options = options.tap { |o| o.delete :as_a }
      end

      attr_accessor :name, :options, :lookup_key, :type, :klass

      def is_an_attribute_of_type?(other)
        type == other
      end
      alias :is_a?    :is_an_attribute_of_type?
      alias :kind_of? :is_an_attribute_of_type?

      def value_for(pre_type_cast_value)
        type.cast pre_type_cast_value
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
