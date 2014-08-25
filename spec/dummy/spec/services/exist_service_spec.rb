require "spec_helper"
require "curb"

describe CerberusCore::Services::ExistService do 
  let(:exist) { CerberusCore::Services::ExistService.new }

  after(:each) { CerberusCore::Services::ExistService.wipe_test_directory } 

  describe "Validation" do 
    it "throws out invalid xml" do 
      xml = "<test>one"
      e   = Nokogiri::XML::SyntaxError
      expect{ exist.put_file(xml, "c/one/test.xml") }.to raise_error e
    end

    it "throws out things that aren't even arguably xml" do 
      xml = "23 My Address, Brookline, MA" 
      e   = Nokogiri::XML::SyntaxError
      expect{ exist.put_file(xml, "c/one/test.xml") }.to raise_error e 
    end

    it "throws out put_file requests with directories that look like files" do 
      xml = "<valid>Xml</valid>"
      pth = "c/one/test.xml/test.xml"
      e   = CerberusCore::BadDirectoryNameError
      expect{ exist.put_file(xml, pth) }.to raise_error e 
    end

    it "throws out put_file requests with files that look like directories" do
      xml = "<valid>Xml</valid>"
      pth = "c/one/test/test"
      e   = CerberusCore::BadFileNameError 
      expect{ exist.put_file(xml, pth) }.to raise_error e 
    end
  end

  describe "Post" do 
    it "allows us to upload xml strings to the database" do 
      file = File.open(Rails.root.join("spec", "fixtures", "files", "xml.xml"))
      e    = exist.put_document(xml, "c/one/valid.xml")
      expect(e.response_code).to eq 201
      expect(e.header_str).to eq "blah"
    end
  end
end