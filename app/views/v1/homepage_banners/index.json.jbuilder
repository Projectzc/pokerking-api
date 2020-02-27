json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.banners do
    json.array! @banners do |banner|
      json.id           banner.id
      json.image        banner.image_url
      json.source_type  banner.source_type
      json.source_id    banner.source_id
    end
  end
end

