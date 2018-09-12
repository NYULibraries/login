FROM nyulibraries/selenium_chrome_headless_ruby:2.5-slim

ENV INSTALL_PATH /app
ENV BUNDLE_PATH /usr/local/bundle
ENV BUILD_PACKAGES git wget \
  libfontconfig libfreetype6 \
  build-essential zlib1g-dev libpq-dev

# Essential dependencies: use if rapidly changing gems
RUN apt-get update -qq && apt-get -y --no-install-recommends install $BUILD_PACKAGES

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker
USER docker

WORKDIR $INSTALL_PATH

RUN wget --no-check-certificate -q -O - https://cdn.rawgit.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh
RUN chmod a+x /tmp/wait-for-it.sh

# For working with locally installed gems
#COPY vendor ./vendor

# Install gems in cachable way
COPY --chown=docker:docker Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy compass-core deprecation manual fix
COPY ./vendor/gems/compass-core-1.0.3/ $BUNDLE_PATH/gems/compass-core-1.0.3/
# Copy source into container
COPY --chown=docker:docker . .
# Precompiles asset for faster testing and development
RUN RAILS_ENV=development bundle exec rake assets:precompile
