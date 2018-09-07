require 'vcr'

VCR.configure do |c|
  c.ignore_localhost = true
  c.ignore_request do |request|
    URI(request.uri).path == "/oauth/token"
  end
  c.default_cassette_options = { allow_playback_repeats: true }
  # c.debug_logger = $stdout
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.filter_sensitive_data('<TWITTER_APP_KEY>') { ENV['TWITTER_APP_KEY'] }
  c.filter_sensitive_data('<FACEBOOK_APP_KEY>') { ENV['FACEBOOK_APP_KEY'] }
  c.filter_sensitive_data('<FACEBOOK_APP_SECRET>') { ENV['FACEBOOK_APP_SECRET'] }
  ["CU", "NYSID", "BOBST"].each do |institution|
    # Filter out aleph username for CU
    c.filter_sensitive_data('username') { ENV["TEST_#{institution}_USERNAME"] }
    # Filter out aleph username for CU, this time the caps.
    # Does a check to see if it exists first, to prevent NoSuchMethodError
    c.filter_sensitive_data('username') { ENV.has_key?("TEST_#{institution}_USERNAME") ? ENV["TEST_#{institution}_USERNAME"].upcase : nil }
    # Filter out aleph password for CU, this time the caps.
    c.filter_sensitive_data('auth_key') { ENV["TEST_#{institution}_PASSWORD"] }
  end
  c.filter_sensitive_data('&sub_library=BET') { "&sub_library=#{ENV["ALEPH_SUB_LIBRARY"]}" }
  c.filter_sensitive_data('&library=ALEPH') { "&library=#{ENV["ALEPH_LIBRARY"]}" }
  c.filter_sensitive_data('aleph.library.edu') { ENV["ALEPH_HOST"] }
  c.filter_sensitive_data('BOR_ID') { ENV["TEST_ALEPH_USER"] }

  # Used to mock an EZ Borrow user with an unauthorized bor-status
  c.before_playback(:ezborrow_unauthorized) do |i|
    i.response.body.sub!('<z305-bor-status>60</z305-bor-status>', '<z305-bor-status>999</z305-bor-status>')
  end
end

VCR.cucumber_tags do |t|
  t.tag '@twitter_login', use_scenario_name: true, record: :once
  t.tag '@vcr', use_scenario_name: true, record: :new_episodes
  t.tag '@ignore_user_keys', record: :new_episodes, match_requests_on: [:method, VCR.request_matchers.uri_without_params(:verification, :bor_id, :sub_library, :library)]
  t.tag '@ezborrow_unauthorized', record: :new_episodes
end
