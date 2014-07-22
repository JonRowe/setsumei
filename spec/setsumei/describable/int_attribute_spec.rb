require 'spec_helper'

module Setsumei
  module Describable
    describe IntAttribute do

      describe "#== other" do
        subject { IntAttribute.new }

        it { is_expected.to eq :int }
        it { is_expected.to eq IntAttribute }
        it { is_expected.not_to eq double }
      end

      describe "#cast value" do
        let(:int_attribute) { IntAttribute.new }

        subject { int_attribute.cast pre_type_cast_value }

        context "where the value is a int" do
          specify { expect(int_attribute.cast(42)).to eq 42 }
        end
        context "where the value isn't a int" do
          specify { expect(int_attribute.cast("10.6")).to eq 11 }
          specify { expect(int_attribute.cast("10.4")).to eq 10 }
        end
      end

    end
  end
end
