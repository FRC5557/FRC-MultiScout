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

  def tba_request(url)
    return request_with_headers(url, {'X-TBA-App-Id':'frc5557:scouting-system:a1'}, true)
  end
end
