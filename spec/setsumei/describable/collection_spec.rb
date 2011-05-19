require 'spec_helper'

module Setsumei
  module Describable
    describe Collection do
      describe "initialization" do
        its(:klass) { should be_nil }
        its(:options) { should be_nil }
      end

      describe ".of(klass,options)" do
        let(:klass) { mock "klass" }
        let(:options) { mock "options" }

        subject { Collection.of klass, options }

        it { should be_a Collection }
        its(:klass) { should == klass }
        its(:options) { should == options }
      end

      describe "#set_value_on(object, from_value_in: hash)" do
        let(:object) { mock "object" }
        let(:hash) { Hash.new }
        let(:hash_keys) { mock "hash_keys" }
        let(:key) { "aHashKey" }

        let(:klass) { mock "a klass" }
        let(:options) { Hash.new }
        let(:collection) { Collection.of klass, options }

        before do
          hash.stub(:keys).and_return(hash_keys)
          Build::Key.stub(:for).and_return(key)
          hash[key] = []
          Build.stub(:a)
        end

        subject { collection.set_value_on object, from_value_in: hash }

        it "should detect they key it should use to retreive the values from the hash" do
          hash.should_receive(:keys).and_return(hash_keys)
          Build::Key.should_receive(:for).with( klass, given: hash_keys).and_return(key)
          subject
        end

        context "single value" do
          let(:single_value) { mock "single_value" }
          let(:single_instance) { mock "single_instance" }

          before do
            hash[key] = single_value
            Build.stub(:a).and_return single_instance
            object.stub(:<<)
          end

          it "should build a single instance of klass" do
            Build.should_receive(:a).with(klass, from: single_value).and_return(single_instance)
            subject
          end
          it "should append this to the object" do
            object.should_receive(:<<).with(single_instance)
            subject
          end
        end
        context "multiple values" do
          let(:a_value) { mock "a_value" }
          let(:another_value) { mock "another_value" }
          let(:more_values) { mock "more_values" }

          let(:first_instance) { mock "first_instance" }
          let(:second_instance) { mock "second_instance" }
          let(:final_instance) { mock "final_instance" }

          before do
            hash[key] = [a_value,another_value,more_values]
            Build.stub(:a).and_return( first_instance, second_instance, final_instance )
            object.stub(:<<)
          end

          it "should build multiple instances of klass" do
            Build.should_receive(:a).with(klass, from: a_value)#and_return(first_instance)
            Build.should_receive(:a).with(klass, from: another_value)#and_return(second_instance)
            Build.should_receive(:a).with(klass, from: more_values)#and_return(final_instance)
            subject
          end
          it "should append all of these to the object" do
            object.should_receive(:<<).with(first_instance)
            object.should_receive(:<<).with(second_instance)
            object.should_receive(:<<).with(final_instance)
            subject
          end
        end

        context "options for collection specifiy within" do
          before do
            options[:within] = "SpecialKeyLocation"
          end

          it "should detect they key it should use to retreive the values from the hash" do
            Build::Key.should_receive(:for).with( "SpecialKeyLocation", given: hash_keys).and_return(key)
            subject
          end
        end
      end
    end
  end
end
