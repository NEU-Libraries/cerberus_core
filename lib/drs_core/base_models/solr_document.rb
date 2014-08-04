# -*- encoding: utf-8 -*-
module DrsCore::BaseModels
  class SolrDocument 
    include Blacklight::Solr::Document
    include DrsCore::Concerns::Traversals
  end
end