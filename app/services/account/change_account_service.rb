module Services
  module Account
    class ChangeAccountService
      include Serviceable

      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        type = user_params[:type]
        old_account = user[type]
        old_account_check = "+#{user.country_code}#{old_account}"
        account = user_params[:account]
        # 判断旧验证码是否匹配
        raise_error 'vcode_not_match' unless check_code('change_old_account', old_account_check, user_params[:old_code], user.country_code)
        # 判断新验证码是否匹配
        raise_error 'vcode_not_match' unless check_code('bind_new_account', "+#{user_params[:country_code]}#{account}", user_params[:new_code], user_params[:country_code])

        send("update_#{type}", account)
      end

      private

      def check_code(type, account, code, country_code)
        return true if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?
        if country_code.eql? '86'
          VCode.check_vcode(type, account, code)
        else
          TwilioVerifyApi.new.check_verification(account, code)
        end
        # VCode.check_vcode(type, account, code)
        # 使用v2版本检查验证码是否正确
        # Rails.logger.info "check_code: #{account} #{code}"
        # TwilioVerifyApi.new.check_verification(account, code)
      end

      def update_mobile(mobile)
        # 判断手机号格式是否正确
        raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(mobile, user_params[:country_code])
        # 判断账户是否存在
        raise_error 'mobile_already_used' if UserValidator.mobile_exists?(mobile, user_params[:country_code])

        # 清除redis缓存的旧用户数据
        User.expire_cache_uniq_key(mobile: user.mobile, country_code: user.country_code) # 清除手机号验证码登录的缓存

        # 更新账户
        user.assign_attributes(mobile: mobile, country_code: user_params[:country_code])
        user.touch_visit!
        # 记录一次账户修改
        ApiResult.success_with_data(user: user)
      end

      def update_email(email)
        # 检查邮箱格式是否正确
        raise_error 'email_format_error' unless UserValidator.email_valid?(email)
        # 检查邮箱是否存在
        raise_error 'email_already_userd' if UserValidator.email_exists?(email)

        # 清除redis缓存的旧用户数据
        User.expire_cache_uniq_key(email: user.email)

        # 更新账户
        user.assign_attributes(email: email)
        user.touch_visit!
        # 记录一次账户修改
        ApiResult.success_with_data(user: user)
      end
    end
  end
end
