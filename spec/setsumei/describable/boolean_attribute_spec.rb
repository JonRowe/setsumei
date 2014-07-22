require 'spec_helper'

module Setsumei
  module Describable
    describe BooleanAttribute do

      describe "#== other" do
        subject { BooleanAttribute.new }

        it { is_expected.to eq :boolean }
        it { is_expected.to eq BooleanAttribute }
        it { is_expected.not_to eq double }
      end

      describe "#cast value" do
        let(:boolean_attribute) { BooleanAttribute.new }

        context "where the value is a boolean" do
          specify { expect(boolean_attribute.cast(true)).to be === true }
          specify { expect(boolean_attribute.cast(false)).to be === false }
        end
        context "where the value isn't a boolean" do
          specify { expect(boolean_attribute.cast("false")).to be === false }
          specify { expect(boolean_attribute.cast("true")).to be === true }
          specify { expect(boolean_attribute.cast("True")).to be === true }
          specify { expect(boolean_attribute.cast("1")).to be === true }
        end
      end

    end
  end
end

