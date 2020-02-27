module V1
  module Account
    # 负责登录相关的业务逻辑
    class SessionsController < ApplicationController
      LOGIN_TYPES = %w[vcode mobile account].freeze

      def create
        optional! :type, values: LOGIN_TYPES
        @api_result = send("login_by_#{params[:type]}")
      end

      private

      def login_by_vcode
        Services::Account::VcodeLoginService.call(params, request.remote_ip)
      end

      def login_by_mobile
        Services::Account::MobileLoginService.call(params, request.remote_ip)
      end

      def login_by_account
        requires! 'account'
        requires! 'password'
        Services::Account::AccountLoginService.call(params, request.remote_ip)
      end
    end
  end
end



