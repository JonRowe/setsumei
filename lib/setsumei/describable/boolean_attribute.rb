module Setsumei
  module Describable
    class BooleanAttribute

      def self.named(name, options = {})
        Attribute.named name, options.merge( type: :boolean, klass: self ), &converter
      end

      def self.new
        Attribute.new :boolean, self, &converter
      end

      def self.converter
        -> value { value.to_s.downcase == "true" || value.to_s == "1" }
      end

    end
  end
end
