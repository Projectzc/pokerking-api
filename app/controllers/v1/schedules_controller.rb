module V1
  class SchedulesController < ApplicationController
    def index
      requires! :date
      @event = MainEvent.find(params[:main_event_id])
      date = params[:date].to_date
      @schedules = @event.event_schedules.where(begin_time: date..date.end_of_day)
    end

    def dates
      @event = MainEvent.find(params[:main_event_id])
      @dates = @event.event_schedules.group("DATE_FORMAT(begin_time, '%Y-%m-%d')").map { |e| e.begin_time.to_date.to_s }
    end
  end
end
