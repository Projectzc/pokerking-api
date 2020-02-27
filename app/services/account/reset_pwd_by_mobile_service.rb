module Services
  module Account
    class ResetPwdByMobileService
      include Serviceable

      attr_accessor :mobile, :vcode, :password, :country_code

      def initialize(params)
        self.mobile = params[:mobile]
        self.country_code = params[:country_code]
        self.vcode = params[:vcode]
        self.password = params[:password]
      end

      def call # rubocop:disable Metrics/CyclomaticComplexity
        # 检查参数是否为空
        raise_error 'params_missing' if mobile.blank? || vcode.blank? || password.blank?

        # 检查密码是否符合规则
        raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(password)

        # 检查验证码是否正确
        # raise_error 'vcode_not_match' unless VCode.check_vcode('reset_pwd', "+#{country_code}#{mobile}", vcode)
        # 使用v2版本检查验证码是否正确
        # raise_error 'vcode_not_match'  unless TwilioVerifyApi.new.check_verification("+#{country_code}#{mobile}", vcode)
        if @country_code.eql? '86'
          raise_error 'vcode_not_match' unless VCode.check_vcode('login', vcode_account, @vcode)
        else
          unless TwilioVerifyApi.new.check_verification(vcode_account, @vcode)
            raise_error 'vcode_not_match'
          end
        end

        # 查询用户
        user = User.by_mobile(mobile)
        raise_error 'user_not_found' if user.nil?

        # 创建新的用户密码
        salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{password}#{salt}")

        user.update(password: new_password, password_salt: salt)
        ApiResult.success_result
      end
    end
  end
end
