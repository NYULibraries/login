Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Do not force ssl in development.
  config.force_ssl = false

  # need to enable caching since session is stored in cache
  config.action_controller.perform_caching = true

  # set cache store to dalli, which uses memcached
  # resolve DNS if service set and not servers to leverage memcached client sharding
  if ENV['MEMCACHE_SERVICE'] && !ENV['MEMCACHE_SERVERS']
    memcached_hosts = []
    Resolv::DNS.new.each_resource(ENV['MEMCACHE_SERVICE'], Resolv::DNS::Resource::IN::SRV) { |rr|
      memcached_hosts << rr.target.to_s
    }
    config.cache_store = :dalli_store, memcached_hosts
  else
    config.cache_store = :dalli_store
  end

  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{2.days.to_i}"
  }

  # Whitelists IP for docker usage of web-console
  config.web_console.whitelisted_ips = ['172.16.0.0/12'] # broad ip pool for docker

  # Store uploaded files on the local file system (see config/storage.yml for options)
  # config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  if ENV['DOCKER'] # Necessary for running dev in unicorn environment
    config.assets.debug = false
    config.assets.quiet = false
    config.assets.compile = false
  end
end
