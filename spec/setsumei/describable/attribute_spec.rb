require 'spec_helper'

module Setsumei
  module Describable
    describe Attribute do

      let(:attribute) { Attribute.new :name, type }

      describe '#initialize name, type' do
        let(:type) { double }
        subject { attribute }

        its(:name) { should == :name }
        its(:type) { should == type }
      end

      describe "#value_for(value)" do
        let(:type)  { double "type", cast: cast }
        let(:value) { double "value" }
        let(:cast)  { double "cast" }

        it 'will cast value to type' do
          type.should_receive(:cast).with(value)
          attribute.value_for value
        end
        it 'will return the cast value' do
          attribute.value_for(value).should == cast
        end
      end

      %w[is_an_attribute_of_type? is_a? kind_of?].each do |meth|
        describe "##{meth}" do
          let(:type)   { double "type", :== => result }
          let(:other)  { double "value" }
          let(:result) { double "result" }

          it 'compares using type' do
            type.should_receive(:==).with(other)
            attribute.send meth, other
          end
          it 'returns the value' do
            attribute.send(meth, other).should eq result
          end
        end
      end

      describe "set_value_on object, from_value_in: hash" do
        let(:hash) { Hash.new }
        let(:key) { "key" }
        let(:hash_keys) { mock "hash_keys" }
        let(:value_in_hash) { mock "value_in_hash" }

        let(:object) { mock "object", :name= => nil }

        let(:converted_value) { mock "converted_value" }
        let(:type) { double "type", cast: converted_value }

        before do
          Build::Key.stub(:for).and_return(key)
          hash[key] = value_in_hash
        end

        subject { attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with(:name, given: hash_keys ).and_return(key)
          subject
        end
        it "should convert the value" do
          attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          object.should_receive(:name=).with(converted_value)
          subject
        end

        context "where a specific key has been specified" do
          before do
            hash["MySpecialKey"] = hash.delete key
            attribute.lookup_key = "MySpecialKey"
          end

          it "should use this key for the hash lookup instead" do
            Setsumei::Build::Key.should_not_receive(:for)
            type.should_receive(:cast).with(value_in_hash).and_return(converted_value)
            subject
          end
        end
      end
    end
  end
end
