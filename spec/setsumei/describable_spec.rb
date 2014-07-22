require 'spec_helper'

module Setsumei
  describe Describable do
    let(:klass) { Class.new }

    before do
      klass.class_eval do
        include Setsumei::Describable
      end
    end

    describe ".defined_attributes" do
      it "should have a list of defined attributes" do
        expect(klass).to respond_to :defined_attributes
        expect(klass.defined_attributes).to be_a Hash
      end
      it "should have a definition method" do
        expect(klass).to respond_to :define
      end
      it "should return defined attributes as a duplicated hash" do
        klass.define :field
        expect(klass.defined_attributes[:field]).not_to be_nil
        klass.defined_attributes.delete(:field)
        expect(klass.defined_attributes[:field]).not_to be_nil
      end
    end

    describe ".define" do
      it "should allow defining of attributes" do
        klass.define :field
        expect(klass.defined_attributes[:field]).not_to be_nil
      end
      it "should create string attributes by default" do
        klass.define :field
        expect(klass.defined_attributes[:field]).to be_a Describable::StringAttribute
      end
      it "should have set the name on the attribute to be the field name" do
        klass.define :field
        expect(klass.defined_attributes[:field].name).to eq :field
      end

      context "where setting a specific type" do
        subject { klass }

        it_should_behave_like "it creates an attribute of type", :boolean,   creating_a: Describable::BooleanAttribute
        it_should_behave_like "it creates an attribute of type", :string,    creating_a: Describable::StringAttribute
        it_should_behave_like "it creates an attribute of type", :float,     creating_a: Describable::FloatAttribute
        it_should_behave_like "it creates an attribute of type", :int,       creating_a: Describable::IntAttribute
        it_should_behave_like "it creates an attribute of type", :date,      creating_a: Describable::DateTimeAttribute
        it_should_behave_like "it creates an attribute of type", :time,      creating_a: Describable::DateTimeAttribute

        it_should_behave_like "it creates an attribute of type", Class.new, creating_a: Describable::ObjectAttribute
      end
    end

    describe "instances with defined attributes" do
      before do
        klass.class_eval do
          define :my_string_attribute
        end
      end

      it "should allow me set to and retrieve values for my attribute" do
        klass.new.tap do |object|
          object.my_string_attribute = "Hey Everybody!"
          expect(object.my_string_attribute).to eq "Hey Everybody!"
        end
      end
    end

    describe ".collection_of(klass,options)" do
      let(:another_klass) { Class.new }
      let(:options) { double "options" }
      let(:element) { double "element" }
      let(:element_2) { double "element_2" }
      let(:instance) { klass.new }
      let(:collection) { double "collection" }

      before do
        allow(Describable::Collection).to receive(:of) { collection }
      end

      subject { klass.collection_of another_klass, options }

      context "a klass with collection_of invoked" do
        context "should behave like an array" do
          before do
            subject
            instance << element
          end

          it "should accept elements with shovel" do
            true
          end
          it "should be testable with include" do
            expect(instance).to include element
          end
          it "should be accessible with []" do
            expect(instance[0]).to eq element
          end
          it "should settable with []=" do
            instance[0] = element_2
            expect(instance[0]).to eq element_2
          end
          it "should be accessible with first" do
            expect(instance.first).to eq element
          end
          it "should be iterable over" do
            values = []
            instance.each { |value| values << value }
            expect(values).to eq [element]
          end
          it "should be injectable" do
            expect(instance.inject({}) { |b,c| b[b.size.to_s] = c; b }).to eq "0" => element
          end
          it "should be mappable" do
            instance << element_2
            expect(instance.map { |a| [a] }).to eq [[element],[element_2]]
          end
          it "should be comparable to an array" do
            expect(instance).to eq [element]
          end
        end
      end

      it "should setup a describable collection" do
        expect(Describable::Collection).to receive(:of).with(another_klass,options) { collection }
        subject
        expect(klass.defined_attributes.values).to include collection
      end
    end
  end
end
