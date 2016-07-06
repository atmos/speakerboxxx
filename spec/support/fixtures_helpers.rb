module FixturesHelpers
  def fixture_data(name)
    path = Rails.root.join("spec", "fixtures", "#{name}.json")
    File.read(path)
  end

  def github_fixture_data(name)
    fixture_data("api.github.com/#{name}")
  end

  def decoded_fixture_data(name)
    JSON.parse(fixture_data(name))
  end
end
