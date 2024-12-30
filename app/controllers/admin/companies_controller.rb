class Admin::CompaniesController < AdminController
    before_action :require_admin_mode
    before_action -> { set_and_verify_company(:id) }
    before_action :set_current_user, only:[:edit, :update]

    def edit
    end

    def update
    end

    private



end
