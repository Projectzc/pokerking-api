module V1
  module Account
    class ResetPasswordsController < ApplicationController
      RESET_TYPES = %w[mobile email].freeze

      def create
        reset_params = permit_reset_params.dup
        reset_type = reset_params.delete(:type)

        raise_error 'unsupported_type' unless RESET_TYPES.include?(reset_type)

        send("reset_pwd_by_#{reset_type}", reset_params)
        render_api_success
      end

      private

      def permit_reset_params
        params.permit(:type,      # 重置密码的方式
                      :mobile,    # 手机
                      :email,     # 邮箱
                      :password,  # 新的密码
                      :country_code,       # 手机号扩展
                      :vcode)     # 验证码
      end

      def reset_pwd_by_mobile(reset_params)
        Services::Account::ResetPwdByMobileService.call(reset_params)
      end

      def reset_pwd_by_email(reset_params)
        Services::Account::ResetPwdByEmailService.call(reset_params)
      end
    end
  end
end
