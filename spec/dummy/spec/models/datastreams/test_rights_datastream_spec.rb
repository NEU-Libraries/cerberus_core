require 'spec_helper'

class RightsValidationTester < ActiveFedora::Base
  include Hydra::ModelMixins::RightsMetadata
  include CerberusCore::Concerns::ParanoidRightsValidation

  def depositor
    self.properties.depositor.first 
  end

  has_metadata name: "rightsMetadata", type: TestRightsDatastream
  has_metadata name: "properties", type: TestPropertiesDatastream
end

describe TestRightsDatastream do 
  let(:obj) { RightsValidationTester.new } 

  after(:each) { obj.destroy if obj.persisted? }  

  describe "Inherited Functionality:" do 

    it "carries over validations" do 
      expect(obj.rightsMetadata.respond_to? :validate).to be true
    end
  end
end