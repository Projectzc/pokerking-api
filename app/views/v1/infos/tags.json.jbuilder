json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.tags do
    json.array! @tags do |tag|
      json.id             tag.id
      json.name           tag.name
      json.name_en        tag.name_en
      json.created_at     tag.created_at.to_i
    end
  end
end

