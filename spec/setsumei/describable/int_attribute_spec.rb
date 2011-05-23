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

        it_should_behave_like "it handles options properly"
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

      describe "set_value_on object, from_value_in: hash" do
        let(:hash) { Hash.new }
        let(:key) { "key" }
        let(:hash_keys) { mock "hash_keys" }
        let(:value_in_hash) { mock "value_in_hash" }

        let(:object) { mock "object", :my_int_attribute= => nil }

        let(:int_attribute) { IntAttribute.named :my_int_attribute }
        let(:converted_value) { mock "converted_value" }

        before do
          Build::Key.stub(:for).and_return(key)
          hash[key] = value_in_hash
          int_attribute.stub(:value_for).and_return(converted_value)
        end

        subject { int_attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with(:my_int_attribute, given: hash_keys ).and_return(key)
          subject
        end
        it "should convert the value" do
          int_attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          object.should_receive(:my_int_attribute=).with(converted_value)
          subject
        end
      end
    end
  end
end
