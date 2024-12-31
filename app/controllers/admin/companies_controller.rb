class Admin::CompaniesController < AdminController
    before_action :set_current_user
    before_action :require_admin_mode
    before_action -> { set_and_verify_company(:id) }


    def edit

    end

    def update
        if @company.update(company_params)
            flash[:notice] = "会社情報を更新しました。"
            redirect_to user_company_path(@user, @company)
        else
            Rails.logger.debug("Company update failed: #{@company.errors.full_messages}")
            flash[:alert] = "会社情報の更新に失敗しました。"
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def company_params
        params.require(:company).permit(:name, :default_work_hours)
    end

end
