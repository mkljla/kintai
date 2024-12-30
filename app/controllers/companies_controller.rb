class CompaniesController < ApplicationController
    before_action -> { set_and_verify_user(:user_id) }
    before_action -> { set_and_verify_company(:id) } #@companyをセット

    def show
    end

    private
end
