# This module implements the basic functionality for a core record in any head
# based off the DRS Architecture.  Core records are fedora objects that hold 
# metadata related to any number of content objects (defined in 
# DrsCore::ContentObject) attached to them via the standard isPartOf
# relationship.  Must be subclassed off an object extending ActiveFedora::Base
module DrsCore::CoreRecord
  extend ActiveSupport::Concern 

  included do
    include DrsCore::Concerns::ParanoidRightsValidation
    include Hydra::ModelMixins::RightsMetadata
    include Hydra::ModelMethods

    include DrsCore::Concerns::PropertiesDatastreamDelegations

    before_destroy :destroy_content_objects

    # Every CoreRecord class should specify an array of model names
    # as strings for the content objects that can exist off this CoreRecord
    # under the constant CONTENT_CLASSES.  E.g. 
    # a CoreRecord class that has AudioFile and VideoFile content object children
    # would specify CONTENT_CLASSES = ["AudioFile", "VideoFile"]
    CONTENT_CLASSES = nil

    # Default datastreams 
    has_metadata name: "DC", type: DrsCore::Datastreams::DublinCoreDatastream
    has_metadata name: "mods", type: DrsCore::Datastreams::ModsDatastream
    has_metadata name: "properties", type: DrsCore::Datastreams::PropertiesDatastream
    has_metadata name: "rightsMetadata", type: DrsCore::Datastreams::ParanoidRightsDatastream
  end

  # Fetches all content objects that are attached to this core record (using solr) 
  # and returns them cast to their fedora model objects
  def content_objects
    fedora_object_from_solr(content_object_query_result) 
  end 

  # Fetches the canonical content object for this core record
  def canonical_object 
    all = content_object_query_result
    obj = all.find { |x| x["canonical_tesim"] == ['yes'] } 
    obj["active_fedora_model_ssi"].constantize.find(obj["id"])
  end

  # Destroy every content object attached to this CoreRecord
  def destroy_content_objects
    content_objects.map { |x| x.destroy } 
  end

  private 

    def content_object_query_result
      content = self.class::CONTENT_CLASSES.map{ |x| "\"#{x}\""}.join(" OR ")
      models = "active_fedora_model_ssi:(#{content})"

      belongs_to_this = "is_part_of_ssim:\"info:fedora/#{self.pid}\""

      as = ActiveFedora::SolrService
      query_result = as.query("#{models} AND #{belongs_to_this}", rows: 999)
    end

    def fedora_object_from_solr(arry) 
      arry.map do |r| 
        r["active_fedora_model_ssi"].constantize.find(r["id"])
      end
    end
end
