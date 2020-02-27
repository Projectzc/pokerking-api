json.user_extra do
  json.id                 user_extra.id
  json.real_name          user_extra.real_name.to_s
  json.cert_no            user_extra.cert_no.to_s
  json.cert_type          user_extra.cert_type.to_s
  json.img_front          user_extra.image_path.to_s
end