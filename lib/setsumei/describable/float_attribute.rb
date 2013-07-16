module Setsumei
  module Describable
    class FloatAttribute

      def == other
        :float == other || FloatAttribute == other
      end

      def cast value
        value.to_f
      end

    end
  end
end
