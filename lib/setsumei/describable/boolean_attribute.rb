module Setsumei
  module Describable
    class BooleanAttribute

      def == other
        :boolean == other || BooleanAttribute == other
      end

      def cast value
        value.to_s.downcase == "true" || value.to_s == "1"
      end

    end
  end
end
