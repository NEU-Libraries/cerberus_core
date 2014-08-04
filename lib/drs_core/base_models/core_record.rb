# This module implements the notion of a core record.  
# Core records are fedora objects that hold 
# metadata related to any number of content objects (defined in 
# DrsCore::ContentObject) attached to them via the standard isPartOf
# relationship.  Core records can belong to collections.
module DrsCore::BaseModels
  class CoreRecord < ActiveFedora::Base
    include DrsCore::Concerns::ParanoidRightsValidation
    include Hydra::ModelMixins::RightsMetadata
    include Hydra::ModelMethods

    include DrsCore::Concerns::PropertiesDatastreamDelegations
    include DrsCore::Concerns::Relatable

    before_destroy :destroy_content_objects

    # Every CoreRecord class should specify an array of model names
    # as strings for the content objects that can exist off this CoreRecord.
    # E.g. a CoreRecord class that has AudioFile and VideoFile content object
    # children would specify CONTENT_CLASSES = ["AudioFile", "VideoFile"]
    CONTENT_CLASSES = nil

    # Default datastreams 
    has_metadata name: "DC", type: DrsCore::Datastreams::DublinCoreDatastream
    has_metadata name: "mods", type: DrsCore::Datastreams::ModsDatastream
    has_metadata name: "properties", type: DrsCore::Datastreams::PropertiesDatastream
    has_metadata name: "rightsMetadata", type: DrsCore::Datastreams::ParanoidRightsDatastream

    # All querying logic assumes that core records are related to their parent 
    # collections via the is_member_of relationship.  Using this method to define
    # that relationship enforces this constraint.  See ContentObject for a
    # description of the arguments.
    def self.relate_to_parent_collection(rel_name, rel_class = nil)
      self.relation_asserter(:belongs_to, rel_name, :is_member_of, rel_class)
    end

    # Fetches all content objects that are attached to this core record (using solr)
    # See Traversals for a description of available opts.
    def content_objects(opts = {})
      qs = DrsCore::Services::QueryService.new(self.pid, self.class.name)
      qs.get_content_objects(opts) 
    end 

    # Fetches the canonical content object for this core record.
    # Assumes that only one exists and will silently ignore any objects
    # tagged as such beyond the first result found.  See Traversals for a
    # description of available opts.
    def canonical_object(opts = {})
      qs = DrsCore::Services::QueryService.new(self.pid, self.class.name)
      qs.get_canonical_object(opts)
    end

    # Destroy every content object attached to this CoreRecord
    def destroy_content_objects
      content_objects(:return_as => :models).map { |x| x.destroy } 
    end

    private
      # :nodoc:
      def fedora_object_from_solr(arry) 
        arry.map do |r| 
          r["active_fedora_model_ssi"].constantize.find(r["id"])
        end
      end
  end
end
