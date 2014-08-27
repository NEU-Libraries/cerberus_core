class CoreFile < CerberusCore::BaseModels::CoreFile
  relate_to_parent_collection(:parent, "Collection")
end