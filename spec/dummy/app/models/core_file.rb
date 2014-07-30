class CoreFile < ActiveFedora::Base
   include DrsCore::CoreRecord

   CONTENT_CLASSES = ["Wigwum", "Wumpus"]
end