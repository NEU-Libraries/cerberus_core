module DrsCore::BaseModels
  # Implements the notion of a content object, which is a fedora object
  # holding a piece of content, e.g. a picture or an XML file.  Content objects
  # always belong to CoreRecord objects.
  class ContentObject < ActiveFedora::Base
    include Hydra::ModelMixins::RightsMetadata
    include Hydra::ModelMethods

    include DrsCore::Concerns::PropertiesDatastreamDelegations
    include DrsCore::Concerns::Characterizable
    include DrsCore::Concerns::Relatable

    has_metadata name: 'DC', type: DrsCore::Datastreams::DublinCoreDatastream
    has_metadata name: 'rightsMetadata', type: DrsCore::Datastreams::ParanoidRightsDatastream
    has_metadata name: 'properties', type: DrsCore::Datastreams::PropertiesDatastream 
    has_metadata name: 'characterization', type: DrsCore::Datastreams::FitsDatastream
    has_file_datastream name: 'content', type: DrsCore::Datastreams::FileContentDatastream 

    def type_label
      self.class.name
    end

    # We assume in the logic for a core_record object that content objects point
    # at it using the is_part_of relationship.  Using this method to define core record
    # relationships enforces that constraint. 
    # ==== Attributes
    # * +rel_name+ - The symbol name of the relationship.  
    # * +rel_class+ - The stringified model name (class) of the fedora object
    #   this class of content objects belongs to.  Only needs to be passed in when
    #   the model name cannot be inferred from rel_name.  E.g., if the rel_name is 
    #   :core_file, and it points at a class called CoreFile, this can be left set
    #   to nil
    def self.relate_to_core_record(rel_name, rel_class = nil)
      self.relation_asserter(:belongs_to, rel_name, :is_part_of, rel_class)
    end
  end
end