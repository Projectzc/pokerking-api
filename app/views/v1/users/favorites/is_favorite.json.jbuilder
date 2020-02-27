json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.is_favorite @current_user.favorite?(@target)
end