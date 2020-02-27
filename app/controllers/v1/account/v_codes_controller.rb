module V1
  module Account
    # 发送验证码的接口
    class VCodesController < ApplicationController
      include UserAuthorize
      before_action :login_need?
      OPTION_TYPES = %w[login reset_pwd change_pwd bind_account change_old_account bind_new_account].freeze
      VCODE_TYPES = %w[mobile email].freeze

      def create
        optional! :vcode_type, values: VCODE_TYPES
        optional! :option_type, values: OPTION_TYPES
        Services::Account::VcodeServicesV2.call(@current_user, user_params) # 使用v2版本发送
        render_api_success
      end

      private

      def user_params
        params.permit(:option_type, :vcode_type, :mobile, :country_code)
      end

      def login_need?
        if params[:option_type].eql?('login') || params[:option_type].eql?('reset_pwd')
          # 登录 注册的时候不需要登录
          @current_user = nil
        else
          login_required
        end
      end
    end
  end
end
