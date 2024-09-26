class ApplicationController < ActionController::Base
  #作成したヘルパーメソッドを全てのページで使えるようにする
  include SessionsHelper
end
