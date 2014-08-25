module CerberusCore::Services
  class ExistService 
    attr_accessor :path, :username, :password

    def initialize
      env        = Rails.env.to_s
      config     = YAML.load_file(Rails.root.join("config", "exist.yml").to_s)
      self.path  = config[env]["base"]
      self.username = config[env]["username"] || "admin" 
      self.password   = config[env]["password"] || ""
    end

    def self.wipe_test_directory
      config = YAML.load_file(Rails.root.join("config", "exist.yml").to_s)
      path   = config["test"]["base"]
      username  = config["test"]["username"] || "admin" 
      password    = config["test"]["password"]   || ""

      c = Curl::Easy.new("#{path}")
      c.http_auth_types = :basic 
      c.username        = username 
      c.password        = password 
      c.http_delete
    end

    def get_resource(db_loc)
      c = authed_curl(build_path(db_loc))
      c.http_get

      unless c.response_code == 200 
        msg = "Server responded with status #{c.response_code}"
        raise CerberusCore::InvalidExistInteractionError, msg 
      end

      return c.body_str 
    end

    def put_file(xml, db_loc)
      validate_xml(xml)
      validate_file_path(db_loc)
      c = authed_curl(build_path(db_loc))

      c.http_put(xml) do |curl|
        curl.headers["Content-Type"]   = "application/xml" 
        curl.headers["Content-Length"] = xml.length
      end

      # If the resource was not created raise an error
      unless [200, 204, 201].include? c.response_code
        msg = "Server responded with status #{c.response_code}"
        raise CerberusCore::InvalidExistInteractionError, msg
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
        c.username        = self.username 
        c.password        = self.password 
      end
    end

    # Loading the xml string into Nokogiri with 'strict' 
    # configuration should reject anything invalid with a 
    # Nokogiri::XML::SyntaxError
    def validate_xml(xml)
      Nokogiri::XML(xml) { |config| config.strict } 
    end

    # Ensures attempts at file upload are being placed in locations
    # that look like files, with the specified collections also all 
    # looking like collections
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