# 绑定登录账户
module V1
  module Account
    class BindAccountController < ApplicationController
      ACCOUNT_TYPES = %w[mobile].freeze
      include UserAuthorize
      before_action :login_required
      def create
        user_params = permit_params.dup

        raise_error 'unsupported_type' unless ACCOUNT_TYPES.include?(user_params[:type])

        raise_error 'params_missing' if user_params[:account].blank? || user_params[:code].blank?

        @api_result = Services::Account::V2::BindAccountService.call(@current_user, user_params)
        render 'v1/users/base', locals: { user: @api_result.data[:user] }
      end

      private

      def permit_params
        params.permit(:type,
                      :account,
                      :country_code,
                      :code)
      end
    end
  end
end


