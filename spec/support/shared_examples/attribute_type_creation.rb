shared_examples "it creates an attribute of type" do |_type,options|
  _klass = options[:creating_a]
  context "definition of #{_type} attributes" do
    it "should allow defining #{_type} attributes" do
      subject.define :field, as_a: _type
      subject.defined_attributes[:field].should be_a _klass
    end
    it "should have defined an attribute testable as :#{_type}" do
      subject.define :field, as_a: _type
      subject.defined_attributes[:field].should be_an_attribute_of_type(_type)
    end
  end
end
