module DrsCore::Concerns::Characterizable
  extend ActiveSupport::Concern 

  included do 
    delegate :mime_type, :to => :characterization, :unique => true
    has_attributes :format_label, :file_size, :last_modified,
                   :filename, :original_checksum, :rights_basis,
                   :copyright_basis, :copyright_note,
                   :well_formed, :valid, :status_message,
                   :file_title, :file_author, :page_count,
                   :file_language, :word_count, :character_count,
                   :paragraph_count, :line_count, :table_count,
                   :graphics_count, :byte_order, :compression,
                   :width, :height, :color_space, :profile_name,
                   :profile_version, :orientation, :color_map,
                   :image_producer, :capture_device,
                   :scanning_software, :exif_version,
                   :gps_timestamp, :latitude, :longitude,
                   :character_set, :markup_basis,
                   :markup_language, :duration, :bit_depth,
                   :sample_rate, :channels, :data_format, :offset,
                   datastream: "fits", 
                   multiple: true
  end

  def characterize 
    self.characterization.ng_xml = self.content.extract_metadata 
  end
end