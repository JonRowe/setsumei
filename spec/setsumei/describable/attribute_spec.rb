require 'spec_helper'

module Setsumei
  module Describable
    describe Attribute do

      describe ".named(name)" do
        let(:name) { :my_field }
        let(:attribute) { Struct.new(:name).new }

        subject { Attribute.named(name,attribute) }

        its(:name) { should == name }
      end

    end
  end
end