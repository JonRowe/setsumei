shared_examples_for "it handles options properly" do |extras = {}|
  specify { expect(subject.lookup_key).to be_nil }
  specify { expect(subject.options).to eq {}.merge(extras) }

  context "when options are specified" do
    subject { described_class.named name, as_a: described_class.to_s.downcase.gsub(/(.*::|attribute)/,'').to_sym, with_additional: :options }
    specify { expect(subject.options).to eq({ with_additional: :options }.merge(extras)) }
  end

  context "when from_within: is specified" do
    let(:key) { "specialKey" }

    subject { described_class.named name, as_a: described_class.to_s.downcase.gsub(/(.*::|attribute)/,'').to_sym, from_within: key }

    specify { expect(subject.lookup_key).to eq key }

    context "with addition options" do
      subject { described_class.named name, as_a: described_class.to_s.downcase.gsub(/(.*::|attribute)/,'').to_sym, from_within: key, with_additional: :options }

      specify { expect(subject.lookup_key).to eq key }
      specify { expect(subject.options).to eq({ with_additional: :options }.merge(extras)) }
    end
  end
end
