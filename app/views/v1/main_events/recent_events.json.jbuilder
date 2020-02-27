json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.recent_event do
    next if @recent_event.blank?
    json.id         @recent_event.id
    json.name        @recent_event.name
    json.logo        @recent_event.logo_url
    json.live_url    @recent_event.live_url
    json.location    @recent_event.location
    json.title               @recent_event.name.to_s
    json.amap_poiid          @recent_event.amap_poiid.to_s
    json.amap_location       @recent_event.amap_location.to_s
    json.amap_navigation_url @recent_event.amap_navigation_url.to_s
    json.begin_time  @recent_event.begin_time.to_i
    json.end_time    @recent_event.end_time.to_i
    json.description @recent_event.description
  end

  json.events do
    json.array! @events do |event|
      next if event.blank?
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

