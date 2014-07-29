require 'spec_helper'

class RightsValidationTester < ActiveFedora::Base
  include Hydra::ModelMixins::RightsMetadata
  include DrsCore::Concerns::ParanoidRightsValidation

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

    describe "Validations" do 
      it "disallow saving a record where the depositor cannot edit" do 
        obj.properties.depositor = "Will Jackson"
        expect{obj.save!}.to raise_error
      end

      it "allows record save when the depositor can edit" do 
        obj.properties.depositor = "Will Jackson" 
        obj.edit_users = ["Will Jackson"]
        expect{ obj.save! }.to_not raise_error 
      end

      it "disallow saving a record with public edit permissions" do 
        obj.edit_groups = ["public"]
        expect{ obj.save! }.to raise_error 
      end

      it "disallow saving a record with registered edit permissions" do 
        obj.edit_groups = ["registered"]
        expect { obj.save! }.to raise_error 
      end
    end
  end
end