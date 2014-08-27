module CerberusCore
  class ExistGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc <<-eos 
    Description:
      Given a preexisting hydra-jetty installation (rails g hydra:jetty), this
      generator sets up an instance of eXist-db to run alongside Fedora and Solr.

    Example:
      rails generate cerberus_core:exist

    This will create:
        jetty/webapps/exist-2.2.rev.war
        jetty/contexts/exist.xml
        config/exist_db.yml
    eos

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