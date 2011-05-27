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
        return nil if options.empty? || options[:from_value_in].nil?

        array( extract_from_hash options[:from_value_in] ).each do |data|
          object << Build.a(klass, from: data)
        end
      end

      private
        def array(thing)
          [thing].flatten(1).compact
        end
        def extract_from_hash(hash)
          (options[:direct_collection] && hash) || hash[ extract_key_for hash ]
        end
        def extract_key_for(hash)
          Build::Key.for configured_key, given: hash_keys(hash)
        end
        def configured_key
          options[:within] || klass
        end
        def hash_keys(hash)
          ( hash && hash.keys ) || []
        end

    end
  end
end
