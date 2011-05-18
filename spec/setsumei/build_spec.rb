require 'spec_helper'

module Setsumei
  describe Build do
    describe ".a(klass,from: hash_data)" do
      let(:klass) { mock "class" }
      let(:hash_data) { Hash.new }

      let(:defined_attributes) { { an_attribute: attribute } }
      let(:attribute) { mock "attribute" }
      let(:object) { mock "object" }

      before do
        klass.stub(:defined_attributes).and_return(defined_attributes)
        klass.stub(:new).and_return(object)
        attribute.stub(:set_value_on)
      end

      subject { Build.a klass, from: hash_data }

      it "should instantiate klass" do
        klass.should_receive(:new).and_return(object)
        subject
      end
      it "should set value on object using attribute" do
        attribute.should_receive(:set_value_on).with(object, from_value_in: hash_data )
        subject
      end
      it { should == object }
    end

    describe ".a(klass,from: hash_data) error conditions" do
      context "klass doesn't have defined attributes" do
        let(:klass) { mock "class" }
        specify { expect { Build.a klass, from: {} }.to raise_error ArgumentError }
      end

      context "hash data isnt provided" do
        let(:klass) { mock "class", defined_attributes: {} }
        specify { expect { Build.a klass }.to raise_error ArgumentError }
      end
    end
  end
end
