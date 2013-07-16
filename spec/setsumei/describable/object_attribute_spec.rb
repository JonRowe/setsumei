require 'spec_helper'

module Setsumei
  module Describable
    describe ObjectAttribute do

      describe "#initialize(klass)" do
        let(:my_klass) { Class.new }

        subject { ObjectAttribute.new my_klass }

        specify { subject.klass.should == my_klass }
      end

      describe "#cast data" do
        let(:klass) { mock "klass" }
        let(:data)  { { hash: "with_values" } }
        let(:object_attribute) { ObjectAttribute.new(klass) }

        before do
          klass.stub(:create_from).and_raise(NoMethodError)
        end

        subject { object_attribute.cast data }

        it "should use the Builder to produce a object with klass" do
          Build.should_receive(:a).with(klass, from: data)
          subject
        end

        context "there is no data for this object" do
          context "empty hash" do
            let(:data) { {} }
            it { should be_nil }
          end
          context "nil" do
            let(:data) { nil }
            it { should be_nil }
          end
        end

        context "klass responds to create_from" do
          let(:pre_fab_object) { double "pre_fab_object" }

          before do
            klass.unstub(:create_from)
          end

          it "should build the klass itself" do
            klass.should_receive(:create_from).with(data).and_return(pre_fab_object)
            subject.should == pre_fab_object
          end
        end
      end

      describe "#== other" do
        let(:klass) { double }

        subject { ObjectAttribute.new klass }

        it { should eq :object }
        it { should eq klass }
        it { should eq ObjectAttribute }
        it { should_not eq double("an unknown type") }
      end

    end
  end
end
