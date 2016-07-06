require "webmock/rspec"
require "sidekiq/testing"

ENV["HOSTNAME"] = "speakerboxxx-test.atmos.org"
ENV["SLACK_SLASH_COMMAND_TOKEN"] = "secret-slack-token"

RSpec.configure do |config|
  config.include(WebMock::API)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before type: :webmock do
    WebMock.disable_net_connect!
  end
end
