require 'spec_helper' 

describe TestFileContentDatastream do
  let(:content) { TestFileContentDatastream.new }

  describe "Inherited Functionality:" do 
    it "provides the characterize method" do 
      expect(content.respond_to? :characterize).to be true 
    end
  end
end