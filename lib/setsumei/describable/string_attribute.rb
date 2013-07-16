module Setsumei
  module Describable
    class StringAttribute

      def self.named(name, options = {})
        Attribute.named name, options.merge( type: :string, klass: self ), &converter
      end

      def self.new
        Attribute.new :string, self, &converter
      end

      def self.converter
        -> value { value.to_s }
      end

    end
  end
end
