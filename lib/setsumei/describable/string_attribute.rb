module Setsumei
  module Describable
    class StringAttribute

      def self.named(name, options = {})
        Attribute.named name, options.merge( type: :string, klass: self ), &converter
      end

      def self.new
        Attribute.new.tap do |attribute|
          attribute.converter = converter
          attribute.type  = :string
          attribute.klass = self
        end
      end

      def self.converter
        -> value { value.to_s }
      end

    end
  end
end
