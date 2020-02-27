module Services
  module Account
    module V2
      class ChangePwdByVcodeService
        include Serviceable

        attr_accessor :new_pwd, :mobile, :vcode, :user, :country_code

        def initialize(params, user)
          self.new_pwd = params[:new_pwd]
          self.vcode = params[:vcode]
          self.country_code = user.country_code
          self.mobile = user.mobile
          self.user = user
        end

        def call
          # 检查密码是否为空
          raise_error 'params_missing' if vcode.blank? || new_pwd.blank?

          # 检查密码是否太简单
          raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(new_pwd)

          # 判断验证码是否一致
          # raise_error 'vcode_not_match' unless VCode.check_vcode('change_pwd', "+#{country_code}#{mobile}", vcode)
          # 使用v2版本检查验证码是否正确
          # raise_error 'vcode_not_match'  unless TwilioVerifyApi.new.check_verification("+#{country_code}#{mobile}", vcode)
          if @country_code.eql? '86'
            raise_error 'vcode_not_match' unless VCode.check_vcode('login', vcode_account, @vcode)
          else
            unless TwilioVerifyApi.new.check_verification(vcode_account, @vcode)
              raise_error 'vcode_not_match'
            end
          end

          # 生成新的密码 设置新的盐值
          new_salt = SecureRandom.hex(6).slice(0, 6)
          new_password = ::Digest::MD5.hexdigest("#{new_pwd}#{new_salt}")

          user.update(password: new_password, password_salt: new_salt)
          ApiResult.success_result
        end
      end
    end
  end
end
