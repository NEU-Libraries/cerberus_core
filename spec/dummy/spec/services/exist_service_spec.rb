require "spec_helper"

describe CerberusCore::Services::ExistService do 
  let(:exist) { CerberusCore::Services::ExistService.new } 

  describe "Validation" do 
    it "throws out invalid xml" do 
      xml = "<test>one"
      e   = Nokogiri::XML::SyntaxError
      expect{exist.post_document(xml, "c/one")}.to raise_error e
    end
  end
end