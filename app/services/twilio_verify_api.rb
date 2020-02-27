class TwilioVerifyApi
  def initialize
    @client = Twilio::REST::Client.new(ENV['SMS_ACCOUNT_SID'], ENV['SMS_AUTH_TOKEN'])
  end

  def start_verification(mobile, country_code, channel='sms')
    puts "start_verification: coming #{Time.now}"
    channel = 'sms' unless ['sms', 'voice'].include? channel
    to = str_mobile(mobile, country_code)
    verification = @client.verify.services(ENV['VERIFICATION_SID'])
                       .verifications
                       .create(:to => to, :channel => channel)
    verification.sid
  end

  def check_verification(to, code)
    puts "check_verification, #{to}, #{code}"
    begin
      verification_check = @client.verify.services(ENV['VERIFICATION_SID'])
                               .verification_checks
                               .create(:to => to, :code => code)
    rescue => err
      puts err
      return false
    end
    verification_check.status == 'approved'
  end

  def str_mobile(mobile, country_code)
    country_code_new = country_code.presence || '86'
    "+#{country_code_new}#{mobile}"
  end
end
