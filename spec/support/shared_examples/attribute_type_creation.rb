shared_examples "it creates an attribute of type" do |_type,options|
  _klass = options[:creating_a]
  context "definition of #{_type} attributes" do
    it "should allow defining #{_type} attributes" do
      subject.define :field, as_a: _type
      expect(subject.defined_attributes[:field]).to be_a _klass
    end
    it "should have defined an attribute testable as :#{_type}" do
      subject.define :field, as_a: _type
      expect(subject.defined_attributes[:field]).to be_an_attribute_of_type(_type)
    end
    context "where options are specified" do
      it "should set the options upon the attribute" do
        subject.define :field, as_a: _type, with: :options
        expect(subject.defined_attributes[:field].options).to eq({ with: :options }.merge(options.fetch(:extra_options,{})))
      end
    end
  end
end
