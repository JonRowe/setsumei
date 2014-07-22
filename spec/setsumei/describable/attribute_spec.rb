require 'spec_helper'

module Setsumei
  module Describable
    describe Attribute do

      let(:attribute) { Attribute.new :name, type }

      describe '#initialize name, type' do
        let(:type) { double }

        specify { expect(attribute.name).to eq :name }
        specify { expect(attribute.type).to eq type }
      end

      describe "#value_for(value)" do
        let(:type)  { double "type", cast: cast }
        let(:value) { double "value" }
        let(:cast)  { double "cast" }

        it 'will cast value to type' do
          expect(type).to receive(:cast).with(value)
          attribute.value_for value
        end
        it 'will return the cast value' do
          expect(attribute.value_for(value)).to eq cast
        end
      end

      %w[is_an_attribute_of_type? is_a? kind_of?].each do |meth|
        describe "##{meth}" do
          let(:type)   { double "type", :== => result }
          let(:other)  { double "value" }
          let(:result) { double "result" }

          it 'compares using type' do
            expect(type).to receive(:==).with(other)
            attribute.send meth, other
          end
          it 'returns the value' do
            expect(attribute.send(meth, other)).to eq result
          end
        end
      end

      describe "set_value_on object, from_value_in: hash" do
        let(:hash) { Hash.new }
        let(:key) { "key" }
        let(:hash_keys) { double "hash_keys" }
        let(:value_in_hash) { double "value_in_hash" }

        let(:object) { double "object", :name= => nil }

        let(:converted_value) { double "converted_value" }
        let(:type) { double "type", cast: converted_value }

        before do
          allow(Build::Key).to receive(:for) { key }
          hash[key] = value_in_hash
        end

        subject { attribute.set_value_on object, from_value_in: hash }

        it "should detect the key it should use to retrieve the value from the hash" do
          expect(hash).to receive(:keys) { hash_keys }
          expect(Build::Key).to receive(:for).with(:name, given: hash_keys ) { key }
          subject
        end
        it "should convert the value" do
          expect(attribute).to receive(:value_for).with(value_in_hash) { converted_value }
          subject
        end
        it "should pass object a value to the attribute described by this class" do
          expect(object).to receive(:name=).with(converted_value)
          subject
        end

        context "where a specific key has been specified" do
          before do
            hash["MySpecialKey"] = hash.delete key
            attribute.lookup_key = "MySpecialKey"
          end

          it "should use this key for the hash lookup instead" do
            expect(Setsumei::Build::Key).not_to receive(:for)
            expect(type).to receive(:cast).with(value_in_hash) { converted_value }
            subject
          end
        end
      end
    end
  end
end
