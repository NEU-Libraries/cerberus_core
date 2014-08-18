module CerberusCore::BaseModels
  # Implements the notion of a community, which is an object describing
  # a project with affiliated users, collections, and records.  Communities
  # may belong only to other communities via the has_affiliation relationship.
  class Community < ActiveFedora::Base 
    include Hydra::ModelMethods
    include Hydra::ModelMixins::RightsMetadata

    include CerberusCore::Concerns::PropertiesDatastreamDelegations
    include CerberusCore::Concerns::Relatable
    include CerberusCore::Concerns::Traversals

    has_metadata name: 'DC', type: CerberusCore::Datastreams::DublinCoreDatastream
    has_metadata name: 'rightsMetadata', type: CerberusCore::Datastreams::ParanoidRightsDatastream
    has_metadata name: 'properties', type: CerberusCore::Datastreams::PropertiesDatastream
    has_metadata name: 'mods', type: CerberusCore::Datastreams::ModsDatastream

    # An array of model names for every Collection class that may have this 
    # Community class as a parent. E.g. COLLECTION_CLASSES = ["Kollection"]
    COLLECTION_CLASSES = []

    # An array of model names for every Community class that may have this 
    # Community class as a parent.  E.g. COMMUNITY_CLASSES = ["Community"] 
    COMMUNITY_CLASSES  = []

    # An array of model names for every Core Record class that may have this 
    # Community class as a *descendent*.  Note that we assume that core records
    # typically won't be directly attached to Communities.  E.g. 
    # CORE_RECORD_CLASSES = ["CoreFile"] 
    CORE_RECORD_CLASSES = []

    # We assume that communities are related to their parent communities via 
    # the has_affiliation relationship.  Using this method to define that
    # relationship enforces this constraint.  See ContentObject for an arg 
    # description.
    def self.relate_to_parent_community(rel_name, rel_class = nil)
      self.relation_asserter(:belongs_to, rel_name, :has_affiliation, rel_class) 
    end
  end
end