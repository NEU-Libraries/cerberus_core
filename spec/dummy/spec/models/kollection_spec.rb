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

  describe "Queries" do 
    before(:all) do 
      @ancestor = Kollection.new()
      @ancestor.depositor = "Will" 
      @ancestor.save!

      @child_kol = Kollection.new()
      @child_kol.depositor = "Will" 
      @child_kol.parent_kollection = @ancestor 
      @child_kol.save! 

      @child_file = CoreFile.new()
      @child_file.depositor = "Will" 
      @child_file.parent = @ancestor 
      @child_file.save!

      @random_file = CoreFile.new()
      @random_file.depositor = "Will" 
      @random_file.save! 
    end

    it "can find its children" do 
      expected = [@child_kol, @child_file] 

      expect(@ancestor.children(:return_as => :models)).to match_array expected 
    end

    after(:all) do 
      @ancestor.destroy ; @child_kol.destroy ; @child_file.destroy
      @random_file.destroy 
    end
  end

  it_behaves_like "A Properties Delegator"
  it_behaves_like "a paranoid rights validator"
end