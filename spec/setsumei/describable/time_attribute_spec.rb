require 'spec_helper'

module Setsumei
  module Describable
    describe DateTimeAttribute do

      describe "#initialize(format)" do
        it 'will default to %Y-%m-%d %H:%M' do
          expect(DateTimeAttribute.new(:time, nil, Time).format).to eq '%Y-%m-%d %H:%M'
        end

        it 'is configurable' do
          format = double
          expect(DateTimeAttribute.new(:time, format, Time).format).to eq format
        end
      end

      describe "#== other" do
        subject { DateTimeAttribute.new :time, '%Y-%m-%d %H:%M', Time }

        it { is_expected.to eq :time }
        it { is_expected.to eq DateTimeAttribute }
        it { is_expected.not_to eq double }
      end

      describe "#cast value" do
        let(:attribute) { DateTimeAttribute.new :time, '%Y-%m-%d %H:%M', Time }

        subject { attribute.cast value }

        context "where pre_type_cast_value is a string" do
          let(:value) { "time" }
          let(:formatted_value) { double "formatted_value" }

          it "should parse it into a time with format" do
            expect(Time).to receive(:strptime).with(value, '%Y-%m-%d %H:%M') { formatted_value }
            expect(subject).to eq formatted_value
          end
        end
      end
    end
  end
end
