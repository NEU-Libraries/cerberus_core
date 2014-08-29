module CerberusCore::Services
  # Given a pid and the name of the class that the pid object
  # is an instance of, this service handles querying Solr for 
  # children and descendents.  See the Traversals concern for 
  # a cleaner interface into this service, which may admittedly
  # need some polish.
  class QueryService 

    attr_accessor :pid, :class_name

    def initialize(pid, class_name)
      self.pid = pid
      self.class_name = class_name 
    end

    # There are three ways to 'have' a Fedora object.  The first is 
    # holding the actual fedora ORM object.  The second is the raw 
    # response hash returned by a query to solr, and the third is 
    # that response hash pushed into a SolrDocument.  This object 
    # creates a new QueryService based on any of the three.
    def self.create_from_object(object) 
      if (object.class.name == "SolrDocument") || object.is_a?(Hash)
        id = object["id"]
        class_name = object["active_fedora_model_ssi"]

        CerberusCore::Services::QueryService.new(id, class_name) 
      else
        CerberusCore::Services::QueryService.new(object.pid, object.class.name) 
      end
    end

    # Assuming a well formed graph of Communities/Collections/CoreRecords,
    # returns the immediate descendents of the object identified by pid.
    def get_children(opts = {})
      query_with_models(:all, opts)
    end

    # Assuming a well formed graph of Communities/Collections/CoreRecords,
    # returns all descendents for the object identified by pid.
    def get_descendents(opts = {}) 
      opts = initialize_opts opts 

      results = query_with_models(:all, :return_as => :query_result)

      results.each do |r|
        id    = r["id"]
        model = r["active_fedora_model_ssi"]
        qs    = QueryService.new(id, model)
        more_kids = qs.query_with_models(:all, :return_as => :query_result)
        results.push(*more_kids)
      end

      parse_return_statement(opts[:return_as], results)  
    end

    # See Traversals.
    def get_child_records(opts = {})
      query_with_models(:files, opts)
    end

    # See Traversals.
    def get_descendent_records(opts = {})
      filter_descendent_query(:files, opts)
    end

    # See Traversals.
    def get_child_collections(opts = {}) 
      query_with_models(:collections, opts) 
    end

    # See Traversals.
    def get_descendent_collections(opts = {})
      filter_descendent_query(:collections, opts)
    end

    # See Traversals.
    def get_child_communities(opts = {})
      query_with_models(:communities, opts) 
    end

    # See Traversals.
    def get_descendent_communities(opts = {}) 
      filter_descendent_query(:communities, opts) 
    end

    # Return all content objects for pid.  If pid doesn't point at 
    # a CoreRecord type object, or just one with no content, 
    # return an empty array.
    def get_content_objects(opts = {}) 
      opts    = initialize_opts opts
      query   = "is_part_of_ssim:#{full_pid}"
      results = ActiveFedora::SolrService.query(query, rows: 999)
      parse_return_statement(opts[:return_as], results)
    end

    # Return the canonical object for this pid.  If pid doesn't point
    # at a CoreRecord type object, or just one with no content, 
    # return nil. 
    def get_canonical_object(opts = {})
      intermediate = get_content_objects(:return_as => :query_result) 
      intermediate.keep_if { |x| x["canonical_tesim"] == ['yes'] }
      parse_return_statement(opts[:return_as], intermediate).first
    end

    protected 

    #:nodoc:
    def query_with_models(model_types, opts = {})
      models = model_array(model_types)
      if models.any?
        opts = initialize_opts opts

        models = construct_model_query(models)

        member_of        = "is_member_of_ssim:#{full_pid}"
        affiliation_with = "has_affiliation_ssim:#{full_pid}"

        query   = "#{models} AND (#{member_of} OR #{affiliation_with})"
        results = ActiveFedora::SolrService.query(query, rows: 999) 

        parse_return_statement(opts[:return_as], results)
      else
        return []
      end
    end

    private

    #:nodoc:
    def full_pid(param_pid = nil)
      if param_pid
        return "\"info:fedora/#{param_pid}\""
      else
        return "\"info:fedora/#{self.pid}\""
      end
    end

    #:nodoc:
    def construct_model_query(model_names)
      models = model_names.map{|x|"\"#{x}\""}.join(" OR ")
      return "active_fedora_model_ssi:(#{models})" 
    end

    #:nodoc:
    def filter_descendent_query(model_type, opts = {}) 
      opts = initialize_opts opts
      qr   = get_descendents(:return_as => :query_result) 

      models = model_array(model_type) 

      qr.keep_if { |r| models.include? r["active_fedora_model_ssi"] } 

      parse_return_statement(opts[:return_as], qr) 
    end

    #:nodoc:
    def initialize_opts(opts)
      opts = opts.with_indifferent_access
      opts[:return_as] ||= :query_result
      return opts
    end

    #:nodoc:
    def parse_return_statement(opt, results)
      if opt == :query_result
        return results 
      elsif opt == :models 
        results.map! do |result| 
          ActiveFedora::Base.find(result["id"], cast: true) 
        end
      elsif opt == :solr_documents
        results.map! do |result| 
          ::SolrDocument.new(result) 
        end
      else
        raise "Invalid option passed" 
      end
    end

    #:nodoc:
    def model_array(type)
      const = class_name.constantize 

      records     = []
      folders     = []
      communities = []

      check = Proc.new do |x, y| 
        const.public_methods.include?(x) && y.include?(type)
      end

      if check.call(:core_file_types, [:files, :all])
        records = const.core_file_types
      end

      if check.call(:collection_types, [:collections, :all])
        folders = const.collection_types
      end

      if check.call(:community_types, [:communities, :all])
        communities = const.community_types
      end

      return records + folders + communities
    end
  end
end