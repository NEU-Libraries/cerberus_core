# This module implements the basic functionality for a content bearing object.
# Content bearing objects should be fedora records that store some manner of file 
# blob in the 'content' datastream, and that belong to a core record object that 
# stores all relevant metadata for its various content objects. 
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
    def relate_to_core_record(rel_name, rel_class = nil)
      if rel_class 
       belongs_to rel_name, :property => :is_part_of, :class => rel_class 
      else
        belongs_to rel_name, :property => :is_part_of 
      end
    end
  end
end