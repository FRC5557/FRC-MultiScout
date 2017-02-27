module HTTPUtil
  require 'net/http'
  require 'net/https'
  require 'uri'

  # Returns a response to a HTTP request with sent headers
  def request_with_headers(url, headers = {}, https = false)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = https

    request = Net::HTTP::Get.new(uri.path)

    headers.each do |header|
      request[header[0].to_s] = header[1]
    end

    response = http.request(request)

    return response
  end
end
