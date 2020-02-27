module V1
  class EventInfosController < ApplicationController
    def show
      @info = Info.find(params[:id])
    end

    def index
      @main_event = MainEvent.find(params[:main_event_id])
      @infos = @main_event.infos.published.page(params[:page]).per(10)
    end
  end
end
