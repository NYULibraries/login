FROM ruby:2.5.1

ENV INSTALL_PATH /app
ENV BUNDLE_PATH /usr/local/bundle

# Essential dependencies
RUN apt-get update -qq && apt-get install -y \
  bzip2 \
  git \
  libfontconfig \
  libfreetype6 \
  wget \
  zlib1g-dev \
  liblzma-dev \
  xvfb \
  unzip \
  libgconf2-4 \
  libnss3 \
  nodejs

ENV CHROMIUM_DRIVER_VERSION 2.38
RUN apt-get update && apt-get -y --no-install-recommends install  \
 && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -  \
 && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
 && apt-get update && apt-get -y --no-install-recommends install google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

# Install Chrome driver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMIUM_DRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ \
    && rm /tmp/chromedriver.zip \
    && chmod ugo+rx /usr/bin/chromedriver

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker
USER docker

WORKDIR $INSTALL_PATH

RUN wget --no-check-certificate -q -O - https://cdn.rawgit.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh
RUN chmod a+x /tmp/wait-for-it.sh

# For working with locally installed gems
#COPY vendor ./vendor

# Add github to known_hosts
RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

# Install gems in cachable way
COPY --chown=docker:docker Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy source into container
COPY --chown=docker:docker . .
