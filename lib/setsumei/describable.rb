require 'setsumei/describable/attribute'
require 'setsumei/describable/boolean_attribute'
require 'setsumei/describable/string_attribute'
require 'setsumei/describable/float_attribute'
require 'setsumei/describable/int_attribute'
require 'setsumei/describable/object_attribute'
require 'setsumei/describable/time_attribute'
require 'setsumei/describable/date_attribute'
require 'setsumei/describable/collection'

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
        _defined_attributes[:_self] = Collection.of klass,options
      end

      private
        def _defined_attributes
          (@_defined_attributes ||= {})
        end
        def attribute_type(type)
          case type
            when :boolean   then BooleanAttribute
            when :string    then StringAttribute
            when nil        then StringAttribute
            when :float     then FloatAttribute
            when :int       then IntAttribute
            when :date      then DateAttribute
            when :time      then TimeAttribute
          else
            object_attribute_if_a_class(type) or raise(ArgumentError)
          end
        end
        def object_attribute_if_a_class(type)
          (type.is_a?(Class) && ObjectAttribute)
        end
    end
  end
end
