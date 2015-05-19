FROM abevoelker/ruby

# Add 'wsops' user which will run the application
RUN adduser wsops --home /apps/wsops --shell /bin/bash --disabled-password --gecos ""

# Separate Gemfile ADD so that `bundle install` can be cached more effectively
ADD Gemfile      /apps/login/
ADD Gemfile.lock /apps/login/
RUN chown -R wsops:wsops /apps/login/ &&\
  mkdir -p /var/bundle &&\
  chown -R wsops:wsops /var/bundle
RUN gem install bundler
RUN cd /apps/login &&\
  bundle install --deployment --path /var/bundle

# Add application source
ADD . /apps/login
RUN chown -R wsops:wsops /apps/login

USER wsops

WORKDIR /apps/login
