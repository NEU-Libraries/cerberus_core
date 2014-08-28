require 'rails'
require 'noid'

module CerberusCore::Services::IdService
  def self.noid_template
    Rails.configuration.cerberus_core.noid_template
  end

  def self.valid?(identifier)
    # remove the fedora namespace since it's not part of the noid
    noid = identifier.split(":").last
    return @minter.valid? noid
  end
  def self.mint
    validate_configuration
    @minter = ::Noid::Minter.new(:template => noid_template)
    @pid = $$
    @namespace = Rails.configuration.cerberus_core.id_namespace
    @semaphore = Mutex.new
    @semaphore.synchronize do
      while true
        pid = self.next_id
        return pid unless ActiveFedora::Base.exists?(pid)
      end
    end
  end

  protected

  def self.validate_configuration
    if Rails.configuration.cerberus_core.id_namespace == nil 
      msg = <<-eos
      No id_namespace defined.  Set config.cerberus_core.id_namespace equal
      to the desired namespace in config/application.rb to enable the 
      IdService.
      eos
      raise CerberusCore::InvalidConfigurationError.new msg 
    end
  end

  def self.next_id
    pid = ''
    statefile = Rails.configuration.cerberus_core.minter_statefile
    File.open(statefile, File::RDWR|File::CREAT, 0644) do |f|
      f.flock(File::LOCK_EX)
      yaml = YAML::load(f.read)
      yaml = {:template => noid_template} unless yaml
      minter = ::Noid::Minter.new(yaml)
      pid = "#{@namespace}:#{minter.mint}"
      f.rewind
      yaml = YAML::dump(minter.dump)
      f.write yaml
      f.flush
      f.truncate(f.pos)
    end
    return pid
  end
end