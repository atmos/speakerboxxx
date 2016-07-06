# rubocop:disable Metrics/LineLength
module WebmockHelpers
  def default_json_headers
    { "Content-Type" => "application/json" }
  end

  def stub_json_request(method, url, response_body, status = 200)
    stub_request(method, url)
      .to_return(status: status, body: response_body, headers: default_json_headers)
  end
end
# rubocop:enable Metrics/LineLength
