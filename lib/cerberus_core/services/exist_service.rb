module CerberusCore::Services
  class ExistService 
    attr_accessor :path, :uname, :pwd

    def initialize
      env        = Rails.env.to_s
      config     = YAML.load_file(Rails.root.join("config", "exist.yml").to_s)
      self.path  = config[env]["base"]
      self.uname = config[env]["uname"] || "admin" 
      self.pwd   = config[env]["pwd"] || ""
    end

    def post_document(xml, db_loc)
      validate_xml(xml)
      db_loc.sub!(/^\//, "")
      c = Curl::Easy.new("#{self.path}/#{db_loc}")
      c.http_auth_types         = :basic
      c.username                = self.uname 
      c.pwd                     = self.pwd 
      c.http_post(xml) do |curl|
        curl.headers["Content-Type"] = "application/xml" 
      end
    end

    private 

    def validate_xml(xml)
      Nokogiri::XML(xml) { |config| config.strict } 
    end
  end
end