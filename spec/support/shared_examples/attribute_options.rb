shared_examples_for "it handles options properly" do
  its(:options) { should == {} }
  context "when options are specified" do
    subject { described_class.named name, as_a: described_class.to_s.downcase.gsub(/(.*::|attribute)/,'').to_sym, with_additional: :options }
    its(:options) { should == { with_additional: :options } }
  end
end
