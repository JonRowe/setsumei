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
        _defined_attributes[field_name] = Attribute.new field_name, attribute_type(options), options
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

        def attribute_type(options = {})
            case options.fetch(:as_a,:string)
              when :boolean   then BooleanAttribute.new
              when :string    then StringAttribute.new
              when nil        then StringAttribute.new
              when :float     then FloatAttribute.new
              when :int       then IntAttribute.new
              when :date      then DateAttribute.new(options[:format])
              when :time      then TimeAttribute.new(options[:format])
              when Class      then ObjectAttribute.new(options[:as_a])
            else
              raise ArgumentError
            end
        end
    end
  end
end
