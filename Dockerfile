FROM ruby:2.5.1-alpine

ENV DOCKER true
ENV INSTALL_PATH /app
ENV BUNDLE_PATH /usr/local/bundle

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

# bundle install
COPY --chown=docker:docker bin/ bin/
COPY --chown=docker:docker Gemfile Gemfile.lock ./
ARG RUN_PACKAGES="ca-certificates fontconfig nodejs tzdata postgresql-dev"
ARG BUILD_PACKAGES="ruby-dev build-base linux-headers python git"
RUN apk add --no-cache --update $RUN_PACKAGES $BUILD_PACKAGES \
  && gem install bundler \
  && bundle config --local github.https true \
  && bundle install --without no_docker,test,development --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle
RUN npm install --global yarn

USER docker
COPY --chown=docker:docker . .
# Copy compass-core deprecation manual fix
COPY ./vendor/gems/compass-core-1.0.3/ $BUNDLE_PATH/gems/compass-core-1.0.3/
# precompile assets; use temporary secret token to silence error, real token set at runtime
RUN RAILS_ENV=production DEVISE_SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) SECRET_TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) \
  bundle exec rake assets:precompile

USER docker
EXPOSE 9292

CMD ./script/start.sh development
