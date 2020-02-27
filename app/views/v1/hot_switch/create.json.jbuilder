json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.hot_switch ENV['HOT_SWITCH'].eql?('true')
end

