require 'active-fedora'
require 'hydra/head'
require 'hydra/derivatives'

module DrsCore
  require 'drs_core/datastreams/properties_datastream'
  require 'drs_core/datastreams/file_content_datastream'
  require 'drs_core/datastreams/dublin_core_datastream'
  require 'drs_core/datastreams/mods_datastream'
  require 'drs_core/datastreams/paranoid_rights_datastream'
  require 'drs_core/datastreams/fits_datastream'

  require 'drs_core/concerns/paranoid_rights_validation'
  require 'drs_core/concerns/properties_datastream_delegations'
  require 'drs_core/concerns/characterizable'
  require 'drs_core/concerns/relatable'

  require 'drs_core/services/query_service'

  require 'drs_core/base_models/content_object'
  require 'drs_core/base_models/core_record'
  require 'drs_core/base_models/collection'
end
