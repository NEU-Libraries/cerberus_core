module DrsCore::BaseModels
  class Community < ActiveFedora::Base 
    include Hydra::ModelMethods
    include Hydra::ModelMixins::RightsMetadata

    include DrsCore::Concerns::PropertiesDatastreamDelegations
    include DrsCore::Concerns::Relatable
    include DrsCore::Concerns::Traversals

    has_metadata name: 'DC', type: DrsCore::Datastreams::DublinCoreDatastream
    has_metadata name: 'rightsMetadata', type: DrsCore::Datastreams::ParanoidRightsDatastream
    has_metadata name: 'properties', type: DrsCore::Datastreams::PropertiesDatastream
    has_metadata name: 'mods', type: DrsCore::Datastreams::ModsDatastream

    COLLECTION_CLASSES = []

    COMMUNITY_CLASSES  = []

    def self.relate_to_parent_community(rel_name, rel_class = nil)
      self.relation_asserter(:belongs_to, rel_name, :has_affiliation, rel_class) 
    end
  end
end