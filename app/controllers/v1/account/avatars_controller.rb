module V1
  module Account
    class AvatarsController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def update
        @current_user.avatar = params[:avatar]
        raise_error 'file_format_error' if @current_user.avatar.blank? || @current_user.avatar.path.blank?
        raise_error 'file_upload_error' unless @current_user.save
        render 'v1/users/base', locals: { user: @current_user }
      end
    end
  end
end
