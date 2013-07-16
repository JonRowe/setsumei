require 'spec_helper'

module Setsumei
  module Describable
    describe IntAttribute do

      describe "#== other" do
        subject { IntAttribute.new }

        it { should == :int }
        it { should == IntAttribute }
        it { should_not eq double }
      end

      describe "#cast value" do
        let(:int_attribute) { IntAttribute.new }

        subject { int_attribute.cast pre_type_cast_value }

        context "where the value is a int" do
          specify { int_attribute.cast(42).should == 42 }
        end
        context "where the value isn't a int" do
          specify { int_attribute.cast("10.6").should == 11 }
          specify { int_attribute.cast("10.4").should == 10 }
        end
      end

    end
  end
end
