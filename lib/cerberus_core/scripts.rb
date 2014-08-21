require 'cerberus_core'
require 'rails'

module CerberusCore
  class Scripts < Rails::Railtie
    railtie_name :cerberus_core

    rake_tasks do 
      load "#{File.dirname(__FILE__)}/../tasks/cerberus_core_tasks.rake"
    end
  end
end