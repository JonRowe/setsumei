require 'spec_helper'

module Setsumei
  module Describable
    describe TimeAttribute do

      describe "#initialize(format)" do
        it 'will default to %Y-%m-%d %H:%M' do
          TimeAttribute.new.format.should == '%Y-%m-%d %H:%M'
        end

        it 'is configurable' do
          format = double
          TimeAttribute.new(format).format.should == format
        end
      end

      describe "#== other" do
        subject { TimeAttribute.new }

        it { should == :time }
        it { should == TimeAttribute }
        it { should_not eq double }
      end

      describe "#cast value" do
        let(:attribute) { TimeAttribute.new }

        subject { attribute.cast value }

        context "where pre_type_cast_value is a string" do
          let(:value) { "time" }
          let(:formatted_value) { mock "formatted_value" }

          it "should parse it into a time with format" do
            Time.should_receive(:strptime).with(value, '%Y-%m-%d %H:%M').and_return(formatted_value)
            subject.should == formatted_value
          end
        end
      end
    end
  end
end
