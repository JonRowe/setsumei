module Setsumei
  module Describable
    class ObjectAttribute

      def ObjectAttribute.named(name,options = {})
        options = options.dup
        raise ArgumentError.new("you must specify what the object is") unless options.has_key? :as_a
        new.tap do |attribute|
          attribute.name = name
          attribute.klass = options.delete(:as_a)
          attribute.options = options
        end
      end

      attr_accessor :name, :klass, :options

      def initialize
        self.klass = Object
      end

      def value_for(data)
        return nil if data.nil? || data.empty?
        Build.a self.klass, from: data
      end

      def is_an_attribute_of_type?(type)
        type == :object || type == self.class || type == self.klass
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
