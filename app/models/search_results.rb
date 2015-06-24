class SearchResults
  attr_reader :query, :fda_response

  delegate :results, :meta, :meta?, :error, :error?, to: :fda_response

  def initialize(raw_response, query = nil)
    @raw_response = raw_response
    @query = query
    @fda_response = Hashie::Mash.new(@raw_response)
  end

  def error_message
    @fda_response.error.message if error?
  end

  def total_results
    @total_results ||= meta? ? meta.results.total : 0
  end
end
