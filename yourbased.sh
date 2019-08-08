#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive
export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile.rails.5.0.1

gem install bundler -v 1.17.3 
bundle install -j4
bundle exec rspec