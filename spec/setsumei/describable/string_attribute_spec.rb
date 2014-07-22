require 'spec_helper'

module Setsumei
  module Describable
    describe StringAttribute do

      describe "#== other" do
        subject { StringAttribute.new }

        it { is_expected.to eq :string }
        it { is_expected.to eq StringAttribute }
        it { is_expected.not_to eq double }
      end

      describe "#cast value" do
        let(:string_attribute) { StringAttribute.new }

        subject { string_attribute.cast pre_type_cast_value }

        context "where the value is a string" do
          let(:pre_type_cast_value) { "I'm already a string" }

          it { is_expected.to eq pre_type_cast_value }
        end

        context "where the value isn't a string" do
          let(:to_s_value) { "stringified value of thing thats a string" }
          let(:pre_type_cast_value) { double "something thats not a string", to_s: to_s_value }

          it { is_expected.to eq to_s_value }
        end
      end

    end
  end
end
