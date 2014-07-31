require 'spec_helper' 
require "#{Rails.root}/spec/models/concerns/properties_datastream_delegations_spec"
require "#{Rails.root}/spec/models/concerns/paranoid_rights_validation_spec"

describe Kollection do 

  describe "Parent Folder" do 
    before(:all) do 
      @parent = Kollection.new 
      @parent.depositor = "Will" 
      @parent.save! 
    end

    let(:kollection) { Kollection.new }

    after(:each) { kollection.destroy if kollection.persisted? }  

    it "can be attached" do 
      kollection.parent_kollection = @parent
      expect(kollection.parent_kollection).to eq(@parent) 
    end

    after(:all) { @parent.destroy } 
  end

  it_behaves_like "A Properties Delegator"
  it_behaves_like "a paranoid rights validator"
end