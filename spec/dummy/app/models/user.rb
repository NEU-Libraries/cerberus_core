class User < ActiveRecord::Base 
  # Connects this user object to hydra behavior
  include Hydra::User

end