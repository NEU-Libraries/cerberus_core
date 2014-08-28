require 'spec_helper'

class MintedPidTest < ActiveFedora::Base
  include CerberusCore::Concerns::AutoMintedPid

  has_metadata "DC", type: CerberusCore::Datastreams::DublinCoreDatastream
end

describe CerberusCore::Concerns::AutoMintedPid do 
  let(:test)   { MintedPidTest.new }
  let(:config) { Dummy::Application.config } 

  context "With auto generation enabled" do 
    # Ensure valid configuration is always set for each of these tests
    before(:each) do 
      config.cerberus_core.auto_generate_pid = true 
      config.cerberus_core.minter_statefile  = Rails.root.join("tmp", "minter-state")
      config.cerberus_core.noid_template     = '.reeddeeddk'
    end

    it "raises an exception if no id_namespace has been set" do 
      config.cerberus_core.id_namespace = nil 
      expect { MintedPidTest.new }.to raise_error CerberusCore::InvalidConfigurationError
    end

    it "generates a valid pid if properly configured" do 
      config.cerberus_core.id_namespace = "testtest"
      expect { MintedPidTest.new }.not_to raise_error 
      expect(test.pid).to include "testtest"
    end
  end
end
