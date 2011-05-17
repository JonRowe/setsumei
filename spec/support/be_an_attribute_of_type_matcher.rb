RSpec::Matchers.define :be_an_attribute_of_type do |type|
  match do |subject|
    subject.is_an_attribute_of_type? type
  end
end
