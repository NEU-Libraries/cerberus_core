require 'active-fedora'
require 'hydra/head'
require 'hydra/derivatives'

module CerberusCore
  require 'exceptions'

  require 'cerberus_core/datastreams/properties_datastream'
  require 'cerberus_core/datastreams/file_content_datastream'
  require 'cerberus_core/datastreams/dublin_core_datastream'
  require 'cerberus_core/datastreams/mods_datastream'
  require 'cerberus_core/datastreams/paranoid_rights_datastream'
  require 'cerberus_core/datastreams/fits_datastream'

  require 'cerberus_core/concerns/paranoid_rights_validation'
  require 'cerberus_core/concerns/properties_datastream_delegations'
  require 'cerberus_core/concerns/paranoid_rights_datastream_delegations'
  require 'cerberus_core/concerns/file_content_datastream_delegations'
  require 'cerberus_core/concerns/characterizable'
  require 'cerberus_core/concerns/relatable'
  require 'cerberus_core/concerns/traversals'

  require 'cerberus_core/services/query_service'

  require 'cerberus_core/base_models/content_object'
  require 'cerberus_core/base_models/core_record'
  require 'cerberus_core/base_models/collection'
  require 'cerberus_core/base_models/community'

  require 'cerberus_core/scripts'
end
