module DrsCore::Datastreams
  # Catch all datastream for information that didn't have another home.
  # Also useful for implementing persistence of information that isn't interesting
  # from an archival/curation point of view, for example an array of urls pointing
  # at the thumbnail file locations for this object, which is useful for reading 
  # from solr responses.
  class PropertiesDatastream < ActiveFedora::OmDatastream
    set_terminology do |t|
      t.root(:path=>"fields" )
      # This is where we put the user id of the object depositor -- impacts permissions/access controls
      t.parent_id :index_as=>[:stored_searchable]
      t.depositor :index_as=>[:stored_searchable]
      t.thumbnail_list :index_as=>[:stored_searchable]
      t.canonical  :index_as=>[:stored_searchable]
      t.in_progress path: 'inProgress', :index_as=>[:stored_searchable]
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.fields
      end
      builder.doc
    end

    DELEGATES = [:in_progress?, :tag_as_in_progress, :tag_as_completed,
                 :canonize, :uncanonize, :canonical?]

    # Checks if the Fedora object is in progress, indicating
    # that the system must do additional work before it can be 
    # considered 'complete'.  Typically, this additional work involves
    # content objects pointing at a core record that should be created
    # before the object is displayed to the world.
    def in_progress?
      return ! self.in_progress.empty?
    end

    def tag_as_in_progress
      self.in_progress = 'true'
    end

    def tag_as_completed
      self.in_progress = []
    end

    # Indicates that this (typically content) object is the chief object
    # associated with some other object (typically a core record), and that
    # this should be read in cases where that question may be ambiguous. 
    def canonize
      self.canonical = 'yes'
    end

    def uncanonize
      self.canonical = ''
    end

    def canonical?
      return self.canonical.first == 'yes'
    end
  end
end