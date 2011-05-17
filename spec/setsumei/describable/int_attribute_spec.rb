require 'spec_helper'

module Setsumei
  module Describable
    describe IntAttribute do
      its(:name) { should == nil }

      describe ".named(name)" do
        let(:name) { :my_int_field }

        subject { IntAttribute.named(name) }

        it { should be_a IntAttribute }
        its(:name) { should == name }
      end

      describe "#value_for(pre_type_cast_value)" do
        let(:int_attribute) { IntAttribute.new }

        subject { int_attribute.value_for pre_type_cast_value }

        context "where the value is a int" do
          specify { int_attribute.value_for(42).should == 42 }
        end
        context "where the value isn't a int" do
          specify { int_attribute.value_for("10.6").should == 11 }
          specify { int_attribute.value_for("10.4").should == 10 }
        end
      end

      describe "#is_an_attribute_of_type?" do
        let(:int_attribute) { IntAttribute.new }

        subject { int_attribute.is_an_attribute_of_type? type }

        context "where type is :int" do
          let(:type) { :int }
          it { should be_true }
        end

        context "where type is IntAttribute" do
          let(:type) { IntAttribute }
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
