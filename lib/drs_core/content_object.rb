# This module implements the basic functionality for a content bearing object.
module DrsCore::ContentObject
  extend ActiveSupport::Concern

  included do
    include DrsCore::Concerns::ParanoidRightsValidation

    include Hydra::ModelMixins::RightsMetadata
    include Hydra::ModelMethods

    include DrsCore::Concerns::PropertiesDatastreamDelegations

    has_metadata name: 'DC', type: DrsCore::Datastreams::DublinCoreDatastream
    has_metadata name: 'rightsMetadata', type: DrsCore::Datastreams::ParanoidRightsDatastream
    has_metadata name: 'properties', type: DrsCore::Datastreams::PropertiesDatastream 
    has_file_datastream name: 'content', type: DrsCore::Datastreams::FileContentDatastream 
  end

  def type_label
    self.class.name
  end
end