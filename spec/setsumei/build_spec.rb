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
        allow(klass).to receive(:defined_attributes) { defined_attributes }
        allow(klass).to receive(:new) { object }
        allow(attribute).to receive(:set_value_on)
      end

      subject { Build.a klass, from: hash_data }

      it "should instantiate klass" do
        expect(klass).to receive(:new) { object }
        subject
      end
      it "should set value on object using attribute" do
        expect(attribute).to receive(:set_value_on).with(object, from_value_in: hash_data )
        subject
      end
      it { is_expected.to eq object }
    end
    describe ".a(String,from: hash_data)" do
      let(:hash_data) { double "hash_data", to_s: string }
      let(:string) { double "string" }

      subject { Build.a String, from: hash_data }

      it "should call to_s on hash_data" do
        expect(hash_data).to receive(:to_s) { string }
        subject
      end
      it { is_expected.to eq string }
    end
    describe ".a(Float,from: hash_data)" do
      let(:hash_data) { double "hash_data", to_f: float }
      let(:float) { double "float" }

      subject { Build.a Float, from: hash_data }

      it "should call to_f on hash_data" do
        expect(hash_data).to receive(:to_f) { float }
        subject
      end
      it { is_expected.to eq float }
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
