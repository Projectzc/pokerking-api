json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.info do
    json.id             @info.id
    json.main_event_id  @info.main_event_id
    json.image          @info.image_url
    json.title          @info.title
    json.source         @info.source
    json.description    @info.description
    json.hot            @info.hot
    json.location       @info.location
    json.created_at     @info.created_at.to_i
  end

  json.hot_infos do
    json.array! @hot_infos do |info|
      json.id             info.id
      json.main_event_id  @info.main_event_id
      json.image          info.image_url
      json.title          info.title
      json.source         info.source
      json.description    @info.description
      json.hot            info.hot
      json.location       info.location
      json.created_at     info.created_at.to_i
    end
  end
end

