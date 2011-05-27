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

        it_should_behave_like "it handles options properly"
      end

      describe "#value_for(pre_type_cast_value)" do
        let(:klass) { mock "klass" }
        let(:pre_type_cast_value) { { hash: "with_values" } }
        let(:object_attribute) { ObjectAttribute.named :name, as_a: klass }

        before do
          klass.stub(:create_from).and_raise(NoMethodError)
        end

        subject { object_attribute.value_for pre_type_cast_value }

        it "should use the Builder to produce a object with klass" do
          Build.should_receive(:a).with(klass, from: pre_type_cast_value)
          subject
        end

        context "there is no data for this object" do
          context "empty hash" do
            let(:pre_type_cast_value) { {} }
            it { should be_nil }
          end
          context "nil" do
            let(:pre_type_cast_value) { nil }
            it { should be_nil }
          end
        end
        context "klass responds to create_from" do
          let(:pre_fab_object) { mock "pre_fab_object" }

          before do
            klass.unstub(:create_from)
          end

          it "should build the klass itself" do
            klass.should_receive(:create_from).with(pre_type_cast_value).and_return(pre_fab_object)
            subject.should == pre_fab_object
          end
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

      describe "set_value_on object, from_value_in: hash" do
        let(:hash) { Hash.new }
        let(:key) { "key" }
        let(:hash_keys) { mock "hash_keys" }
        let(:value_in_hash) { mock "value_in_hash" }

        let(:object) { mock "object", :my_object_attribute= => nil }

        let(:object_attribute) { ObjectAttribute.named :my_object_attribute, as_a: mock("object_klass") }
        let(:converted_value) { mock "converted_value" }

        before do
          Build::Key.stub(:for).and_return(key)
          hash[key] = value_in_hash
          object_attribute.stub(:value_for).and_return(converted_value)
        end

        subject { object_attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with(:my_object_attribute, given: hash_keys ).and_return(key)
          subject
        end
        it "should convert the value" do
          object_attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          object.should_receive(:my_object_attribute=).with(converted_value)
          subject
        end
        it_should_behave_like "it handles lookup keys properly"
      end
    end
  end
end
