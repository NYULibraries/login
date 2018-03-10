require 'database_cleaner'
RSpec.configure do |config|
  config.before(:suite) do
    # Run factory girl lint before the suite
    # FactoryBot.lint

    # Startout by trucating all the tables
    DatabaseCleaner.clean_with :truncation
    # Then use transactions to roll back other changes
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.start
    VCR.use_cassette('aleph bor info') do
      example.run
    end
    DatabaseCleaner.clean
  end
end
