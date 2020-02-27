module V1
  class HomepageBannersController < ApplicationController
    def index
      @banners = HomepageBanner.position_desc.limit(20)
    end
  end
end
