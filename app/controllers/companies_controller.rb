class CompaniesController < ApplicationController
    before_action -> { set_and_verify_user(:user_id) }
    before_action -> { set_and_verify_company(:id) }

    # ユーザー詳細画面
    def show
    end

    def edit
    end

    def upadte
    end

    private

    def set_and_verify_company(key = :id, verify: true)

        company_id = params[key]
        Rails.logger.debug "Fetching company record by #{key}: params[#{key}]=#{company_id}"

        begin
            @company = Company.find(company_id)

            # 管理者の場合はチェックしない
            return if current_user.is_admin

            # ログイン中のユーザーの会社であることを確認
            unless @company.user_id == current_user.id
                Rails.logger.warn "Invalid company access attempt: company_user_id=#{@company.user_id}, current_user_id=#{current_user&.id}"
                flash[:alert] = "不正なアクセスです"
                redirect_to( home_users_path) and return
            end

            Rails.logger.info "Access verified for company_id=#{@company.id}"
        rescue ActiveRecord::RecordNotFound => e
        Rails.logger.warn "Work not found with #{key}=#{company_id}: #{e.message}"
            if current_user.is_admin
                flash[:alert] = "存在しないIDです"
            else
                flash[:alert] = "不正なアクセスです"
            end
            redirect_to( home_users_path) and return
        end
    end

end
