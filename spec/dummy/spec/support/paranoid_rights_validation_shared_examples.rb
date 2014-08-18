require 'spec_helper'

RSpec.shared_examples "a paranoid rights validator" do 
  let(:validator) { described_class.new }

  after(:each) { validator.destroy if validator.persisted? } 

  it "disallows save with public edit access" do 
    validator.edit_groups = ["public"]
    expect { validator.save! }.to raise_error(ActiveFedora::RecordInvalid) 
  end

  it "disallows save with registered edit access" do 
    validator.edit_groups = ["registered"]
    expect { validator.save! }.to raise_error(ActiveFedora::RecordInvalid)
  end

  it "disallows save with depositor with no edit access" do 
    validator.properties.depositor = "Will Jackson" 
    expect { validator.save! }.to raise_error(ActiveFedora::RecordInvalid) 
  end
end