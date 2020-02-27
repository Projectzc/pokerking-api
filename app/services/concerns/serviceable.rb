module Serviceable
  extend ActiveSupport::Concern

  module ClassMethods
    def call(*args)
      new(*args).call
    end
  end

  def raise_error(msg, i18n = true)
    msg = i18n ? I18n.t("errors.#{msg}") : msg
    raise ApplicationController::CommonError, msg
  end

  def raise_error_msg(msg)
    raise ApplicationController::CommonError, msg
  end
end
