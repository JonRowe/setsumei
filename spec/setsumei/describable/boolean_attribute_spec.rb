require 'spec_helper'

module Setsumei
  module Describable
    describe BooleanAttribute do

      describe "#== other" do
        subject { BooleanAttribute.new }

        it { should == :boolean }
        it { should == BooleanAttribute }
        it { should_not eq double }
      end

      describe "#cast value" do
        let(:boolean_attribute) { BooleanAttribute.new }

        context "where the value is a boolean" do
          specify { boolean_attribute.cast(true).should === true }
          specify { boolean_attribute.cast(false).should === false }
        end
        context "where the value isn't a boolean" do
          specify { boolean_attribute.cast("false").should === false }
          specify { boolean_attribute.cast("true").should === true }
          specify { boolean_attribute.cast("True").should === true }
          specify { boolean_attribute.cast("1").should === true }
        end
      end

    end
  end
end

