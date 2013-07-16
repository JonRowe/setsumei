module Setsumei
  module Describable
    class BooleanAttribute

      def self.named(name, options = {})
        Attribute.named name, options.merge( type: :boolean, klass: self ), &converter
      end

      def self.new
        Attribute.new.tap do |attribute|
          attribute.converter = converter
          attribute.type  = :boolean
          attribute.klass = self
        end
      end

      def self.converter
        -> value { value.to_s.downcase == "true" || value.to_s == "1" }
      end

    end
  end
end
