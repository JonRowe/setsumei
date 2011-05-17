module Setsumei
  module Describable
    class ObjectAttribute

      def ObjectAttribute.named(name,options = {})
        raise ArgumentError.new("you must specify what the object is") unless options.has_key? :as_a
        new.tap do |attribute|
          attribute.name = name
          attribute.klass = options[:as_a]
        end
      end

      attr_accessor :name, :klass

      def initialize
        self.klass = Object
      end

      def is_an_attribute_of_type?(type)
        type == :object || type == self.class || type == self.klass
      end
    end
  end
end
