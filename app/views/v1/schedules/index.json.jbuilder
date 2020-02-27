json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.schedules do
    json.array! @schedules do |schedule|
      json.id             schedule.id
      json.name           schedule.name
      json.event_type     schedule.event_type
      json.event_num      schedule.event_num
      json.buy_in         schedule.buy_in
      json.entries        schedule.entries
      json.starting_stack schedule.starting_stack
      json.schedule_pdf   schedule.schedule_pdf_url
      json.begin_time     schedule.begin_time.to_i
      json.reg_open       schedule.reg_open.to_i
      json.reg_close      schedule.reg_close.to_i
    end
  end
end

