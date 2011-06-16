require 'setsumei/build/key'

module Setsumei
  module Build
    def Build.a(klass,options = {})
      inform_developer "wrong number of arguments, options must include { from: data }" unless options.keys.include? :from
      detect_string(klass) and return(options[:from].to_s)
      detect_float(klass) and return(options[:from].to_f)
      inform_developer "#{klass} should be able to list its attributes" unless klass.respond_to? :defined_attributes

      klass.new.tap do |object|
        klass.defined_attributes.each do |_,attribute|
          attribute.set_value_on object, from_value_in: options[:from]
        end
      end
    end

    private
      def self.inform_developer(message)
        raise ArgumentError.new message
      end
      def self.detect_string(klass)
        klass == String
      end
      def self.detect_float(klass)
        klass == Float
      end
  end
end
