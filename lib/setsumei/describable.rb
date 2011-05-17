require 'setsumei/describable/string_attribute'

module Setsumei
  module Describable

    def Describable.included(other)
      other.extend DescriptionMethods
    end

    module DescriptionMethods

      def defined_attributes
        _defined_attributes.dup
      end

      def define(field)
        _defined_attributes[field] = StringAttribute.new
      end

      private
        def _defined_attributes
          (@_defined_attributes ||= {})
        end
    end
  end
end
