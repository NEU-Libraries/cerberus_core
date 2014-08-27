class Community < CerberusCore::BaseModels::Community
  parent_community_relationship :community

  has_collection_types ["Collection"]
  has_community_types  ["Community"]
  has_core_file_types  ["CoreFile"]
end