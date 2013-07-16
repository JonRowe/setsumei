module Setsumei
  module Describable
    class IntAttribute

      def == other
        :int == other || IntAttribute == other
      end

      def cast value
        value.to_f.round
      end

    end
  end
end
