require 'rails'

module CerberusCore
  class Railtie < Rails::Railtie
    railtie_name :cerberus_core

    initializer "my_engine.load_app_root" do |app|
       CerberusCore.app_root = app.root
       config.cerberus_core.minter_statefile = "#{CerberusCore.app_root}/tmp/minter-state"
    end

    rake_tasks do 
      load "#{File.dirname(__FILE__)}/../tasks/cerberus_core_tasks.rake"
    end

    config.cerberus_core = ActiveSupport::OrderedOptions.new
    config.cerberus_core.auto_generate_pid = false 
    config.cerberus_core.id_namespace      = nil
    config.cerberus_core.noid_template     = ".reeddeeddk"
  end
end