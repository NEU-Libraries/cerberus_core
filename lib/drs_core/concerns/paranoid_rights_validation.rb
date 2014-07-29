module DrsCore::Concerns
  module ParanoidRightsValidation
    extend ActiveSupport::Concern 

    included do 
      validate :paranoid_validations 

      def paranoid_validations
        self.rightsMetadata.validate(self)
      end

      private :paranoid_validations
    end
  end
end