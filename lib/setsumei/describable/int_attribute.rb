module Setsumei
  module Describable
    class IntAttribute

      def self.named(name, options = {})
        Attribute.named name, options.merge( type: :int, klass: self ), &converter
      end

      def self.new
        Attribute.new.tap do |attribute|
          attribute.converter = converter
          attribute.type  = :int
          attribute.klass = self
        end
      end

      def self.converter
        -> value { value.to_f.round }
      end

    end
  end
end
