require 'spec_helper' 

describe Collection do    
  describe "Parent Folder" do 
    before(:all) do 
      @parent = Collection.new 
      @parent.depositor = "Will" 
      @parent.save! 
    end

    let(:collection) { Collection.new }

    after(:each) { collection.destroy if collection.persisted? }  

    it "can be attached" do 
      collection.parent_collection = @parent
      expect(collection.parent_collection).to eq(@parent) 
    end

    after(:all) { @parent.destroy } 
  end

  describe "Queries" do 
    before(:all) do 
      @ancestor = Collection.new()
      @ancestor.depositor = "Will" 
      @ancestor.save!

      @child_col = Collection.new()
      @child_col.depositor = "Will" 
      @child_col.parent_collection = @ancestor 
      @child_col.save! 

      @child_file = CoreFile.new()
      @child_file.depositor = "Will" 
      @child_file.parent = @ancestor 
      @child_file.save!

      @descendent_kol = Collection.new()
      @descendent_kol.depositor = "Will" 
      @descendent_kol.parent_collection = @child_col 
      @descendent_kol.save!

      @descendent_file = CoreFile.new()
      @descendent_file.depositor = "Will" 
      @descendent_file.parent = @descendent_kol
      @descendent_file.save!

      @random_file = CoreFile.new()
      @random_file.depositor = "Will" 
      @random_file.save! 

      @random_kol  = Collection.new()
      @random_kol.depositor = "Will" 
      @random_kol.save!
    end

    it "can find children" do 
      expected = [@child_col, @child_file] 

      expect(@ancestor.children(:return_as => :models)).to match_array expected 
    end

    it "returns an empty array when no children exist" do 
      expect(@random_kol.children(:return_as => :models)).to match_array [] 
    end

    it "can find children who are records" do 
      expected  = [@child_file] 

      expect(@ancestor.records(:return_as => :models)).to match_array expected
    end

    it "can find children who are collections" do 
      expected = [@child_col]
      expect(@ancestor.collections(:return_as => :models)).to match_array expected
    end

    it "can find all descendents" do 
      expected = [@child_col, @child_file, @descendent_file, @descendent_kol]
      expect(@ancestor.descendents(:return_as => :models)).to match_array expected 
    end

    it "can find all descendents who are records" do
      expected = [@child_file, @descendent_file]
      expect(@ancestor.descendent_records(:return_as => :models)).to match_array expected
    end 

    it "can find all descendents who are collections" do 
      expected = [@child_col, @descendent_kol]
      expect(@ancestor.descendent_collections(:return_as => :models)).to match_array expected
    end

    after(:all) do 
      @ancestor.destroy ; @child_col.destroy ; @child_file.destroy
      @random_file.destroy ; @descendent_kol.destroy ; @descendent_file.destroy  
    end
  end

  it_behaves_like "A Properties Delegator"
  it_behaves_like "a paranoid rights validator"
end