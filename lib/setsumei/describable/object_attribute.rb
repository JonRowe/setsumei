module Setsumei
  module Describable
    class ObjectAttribute < Attribute

      def self.named name, options = {}
        raise ArgumentError.new("you must specify what the object is") unless options.has_key? :as_a
        Attribute.named name, new(options)
      end

      def self.new options = {}
        Attribute.new super(options.delete(:as_a)), options
      end

      def initialize type = nil
        @klass = type || Object
      end
      attr_reader :klass

      def == other
        :object == other || ObjectAttribute == other || klass == other
      end

      def cast data
        return nil if data.nil? || data.empty?

        begin
          klass.create_from data
        rescue NoMethodError
          Build.a klass, from: data
        end
      end

    end
  end
end
