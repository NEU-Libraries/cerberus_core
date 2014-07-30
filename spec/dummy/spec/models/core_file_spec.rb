require 'spec_helper'
require "#{Rails.root}/spec/models/concerns/properties_datastream_delegations_spec"
require "#{Rails.root}/spec/models/concerns/paranoid_rights_validation_spec"

describe CoreFile do 
  let(:x) { CoreFile.new }
  after(:each) { x.destroy if x.persisted? }

  it_behaves_like "A Properties Delegator"
  it_behaves_like "a paranoid rights validator"
end