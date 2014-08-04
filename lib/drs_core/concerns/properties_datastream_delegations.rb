# Handles delegations to the properties datastream which are assumed
# to be universally useful. 
module DrsCore::Concerns::PropertiesDatastreamDelegations
  extend ActiveSupport::Concern 

  included do 
    delegate :in_progress?, to: "properties"
    delegate :tag_as_in_progress, to: "properties"
    delegate :tag_as_completed, to: "properties" 
    delegate :canonize, to: "properties" 
    delegate :uncanonize, to: "properties" 
    delegate :canonical?, to: "properties" 
    has_attributes :depositor, datastream: "properties", multiple: false
    has_attributes :thumbnail_list, datastream: "properties", multiple: true

    # Overrides the depositor= delegation to ensure that
    # #apply_depositor_metadata from Hydra::ModelMethods is 
    # used instead. 
    # ==== Attributes 
    # * +whatever+ - The thing you wish to set as the depositor.  Is passed
    #   straight to #apply_depositor_metadata, so look there to see behavior.
    def depositor=(whatever) 
      self.apply_depositor_metadata whatever 
    end
  end
end