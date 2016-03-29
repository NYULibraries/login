# Set flat file for testing.
if ENV['TRAVIS']
  ENV['FLAT_FILE'] = "#{ENV['TRAVIS_BUILD_DIR']}/spec/data/patrons-UTF-8.dat"
else
  ENV['FLAT_FILE'] = "spec/data/patrons-UTF-8.dat"
end
