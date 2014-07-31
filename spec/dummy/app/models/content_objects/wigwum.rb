class Wigwum < ActiveFedora::Base 
  include DrsCore::ContentObject

  relate_to_core_record(:core_file)
end