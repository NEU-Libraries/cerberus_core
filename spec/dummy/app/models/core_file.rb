class CoreFile < CerberusCore::BaseModels::CoreFile
  relate_to_parent_collection(:parent, "Collection")

   CONTENT_CLASSES = ["Wigwum", "Wumpus", "Wampus"]
end