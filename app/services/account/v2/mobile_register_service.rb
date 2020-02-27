module Services
  module Account
    module V2
      class MobileRegisterService
        include Serviceable

        def initialize(params, remote_ip)
          @account = params[:account].blank? ? "T#{SecureRandom.hex(5)}" : params[:account]
          @password = params[:password].blank? ? ::Digest::MD5.hexdigest(SecureRandom.uuid) : params[:password]
          @mobile = params[:mobile]
          @country_code = params[:country_code]
          @vcode = params[:vcode]
          @nickname = params[:nickname]
          @country = params[:country]
          @gender = params[:gender]
          @email = params[:email]
          @birthday = params[:birthday]
          # 实名需要的信息
          @realname = params[:realname]
          @cert_no = params[:cert_no]
          @img_front = params[:img_front]
          @remote_ip = remote_ip
        end

        def call
          if @mobile.present?
            # 检查手机格式是否正确
            raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(@mobile, @country_code)
            # 检查手机号是否存在
            raise_error 'mobile_already_used' if UserValidator.mobile_exists?(@mobile, @country_code)
          end
          # 账户长度是否合法
          raise_error 'account_illegal' unless UserValidator.account_valid?(@account)
          # 账户和密码为必填项
          # 检查账号是否唯一
          raise_error 'account_already_used' if UserValidator.account_id_exists?(@account)
          # 检查密码是否合法
          raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(@password)

          # 判断是新版还是老版 如果前端给了country那么是新版 需要强制实名
          if @country.present?
            #验证用户是否上传了实名信息， 如果没有就报错
            if @realname.blank? || @cert_no.blank? || @img_front.blank?
              raise_error 'card_info_error'
            end
          end

          if @mobile.present? # 由于twilio的特殊性 先检查完上面的 再判断验证码是否正确
            # 检查验证码是否正确
            # raise_error 'vcode_not_match' unless VCode.check_vcode('login', "+#{@country_code}#{@mobile}", @vcode)
            # 使用v2版本检查验证码是否正确
            raise_error 'vcode_not_match'  unless TwilioVerifyApi.new.check_verification("+#{@country_code}#{@mobile}", @vcode)
          end

          # 可以注册, 创建一个用户
          create_infos = { account_id: @account,
                           password: @password,
                           mobile: @mobile,
                           country_code: @country_code,
                           nickname: @nickname,
                           country: @country, # 添加国籍
                           gender: @gender,
                           email: @email,
                           birthday: @birthday }
          user = User.create_by_mobile(create_infos)

          if @country.present?
            # 添加用户实名信息 如果用户上传了就验证 没有就取消验证
            @user_extra = user.user_extras.new
            @user_extra.img_front = @img_front # 正面图片
            @user_extra.real_name = @realname
            @user_extra.cert_no = @cert_no
            raise_error 'file_format_error' if @user_extra.img_front.blank? || @user_extra.img_front.path.blank?
            unless @user_extra.save
              user.destroy # 如果没有保存成功 报用户上传失败错误返回
              raise_error 'file_upload_error'
            end
          end

          user.update(last_sign_in_ip: @remote_ip)
          # 生成用户令牌
          access_token = UserToken.encode(user.user_uuid)
          LoginResultHelper.call(user, access_token)
        end
      end
    end
  end
end
