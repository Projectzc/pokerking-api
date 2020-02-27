json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.infos do
    json.array! @infos do |info|
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

