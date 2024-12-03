class SessionsController < ApplicationController
    before_action :redirect_if_logged_in, only: [:new]
    before_action :set_no_cache, only: [:new]

    def new
        # ログインフォームの表示
    end

    # ログイン処理
    def create
        user = User.find_by(employee_number: params[:session][:employee_number].downcase)
        if user && user.authenticate(params[:session][:password])# パスワードの確認
            reset_session # 古いセッションをクリア
            form_authenticity_token # 新しいCSRFトークンを生成
            log_in user
            Rails.logger.info "Login successful for user: #{user.full_name} (Employee Number: #{user.employee_number})"

            flash[:notice] = "ログインに成功しました"
            redirect_to home_users_path

        else
            Rails.logger.warn "Login failed for employee number: #{session_params[:employee_number]}"
            flash.now[:alert] = "ログインに失敗しました。社員番号とパスワードを確認してください。"
            render 'new'
        end
    end


    def destroy
        # ログアウト処理
        log_out if logged_in?
        redirect_to root_url
    end

    private
    def session_params
        params.require(:session).permit(:employee_number, :password)
    end

    def redirect_if_logged_in
        if logged_in?
            flash[:notice] = "ログイン済みです。"
            redirect_to home_users_path
        end
    end

    def set_no_cache
        response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
end
