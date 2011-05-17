RSpec::Matchers.define :have_an_attribute do |name,opts = {}|
  match do |klass|
    setup(klass,name,opts)
    check_attribute && check_type && check_options
  end
end
