require 'spec_helper'

module Setsumei
  module Build
    describe Key do
      describe ".for name, given: hash_keys" do
        let(:hash_keys) { ["otherAttribute","@anotherAttribute","Array","Object"] }

        subject { Key.for :attribute_name, given: hash_keys }

        specify do
          hash_keys.concat ["AttributeName", "attributeName", "@attributeName","attribute_name"]
          subject.should == "attribute_name"
        end

        specify do
          hash_keys.concat ["AttributeName", "attributeName", "@attributeName"]
          subject.should == "attributeName"
        end

        specify do
          hash_keys.concat ["AttributeName", "@attributeName"]
          subject.should == "@attributeName"
        end

        specify do
          hash_keys.concat ["AttributeName"]
          subject.should == "AttributeName"
        end
      end

      describe "direct(name,keys)" do
        let(:name) { 'attribute_name' }
        let(:keys) { [] }

        subject { Key.direct :attribute_name, keys }

        it "should return name when keys contain name" do
          keys << name
          subject.should == name
        end
        it "should return nil when keys do not contain name" do
          subject.should be_nil
        end

        context "keys are ommited" do
          it "should return name" do
            Key.direct(:attribute_name).should == "attribute_name"
          end
        end
      end

      describe "lower_camel_case(name,keys)" do
        let(:keys) { [] }

        subject { Key.lower_camel_case :attribute_name, keys }

        it "should return lower camelcase named when keys contain name" do
          keys << "attributeName"
          subject.should == "attributeName"
        end
        it "should return nil when keys do not contain name" do
          subject.should be_nil
        end

        context "keys are ommited" do
          it "should return lower camelcase name" do
            Key.lower_camel_case(:attribute_name).should == "attributeName"
          end
        end
      end

      describe "upper_camel_case(name,keys)" do
        let(:keys) { [] }

        subject { Key.upper_camel_case :attribute_name, keys }

        it "should return upper camelcase named when keys contain name" do
          keys << "AttributeName"
          subject.should == "AttributeName"
        end
        it "should return nil when keys do not contain name" do
          subject.should be_nil
        end

        context "keys are ommited" do
          it "should return upper camelcase name" do
            Key.upper_camel_case(:attribute_name).should == "AttributeName"
          end
        end
      end

      describe "at_symbol_case(name,keys)" do
        let(:keys) { [] }

        subject { Key.at_symbol_case :attribute_name, keys }

        it "should return symbol case named when keys contain name" do
          keys << "@attributeName"
          subject.should == "@attributeName"
        end
        it "should return nil when keys do not contain name" do
          subject.should be_nil
        end

        context "keys are ommited" do
          it "should return at symbol case" do
            Key.at_symbol_case(:attribute_name).should == "@attributeName"
          end
        end
      end
    end
  end
end
