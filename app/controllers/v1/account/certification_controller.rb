module V1
  module Account
    class CertificationController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def index
        @user_extra = @current_user.user_extras.first # 暂时为单实名
        raise_error 'no_certification' if @user_extra.blank?
        render :index
      end

      def create
        requires! :real_name
        requires! :cert_no
        requires! :img_front

        raise_error 'certification_exist' if @current_user.user_extras.present?

        @user_extra = @current_user.user_extras.new
        @user_extra.img_front = params[:img_front] # 正面图片
        @user_extra.real_name = params[:real_name]
        @user_extra.cert_no = params[:cert_no]

        raise_error 'file_format_error' if @user_extra.img_front.blank? || @user_extra.img_front.path.blank?
        unless @user_extra.save
          raise_error 'file_upload_error'
        end
        render :index
      end

      def update
        requires! :real_name
        requires! :cert_no
        requires! :img_front

        @user_extra = UserExtra.find(params[:id])

        @user_extra.img_front = params[:img_front] # 正面图片
        @user_extra.real_name = params[:real_name]
        @user_extra.cert_no = params[:cert_no]

        raise_error 'file_format_error' if @user_extra.img_front.blank? || @user_extra.img_front.path.blank?
        unless @user_extra.save
          raise_error 'file_upload_error'
        end
        render :index
      end

      private

      def user_params
        params.permit(:real_name, :cert_no, :img_front)
      end
    end
  end
end
