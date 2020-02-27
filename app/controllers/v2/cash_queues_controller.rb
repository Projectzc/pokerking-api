class V2::CashQueuesController < ApplicationController
  include UserAuthorize
  before_action :check_login
  before_action :set_cash_game
  def index
    from_h5? ? h5_lists : app_lists
  end

  private

  # h5 部分要显示出来high limit 和 transfer， app端不需要
  def h5_lists
    @cash_queues = @cash_game.cash_queues.position_desc.order(id: :desc).take(limit_number)
    # 将桌子全部打散开来，对应到对应的盲注结构上
    @sorted_queues = is_macao? ? macao_tables(@cash_queues) : {}
  end

  def app_lists
    @cash_queues = @cash_game.cash_queues.where(high_limit: false).where(transfer: false).position_desc.order(id: :desc).page(params[:page]).per(params[:page_size])
    @sorted_queues = is_macao? ? macao_tables(@cash_queues) : {}
  end

  # 澳门需要获取每个桌子的大盲注 小盲注 亚洲的不需要
  def macao_tables(cash_queue)
    sorted_queues = {}
    cash_queue.each do |item|
      item.table_no.split(',').each do |i|
        sorted_queues[i] = item
      end
    end
    sorted_queues
  end

  # 不同模板显示的数量不一样， h5澳门最多显示5列  亚洲显示6列
  def limit_number
    is_macao? ? 5 : 6
  end

  def is_macao?
    @cash_game.table_type.eql?('Macao')
  end

  def set_cash_game
    @cash_game = CashGame.find(params[:cash_game_id])
  end

  def check_login
    login_required unless from_h5?
  end

  def from_h5?
    params[:from].eql?('h5')
  end
end
