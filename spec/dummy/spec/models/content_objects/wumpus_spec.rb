require 'spec_helper'
require "#{Rails.root}/spec/models/concerns/properties_datastream_delegations_spec"
require "#{Rails.root}/spec/models/concerns/paranoid_rights_validation_spec"

describe Wumpus do 

  it_behaves_like "A Properties Delegator"
  it_behaves_like "a paranoid rights validator"
end