require 'spec_helper'

module Setsumei
  module Describable
    describe Collection do

      describe "initialization" do
        let(:collection) { Collection.new }

        specify { expect(collection.klass).to be_nil }
        specify { expect(collection.options).to be_nil }
      end

      describe ".of(klass,options)" do
        let(:klass) { double "klass" }
        let(:options) { double "options" }

        let(:collection) { Collection.of klass, options }

        specify { expect(collection).to be_a Collection }
        specify { expect(collection.klass).to eq klass }
        specify { expect(collection.options).to eq options }
      end

      describe "#set_value_on(object, from_value_in: data) where data is a direct single or collection of values" do
        let(:object) { double "object", :<< => nil }

        let(:klass) { double "a klass" }
        let(:collection) { Collection.of klass, from_value_in: data, direct_collection: true }

        subject { collection.set_value_on object, from_value_in: data }

        context "nil value" do
          let(:data) { nil }
          it "should protect against instances where there are attributes, but not for our defined element keys" do
            expect(object).not_to receive(:<<)
            subject
          end
        end
        context "single value" do
          let(:data) { double "data" }
          let(:single_instance) { double "single_instance" }

          before { allow(Build).to receive(:a) { single_instance } }

          it "should build a single instance of klass" do
            expect(Build).to receive(:a).with(klass, from: data) { single_instance }
            subject
          end
          it "should append this to the object" do
            expect(object).to receive(:<<).with(single_instance)
            subject
          end
        end
        context "multiple values" do
          let(:a_value) { double "a_value" }
          let(:another_value) { double "another_value" }
          let(:more_values) { double "more_values" }

          let(:first_instance) { double "first_instance" }
          let(:second_instance) { double "second_instance" }
          let(:final_instance) { double "final_instance" }

          let(:data) { [a_value,another_value,more_values] }

          before { allow(Build).to receive(:a).and_return( first_instance, second_instance, final_instance ) }

          it "should build multiple instances of klass" do
            expect(Build).to receive(:a).with(klass, from: a_value)#and_return(first_instance)
            expect(Build).to receive(:a).with(klass, from: another_value)#and_return(second_instance)
            expect(Build).to receive(:a).with(klass, from: more_values)#and_return(final_instance)
            subject
          end
          it "should append all of these to the object" do
            expect(object).to receive(:<<).with(first_instance)
            expect(object).to receive(:<<).with(second_instance)
            expect(object).to receive(:<<).with(final_instance)
            subject
          end
        end
      end
      describe "#set_value_on(object, from_value_in: hash)" do
        let(:object) { double "object" }
        let(:hash) { Hash.new }
        let(:hash_keys) { double "hash_keys" }
        let(:key) { "aHashKey" }

        let(:klass) { AModule::Klass }
        let(:options) { Hash.new }
        let(:collection) { Collection.of klass, options }

        before do
          module AModule
            class Klass
            end
          end
          allow(hash).to receive(:keys) { hash_keys }
          allow(Build::Key).to receive(:for) { key }
          hash[key] = []
          allow(Build).to receive(:a)
        end

        subject { collection.set_value_on object, from_value_in: hash }

        it "should detect they key it should use to retreive the values from the hash" do
          expect(hash).to receive(:keys) { hash_keys }
          expect(Build::Key).to receive(:for).with( "Klass", given: hash_keys) { key }
          subject
        end

        context "nil value" do
          specify { expect(collection.set_value_on(object)).to be_nil }
          it "should protect against instances where there are attributes, but not for our defined element keys" do
            hash = { from_value_in: {"@size"=>"0"} }
            expect(object).not_to receive(:<<)
            collection.set_value_on(object,hash)
          end
        end

        context "single value" do
          let(:single_value) { double "single_value", to_a: nil }
          let(:single_instance) { double "single_instance" }

          before do
            hash[key] = single_value
            allow(Build).to receive(:a) { single_instance }
            allow(object).to receive(:<<)
          end

          it "should build a single instance of klass" do
            expect(Build).to receive(:a).with(klass, from: single_value) { single_instance }
            subject
          end
          it "should append this to the object" do
            expect(object).to receive(:<<).with(single_instance)
            subject
          end
        end
        context "multiple values" do
          let(:a_value) { double "a_value" }
          let(:another_value) { double "another_value" }
          let(:more_values) { double "more_values" }

          let(:first_instance) { double "first_instance" }
          let(:second_instance) { double "second_instance" }
          let(:final_instance) { double "final_instance" }

          before do
            hash[key] = [a_value,another_value,more_values]
            allow(Build).to receive(:a).and_return( first_instance, second_instance, final_instance )
            allow(object).to receive(:<<)
          end

          it "should build multiple instances of klass" do
            expect(Build).to receive(:a).with(klass, from: a_value)#and_return(first_instance)
            expect(Build).to receive(:a).with(klass, from: another_value)#and_return(second_instance)
            expect(Build).to receive(:a).with(klass, from: more_values)#and_return(final_instance)
            subject
          end
          it "should append all of these to the object" do
            expect(object).to receive(:<<).with(first_instance)
            expect(object).to receive(:<<).with(second_instance)
            expect(object).to receive(:<<).with(final_instance)
            subject
          end
        end

        context "options for collection specifiy within" do
          before do
            options[:within] = "SpecialKeyLocation"
          end

          it "should detect they key it should use to retreive the values from the hash" do
            expect(Build::Key).to receive(:for).with( "SpecialKeyLocation", given: hash_keys) { key }
            subject
          end
        end
      end
    end
  end
end
