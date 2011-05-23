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

        it_should_behave_like "it handles options properly"
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

      describe "set_value_on object, from_value_in: hash" do
        let(:hash) { Hash.new }
        let(:key) { "key" }
        let(:hash_keys) { mock "hash_keys" }
        let(:value_in_hash) { mock "value_in_hash" }
        let(:converted_value) { mock "converted_value" }

        let(:object) { mock "object", :my_string_attribute= => nil }

        let(:string_attribute) { StringAttribute.named :my_string_attribute }

        before do
          Build::Key.stub(:for).and_return(key)
          hash[key] = value_in_hash
          string_attribute.stub(:value_for).and_return(converted_value)
        end

        subject { string_attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with(:my_string_attribute, given: hash_keys ).and_return(key)
          subject
        end
        it "should convert the value" do
          string_attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          object.should_receive(:my_string_attribute=).with(converted_value)
          subject
        end
      end
    end
  end
end
