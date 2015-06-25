require 'faraday'
require 'json'
require 'active_support'

class DoNotEncoder
  def self.encode(params)
    buffer = ''
    params.each do | k,v |
      buffer << "#{k}=#{v}&"
    end
    return buffer.chop
  end
end

class FdaApi
  API_KEY = ENV['FDA_API_KEY']

  def self.get_label(query, page = nil)
    response = connection.get "/drug/label.json", build_params(search: parse_query(query), limit: limit, skip: get_skip_for_page(page))
    parse_response(response.body)
  end

  def self.find_drug_by_id(drug_id)
    response = connection.get "/drug/label.json", build_params(search: "id:#{drug_id}")
    parse_response(response.body)
  end

  private

  def self.get_skip_for_page(page)
    page ||= 1
    page = page.to_i

    if page == 1
      0
    else
      (page - 1) * limit
    end
  end

  def self.limit
    20
  end

  def self.parse_query(query)
    terms = query.gsub(/\s+/m, ' ').strip.split(' ')
    terms.collect { |x| "generic_name:#{x}" }.join("+AND+") + "+OR+" +
    terms.collect { |x| "brand_name:#{x}" }.join("+AND+")
  end

  def self.build_params(params)
    { api_key: API_KEY }.merge(params)
  end

  def self.parse_response(response)
    JSON.parse(response, symbolize_names: true)
  end

  def self.connection
    @connection ||= Faraday.new(url: "https://api.fda.gov") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.options.params_encoder = DoNotEncoder
    end
  end
end
