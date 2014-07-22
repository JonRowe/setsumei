require 'spec_helper'

module Setsumei
  module Describable
    describe ObjectAttribute do

      describe "#initialize(klass)" do
        let(:my_klass) { Class.new }

        subject { ObjectAttribute.new my_klass }

        specify { expect(subject.klass).to eq my_klass }
      end

      describe "#cast data" do
        let(:klass) { double "klass" }
        let(:data)  { { hash: "with_values" } }
        let(:object_attribute) { ObjectAttribute.new(klass) }

        before do
          allow(klass).to receive(:create_from).and_raise(NoMethodError)
        end

        subject { object_attribute.cast data }

        it "should use the Builder to produce a object with klass" do
          expect(Build).to receive(:a).with(klass, from: data)
          subject
        end

        context "there is no data for this object" do
          context "empty hash" do
            let(:data) { {} }
            it { is_expected.to be_nil }
          end
          context "nil" do
            let(:data) { nil }
            it { is_expected.to be_nil }
          end
        end

        context "klass responds to create_from" do
          let(:pre_fab_object) { double "pre_fab_object" }

          it "should build the klass itself" do
            expect(klass).to receive(:create_from).with(data) { pre_fab_object }
            expect(subject).to eq pre_fab_object
          end
        end
      end

      describe "#== other" do
        let(:klass) { double }

        subject { ObjectAttribute.new klass }

        it { is_expected.to eq :object }
        it { is_expected.to eq klass }
        it { is_expected.to eq ObjectAttribute }
        it { is_expected.not_to eq double("an unknown type") }
      end

    end
  end
end
