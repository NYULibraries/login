FROM ruby:2.3.4

ENV INSTALL_PATH /app

# Essential dependencies
RUN apt-get update -qq && apt-get install -y \
      bzip2 \
      git \
      libfontconfig \
      libfreetype6 \
      vim \
      wget

# PhantomJS
ENV PHANTOMJS_VERSION 2.1.1

RUN wget --no-check-certificate -q -O - https://cnpmjs.org/mirrors/phantomjs/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 | tar xjC /opt
RUN ln -s /opt/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker
USER docker

WORKDIR $INSTALL_PATH

RUN wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > wait-for-it.sh
RUN chmod a+x wait-for-it.sh

# For working with locally installed gems
#COPY vendor ./vendor

# Add github to known_hosts
RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

# Install gems in cachable way
COPY Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy source into container
COPY --chown=docker:docker . .
