case model_type
when 'info'
  json.info do
    json.id            target.id
    json.title         target.title
    json.created_at    target.created_at.to_i
    json.preview_image target.image_url
  end
when 'main_event'
  json.main_event do
    json.id            target.id
    json.name          target.name
    json.logo          target.logo_url
    json.begin_time    target.begin_time.to_i
    json.end_time      target.end_time.to_i
  end
end