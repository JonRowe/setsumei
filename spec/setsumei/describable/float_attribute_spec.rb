require 'spec_helper'

module Setsumei
  module Describable
    describe FloatAttribute do
      its(:name) { should == nil }

      describe ".named(name)" do
        let(:name) { :my_float_field }

        subject { FloatAttribute.named(name) }

        it { should be_a FloatAttribute }
        its(:name) { should == name }
      end

      describe "#value_for(pre_type_cast_value)" do
        let(:float_attribute) { FloatAttribute.new }

        subject { float_attribute.value_for pre_type_cast_value }

        context "where the value is a float" do
          specify { float_attribute.value_for(10.2).should == 10.2 }
        end
        context "where the value isn't a float" do
          specify { float_attribute.value_for("10.2").should == 10.2 }
        end
      end

      describe "#is_an_attribute_of_type?" do
        let(:float_attribute) { FloatAttribute.new }

        subject { float_attribute.is_an_attribute_of_type? type }

        context "where type is :float" do
          let(:type) { :float }
          it { should be_true }
        end

        context "where type is FloatAttribute" do
          let(:type) { FloatAttribute }
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
