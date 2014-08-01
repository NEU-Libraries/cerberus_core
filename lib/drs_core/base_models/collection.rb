module DrsCore::BaseModels
  # Implements the notion of a collection holding core records and other
  # collections.  Collections may belong to Communities but cannot have 
  # Communities as children. 
  class Collection < ActiveFedora::Base
    include DrsCore::Concerns::ParanoidRightsValidation
    include Hydra::ModelMixins::RightsMetadata
    include Hydra::ModelMethods 

    include DrsCore::Concerns::PropertiesDatastreamDelegations
    include DrsCore::Concerns::Relatable
    include DrsCore::Concerns::Traversals

    has_metadata name: 'DC', type: DrsCore::Datastreams::DublinCoreDatastream
    has_metadata name: 'rightsMetadata', type: DrsCore::Datastreams::ParanoidRightsDatastream
    has_metadata name: 'properties', type: DrsCore::Datastreams::PropertiesDatastream
    has_metadata name: 'mods', type: DrsCore::Datastreams::ModsDatastream

    # Records the model names for core record type classes that can have
    # an instance of this collection as their parent.  E.g. a child of the 
    # Collection class that has CoreFile children would specify
    # CORE_RECORD_CLASSES = ["CoreFile"]
    CORE_RECORD_CLASSES = []

    # Records the model names for folder type classes that can have an instance
    # of this collection as their parent.  Typically this will be the model that
    # FOLDER_CLASSES is being defined for.  
    # E.g. Collection::FOLDER_CLASSES = ["Collection"]
    FOLDER_CLASSES      = []

    def self.relate_to_parent_community(rel_name, rel_class = nil) 
      self.relation_asserter(:belongs_to, rel_name, :is_member_of, rel_class)
    end

    def self.relate_to_parent_collection(rel_name, rel_class = nil) 
      self.relation_asserter(:belongs_to, rel_name, :is_member_of, rel_class)
    end
  end
end
