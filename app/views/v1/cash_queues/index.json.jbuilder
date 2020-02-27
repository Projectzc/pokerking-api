json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.table_type @cash_game.table_type.to_s

  # 普通的列
  json.queues do
    json.array! @cash_queues do |cash_queue|
      json.partial! 'v1/cash_queues/item', cash_queue: cash_queue
    end
  end

  # 桌号的问题
  json.tables do
    json.array! @sorted_queues do |cash_queue|
      json.table_no     cash_queue[0]
      json.cash_game_id cash_queue[1].cash_game_id
      json.small_blind  cash_queue[1].small_blind
      json.big_blind    cash_queue[1].big_blind
      json.straddle     cash_queue[1].straddle
      json.blind_info   cash_queue[1].blind_info
    end
  end

  # 兼容APP老版本
  json.ordinary_queues do
    json.array! @cash_queues do |cash_queue|
      json.partial! 'v1/cash_queues/item', cash_queue: cash_queue
    end
  end
end
