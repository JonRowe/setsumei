require 'spec_helper'

module Setsumei
  describe Build do
    describe ".a(klass,from: hash_data)" do
      let(:klass) { double "class" }
      let(:hash_data) { Hash.new }

      let(:defined_attributes) { { an_attribute: attribute } }
      let(:attribute) { double "attribute" }
      let(:object) { double "object" }

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
    describe ".a(String,from: hash_data)" do
      let(:hash_data) { double "hash_data", to_s: string }
      let(:string) { double "string" }

      subject { Build.a String, from: hash_data }

      it "should call to_s on hash_data" do
        hash_data.should_receive(:to_s).and_return(string)
        subject
      end
      it { should == string }
    end
    describe ".a(Float,from: hash_data)" do
      let(:hash_data) { double "hash_data", to_f: float }
      let(:float) { double "float" }

      subject { Build.a Float, from: hash_data }

      it "should call to_f on hash_data" do
        hash_data.should_receive(:to_f).and_return(float)
        subject
      end
      it { should == float }
    end
    describe ".a(klass,from: hash_data) error conditions" do
      context "klass doesn't have defined attributes" do
        let(:klass) { double "class" }
        specify { expect { Build.a klass, from: {} }.to raise_error ArgumentError }
      end

      context "hash data isnt provided" do
        let(:klass) { double "class", defined_attributes: {} }
        specify { expect { Build.a klass }.to raise_error ArgumentError }
      end
    end
  end
end
