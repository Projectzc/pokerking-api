json.partial! 'common/basic', api_result: ApiResult.success_result
# data
json.data do
  json.applies do
    json.array! @apply_notifications do |notification|
      json.partial! 'v1/users/notifications/base', notification: notification
    end
  end
  json.apply_unread_counts @apply_notification_unread

  json.events do
    json.array! @event_notifications do |notification|
      json.partial! 'v1/users/notifications/base', notification: notification
      info = notification.source
      json.info do
        json.id             info.id
        json.image          info.image_url
        json.title          info.title
        json.source         info.source
        json.hot            info.hot
        json.location       info.location
        json.created_at     info.created_at.to_i
      end
    end
  end
  json.event_unread_counts @event_notification_unread
end
