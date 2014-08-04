require 'spec_helper'

describe SolrDocument do 

  describe "Traversals" do 
    let(:doc) { SolrDocument.new(@community.to_solr) } 

    before :all do 
      @community = Community.create 

      @collection = Kollection.new 
      @collection.depositor = "Will" 
      @collection.parent_community = @community
      @collection.save! 

      @core_file = CoreFile.new 
      @core_file.depositor = "Will" 
      @core_file.parent = @collection
      @core_file.save! 
    end

    it "can be run" do 
      expect(@community.children(:return_as => :models)).to match_array [@collection]  
    end

    it "can return other SolrDocuments" do 
      result = @community.descendents(:return_as => :solr_documents) 

      expect(result.map{|x| x.class.name}).to match_array ["SolrDocument", "SolrDocument"]
      expect(result.map{|x| x["id"]}).to match_array [@collection.pid, @core_file.pid]
    end

    after :all do 
      @community.destroy
      @collection.destroy 
      @core_file.destroy 
    end
  end
end