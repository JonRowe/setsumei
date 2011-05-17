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
    end
  end
end
