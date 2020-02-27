module V1
  module Account
    class ChangePasswordsController < ApplicationController
      CHANGE_PWD_TYPE = %w[vcode pwd].freeze
      include UserAuthorize
      before_action :login_required

      def create
        optional! :type, values: CHANGE_PWD_TYPE
        send("change_pwd_by_#{user_params[:type]}")
        render_api_success
      end

      private

      def change_pwd_by_pwd
        change_pwd_service = Services::Account::V2::ChangePwdByPwdService
        change_pwd_service.call(user_params, @current_user)
      end

      def change_pwd_by_vcode
        change_pwd_service = Services::Account::V2::ChangePwdByVcodeService
        change_pwd_service.call(user_params, @current_user)
      end

      def user_params
        params.permit(:type, :new_pwd, :old_pwd, :vcode)
      end
    end
  end
end
