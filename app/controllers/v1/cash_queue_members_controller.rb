module V1
  class CashQueueMembersController < ApplicationController
    include UserAuthorize
    before_action :check_login
    before_action :set_cash_queue

    def index
      @cash_queue_members = @cash_queue.cash_queue_members.where(confirmed: true).position_asc.page(params[:page]).per(params[:page_size])
    end

    private

    def set_cash_queue
      @cash_queue = CashQueue.find(params[:cash_queue_id])
    end

    def check_login
      login_required unless params[:from].eql?('h5')
    end
  end
end
