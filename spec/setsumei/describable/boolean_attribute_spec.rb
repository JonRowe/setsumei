require 'spec_helper'

module Setsumei
  module Describable
    describe BooleanAttribute do
      its(:name) { should == nil }

      describe ".named(name)" do
        let(:name) { :my_boolean_field }

        subject { BooleanAttribute.named(name) }

        it { should be_a BooleanAttribute }
        its(:name) { should == name }
      end

      describe "#value_for(pre_type_cast_value)" do
        let(:boolean_attribute) { BooleanAttribute.new }

        context "where the value is a boolean" do
          specify { boolean_attribute.value_for(true).should === true }
          specify { boolean_attribute.value_for(false).should === false }
        end
        context "where the value isn't a boolean" do
          specify { boolean_attribute.value_for("false").should === false }
          specify { boolean_attribute.value_for("true").should === true }
          specify { boolean_attribute.value_for("True").should === true }
          specify { boolean_attribute.value_for("1").should === true }
        end
      end

      describe "#is_an_attribute_of_type?" do
        let(:boolean_attribute) { BooleanAttribute.new }

        subject { boolean_attribute.is_an_attribute_of_type? type }

        context "where type is :boolean" do
          let(:type) { :boolean }
          it { should be_true }
        end

        context "where type is BooleanAttribute" do
          let(:type) { BooleanAttribute }
          it { should be_true }
        end

        context "where type is unknown" do
          let(:type) { mock "an unknown type" }
          it { should be_false }
        end
      end
    end
  end
end
