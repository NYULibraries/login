require 'vcr'
VCR.configure do |c|
  c.filter_sensitive_data('&sub_library=BET') { "&sub_library=#{ENV["ALEPH_SUB_LIBRARY"]}" }
  c.filter_sensitive_data('&library=ALEPH') { "&library=#{ENV["ALEPH_LIBRARY"]}" }
  c.filter_sensitive_data('aleph.library.edu') { ENV["ALEPH_HOST"] }
  c.filter_sensitive_data('BOR_ID') { ENV["TEST_ALEPH_USER"] }
  c.default_cassette_options = { :record => :new_episodes, :allow_playback_repeats => true }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
end
