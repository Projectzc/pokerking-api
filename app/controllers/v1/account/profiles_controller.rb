module V1
  module Account
    # 个人中心 个人信息部分
    class ProfilesController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def show; end

      def update
        raise_error 'user_nickname_exist' if User.by_nickname(user_params[:nickname]).present?
        raise_error 'email_format_error'  if user_params[:email].present? && !UserValidator.email_valid?(user_params[:email])
        @current_user.assign_attributes(user_params)
        @current_user.touch_visit!
        render :show
      end

      private

      def user_params
        params.permit(:nickname, :gender, :email, :birthday, :country)
      end
    end
  end
end
