require 'vcr'

VCR.configure do |c|
  # Capybara with poltergeist js driver uses this /__identify__ path
  # which we want to always ignore in VCR
  # Selenium uses the /hub/session path
  # See: https://github.com/vcr/vcr/issues/229
  c.ignore_request do |request|
    URI(request.uri).path == "/__identify__" || URI(request.uri).path =~ /\/hub\/session/
  end
  c.default_cassette_options = { allow_playback_repeats: true }
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.filter_sensitive_data('<TWITTER_APP_KEY>') { ENV['TWITTER_APP_KEY'] }
  ["CU", "NYSID", "BOBST"].each do |institute|
    # Filter out aleph username for CU
    c.filter_sensitive_data('username') { ENV["TEST_#{institute}_USERNAME"] }
    # Filter out aleph username for CU, this time the caps.
    # Does a check to see if it exists first, to prevent NoSuchMethodError
    c.filter_sensitive_data('username') { ENV.has_key?("TEST_#{institute}_USERNAME") ? ENV["TEST_#{institute}_USERNAME"].upcase : nil }
    # Filter out aleph password for CU, this time the caps.
    c.filter_sensitive_data('auth_key') { ENV["TEST_#{institute}_PASSWORD"] }
  end
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
