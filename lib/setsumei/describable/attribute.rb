module Setsumei
  module Describable
    class Attribute

      def self.named name, options = {}, &converter
        options = options.dup
        new(options.delete(:type), options.delete(:klass), &converter).tap do |attribute|
          attribute.name = name
          attribute.lookup_key = options.delete(:from_within)
          attribute.options = options.tap { |o| o.delete :as_a }
        end
      end

      def initialize type, klass, &converter
        self.type  = type
        self.klass = klass
        self.converter = converter
      end

      attr_accessor :name, :options, :lookup_key, :converter, :type, :klass

      def is_an_attribute_of_type?(other)
        type == other || klass == other
      end

      def is_a? other
        klass == other || super
      end

      def kind_of? other
        klass == other || super
      end

      def value_for(pre_type_cast_value)
        (converter || -> value { value }).(pre_type_cast_value)
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
