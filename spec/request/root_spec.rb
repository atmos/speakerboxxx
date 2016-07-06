require "rails_helper"

RSpec.describe "Speakerboxxx /", type: :request do
  it "200s on /" do
    get "/"
    expect(status).to eql(200)
  end
end
