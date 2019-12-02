# How to use it
# =============
#
# Visit https://blog.zedroot.org/2015/04/30/using-docker-to-maintain-a-ruby-gem/

# ~~~~ Image base ~~~~
# Base image
FROM ruby:2.6.5-alpine
LABEL maintainer="klriutsa"

RUN mkdir -p /gem/
WORKDIR /gem/
ADD . /gem/

# ~~~~ OS Maintenance & Rails Preparation ~~~~
# Rubygems and Bundler
RUN apk add --no-cache \
            --quiet \
            build-base \
            git \
  && touch ~/.gemrc \
  && echo "gem: --no-ri --no-rdoc" >> ~/.gemrc \
  && gem install rubygems-update \
  && update_rubygems \
  && gem install bundler \
  && bundle install \
  && rm -rf /var/cache/apk/*

ENTRYPOINT ["bundle", "exec"]
CMD ["rake", "-T"]
