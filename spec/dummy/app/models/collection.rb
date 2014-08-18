class Collection < DrsCore::BaseModels::Collection

  relate_to_parent_collection(:parent_collection, "Collection")
  relate_to_parent_community(:parent_community, "Community")

  CORE_RECORD_CLASSES = ["CoreFile"]
  COLLECTION_CLASSES  = ["Collection"]
end