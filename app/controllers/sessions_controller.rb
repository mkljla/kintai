class SessionsController < ApplicationController
    def new
        # ログインフォームの表示
    end

    # ログイン処理
    def create
        user = User.find_by(employee_number: session_params[:employee_number].downcase)
        if user && user.authenticate(session_params[:password])# パスワードの確認
            log_in user
            Rails.logger.info "Login successful for user: #{user.full_name} (Employee Number: #{user.employee_number})"
            flash[:notice] = "ログインに成功しました"
            redirect_to user_home_path
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
end
