module Services
  module Account
    class ResetPwdByEmailService
      include Serviceable

      attr_accessor :email, :vcode, :password

      def initialize(params)
        self.email = params[:email]&.downcase
        self.vcode = params[:vcode]
        self.password = params[:password]
      end

      def call # rubocop:disable Metrics/CyclomaticComplexity
        # 检查参数是否为空
        raise_error 'params_missing' if email.blank? || vcode.blank? || password.blank?

        # 检查密码是否符合规则
        raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(password)

        # 检查验证码是否正确
        raise_error 'vcode_not_match' unless VCode.check_vcode('reset_pwd', email, vcode)

        # 查询用户
        user = User.by_email(email)
        raise_error 'user_not_found' if user.nil?

        # 创建新的用户密码
        salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{password}#{salt}")

        user.update(password: new_password, password_salt: salt)

        # 验证完就清除掉验证码
        VCode.remove_vcode('reset_pwd', email)
        ApiResult.success_result
      end
    end
  end
end
