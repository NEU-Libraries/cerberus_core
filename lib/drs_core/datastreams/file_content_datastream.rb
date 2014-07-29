module DrsCore::Datastreams
  class FileContentDatastream < ActiveFedora::Datastream
    include Hydra::Derivatives::ExtractMetadata
  end
end
