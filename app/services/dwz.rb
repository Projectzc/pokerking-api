class Dwz
  def initialize
    @conn = Faraday.new(
        url: 'https://dwz.cn',
        headers: { 'Content-Type' => 'application/json', 'Token' => ENV['DWZ_TOKEN'] }
    )
  end

  # long-term， 1-year
  def create(url, expire_time = '1-year')
    resp = @conn.post('/admin/v2/create') do |req|
      req.body = { Url: url, TermOfValidity: expire_time }.to_json
    end
    result = JSON.parse resp.body
    return raise_api_error(result['ErrMsg']) unless result['Code'].eql?(0)
    result
  end

  def query(short_url)
    resp = @conn.post('/admin/v2/query') do |req|
      req.body = { shortUrl: short_url }.to_json
    end
    result = JSON.parse resp.body
    return raise_api_error(result['ErrMsg']) unless result['Code'].eql?(0)
    result
  end

  def raise_api_error(msg)
    raise ApplicationController::CommonError, msg
  end
end