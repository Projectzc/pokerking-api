module UserAuthorize
  extend ActiveSupport::Concern

  def http_token
    @http_token ||= request.headers['HTTP_X_ACCESS_TOKEN']
  end

  def user_authenticate!
    @user_authenticate ||= UserToken.decode(http_token) || authorized_error('invalid_credential')
  end

  def login_required
    user_authenticate!
    user_uuid = @user_authenticate[:user_uuid]
    @current_user ||= User.by_uuid(user_uuid)

    @current_user || authorized_error('login_required')
  end

  def user_self_required
    login_required
    verified = @current_user.present? && @current_user.user_uuid.eql?(params[:user_id])
    authorized_error('user_self_required') unless verified
  end

  def current_user
    token = UserToken.decode(http_token)
    return @current_user = nil if http_token.blank? || token.blank?

    @current_user ||= User.by_uuid(token[:user_uuid])
  end

  def authorized_error(msg)
    raise(ApplicationController::AuthorizedError, I18n.t("errors.#{msg}"))
  end
end