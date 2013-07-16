module Setsumei
  module Describable
    class ObjectAttribute < Attribute

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
