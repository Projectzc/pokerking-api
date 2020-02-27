module V2
  module Account
    # 负责登录相关的业务逻辑
    class SessionsController < ApplicationController

      def create
        requires! 'account'
        requires! 'password'
        raise_error 'user_not_found' if params[:account].blank?
        @api_result = login_by_account
        render 'v1/account/sessions/create'
      end

      private

      def login_by_account
        Services::Account::AccountLoginService.call(params, request.remote_ip)
      end
    end
  end
end

