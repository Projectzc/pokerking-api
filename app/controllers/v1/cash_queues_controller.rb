class V1::CashQueuesController < ApplicationController
  include UserAuthorize
  before_action :check_login, except: [:scanapply]
  before_action :set_cash_game, except: [:scanapply, :scanapplystatus]

  def index
    from_h5? ? h5_lists : app_lists
  end

  # 扫描报名某个盲注结构
  def scanapply
    @params = parse_params # 解析前端传递的参数
    # 判断是否有效的请求
    return if redis_url_check(@params[:dwz_url])
    Rails.logger.info "params: #{@params}"
    check_scan_login(@params[:token]) # 检查设备传递的token是否正确 并返回当前用户
    @params[:cash_queue_id].split('|').each do |queue_id|
      @cash_game = CashGame.find(@params[:cash_game_id])
      # 1 判断A想报名的盲注结构没有与A同名的用户
      @cash_queue = @cash_game.cash_queues.find(queue_id)
      apply_users = @cash_queue.cash_queue_members.where(nickname: @current_user.nickname)
      Rails.logger.info "error: 上传的参数已有报名的queue：#{queue_id}" unless apply_users.blank?
      unless apply_users.blank?
        Rails.cache.write(@params[:dwz_url], 'failed', expires_in: 60.seconds)
        return render html: 'code=1111'
      end
      # 2 允许A报名
      @queue_member = @cash_queue.cash_queue_members.create(nickname: @current_user.nickname, user_id: @current_user.id, memo: 'from app', confirmed: false)
      # 3 报名成功下发通知
      # Notification.create_queue_notify(@current_user, @cash_queue)
    end
    # 4 返回A报名成功的信息
    Rails.logger.info "报名成功啦"
    Rails.cache.write(@params[:dwz_url], 'success', expires_in: 60.seconds) # 将报名的状态重新设为true
    render html: "code=0000"
  end

  # 用于前端检查二维码是否扫描成功的接口
  def scanapplystatus
    requires! :dwz_url
    60.times do
      url = Rails.cache.read(params[:dwz_url])
      # 如果url返回的是true 那么直接返回结果
      return render_api_success if url.eql? 'success'
      return render_api_error('报名失败') if url.eql? 'failed'
      sleep(1) # 一秒执行一次
    end
    # 60 秒数据都没有 那么告诉前端请求异常
    render_api_error('请求用时太久', 2)
  end

  # app上取消报名排队
  def cancelapply
    # 判断用户是否有申请报名过该盲注结构
    @cash_queue = @cash_game.cash_queues.find(params[:id])
    member_item = @cash_queue.cash_queue_members.find_by(user_id: @current_user.id)
    raise_error 'no_apply' if member_item.blank?
    # 取消用户报名
    member_item.destroy
    # 下发取消报名的通知
    Notification.cancel_queue_notify(@current_user, @cash_queue)
    # 返回成功结果
    render_api_success
  end

  private

  def parse_params
    stringio = request.body.read
    Rails.logger.info "string io: #{stringio}"
    # 解析前端传过来的短网址
    stringio = stringio&.split('&&')
    # 获取dwz url 并检查
    dwz_url = stringio&.first&.split('=')&.second
    raise_error 'params_missing' if dwz_url.blank?
    # 获取vg 设备号
    vg_number = stringio.second.split('=').second
    vg_result = parse_dwz(dwz_url)['LongUrl'].split('?').second
    raise_error 'params_missing' if vg_result.blank? || vg_number.blank?
    vg_params = vg_result.split('&')
    raise_error 'params_missing' if vg_params.blank? ||
        !vg_params.first.split('=').first.eql?('token') ||
        !vg_params.second.split('=').first.eql?('cash_queue_id')
        !vg_params.third.split('=').first.eql?('cash_game_id')
    token = vg_params.first.split('=').second
    cash_queue_id = vg_params.second.split('=').second
    cash_game_id = vg_params.third.split('=').second
    {
      token: token,
      cash_queue_id: cash_queue_id,
      cash_game_id: cash_game_id,
      number: vg_number,
      dwz_url: dwz_url
    }
  end

  def redis_url_check(url)
    if Rails.cache.read(url).present?
      sleep(1)
      Rails.logger.info "重复的url 已废弃"
      true
    else
      Rails.cache.write(url, false, expires_in: 60.seconds) # 第一次请求上来设为false
      false
    end
  end

  def parse_dwz(url)
    Dwz.new.query(url)
  end

  def check_scan_login(user_token)
    user_authenticate ||= UserToken.decode(user_token) || authorized_error('invalid_credential')
    user_uuid = user_authenticate[:user_uuid]
    @current_user ||= User.by_uuid(user_uuid)

    @current_user || authorized_error('login_required')
  end

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
