class Collection < CerberusCore::BaseModels::Collection

  parent_collection_relationship :collection
  parent_community_relationship :community

  has_core_file_types  ["CoreFile"]
  has_collection_types ["Collection"]
end