module CerberusCore::BaseModels
  # Implements the notion of a collection holding core records and other
  # collections.  Collections may belong to Communities but cannot have 
  # Communities as children. 
  class Collection < ActiveFedora::Base
    include CerberusCore::Concerns::ParanoidRightsValidation
    include CerberusCore::Concerns::PropertiesDatastreamDelegations
    include CerberusCore::Concerns::ParanoidRightsDatastreamDelegations
    include CerberusCore::Concerns::Relatable
    include CerberusCore::Concerns::Traversals

    has_metadata name: 'DC', type: CerberusCore::Datastreams::DublinCoreDatastream
    has_metadata name: 'rightsMetadata', type: CerberusCore::Datastreams::ParanoidRightsDatastream
    has_metadata name: 'properties', type: CerberusCore::Datastreams::PropertiesDatastream
    has_metadata name: 'mods', type: CerberusCore::Datastreams::ModsDatastream

    # Records the model names for core record type classes that can have
    # an instance of this collection as their parent.  E.g. a child of the 
    # Collection class that has CoreFile children would specify
    # CORE_RECORD_CLASSES = ["CoreFile"]
    CORE_RECORD_CLASSES = []

    # Records the model names for folder type classes that can have an instance
    # of this collection as their parent.  Typically this will be the model that
    # COLLECTION_CLASSES is being defined for.  
    # E.g. Collection::COLLECTION_CLASSES = ["Collection"]
    COLLECTION_CLASSES = []

    # All querying logic assumes that collections are related to communities
    # via the is_member_of relationship.  Using this method to define that
    # relationship enforces this constraint.  See ContentObject for a 
    # description of arguments.
    def self.relate_to_parent_community(rel_name, rel_class = nil) 
      self.relation_asserter(:belongs_to, rel_name, :is_member_of, rel_class)
    end

    # All querying logic assumes that collections are related to their 
    # parent collections via the is_member_of relationship.  Using this 
    # method to define that relationship enforces this constraint.  See 
    # ContentObject for a description of arguments.
    def self.relate_to_parent_collection(rel_name, rel_class = nil) 
      self.relation_asserter(:belongs_to, rel_name, :is_member_of, rel_class)
    end
  end
end
