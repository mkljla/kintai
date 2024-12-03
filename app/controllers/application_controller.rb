class ApplicationController < ActionController::Base
    before_action :logged_in_user, unless: -> { controller_name == 'sessions' }
    before_action :check_session_timeout, unless: -> { controller_name == 'sessions' }
    before_action :update_last_activity_time, unless: -> { controller_name == 'sessions' }
    before_action :set_admin_mode

    # セッションのタイムアウト時間
    SESSION_TIMEOUT = 30.minutes

    #作成したヘルパーメソッドを全てのページで使えるようにする
    include SessionsHelper

    private

    # --- セッション関連 ---

    # セッションのタイムアウトを確認
    def check_session_timeout
        if session[:last_activity_time] && Time.current > session[:last_activity_time].to_time + SESSION_TIMEOUT
        log_out
        flash[:alert] = "セッションがタイムアウトしました。再度ログインしてください。"
        redirect_to login_path
        end
    end

    # セッションの最終アクティビティ時間を更新
    def update_last_activity_time
        session[:last_activity_time] = Time.current if logged_in?
    end

    # --- 権限関連 ---

    def require_admin
        unless current_user.is_admin
            flash[:alert] = "権限がありません"
            redirect_to login_path
        end
    end

    def set_admin_mode
        @admin_mode = session[:admin_mode]
    end

    # --- ユーザー関連 ---

    # ログイン中のユーザーを設定
    def set_current_user
        @user = current_user
    end

    # paramsを@userにセット
    def set_user(key = :id)
        @user = User.find(params[key])
    end

    # 正しいユーザーか確認
    def verify_user(key = :id)
        @user = User.find(params[key])
        unless @user == current_user
            flash[:alert] = "不正なアクセスです"
            redirect_to(home_users_path)
        end
    end

    # ログイン済みかどうか確認
    def logged_in_user
        unless logged_in?
            flash[:alert] = "ログインしてください"
            redirect_to login_path
        end
    end

    # --- 勤務関連 ---

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

    # 最新の出勤記録と休憩記録を取得
    def set_latest_records
        @latest_work = current_user.works.order(created_at: :desc).first
        @latest_break = current_user.breaks.order(created_at: :desc).first
    end
end
