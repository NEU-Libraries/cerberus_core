class CoreFile < DrsCore::BaseModels::CoreRecord
  relate_to_parent_collection(:parent, "Kollection")

   CONTENT_CLASSES = ["Wigwum", "Wumpus", "Wampus"]
end