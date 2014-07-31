# This module implements the basic functionality for a content bearing object.
module DrsCore::ContentObject
  extend ActiveSupport::Concern

  included do
    include Hydra::ModelMixins::RightsMetadata
    include Hydra::ModelMethods

    include DrsCore::Concerns::PropertiesDatastreamDelegations
    include DrsCore::Concerns::Characterizable

    has_metadata name: 'DC', type: DrsCore::Datastreams::DublinCoreDatastream
    has_metadata name: 'rightsMetadata', type: DrsCore::Datastreams::ParanoidRightsDatastream
    has_metadata name: 'properties', type: DrsCore::Datastreams::PropertiesDatastream 
    has_metadata name: 'characterization', type: DrsCore::Datastreams::FitsDatastream
    has_file_datastream name: 'content', type: DrsCore::Datastreams::FileContentDatastream 
  end

  def type_label
    self.class.name
  end

  module ClassMethods
    def relate_to_core_record(rel_name, rel_class = nil)
      if rel_class 
       belongs_to rel_name, :property => :is_part_of, :class => rel_class 
      else
        belongs_to rel_name, :property => :is_part_of 
      end
    end
  end
end