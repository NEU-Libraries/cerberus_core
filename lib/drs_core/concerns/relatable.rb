module DrsCore::Concerns::Relatable 
  extend ActiveSupport::Concern 

  module ClassMethods
    def relation_asserter(method, rel_name, rel_type, rel_class)
      if rel_class 
        self.send(method, rel_name, :property => rel_type, :class_name => rel_class)
      else
        self.send(method, rel_name, :property => rel_type)
      end
    end
  end
end