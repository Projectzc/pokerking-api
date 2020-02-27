# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  json.apply_notify        @current_user.apply_notify
  json.event_notify        @current_user.event_notify
  json.notify_event_unread @current_user.notify_event_unread_new
  json.notify_apply_unread @current_user.notify_apply_unread_new
end