module RequestParamsInspector
  def requires!(name, opts = {})
    opts[:require] = true
    optional!(name, opts)
  end

  def optional!(name, opts = {})
    if opts[:require] && params[name].nil?
      raise ApplicationController::CommonError, I18n.t('errors.params_missing')
    end

    params[name] ||= opts[:default]
    check_in_values!(name, opts)
  end

  def check_in_values!(name, opts)
    return unless opts[:values] && params.key?(name)

    values = opts[:values].to_a
    return if param_in_values?(params[name], values)

    raise ApplicationController::CommonError, I18n.t('errors.params_format_error')
  end

  def param_in_values?(value, values)
    value.in?(values) || value.to_i.in?(values)
  end
end
