require 'spec_helper'

describe CoreFile do 

  describe "datastreams" do 
    let (:x) { CoreFile.new() } 

    it "are implemented with the proper keys" do 
      expected_keys = ["DC", "rightsMetadata", "properties", "mods", "RELS-EXT"]
      x.datastreams.keys.should =~ expected_keys
    end
  end
end