shared_examples_for "it handles options properly" do |extras = {}|
  its(:lookup_key) { should be_nil }
  its(:options) { should == {}.merge(extras) }

  context "when options are specified" do
    subject { described_class.named name, as_a: described_class.to_s.downcase.gsub(/(.*::|attribute)/,'').to_sym, with_additional: :options }
    its(:options) { should == { with_additional: :options }.merge(extras) }
  end

  context "when from_within: is specified" do
    let(:key) { "specialKey" }

    subject { described_class.named name, as_a: described_class.to_s.downcase.gsub(/(.*::|attribute)/,'').to_sym, from_within: key }

    its(:lookup_key) { should == key }

    context "with addition options" do
      subject { described_class.named name, as_a: described_class.to_s.downcase.gsub(/(.*::|attribute)/,'').to_sym, from_within: key, with_additional: :options }

      its(:lookup_key) { should == key }
      its(:options) { should == { with_additional: :options }.merge(extras) }
    end
  end
end
