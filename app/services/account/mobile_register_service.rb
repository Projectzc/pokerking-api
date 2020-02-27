module Services
  module Account
    class MobileRegisterService
      include Serviceable

      def initialize(params, remote_ip)
        @mobile = params[:mobile]
        @country_code = params[:country_code]
        @vcode = params[:vcode]
        @nickname = params[:nickname]
        @gender = params[:gender]
        @email = params[:email]
        @password = params[:password]
        @remote_ip = remote_ip
      end

      def call
        # 检查手机格式是否正确
        raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(@mobile, @country_code)

        # 检查验证码是否正确
        # raise_error 'vcode_not_match' unless VCode.check_vcode('login', "+#{@country_code}#{@mobile}", @vcode)
        # 使用v2版本检查验证码是否正确
        # raise_error 'vcode_not_match'  unless TwilioVerifyApi.new.check_verification("+#{@country_code}#{@mobile}", @vcode)
        if @country_code.eql? '86'
          raise_error 'vcode_not_match' unless VCode.check_vcode('login', vcode_account, @vcode)
        else
          unless TwilioVerifyApi.new.check_verification(vcode_account, @vcode)
            raise_error 'vcode_not_match'
          end
        end

        # 检查手机号是否存在
        raise_error 'mobile_already_used' if UserValidator.mobile_exists?(@mobile, @country_code)

        # 检查密码是否合法
        raise_error 'password_format_wrong' if @password.present? && !UserValidator.pwd_valid?(@password)

        # 可以注册, 创建一个用户
        create_infos = { mobile: @mobile, country_code: @country_code, nickname: @nickname, gender: @gender, email: @email, password: @password }
        user = User.create_by_mobile(create_infos)
        user.update(last_sign_in_ip: @remote_ip)

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
