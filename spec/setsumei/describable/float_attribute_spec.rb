require 'spec_helper'

module Setsumei
  module Describable
    describe FloatAttribute do

      describe "#== other" do
        subject { FloatAttribute.new }

        it { should == :float }
        it { should == FloatAttribute }
        it { should_not eq double }
      end

      describe "#cast value" do
        let(:float_attribute) { FloatAttribute.new }

        context "where the value is a float" do
          specify { float_attribute.cast(10.2).should == 10.2 }
        end
        context "where the value isn't a float" do
          specify { float_attribute.cast("10.2").should == 10.2 }
        end
      end

    end
  end
end
