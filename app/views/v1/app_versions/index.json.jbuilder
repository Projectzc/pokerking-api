# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.ios_platform do
    json.version       @ios_platform.version
    json.force_upgrade @ios_platform.force_upgrade
    json.title         @ios_platform.title
    json.content       @ios_platform.content
    json.download_url  @ios_platform.download_url
  end

  json.android_platform do
    json.version       @android_platform.version
    json.force_upgrade @android_platform.force_upgrade
    json.title         @android_platform.title
    json.content       @android_platform.content
    json.download_url  @android_platform.download_url
  end
end
