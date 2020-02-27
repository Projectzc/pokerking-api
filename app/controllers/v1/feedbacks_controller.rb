module V1
  class FeedbacksController < ApplicationController
    include UserAuthorize
    before_action :login_required

    def create
      requires! :email
      requires! :sense
      requires! :content

      @feedback = Feedback.create!(user_id: @current_user.id,
                                   email: params[:email],
                                   sense: params[:sense],
                                   content: params[:content])

      if params[:images].present? && params[:images].size <= 3
        params[:images].each do |image|
          feedback_image = @feedback.feedback_images.new
          feedback_image.image = image
          raise_error 'file_format_error' if feedback_image.image.blank? || feedback_image.image.path.blank?
          raise_error 'file_upload_error' unless feedback_image.save
        end
      end

      render_api_success
    end
  end
end
