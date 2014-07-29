require 'spec_helper'

describe DrsCore::Datastreams::PropertiesDatastream do
  let (:properties) { DrsCore::Datastreams::PropertiesDatastream.new } 

  describe "Canonization" do 
    it "can be set" do 
      properties.canonical?.should be false 
      properties.canonize
      properties.canonical?.should be true 
    end

    it "can be unset" do 
      properties.canonize
      properties.uncanonize
      properties.canonical?.should be false 
    end
  end

  describe "In Progress State" do 

    it "can be set" do 
      properties.in_progress?.should be false 
      properties.tag_as_in_progress
      properties.in_progress?.should be true 
    end

    it "can be unset" do 
      properties.tag_as_in_progress
      properties.tag_as_completed
      properties.in_progress?.should be false 
    end
  end

  describe "Thumbnail lists" do 

    it "start empty" do 
      properties.thumbnail_list = []
    end

    it "but can be added to" do 
      thumbs = ["path/to/obj?dsid=1", "path/to/obj?dsid=2"]

      properties.thumbnail_list = thumbs
      properties.thumbnail_list.should =~ thumbs 

      properties.thumbnail_list = ["path/to/obj?dsid=3"]
      properties.thumbnail_list.should =~ ["path/to/obj?dsid=3"]
    end
  end
end