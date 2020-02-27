json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @favorites_actions do |action|
      model_name = action.target_type.tableize.singularize
      if action.target.present?
        json.target_type model_name
        json.partial! 'v1/briefs/base', model_type: model_name, target: action.target
      end
      json.created_at action.created_at.to_i
    end
  end
  json.favorites_count @favorites_actions.count
end