class SmsApi
  class << self
    def send(mobile, msg, options = {})
      country_code = options[:country_code].presence || '86'
      str_mobile = "+#{country_code}#{mobile}" # 带区号带手机号

      client = Twilio::REST::Client.new(ENV['SMS_ACCOUNT_SID'], ENV['SMS_AUTH_TOKEN'])

      result = client.messages.create(
          from: ENV['SMS_FROM'],
          to: str_mobile,
          body: msg
      )
      Rails.logger.info "SmsApi: result: #{result}"
    end
  end
end