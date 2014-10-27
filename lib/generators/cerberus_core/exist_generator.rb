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
        jetty/webapps/exist-2.2-rev.war
        jetty/contexts/exist.xml
        config/exist.yml
    eos

    def insert_war_file
      say "Creating exist .war file", :green
      pth = "#{Rails.root}/jetty/webapps"
      if File.exists?("#{pth}/exist-2.2-rev.war")
        say "#{pth}/exist-2.2-rev.war already exists - skipping", :yellow
      else
        url = "librarystaff.neu.edu/DRSzip/exist-2.2-rev.war"
        run "wget #{url} -O #{pth}/exist-2.2-rev.war"
      end
    end

    def insert_context_file
      say "copying over exist db context file", :green
      copy_file "exist.xml", "#{Rails.root}/jetty/contexts/exist.xml"
    end

    def insert_config_file
      say "copying over exist db connector configuration", :green
      copy_file "exist.yml", "#{Rails.root}/config/exist.yml" 
    end
  end
end