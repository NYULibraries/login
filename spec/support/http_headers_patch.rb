# Allows us to store our Shibboleth environment variables
# without worrying about their keys getting dashes translated to
# to underscores or getting prefixed with HTTP_ which seems to be
# a result of https://github.com/rails/rails/pull/9700
ActionDispatch::Http::Headers.class_eval do
  def env_name(key)
    key = key.to_s
    return key if SHIBBOLETH_ENV.keys.include?(key)
    if key =~ ActionDispatch::Http::Headers::HTTP_HEADER
      key = key.upcase.tr('-', '_')
      key = "HTTP_" + key unless ActionDispatch::Http::Headers::CGI_VARIABLES.include?(key)
    end
    key
  end
  private :env_name
end
