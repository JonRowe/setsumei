require 'spec_helper'

module Setsumei
  module Describable
    describe DateAttribute do

      describe "#initialize(format)" do
        it 'will default to %Y-%m-%d' do
          DateAttribute.new.format.should == '%Y-%m-%d'
        end

        it 'is configurable' do
          format = double
          DateAttribute.new(format).format.should == format
        end
      end

      describe "#== other" do
        subject { DateAttribute.new }

        it { should == :date }
        it { should == DateAttribute }
        it { should_not eq double }
      end

      describe "#cast value" do
        let(:attribute) { DateAttribute.new }

        subject { attribute.cast value }

        context "where pre_type_cast_value is a string" do
          let(:value) { "time" }
          let(:formatted_value) { mock "formatted_value" }

          it "should parse it into a time with format" do
            Date.should_receive(:strptime).with(value,'%Y-%m-%d').and_return(formatted_value)
            subject.should == formatted_value
          end
        end
      end
    end
  end
end
