module V2
  module Account
    class AccountsController < ApplicationController
      def create
        # 验证参数 改动的地方是不强制用户使用手机号注册
        %w[account password nickname gender email].each { |param| requires! param.to_sym }
        raise_error 'user_nickname_exist' if User.by_nickname(user_params[:nickname]).present? # 检查昵称唯一性
        raise_error 'email_format_error'  unless UserValidator.email_valid?(user_params[:email]) # 检查邮箱的格式

        mobile_register_service = Services::Account::V2::MobileRegisterService
        @api_result = mobile_register_service.call(user_params, request.remote_ip)
        render 'v1/account/accounts/create'
      end

      def verify
        account = params[:account]
        country_code = params[:country_code] || '86'
        @flag = UserValidator.mobile_exists?(account, country_code) || UserValidator.email_exists?(account) || UserValidator.account_id_exists?(account)
      end

      def user_params
        params.permit(:account, :password, :mobile, :country_code, :vcode, :nickname, :gender, :email)
      end
    end
  end
end
