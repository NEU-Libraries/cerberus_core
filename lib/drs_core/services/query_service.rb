module DrsCore::Services
  class QueryService 

    attr_accessor :pid, :class_name

    def initialize(pid, class_name)
      self.pid = pid
      self.class_name = class_name 
    end

    # Assuming a well formed graph of Projects/Collections/CoreRecords
    # Returns the immediate descendents of this pid and class name
    def get_children(opts = {})
      opts = opts.with_indifferent_access
      opts[:return_as] ||= :query_result

      models = all_possible_models
      models = models.map{ |x| "\"#{x}\""}.join(" OR ")
      m = "active_fedora_model_ssi:(#{models})"

      full_pid = "\"info:fedora/#{pid}\""
      member_of = "is_member_of_ssim:#{full_pid}"
      affiliation_with = "has_affiliation_ssim:#{full_pid}"

      query = "#{m} AND (#{affiliation_with} OR #{member_of})"
      results = ActiveFedora::SolrService.query(query, rows: 999)

      parse_return_statement(opts[:return_as], results)
    end

    def get_descendents(opts = {})
      opts = opts.with_indifferent_access
      opts[:return_as] ||= :query_result

      initial = get_children(:return_as => :query_result)

      initial.map! do |r| 
        id    = r["id"]
        model = r["active_fedora_model_ssi"]
        more_kids = QueryService.new(id, model).get_children(:return_as => :query_result)
        initial << more_kids 
      end

      parse_return_statement(opts[:return_as], results)
    end

    private

    def parse_return_statement(opt, results)
      if opt == :query_result
        return results 
      elsif opt == :models 
        results.map! do |result| 
          ActiveFedora::Base.find(result["id"], cast: true) 
        end
      elsif opt == :solr_document
        raise "Not implemented yet srry" 
      else
        raise "Invalid option passed" 
      end
    end

    def all_possible_models
      const = class_name.constantize

      records = []
      folders = []

      if const.constants.include? :CORE_RECORD_CLASSES 
        records = const::CORE_RECORD_CLASSES 
      end

      if const.constants.include? :FOLDER_CLASSES 
        folders = const::FOLDER_CLASSES 
      end

      return records + folders 
    end
  end
end