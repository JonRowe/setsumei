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

        it_should_behave_like "it handles options properly"
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

      describe "set_value_on object, from_value_in: hash" do
        let(:hash) { Hash.new }
        let(:key) { "key" }
        let(:hash_keys) { mock "hash_keys" }
        let(:value_in_hash) { mock "value_in_hash" }

        let(:object) { mock "object", :my_float_attribute= => nil }

        let(:float_attribute) { FloatAttribute.named :my_float_attribute }
        let(:converted_value) { mock "converted_value" }

        before do
          Build::Key.stub(:for).and_return(key)
          hash[key] = value_in_hash
          float_attribute.stub(:value_for).and_return(converted_value)
        end

        subject { float_attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with(:my_float_attribute, given: hash_keys ).and_return(key)
          subject
        end
        it "should convert the value" do
          float_attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          object.should_receive(:my_float_attribute=).with(converted_value)
          subject
        end
        it_should_behave_like "it handles lookup keys properly"
      end
    end
  end
end
