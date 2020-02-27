# 改变登录账户
module V1
  module Account
    class ChangeAccountController < ApplicationController
      ACCOUNT_TYPES = %w[mobile email].freeze
      include UserAuthorize
      before_action :login_required

      def create
        user_params = permit_params.dup

        raise_error 'unsupported_type' unless ACCOUNT_TYPES.include?(user_params[:type])

        if user_params[:account].blank? || user_params[:old_code].blank? || user_params[:new_code].blank?
          raise_error 'params_missing'
        end

        @api_result = Services::Account::ChangeAccountService.call(@current_user, user_params)
        render 'v1/users/base', locals: { user: @api_result.data[:user] }
      end

      private

      def permit_params
        params.permit(:type,      # 重置账户的类型
                      :account,   # 账户
                      :country_code,
                      :old_code,  # 旧的验证码
                      :new_code)  # 新的验证码
      end
    end
  end
end


