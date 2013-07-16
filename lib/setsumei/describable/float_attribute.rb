module Setsumei
  module Describable
    class FloatAttribute

      def self.named(name, options = {})
        Attribute.named name, options.merge( type: :float, klass: self ), &converter
      end

      def self.new
        Attribute.new :float, self, &converter
      end

      def self.converter
        -> value { value.to_f }
      end

    end
  end
end
