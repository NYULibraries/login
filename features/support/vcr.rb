require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.ignore_localhost = true
  c.filter_sensitive_data('<TWITTER_APP_KEY>') { ENV['TWITTER_APP_KEY'] }
  # Filter out aleph username for CU
  c.filter_sensitive_data('username') { ENV['TEST_CU_USERNAME'] }
  # Filter out aleph username for CU, this time the caps.
  # Does a check to see if it exists first, to prevent NoSuchMethodError
  c.filter_sensitive_data('username') { ENV.has_key?('TEST_CU_USERNAME') ? ENV['TEST_CU_USERNAME'].upcase : nil }
  # Filter out aleph password for CU, this time the caps.
  c.filter_sensitive_data('auth_key') { ENV['TEST_CU_PASSWORD'] }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
