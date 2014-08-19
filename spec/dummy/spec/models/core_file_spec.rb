require 'spec_helper'

describe CoreFile do 
  describe "Content Objects" do 
    before :all do 
      @core = CoreFile.new 
      @core.depositor =  "Will" 
      @core.save! 

      @wigwum  = Wigwum.new 
      @wigwum.core_file = @core 
      @wigwum.save!

      @wumpus  = Wumpus.new
      @wumpus.core_file = @core 
      @wumpus.canonize
      @wumpus.save! 

      @wigwum2 = Wigwum.create 
    end

    it "can be found in various ways" do 
      expected = [@wigwum, @wumpus] 

      expect(@core.content_objects(:return_as => :models)).to match_array expected 
      expect(@core.canonical_object(:return_as => :models)).to eq @wumpus
    end

    it "are destroyed on core record destruction" do 
      wigwum_pid = @wigwum.pid 
      wumpus_pid = @wumpus.pid

      @core.destroy 

      expect(Wumpus.exists?(wumpus_pid)).to be false 
      expect(Wigwum.exists?(wigwum_pid)).to be false 
    end

    after :all do 
      @wigwum2.destroy
    end
  end

  it_behaves_like "A Properties Delegator"
  it_behaves_like "a paranoid rights validator"
end