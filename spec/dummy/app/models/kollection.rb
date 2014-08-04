class Kollection < DrsCore::BaseModels::Collection

  relate_to_parent_collection(:parent_kollection, "Kollection")
  relate_to_parent_community(:parent_community, "Community")

  CORE_RECORD_CLASSES = ["CoreFile"]
  COLLECTION_CLASSES  = ["Kollection"]
end