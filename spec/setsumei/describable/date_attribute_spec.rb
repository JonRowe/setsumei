require 'spec_helper'

module Setsumei
  module Describable
    describe DateTimeAttribute do

      describe "#initialize(format)" do
        it 'is configurable' do
          format = double
          DateTimeAttribute.new(:date, format, Date).format.should == format
        end
      end

      describe "#== other" do
        subject { DateTimeAttribute.new :date, '%Y-%m-%d', Date }

        it { should == :date }
        it { should == DateTimeAttribute }
        it { should_not eq double }
      end


      describe "#cast value" do
        let(:attribute) { DateTimeAttribute.new :date, '%Y-%m-%d', Date }

        subject { attribute.cast value }

        context "where pre_type_cast_value is a string" do
          let(:value) { "time" }
          let(:formatted_value) { double "formatted_value" }

          it "should parse it into a time with format" do
            Date.should_receive(:strptime).with(value,'%Y-%m-%d').and_return(formatted_value)
            subject.should == formatted_value
          end
        end
      end
    end
  end
end
