# 发送短信验证码任务
class SendMobileIsmsJob < ApplicationJob
  queue_as :send_mobile_isms_jobs

  def perform(mobile, country_code, sms_content = '')
    if country_code.eql?('86')
      logger = Resque.logger
      logger.info "[SendMobileSmsJob] Send SMS to #{mobile} content [#{sms_content}]"
      Qcloud::SmsGateway::SendIsms.send(mobile, sms_content, { country_code: country_code })
    else
      TwilioVerifyApi.new.start_verification(mobile, country_code, 'sms')
    end
  end

  # def perform(mobile, content, options={})
  #   logger = Resque.logger
  #   logger.info "[SendMobileSmsJob] Send SMS to #{mobile} content [#{content}]"
  #   # Qcloud::SmsGateway::SendIsms.send(mobile, content, options)
  #   SmsApi.send(mobile, content, options) // v1版本的twilio
  # end
end

