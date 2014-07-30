require 'spec_helper'
require "#{Rails.root}/spec/models/concerns/properties_datastream_delegations_spec"

describe CoreFile do 
  let(:x) { CoreFile.new }

  after(:each) { x.destroy if x.persisted? } 

  describe "Validations" do 

    it "disallow save with public edit access" do 
      x.edit_groups = ["public"]
      expect { x.save! }.to raise_error(ActiveFedora::RecordInvalid) 
    end

    it "disallow save with registered edit access" do 
      x.edit_groups = ["registered"]
      expect { x.save! }.to raise_error(ActiveFedora::RecordInvalid) 
    end

    it "disallow save with depositor with no edit access" do 
      x.properties.depositor = "Will Jackson" 
      expect { x.save! }.to raise_error(ActiveFedora::RecordInvalid) 
    end
  end

  it_behaves_like "A Properties Delegator"
end