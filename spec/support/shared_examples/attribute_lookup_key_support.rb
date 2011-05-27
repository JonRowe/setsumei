shared_examples_for "it handles lookup keys properly" do
  let(:attribute) { send described_class.to_s.slice(/::([^:]*)$/,1).gsub(/[a-z][A-Z]/) { |s| s[0]+'_'+s[1] }.downcase }
  context "where a specific key has been specified" do
    before do
      hash["MySpecialKey"] = hash.delete key
      attribute.lookup_key = "MySpecialKey"
    end

    it "should use this key for the hash lookup instead" do
      Setsumei::Build::Key.should_not_receive(:for)
      attribute.should_receive(:value_for).with(value_in_hash).and_return(converted_value)
      subject
    end
  end
end
