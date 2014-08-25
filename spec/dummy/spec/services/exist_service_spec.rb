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

  describe "#put_file" do 
    it "allows us to upload xml strings to the database" do 
      xml = File.read(Rails.root.join("spec", "fixtures", "files", "xml.xml"))
      e   = exist.put_file(xml, "c/one/valid.xml")
      expect(e.response_code).to eq 201
    end
  end

  describe "#get_resource" do 

    it "throws an error on invalid GET requests" do 
      e = CerberusCore::InvalidExistInteractionError
      expect{ exist.get_resource("nope/nope/nope.xml") }.to raise_error e 
    end

    it "retrieves the body of the document on valid GET doc requests" do 
      xml = "<valid>XML</valid>" 
      exist.put_file(xml, "a/b/test.xml")
      expect(exist.get_resource "a/b/test.xml").to eq xml 
    end

    it "retrieves the XML collection description for collections" do 
      exist.put_file("<v>b</v>", "a.xml")
      expect(exist.get_resource "").not_to eq ""
    end
  end
end