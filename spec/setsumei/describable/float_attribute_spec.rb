require 'spec_helper'

module Setsumei
  module Describable
    describe FloatAttribute do

      describe "#== other" do
        subject { FloatAttribute.new }

        it { is_expected.to eq :float }
        it { is_expected.to eq FloatAttribute }
        it { is_expected.not_to eq double }
      end

      describe "#cast value" do
        let(:float_attribute) { FloatAttribute.new }

        context "where the value is a float" do
          specify { expect(float_attribute.cast(10.2)).to eq 10.2 }
        end
        context "where the value isn't a float" do
          specify { expect(float_attribute.cast("10.2")).to eq 10.2 }
        end
      end

    end
  end
end
