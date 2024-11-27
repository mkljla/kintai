class ApplicationController < ActionController::Base
    before_action :logged_in_user

    #作成したヘルパーメソッドを全てのページで使えるようにする
    include SessionsHelper

    private
    # ログイン済みユーザーかどうか確認
    def logged_in_user
        unless logged_in?
            flash[:alert] = message
            redirect_to login_path
        end
    end


    # 最新の出勤記録と休憩記録を取得
    def set_latest_records
        @latest_work = current_user.works.order(created_at: :desc).first
        @latest_break = current_user.breaks.order(created_at: :desc).first
    end

    def redirect_with_alert(message)
        flash[:alert] = message
        redirect_to home_users_path
    end

    def redirect_with_notice(message)
        flash[:notice] = message
        redirect_to home_users_path
    end




end
