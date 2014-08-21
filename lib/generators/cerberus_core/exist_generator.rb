module CerberusCore
  class ExistGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def insert_war_file
      #TODO
    end

    def insert_context_file
      puts "copying over exist db context file"
      copy_file "exist.xml", "#{Rails.root}/jetty/contexts/exist.xml"
    end

    def insert_config_file
      puts "copying over exist db connector configuration"
      copy_file "exist.yml", "#{Rails.root}/config/exist.yml" 
    end
  end
end