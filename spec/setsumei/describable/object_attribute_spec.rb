require 'spec_helper'

module Setsumei
  module Describable
    describe ObjectAttribute do
      its(:name) { should == nil }
      its(:klass) { should == Object }

      describe ".named(name)" do
        let(:name) { :my_object_field }
        let(:my_klass) { Class.new }

        subject { ObjectAttribute.named name, as_a: my_klass }

        it { should be_a ObjectAttribute }
        its(:name) { should == name }
        its(:klass) { should == my_klass }

        context "klass is left off" do
          subject { ObjectAttribute.named name }
          specify { expect { subject }.to raise_error ArgumentError }
        end
      end

      describe "#value_for(pre_type_cast_value)" do
        let(:klass) { mock "klass" }
        let(:pre_type_cast_value) { mock "pre_type_cast_value" }
        let(:object_attribute) { ObjectAttribute.named :name, as_a: klass }

        subject { object_attribute.value_for pre_type_cast_value }

        it "should use the Builder to produce a object with klass" do
          Build.should_receive(:from_parsed_data).with(klass,pre_type_cast_value)
          subject
        end
      end

      describe "#is_an_attribute_of_type?" do
        let(:object_attribute) { ObjectAttribute.new }

        subject { object_attribute.is_an_attribute_of_type? type }

        context "where type is :object" do
          let(:type) { :object }
          it { should be_true }
        end

        context "where type is ObjectAttribute" do
          let(:type) { ObjectAttribute }
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
