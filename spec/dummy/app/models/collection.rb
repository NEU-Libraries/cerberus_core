class Collection < CerberusCore::BaseModels::Collection

  relate_to_parent_collection(:parent_collection, "Collection")
  relate_to_parent_community(:parent_community, "Community")

  has_core_file_types  ["CoreFile"]
  has_collection_types ["Collection"]
end