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

    def self.wipe_test_directory
      config = YAML.load_file(Rails.root.join("config", "exist.yml").to_s)
      path   = config["test"]["base"]
      uname  = config["test"]["uname"] || "admin" 
      pwd    = config["test"]["pwd"]   || ""

      c = Curl::Easy.new("#{path}")
      c.http_auth_types = :basic 
      c.username        = uname 
      c.password        = pwd 
      c.http_delete
    end

    def self.test_put
      x = CerberusCore::Services::ExistService.new
      puts "path is #{x.path}"
      puts "username is #{x.uname}"
      puts "pwd is #{x.pwd}"
      response = x.put_file("<xml>One</xml>", "test_two/three/test/test.xml")
      puts response.response_code
    end

    def put_file(xml, db_loc)
      validate_xml(xml)
      validate_file_path(db_loc)
      c = authed_curl(build_path(db_loc))
      c.http_put(xml) do |curl|
        curl.headers["Content-Type"]   = "application/xml" 
        curl.headers["Content-Length"] = xml.length
      end
      return c
    end 

    private 

    def build_path(loc)
      "#{self.path}/#{loc.sub(/^\//, "")}"
    end

    def authed_curl(full_path)
      Curl::Easy.new(full_path).tap do |c| 
        c.http_auth_types = :basic 
        c.username        = self.uname 
        c.password        = self.pwd 
      end
    end

    # Loading the xml string into Nokogiri with 'strict' 
    # configuration should reject anything invalid with a 
    # Nokogiri::XML::SyntaxError
    def validate_xml(xml)
      Nokogiri::XML(xml) { |config| config.strict } 
    end

    # Ensures attempts at file upload are being placed in locations
    # that look like files
    def validate_file_path(path)
      path_array = path.split("/")
      last_index = path_array.length - 1
      path_array.each_with_index do |segment, i| 
        unless i == last_index
          if segment.include? "."
            msg = "Directory names cannot include periods or slashes"
            raise CerberusCore::BadDirectoryNameError.new msg 
          end
        else
          unless segment.include? "." 
            msg = "Files must have names that look like filenames" 
            raise CerberusCore::BadFileNameError.new msg 
          end
        end
      end
    end
  end
end