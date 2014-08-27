module CerberusCore
  class BaseModelsGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc <<-eos
    Description: 
      Creates the three models (CoreFile, Collection, Community) that are 
      assumed to be the basis for any Cerberus-ish type head.  It will also
      create an empty directory called content_types, in which the content file 
      models required for the head ought to be defined.  It will also also create 
      an empty directory called datastreams, in which any new datastreams/extensions 
      of provided datastreams ought to go.     

      Example: 
        rails generate cerberus_core:base_models

      This will create: 
        app/models/core_file.rb
        app/models/collection.rb 
        app/models/community.rb 
        app/models/content_types/
        app/models/content_types/.gitkeep
        app/models/datastreams/
        app/models/datastreams/.gitkeep
      eos

    def copy_core_file 

    end

    def copy_collection

    end

    def copy_community 

    end

    def create_content_types_dir

    end

    def create_datastreams_dir 

    end
  end 
end 