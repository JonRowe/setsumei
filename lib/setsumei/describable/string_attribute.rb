module Setsumei
  module Describable
    class StringAttribute

      def == other
        :string == other || StringAttribute == other
      end

      def cast value
        value.to_s
      end

    end
  end
end
