class Community < CerberusCore::BaseModels::Community
  relate_to_parent_community(:parent_community, "Community") 

  has_collection_types ["Collection"]
  has_community_types  ["Community"]
  has_core_file_types  ["CoreFile"]
end