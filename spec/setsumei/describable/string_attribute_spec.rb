require 'spec_helper'

module Setsumei
  module Describable
    describe StringAttribute do
      its(:name) { should == nil }

      describe ".named(name)" do
        let(:name) { :my_string_field }

        subject { StringAttribute.named(name) }

        it { should be_a StringAttribute }
        its(:name) { should == name }
      end

      describe "#value_for(pre_type_cast_value)" do
        let(:string_attribute) { StringAttribute.new }

        subject { string_attribute.value_for pre_type_cast_value }

        context "where the value is a string" do
          let(:pre_type_cast_value) { "I'm already a string" }

          it { should == pre_type_cast_value }
        end
        context "where the value isn't a string" do
          let(:to_s_value) { "stringified value of thing thats a string" }
          let(:pre_type_cast_value) { mock "something thats not a string", to_s: to_s_value }

          it { should == to_s_value }
        end
      end

      describe "#is_an_attribute_of_type?" do
        let(:string_attribute) { StringAttribute.new }

        subject { string_attribute.is_an_attribute_of_type? type }

        context "where type is :string" do
          let(:type) { :string }
          it { should be_true }
        end

        context "where type is StringAttribute" do
          let(:type) { StringAttribute }
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
