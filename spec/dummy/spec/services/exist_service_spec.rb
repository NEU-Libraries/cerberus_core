require "spec_helper"
require "curb"

describe CerberusCore::Services::ExistService do 
  let(:exist) { CerberusCore::Services::ExistService.new }

  after(:each) { CerberusCore::Services::ExistService.wipe_test_directory } 

  describe "Validation" do 
    it "throws out invalid xml" do 
      xml = "<test>one"
      e   = Nokogiri::XML::SyntaxError
      expect{exist.put_file(xml, "c/one/test.xml")}.to raise_error e
    end

    it "throws out things that aren't even arguably xml" do 
      xml = "23 My Address, Brookline, MA" 
      e   = Nokogiri::XML::SyntaxError
      expect{exist.put_file(xml, "c/one/test.xml")}.to raise_error e 
    end

    it "throws out attempts to save files to non-file locations" do 
      xml = "<valid>Xml</valid>"
      pth = "c/one/test.dir/test.xml"
      e   = CerberusCore::BadDirectoryNameError
      expect{exist.put_file(xml, pth)}.to raise_error e 
    end
  end

  # describe "Post" do 
  #   it "allows us to upload xml strings to the database" do 
  #     file = File.open(Rails.root.join("spec", "fixtures", "files", "xml.xml"))
  #     e    = exist.put_document(xml, "c/one")
  #     expect(e.response_code).to eq 201
  #     expect(e.header_str).to eq "blah"
  #   end
  # end

  # describe "Wipe test directory" do 
  #   it "eliminates the entire test directory when invoked" do
  #     dirs      = ["c/one", "d/one", "e/one"]

  #     responses = dirs.map  { |dir| exist.post_document("<a>b</a>", dir) }
  #     expect(responses.map { |r| r.response_code}).to match_array [201, 201, 201]

  #     CerberusCore::Services::ExistService.wipe_test_directory

  #     expect(exist.get_document("c/one").response_code).to eq 404
  #   end
  # end
end