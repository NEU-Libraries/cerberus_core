# Implements traversals over the graph of core records, collections, 
# and communities.  Included in Collections and Communities and in 
# SolrDocumentBehavior.
# ==== Options
# All the methods defined in this module take the following options: 
# * +:return_as+ - A symbol dictating how the results of the Solr query 
#   ought to be returned to the user.  The default option is 
#   :query_result, which simply returns the array of solr responses
#   retrieved by ActiveFedora::SolrService.query().  Other options are
#   :models, which casts each result to its fedora object model, and 
#   :solr_document, which returns an array of SolrDocuments. 
module DrsCore::Concerns::Traversals
  # Creates a new QueryService object from the given object. 
  # Ought to know how to create from a fedora level model, 
  # a SolrDocument, or a raw response hash.  
  def new_query
    DrsCore::Services::QueryService.create_from_object(self)
  end

  # Fetch all children (immediate descendents) of this fedora object.
  def children(opts)
    new_query.get_children opts
  end

  # Fetch all descendents of this fedora object.
  def descendents(opts) 
    new_query.get_descendents opts 
  end

  # Fetch all children which are named in CORE_RECORD_CLASSES
  # for this fedora object.
  def records(opts) 
    new_query.get_child_records opts
  end

  # Fetch all descendents which are named in CORE_RECORD_CLASSES
  # for this fedora object.
  def descendent_records(opts) 
    new_query.get_descendent_records opts 
  end

  # Fetch all children which are named in COLLECTION_CLASSES
  # for this fedora object.
  def collections(opts) 
    new_query.get_child_collections opts 
  end

  # Fetch all descendents which are named in COLLECTION_CLASSES
  # for this fedora object.
  def descendent_collections(opts) 
    new_query.get_descendent_collections opts 
  end

  # Fetch all children which are named in COMMUNITY_CLASSES
  # for this fedora object.
  def communities(opts) 
    new_query.get_child_communities opts
  end

  # Fetch all descendents which are named in COMMUNITY_CLASSES
  # for this fedora object.
  def descendent_communities(opts)
    new_query.get_descendent_communities opts
  end
end