class Community < DrsCore::BaseModels::Community
  relate_to_parent_community(:parent_community, "Community") 

  COLLECTION_CLASSES  = ["Kollection"]

  COMMUNITY_CLASSES   = ["Community"]

  CORE_RECORD_CLASSES = ["CoreFile"]
end