require 'setsumei/describable/boolean_attribute'
require 'setsumei/describable/string_attribute'
require 'setsumei/describable/float_attribute'
require 'setsumei/describable/int_attribute'

module Setsumei
  module Describable

    def Describable.included(other)
      other.extend DescriptionMethods
    end

    module DescriptionMethods

      def defined_attributes
        _defined_attributes.dup
      end

      def define field_name, options = {}
        _defined_attributes[field_name] = attribute_type(options[:as_a]).named field_name
        attr_accessor field_name
      end

      private
        def _defined_attributes
          (@_defined_attributes ||= {})
        end
        def attribute_type(type)
          case type
            when :boolean then BooleanAttribute
            when :string  then StringAttribute
            when nil      then StringAttribute
            when :float   then FloatAttribute
            when :int     then IntAttribute
          end
        end
    end
  end
end
