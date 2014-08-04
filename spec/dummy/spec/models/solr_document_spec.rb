require 'spec_helper'

describe SolrDocument do 
  let(:core_file) { CoreFile.new} 

  def doc 
    SolrDocument.new(core_file.to_solr) 
  end

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

  describe "Rights metadata access" do 
    it "allows us to check an object's mass permissions" do
      expect(doc.is_private?).to be true

      core_file.read_groups = ['public']
      expect(doc.is_public?).to be true 

      core_file.read_groups = ['registered']
      expect(doc.is_registered?).to be true 
    end

    it "allows us to see an object's read users" do 
      core_file.read_users = ["Will"]
      expect(doc.read_people).to eq ["Will"]
    end

    it "allows us to see an object's edit users" do 
      core_file.edit_users = ["Will"] 
      expect(doc.edit_people).to eq ["Will"]
    end

    it "allows us to see an object's edit groups" do 
      core_file.edit_groups = ["Willump"]
      expect(doc.edit_groups).to eq ["Willump"]
    end

    it "allows us to see an object's read groups" do 
      core_file.read_groups = ["Willump"]
      expect(doc.read_groups).to eq ["Willump"]
    end
  end

  describe "Properties datastream access" do 
    it "allows us to read an objects depositor" do 
      core_file.apply_depositor_metadata "Will" 
      expect(doc.depositor).to eq "Will" 
    end

    it "allows us to check whether an object is in progress" do 
      core_file.tag_as_in_progress
      expect(doc.in_progress?).to be true

      core_file.tag_as_completed
      expect(doc.in_progress?).to be false
    end

    it "allows us to check if this object is canonical" do 
      expect(doc.canonical?).to be false 
      core_file.canonize
      expect(doc.canonical?).to be true 
    end

    it "allows us to access the thumbnail list" do 
      thumbs = ["url1", "url2", "url3"]
      core_file.thumbnail_list = thumbs
      expect(doc.thumbnail_list).to match_array thumbs
    end
  end
end