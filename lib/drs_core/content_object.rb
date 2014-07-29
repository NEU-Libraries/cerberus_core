# This module implements the basic functionality for a content bearing object.
module DrsCore::ContentObject
  extend ActiveSupport::Concern

  # Provides permissions logic for accessing read/edit groups/persons, 
  # Setting read/edit groups/persons, etc.
  include Hydra::ModelMixins::RightsMetadata

  # Primarily useful for adding the add_file method
  include Hydra::ModelMethods

  included do 
    # has_metadata name: 'DC', type: DrsCore::Datastreams::NortheasternDublinCoreDatastream
    # has_metadata name: 'rightsMetadata', type: DrsCore::Datastreams::ParanoidRightsDatastream
    # has_metadata name: 'properties', type: DrsCore::Datastreams::DrsPropertiesDatastream 
    # has_file_datastream name: 'content', type: DrsCore::Datastreams::FileContentDatastream 
  end

  def type_label
    self.class.name 
  end
end