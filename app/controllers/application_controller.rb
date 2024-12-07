class ApplicationController < ActionController::Base
    before_action :logged_in_user, unless: -> { controller_name == 'sessions' }
    before_action :check_session_timeout, unless: -> { controller_name == 'sessions' }
    before_action :update_last_activity_time, unless: -> { controller_name == 'sessions' }
    before_action :set_admin_mode

    # セッションのタイムアウト時間
    SESSION_TIMEOUT = 30.minutes

    #作成したヘルパーメソッドを全てのページで使えるようにする
    include SessionsHelper

    # seedファイル再作成
    def reset_demo_data
        Rails.logger.info "Starting demo data reset process"

        # 開発環境・テスト環境でのみ実施する
        unless Rails.env.development? || Rails.env.test?
            Rails.logger.warn "Access denied: reset_demo_data is allowed only in development or test environments"
            render plain: 'This operation is allowed only in development or test environments', status: :forbidden
            return
        end

        begin
            ActiveRecord::Base.transaction do
                Rails.logger.info 'Resetting database...'
                # データベース内の全データを削除
                ActiveRecord::Base.connection.truncate_tables(*ActiveRecord::Base.connection.tables)

                Rails.logger.info "Reloading seed data"
                # シードデータを再実行
                Rails.application.load_seed
            end

            Rails.logger.info "Demo data reset completed successfully"
            flash[:notice] = 'デモデータがリセットされました。'
            render json: { message: 'Reset successful' }, status: :ok

            rescue => e
            Rails.logger.error "An error occurred during the demo data reset: #{e.message}"
            Rails.logger.debug "Backtrace:\n#{e.backtrace.join("\n")}"

            flash[:alert] = 'デモデータのリセットに失敗しました。'
            render json: { message: 'Reset failed' }, status: :internal_server_error
        end
    end


    private

    # --- セッション関連 ---

    # セッションのタイムアウトを確認
    def check_session_timeout
        if session[:last_activity_time] && Time.current > session[:last_activity_time].to_time + SESSION_TIMEOUT
        Rails.logger.info "Session timeout detected for user_id=#{current_user&.id}"
        log_out
        flash[:alert] = "セッションがタイムアウトしました。再度ログインしてください。"
        redirect_to login_path
        end
    end

    # セッションの最終アクティビティ時間を更新
    def update_last_activity_time
        Rails.logger.debug "Updating last activity time for user_id=#{current_user&.id} at #{Time.current}"
        session[:last_activity_time] = Time.current if logged_in?
    end

    # --- 権限関連 ---

    def require_admin
        unless current_user.is_admin
            Rails.logger.warn "Unauthorized access attempt by user_id=#{current_user&.id}"
            flash[:alert] = "権限がありません"
            redirect_to login_path
        end
    end

    def set_admin_mode
        Rails.logger.debug "Admin mode set to #{@admin_mode} for user_id=#{current_user&.id}"
        @admin_mode = session[:admin_mode]
    end

    # --- ユーザー関連 ---

    # ログイン中のユーザーを設定
    def set_current_user
        Rails.logger.debug "Setting current user: user_id=#{current_user&.id}"
        @user = current_user
    end

    # paramsを@userにセット
    def set_user_by_id
        @user = User.find(params[:id])
    end
    def set_user_by_user_id
        @user = User.find(params[:user_id])
    end

    # 正しいユーザーか確認
    def verify_user_by_id
        @user = User.find(params[:id])
        unless @user == current_user
            flash[:alert] = "不正なアクセスです"
            redirect_to(home_users_path)
        end
    end
    def verify_user_by_user_id
        @user = User.find(params[:user_id])
        unless @user == current_user
            flash[:alert] = "不正なアクセスです"
            redirect_to(home_users_path)
        end
    end

    # ログイン済みかどうか確認
    def logged_in_user
        unless logged_in?
            Rails.logger.info "Access attempt without login: request_path=#{request.path}"
            flash[:alert] = "ログインしてください"
            redirect_to login_path
        end
    end

    # --- 勤務関連 ---

    # params[:id]を@workにセット
    def set_work_by_id
        Rails.logger.debug "Fetching work record by id: params[:id]=#{params[:id]}"
        @work = Work.find(params[:id])
    end

    # ユーザーの所持する勤務履歴か確認
    def verify_work_by_id
        @work = Work.find(params[:id])
        @user = User.find(params[:user_id])
        unless @work.user_id == @user.id
            Rails.logger.warn "Invalid work access attempt: work_id=#{@work.id}, user_id=#{@user.id}, current_user_id=#{current_user&.id}"
            flash[:alert] = "不正なアクセスです"
            redirect_to(user_works_path(@user))
        end
    end

    # 最新の出勤記録と休憩記録を取得
    def set_latest_records
        @latest_work = current_user.works.order(created_at: :desc).first
        @latest_break = current_user.breaks.order(created_at: :desc).first
        Rails.logger.debug "Latest work and break records set for user_id=#{current_user&.id}"
    end


end
