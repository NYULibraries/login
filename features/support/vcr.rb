require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.ignore_localhost = true
  c.filter_sensitive_data('<TWITTER_APP_KEY>') { ENV['TWITTER_APP_KEY'] }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
