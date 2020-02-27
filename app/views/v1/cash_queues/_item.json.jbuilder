json.id                         cash_queue.id
json.cash_game_id               cash_queue.cash_game_id
json.small_blind                cash_queue.small_blind
json.big_blind                  cash_queue.big_blind
json.straddle                   cash_queue.straddle.to_i
json.blind_info                 cash_queue.blind_info
json.table_numbers              cash_queue.table_nums
json.cash_queue_members_count   cash_queue.cash_queue_members_count
json.buy_in                     cash_queue.buy_in
json.table_no                   cash_queue.table_no
json.queue_type                 cash_queue.queue_type_tmp
json.navigation                 cash_queue.navigation_url.to_s
json.notice                     cash_queue.notice.to_s
json.currency                   cash_queue.currency
json.created_at                 cash_queue.created_at.to_i
json.apply_index                cash_queue.current_user_index(@current_user)
json.apply_status               cash_queue.current_user_apply_status(@current_user)

