json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.events do
    json.array! @events do |event|
      json.id          event.id
      json.name        event.name
      json.logo        event.logo_url
      json.live_url    event.live_url
      json.location    event.location
      json.title               event.name.to_s
      json.amap_poiid          event.amap_poiid.to_s
      json.amap_location       event.amap_location.to_s
      json.amap_navigation_url event.amap_navigation_url.to_s
      json.begin_time  event.begin_time.to_i
      json.end_time    event.end_time.to_i
    end
  end
end

