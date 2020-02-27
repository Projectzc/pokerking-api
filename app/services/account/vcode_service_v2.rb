module Services
  module Account
    class VcodeServicesV2
      COMMON_SMS_TEMPLATE = '%s为您的验证码，请于1分钟内填写，如非本人操作，请忽略本短信。'.freeze
      RESET_PWD_SMS_TEMPLATE = '【Pokerkinglive】Your verification code is:%s'.freeze
      REGISTER_SMS_TITLE = '请激活您的帐号，完成注册'.freeze
      RESET_PWD_TITLE = '重设您的密码'.freeze
      COMMON_SMS_TITLE = 'Pokerkinglive验证码'.freeze
      REQUIRE_USER_NOT_EXIST_TYPES = %w[register bind_account bind_new_account].freeze
      REQUIRE_USER_EXIST_TYPES = %w[register bind_account bind_new_account].freeze

      include Serviceable

      def initialize(user, user_params)
        @user = user
        @user_params = user_params
        @vcode_type = user_params[:vcode_type]
        @option_type = user_params[:option_type]
        @country_code = user_params[:country_code]
        @account = gain_account_id
      end

      def call
        # 检查是否传了手机号或者邮箱
        raise_error 'params_missing' if @account.blank?
        check_permission
        send("send_#{@vcode_type}_vcodes")
      end

      private

      def send_mobile_vcodes
        raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(@account, @country_code)
        sms_content = ''

        if @country_code.eql?('86') # 如果是国内 走腾讯云
          # 验证的时候也要带上区号 才可以
          vcode = VCode.generate_mobile_vcode(@option_type, "+#{@country_code}#{@account}")
          sms_content = format(send_template, vcode)
          Rails.logger.info "send [#{sms_content}] to #{@account} in queue"
          # 测试则不实际发出去
          return ApiResult.success_result if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?
        end

        SendMobileIsmsJob.perform_later(@account, @country_code, sms_content)
        ApiResult.success_result
      end

      def send_email_vcodes
        raise_error 'email_format_error' unless UserValidator.email_valid?(@account)
        @account = @account.downcase
        vcode = VCode.generate_email_vcode(@option_type, @account)
        sms_content = format(send_template, vcode)
        Rails.logger.info "send [#{sms_content}] to #{@account} in queue"
        # 测试则不实际发出去
        return ApiResult.success_result if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?

        SendEmailSmsJob.perform_later(@option_type, @account, sms_content, send_title)
        ApiResult.success_result
      end

      def send_template
        @option_type.eql?('reset_pwd') ? COMMON_SMS_TEMPLATE : COMMON_SMS_TEMPLATE
      end

      def send_title
        if @option_type == 'register'
          REGISTER_SMS_TITLE
        elsif @option_type == 'reset_pwd'
          RESET_PWD_TITLE
        else
          COMMON_SMS_TITLE
        end
      end

      def check_permission
        # 登录的情况下跳过检查
        return if @option_type.eql?('login') || @option_type.eql?('change_pwd')
        # 注册和绑定的时候要求用户不存在
        raise_error 'user_already_exist' if @option_type.in?(REQUIRE_USER_NOT_EXIST_TYPES) && check_user_exist
        # 其它情况都要求用户已存在
        raise_error 'user_not_found' unless @option_type.in?(REQUIRE_USER_EXIST_TYPES) || check_user_exist
      end

      def check_user_exist
        User.by_email(@account).present? || User.by_mobile(@account, @country_code).present?
      end

      # 从数据库中取 -> change_pwd
      def gain_account_id
        if @option_type.eql?('change_old_account') || @option_type.eql?('change_pwd')
          @country_code = @user.country_code # 如果是更换账户，那么它的区号 手机号 或邮箱都从数据库取
          @user[:"#{@vcode_type}"]
        else
          @user_params[:"#{@vcode_type}"]
        end
      end
    end
  end
end
