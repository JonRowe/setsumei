require 'spec_helper'

module Setsumei
  module Describable
    describe DateTimeAttribute do

      describe "#initialize(format)" do
        it 'will default to %Y-%m-%d %H:%M' do
          DateTimeAttribute.new(:time, nil, Time).format.should == '%Y-%m-%d %H:%M'
        end

        it 'is configurable' do
          format = double
          DateTimeAttribute.new(:time, format, Time).format.should == format
        end
      end

      describe "#== other" do
        subject { DateTimeAttribute.new :time, '%Y-%m-%d %H:%M', Time }

        it { should == :time }
        it { should == DateTimeAttribute }
        it { should_not eq double }
      end

      describe "#cast value" do
        let(:attribute) { DateTimeAttribute.new :time, '%Y-%m-%d %H:%M', Time }

        subject { attribute.cast value }

        context "where pre_type_cast_value is a string" do
          let(:value) { "time" }
          let(:formatted_value) { double "formatted_value" }

          it "should parse it into a time with format" do
            Time.should_receive(:strptime).with(value, '%Y-%m-%d %H:%M').and_return(formatted_value)
            subject.should == formatted_value
          end
        end
      end
    end
  end
end
