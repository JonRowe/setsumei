require 'setsumei/build/key'

module Setsumei
  module Build
    def Build.a(klass,options = {})
      inform_developer "#{klass} should be able to list its attributes" unless klass.respond_to? :defined_attributes
      inform_developer "wrong number of arguments, options must include from: data }" unless options.keys.include? :from

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
  end
end
