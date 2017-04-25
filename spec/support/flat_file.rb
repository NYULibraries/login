# def ci?
#   ENV['CI']
# end

# Set flat file for testing.
# if ci?
#   ENV['FLAT_FILE'] = File.expand_path(File.join(__FILE__, "../../../spec/data/patrons-UTF-8.dat"))
# else
  ENV['FLAT_FILE'] = "spec/data/patrons-UTF-8.dat"
# end
