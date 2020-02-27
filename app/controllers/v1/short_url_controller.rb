module V1
  class ShortUrlController < ApplicationController
    before_action :set_dwz
    def create
      requires! :url
      @url = @dwz.create(params[:url])
      # 将请求生成的短网址存到redis
    end

    def restore
      requires! :url
      @url = @dwz.query(params[:url])
      render :create
    end

    private

    def set_dwz
      @dwz =  Dwz.new
    end
  end
end
