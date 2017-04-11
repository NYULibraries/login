FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev
# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev
# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb
# install phantomjs for cucumber (using npm since building from source takes 30 minutes+)
RUN apt-get install -y nodejs npm nodejs-legacy
RUN npm install -g phantomjs-prebuilt
# add vim
RUN apt-get install -y vim

# create directory
ENV APP_HOME /login
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# add gems and install
COPY Gemfile Gemfile.lock $APP_HOME/
RUN gem install bundler
RUN bundle config github.https true
RUN bundle install

# add application
COPY . $APP_HOME/

WORKDIR $APP_HOME

ENV LOGIN_SECRET_TOKEN 123abc
ENV TEST_TWITTER_USERNAME libtechnyu
ENV ALEPH_HOST aleph.library.edu
ENV ALEPH_LIBRARY ALEPH
ENV ALEPH_SUB_LIBRARY BET
ENV SHIBBOLETH_LOGOUT_URL https://aqa.home.nyu.edu/sso/UI/Logout
ENV PDS_URL https://pdsdev.library.nyu.edu
ENV BOBCAT_URL http://bobcatdev.library.nyu.edu
