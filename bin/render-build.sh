#!/usr/bin/env bash
# エラーが発生したらスクリプトを停止
set -o errexit

# 必要なコマンドを実行
bundle install
yarn install
bundle exec rails assets:precompile
bundle exec rails db:migrate
