module V1
  module Account
    # 校验验证码是否正确
    class VerifyVcodesController < ApplicationController
      include UserAuthorize
      before_action :login_need?
      OPTION_TYPES = %w[login reset_pwd change_pwd change_old_account bind_account bind_new_account].freeze
      VCODE_TYPES = %w[mobile email].freeze

      def create
        # 验证码类型是否符合
        optional! :vcode_type, values: VCODE_TYPES unless params[:option_type].eql?('change_old_account') || params[:option_type].eql?('change_pwd')
        optional! :option_type, values: OPTION_TYPES

        # 验证参数
        # requires! :account

        # if ENV['SKIP_LOGIN_ON'] && ENV['SKIP_LOGIN_MOBILES']&.split(',')&.include?(params[:account]) && params[:vcode].eql?(ENV['SKIP_LOGIN_VCODE'])
        #   # 说明免登陆
        #   nil
        # else
        #   # 检查验证码是否正确
        #   # raise_error 'vcode_not_match' unless VCode.check_vcode(params[:option_type], gain_account, params[:vcode])
        #   # 使用v2版本检查验证码是否正确
        #   raise_error 'vcode_not_match' unless TwilioVerifyApi.new.check_verification(gain_account, params[:vcode])
        # end
        #
        # 由于twilio短信验证码失效无法控制时间 这里去掉这个判断
        render_api_success
      end

      private

      def login_need?
        if params[:option_type].eql?('login') || params[:option_type].eql?('reset_pwd')
          @current_user = nil
        else
          login_required
        end
      end

      def gain_account
        if params[:option_type].eql?('change_old_account') || params[:option_type].eql?('change_pwd')
          "+#{@current_user.country_code}#{@current_user.mobile}"
        else
          "+#{params[:country_code]}#{params[:account]}"
        end
      end
    end
  end
end
