require 'setsumei/describable/boolean_attribute'
require 'setsumei/describable/string_attribute'
require 'setsumei/describable/float_attribute'
require 'setsumei/describable/int_attribute'
require 'setsumei/describable/object_attribute'

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
        _defined_attributes[field_name] = attribute_type(options[:as_a]).named field_name, options
        attr_accessor field_name
      end

      def collection_of klass, options = {}
        self.class_eval do
          include Enumerable
          include Comparable

          def each(*args,&block)
            _internal_collection.each(*args,&block)
          end

          def include? value
            _internal_collection.include? value
          end

          def <<(value)
            _internal_collection << value
          end

          def [](value)
            _internal_collection[value]
          end

          def []=(index,value)
            _internal_collection[index] = value
          end

          def <=>(other)
            _internal_collection <=> other || super
          end

          private
            def _internal_collection
              @_internal_collection ||= []
            end
        end
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
          else
            ObjectAttribute if type.is_a?(Class)
          end
        end
    end
  end
end
