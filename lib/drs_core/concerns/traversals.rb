module DrsCore::Concerns::Traversals 
  def new_query
    DrsCore::Services::QueryService.create_from_object(self)
  end

  def children(opts)
    new_query.get_children opts
  end

  def descendents(opts) 
    new_query.get_descendents opts 
  end

  def records(opts) 
    new_query.get_child_records opts
  end

  def descendent_records(opts) 
    new_query.get_descendent_records opts 
  end

  def collections(opts) 
    new_query.get_child_collections opts 
  end

  def descendent_collections(opts) 
    new_query.get_descendent_collections opts 
  end
end