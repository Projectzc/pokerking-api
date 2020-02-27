module Services
  module Account
    module V2
      class ChangePwdByPwdService
        include Serviceable
        attr_accessor :new_pwd, :old_pwd, :user

        def initialize(params, user)
          self.new_pwd = params[:new_pwd]
          self.old_pwd = params[:old_pwd]
          self.user = user
        end

        def call
          # 检查密码是否为空
          raise_error 'params_missing' if old_pwd.blank? || new_pwd.blank?

          # 检查密码是否有效格式
          raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(new_pwd)

          # 判断输入的密码是否和之前设定的是一致的
          old_salt = user.password_salt
          old_salted_password = ::Digest::MD5.hexdigest("#{old_pwd}#{old_salt}")
          raise_error 'password_not_match' unless user.password.eql?(old_salted_password)

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
