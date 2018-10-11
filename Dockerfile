FROM ruby:2.5.1-alpine

ENV INSTALL_PATH /app
ENV BUNDLE_PATH /usr/local/bundle

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

# bundle install
COPY --chown=docker:docker bin/ bin/
COPY --chown=docker:docker Gemfile Gemfile.lock ./
ARG RUN_PACKAGES="ca-certificates fontconfig mariadb-dev nodejs tzdata postgresql-dev git"
ARG BUILD_PACKAGES="ruby-dev build-base linux-headers python"
RUN apk add --no-cache --update $RUN_PACKAGES $BUILD_PACKAGES \
  && gem install bundler \
  && bundle config --local github.https true \
  && bundle install --deployment --without no_docker,test,development --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle

USER docker
COPY --chown=docker:docker . .
# Copy compass-core deprecation manual fix
COPY ./vendor/gems/compass-core-1.0.3/ $BUNDLE_PATH/gems/compass-core-1.0.3/
# precompile assets; use temporary secret token to silence error, real token set at runtime
RUN DISABLE_FIGS=true RAILS_ENV=production DEVISE_SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) SECRET_TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) \
  bundle exec rake assets:precompile

# run microscanner
USER root
ARG AQUA_MICROSCANNER_TOKEN
RUN wget -O /microscanner https://get.aquasec.com/microscanner && \
  chmod +x /microscanner && \
  /microscanner ${AQUA_MICROSCANNER_TOKEN} && \
  rm -rf /microscanner

USER docker
EXPOSE 9292

CMD ./script/start.sh development