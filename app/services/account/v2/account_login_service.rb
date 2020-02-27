module Services
  module Account
    class AccountLoginService
      include Serviceable

      def initialize(params, remote_ip)
        @account = params[:account] # 手机号或账户id
        @password = params[:password]
        @remote_ip = remote_ip
      end

      def call
        # 查询用户是否存在
        user = User.by_account(@account) || User.by_mobile_without_code(@account)
        raise_error 'user_not_found' if user.nil?

        # 说明免登陆
        if ENV['SKIP_LOGIN_ON'] && ENV['SKIP_LOGIN_MOBILES']&.split(',')&.include?(@account)
          # 说明免登陆
        else
          # 非免登陆 检查密码有效性
          salted_passwd = ::Digest::MD5.hexdigest(@password + user.password_salt)
          raise_error 'password_not_match' unless salted_passwd.eql?(user.password)
        end


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
