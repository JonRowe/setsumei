require 'spec_helper'

module Setsumei
  describe Describable do
    let(:klass) { Class.new }

    before do
      klass.class_eval do
        include Setsumei::Describable
      end
    end

    describe ".defined_attributes" do
      it "should have a list of defined attributes" do
        klass.should respond_to :defined_attributes
        klass.defined_attributes.should be_a Hash
      end
      it "should have a definition method" do
        klass.should respond_to :define
      end
      it "should return defined attributes as a duplicated hash" do
        klass.define :field
        klass.defined_attributes[:field].should_not be_nil
        klass.defined_attributes.delete(:field)
        klass.defined_attributes[:field].should_not be_nil
      end
    end

    describe ".define" do
      it "should allow defining of attributes" do
        klass.define :field
        klass.defined_attributes[:field].should_not be_nil
      end
      it "should create string attributes by default" do
        klass.define :field
        klass.defined_attributes[:field].should be_a Describable::StringAttribute
      end
      it "should have set the name on the attribute to be the field name" do
        klass.define :field
        klass.defined_attributes[:field].name.should == :field
      end

      context "where setting a specific type" do
        it "should allow defining of attribute with an explicity type" do
          klass.define :field, as_a: :string
          klass.defined_attributes[:field].should be_a Describable::StringAttribute
        end
      end
    end

    describe "instances with defined attributes" do
      before do
        klass.class_eval do
          define :my_string_attribute
        end
      end

      it "should allow me set to and retrieve values for my attribute" do
        klass.new.tap do |object|
          object.my_string_attribute = "Hey Everybody!"
          object.my_string_attribute.should == "Hey Everybody!"
        end
      end
    end
  end
end
