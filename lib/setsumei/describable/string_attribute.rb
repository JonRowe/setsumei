module Setsumei
  module Describable
    class StringAttribute

      def self.new options = {}
        Attribute.new super(), options
      end

      def == other
        :string == other || StringAttribute == other
      end

      def cast value
        value.to_s
      end

    end
  end
end
