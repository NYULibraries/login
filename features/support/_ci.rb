def ci?
  ENV["CI"] || ENV["DOCKER"]
end
