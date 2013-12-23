# (jameschristie) NOTE This class is a necessity at
# the moment, given the structural problems in
# netsuite-rest-client. It duplicates the search
# accumulation loop present in the gem, but adding
# in calls to BeanCounter caching functionality.

module BeanCounter

  class SearchManager

    attr_reader :search_name

    def self.execute_and_cache(search_name)
      new(search_name).execute_and_cache!
    end

    def initialize(search_name)
      @search_name  = search_name
      @last_item_id = 0
      @done         = false
    end

    def execute_and_cache!
      ::BeanCounter::Logging.info("Starting search cache for #{search_name}...")
      begin
        update_search_context
        cache_current_result_set
      end while !done?
      ::BeanCounter::Logging.info("Search caching complete!")
    end

    private

    def cache_current_result_set
      ::BeanCounter::Logging.info("Caching results for set from id #{@last_item_id}...")
      Cache.record_search_results(@current_results) unless @current_results.empty?
    end

    def update_search_context
      @current_results = fetch_next_result_set
      @last_item_id    = @current_results.last[:id] unless @current_results.empty?
    end

    def done?
      @current_results.count < NetsuiteToolbox::SEARCH_BATCH_SIZE ||
        @current_results.empty?
    end

    def fetch_next_result_set
      ::BeanCounter::Logging.info("Fetching result set starting with id: #{@last_item_id}...")
      NetsuiteToolbox.search(search_name, @last_item_id)
    end

  end

end
