#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive
export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile.rails.5.0.1

bundle install -j4
gem install tzinfo
bundle exec rspec