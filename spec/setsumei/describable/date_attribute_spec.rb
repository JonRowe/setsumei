require 'spec_helper'

module Setsumei
  module Describable
    describe DateTimeAttribute do

      describe "#initialize(format)" do
        it 'is configurable' do
          format = double
          expect(DateTimeAttribute.new(:date, format, Date).format).to eq format
        end
      end

      describe "#== other" do
        subject { DateTimeAttribute.new :date, '%Y-%m-%d', Date }

        it { is_expected.to eq :date }
        it { is_expected.to eq DateTimeAttribute }
        it { is_expected.not_to eq double }
      end


      describe "#cast value" do
        let(:attribute) { DateTimeAttribute.new :date, '%Y-%m-%d', Date }

        subject { attribute.cast value }

        context "where pre_type_cast_value is a string" do
          let(:value) { "time" }
          let(:formatted_value) { double "formatted_value" }

          it "should parse it into a time with format" do
            expect(Date).to receive(:strptime).with(value,'%Y-%m-%d') { formatted_value }
            expect(subject).to eq formatted_value
          end
        end
      end
    end
  end
end
