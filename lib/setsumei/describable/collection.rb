module Setsumei
  module Describable
    class Collection
      def Collection.of(klass,options = {})
        new.tap do |collection|
          collection.klass = klass
          collection.options = options
        end
      end

      attr_accessor :klass, :options

      def set_value_on(object, options = {})
        [options[:from_value_in][Build::Key.for((self.options[:within] || klass), given: options[:from_value_in].keys)]].flatten(1).each do |data|
          object << Build.a(klass, from: data)
        end
      end
    end
  end
end
