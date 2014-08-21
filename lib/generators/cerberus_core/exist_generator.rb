module CerberusCore
  class ExistGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def insert_war_file
      #TODO
    end

    def insert_context_file
      puts "copying over exist db context file"
      path = "#{Rails.root}/jetty/contexts"
      copy_file "exist.xml", "#{path}/exist.xml"
    end

    def insert_config_file
      puts "copying over exist db connector configuration"
      path = "#{Rails.root}/config"
      copy_file "exist_db.yml", "#{path}/exist_db.yml" 
    end
  end
end