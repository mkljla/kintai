class ApplicationController < ActionController::Base
    before_action :logged_in_user, unless: -> { controller_name == 'sessions' }

    #作成したヘルパーメソッドを全てのページで使えるようにする
    include SessionsHelper

    private

    # ログイン済みかどうか確認
    def logged_in_user
        unless logged_in?
            flash[:alert] = "ログインしてください"
            redirect_to login_path
        end
    end


    def redirect_with_alert(message)
        flash[:alert] = message
        redirect_to home_users_path
    end

    def redirect_with_notice(message)
        flash[:notice] = message
        redirect_to home_users_path
    end

    # 最新の出勤記録と休憩記録を取得
    def set_latest_records
        @latest_work = current_user.works.order(created_at: :desc).first
        @latest_break = current_user.breaks.order(created_at: :desc).first
    end

    # ログイン中のユーザーを設定
    def set_current_user
        @user = current_user
    end

    # params[:id]を@userにセット
    def set_user_by_id
        @user = User.find(params[:id])
    end

    # params[:user_id]を@userにセット
    def  set_user_by_user_id
        @user = User.find(params[:user_id])
    end


    # 正しいユーザーかどうか確認(params[:id])
    def verify_user_by_id
        @user = User.find(params[:id])
        unless @user == current_user
            flash[:alert] = "不正なアクセスです"
            redirect_to(home_users_path)
        end
    end

    # 正しいユーザーかどうか確認(params[:user_id])
    def verify_user_by_user_id
        @user = User.find(params[:user_id])
        unless @user == current_user
            flash[:alert] = "不正なアクセスです"
            redirect_to(home_users_path)
        end
    end

    # params[:id]を@workにセット
    def set_work_by_id
        @work = Work.find(params[:id])
    end

    # ユーザーの所持する勤務履歴か確認
    def verify_work_by_id
        @work = Work.find(params[:id])
        @user = User.find(params[:user_id])
        unless @work.user_id == @user.id
            flash[:alert] = "不正なアクセスです"
            redirect_to(user_works_path(@user))
        end
    end
end
