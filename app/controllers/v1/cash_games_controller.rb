module V1
  class CashGamesController < ApplicationController
    include UserAuthorize
    before_action :login_required, only: [:feedbacks]

    def index
      @cash_games = CashGame.position_desc.page(params[:page]).per(params[:page_size])
    end

    def feedbacks
      requires! :email
      requires! :sense
      requires! :content
      @cash_game = CashGame.find(params[:id])
      @feedback = CashGameFeedback.create!(user_id: @current_user.id,
                                           cash_game_id: @cash_game.id,
                                           email: params[:email],
                                           sense: params[:sense],
                                           content: params[:content])

      if params[:images].present? && params[:images].size <= 3
        params[:images].each do |image|
          feedback_image = @feedback.cash_game_feedback_images.new
          feedback_image.image = image
          raise_error 'file_format_error' if feedback_image.image.blank? || feedback_image.image.path.blank?
          raise_error 'file_upload_error' unless feedback_image.save
        end
      end

      render_api_success
    end
  end
end
