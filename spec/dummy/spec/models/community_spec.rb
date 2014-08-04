require 'spec_helper' 

describe Community do 

  describe "Traversal" do 
    before :all do 
      @community = Community.create 

      @kid_comm = Community.new
      @kid_comm.parent_community = @community
      @kid_comm.save! 

      @kid_kol = Kollection.new 
      @kid_kol.depositor = "Will" 
      @kid_kol.parent_community = @community 
      @kid_kol.save! 

      @des_file = CoreFile.new 
      @des_file.depositor = "Will" 
      @des_file.parent = @kid_kol
      @des_file.save!
    end

    it "knows how to find children" do 
      expected = [@kid_comm, @kid_kol]
      expect(@community.children(:return_as => :models)).to match_array expected
    end

    it "knows how to find children who are communities" do 
      expected = [@kid_comm] 
      expect(@community.communities(:return_as => :models)).to match_array expected
    end

    it "knows how to find children who are collections" do 
      expected = [@kid_kol] 
      expect(@community.collections(:return_as => :models)).to match_array expected 
    end

    it "knows how to find all descendent files" do 
      expected = [@des_file]
      expect(@community.descendent_records(:return_as => :models)).to match_array expected 
    end

    after :all do 
      @community.destroy
      @kid_comm.destroy 
      @kid_kol.destroy 
      @kid_file.destroy
    end
  end
end