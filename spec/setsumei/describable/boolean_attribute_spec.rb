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

      describe "set_value_on object, from_value_in: hash" do
        let(:hash) { Hash.new }
        let(:key) { "key" }
        let(:hash_keys) { mock "hash_keys" }
        let(:value_in_hash) { mock "value_in_hash" }

        let(:object) { mock "object", :my_boolean_attribute= => nil }

        let(:boolean_attribute) { BooleanAttribute.named :my_boolean_attribute }
        let(:converted_value) { mock "converted_value" }

        before do
          Build::Key.stub(:for).and_return(key)
          hash[key] = value_in_hash
          boolean_attribute.stub(:value_for).and_return(converted_value)
        end

        subject { boolean_attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with(:my_boolean_attribute, given: hash_keys ).and_return(key)
          subject
        end
        it "should convert the value" do
          boolean_attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          object.should_receive(:my_boolean_attribute=).with(converted_value)
          subject
        end
      end
    end
  end
end
