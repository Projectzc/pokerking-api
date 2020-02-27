json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.long_url  @url['LongUrl']
  json.short_url @url['ShortUrl']
end

