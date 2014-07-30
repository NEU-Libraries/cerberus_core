module DrsCore::Concerns::PropertiesDatastreamDelegations
  extend ActiveSupport::Concern 

  included do 
    delegate :in_progress?, to: "properties"
    delegate :tag_as_in_progress, to: "properties"
    delegate :tag_as_completed, to: "properties" 
    delegate :canonize, to: "properties" 
    delegate :uncanonize, to: "properties" 
    delegate :canonical?, to: "properties" 
    delegate :depositor, to: "properties", unique: true 
  end
end