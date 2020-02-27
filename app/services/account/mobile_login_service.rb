module Services
  module Account
    class MobileLoginService
      include Serviceable

      def initialize(params, remote_ip)
        @mobile = params[:mobile]
        @password = params[:password]
        @remote_ip = remote_ip
      end

      def call
        # 检查手机号格式是否正确
        raise_error 'params_missing' if @mobile.blank? || @password.blank?

        # 查询用户是否存在
        user = User.by_mobile(@mobile)
        raise_error 'user_not_found' if user.nil?

        salted_passwd = ::Digest::MD5.hexdigest(@password + user.password_salt)
        raise_error 'password_not_match' unless salted_passwd.eql?(user.password)


        # 刷新上次访问时间
        user.touch_visit!
        # 登录次数+1
        user.increase_login_count
        # 更新上次访问的ip
        user.update(last_sign_in_ip: @remote_ip)

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
