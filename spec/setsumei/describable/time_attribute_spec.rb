require 'spec_helper'

module Setsumei
  module Describable
    describe TimeAttribute do
      its(:name) { should == nil }

      describe ".named(name)" do
        let(:name) { :my_time_field }

        subject { TimeAttribute.named(name) }

        it { should be_a TimeAttribute }
        its(:name) { should == name }
        its(:format) { should == '%Y-%m-%d %H:%M' }

        context 'format specified' do
          let(:format) { mock "format" }

          subject { TimeAttribute.named name, format: format }

          its(:format) { should == format }
        end

        it_should_behave_like "it handles options properly"
      end

      describe "#value_for(pre_type_cast_value)" do
        let(:attribute) { TimeAttribute.new }

        subject { attribute.value_for pre_type_cast_value }

        context "where pre_type_cast_value is a string" do
          let(:pre_type_cast_value) { "time" }
          let(:formatted_value) { mock "formatted_value" }

          it "should parse it into a time with format" do
            Time.should_receive(:strptime).with(pre_type_cast_value,attribute.format).and_return(formatted_value)
            subject.should == formatted_value
          end
        end
      end

      describe "#is_an_attribute_of_type?" do
        let(:attribute) { TimeAttribute.new }

        subject { attribute.is_an_attribute_of_type? type }

        context "where type is :time" do
          let(:type) { :time }
          it { should be_true }
        end

        context "where type is TimeAttribute" do
          let(:type) { TimeAttribute }
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

        let(:object) { mock "object", :my_time_attribute= => nil }

        let(:time_attribute) { TimeAttribute.named :my_time_attribute }

        before do
          Build::Key.stub(:for).and_return(key)
          hash[key] = value_in_hash
          time_attribute.stub(:value_for).and_return(converted_value)
        end

        subject { time_attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with(:my_time_attribute, given: hash_keys ).and_return(key)
          subject
        end
        it "should convert the value" do
          time_attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          object.should_receive(:my_time_attribute=).with(converted_value)
          subject
        end
        it_should_behave_like "it handles lookup keys properly"
      end
    end
  end
end
