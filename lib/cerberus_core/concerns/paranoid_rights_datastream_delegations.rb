# Handles delegations to the paranoidrights datastream which are assumed 
# to be universally helpful
module CerberusCore::Concerns::ParanoidRightsDatastreamDelegations
  extend ActiveSupport::Concern

  included do 
    delegate :groups,      to: "rightsMetadata"
    delegate :users,       to: "rightsMetadata" 
    delegate :permissions, to: "rightsMetadata"
  end

  def read_groups
    x = self.groups.keep_if { |k, v| v == 'read'}
    return x.keys
  end

  def edit_groups
    x = self.groups.keep_if { |k, v| v == 'edit' }
    return x.keys
  end

  def read_users
    x = self.users.keep_if { |k, v| v == 'read' }
    return x.keys
  end

  def edit_users 
    x = self.users.keep_if { |k, v| v == 'edit' }
    return x.keys
  end
end