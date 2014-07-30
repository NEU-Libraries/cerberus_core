class Wigwum < ActiveFedora::Base 
  belongs_to :core_file, :property => :is_part_of

  include DrsCore::ContentObject
end