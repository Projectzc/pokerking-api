module V1
  class MainEventsController < ApplicationController
    def show
      @event = MainEvent.find(params[:id])
    end

    def index
      optional! :fetch_type, values: %w[future bygone], default: 'future'
      requires! :event_id
      current_event = MainEvent.find(params[:event_id])
      @events = MainEvent.published.limit(10)
                  .yield_self { |it| future_or_bygone_query(it, current_event) }
    end

    def future_or_bygone_query(it, event)
      if params[:fetch_type] == 'future'
        it.where('begin_time >= ?', event.begin_time).where.not(id: event.id).position_desc.begin_asc
      else
        # 将搜索出的数据，变回正序
        it.where('begin_time <= ?', event.begin_time).where.not(id: event.id).begin_desc.reverse
      end
    end

    def recent_events
      # 找到还未结束主赛 或者 找到开始时间距离最近的主赛
      @recent_event = MainEvent.published.where('end_time >= ?', Time.current).begin_asc.first || MainEvent.published.begin_desc.first
      future_events = MainEvent.published.where('position <= ?', @recent_event.position)
                        .where.not(id: @recent_event.id).position_desc.limit(20)
      # 将搜索出的数据，变回正序
      bygone_events = MainEvent.published.where('position >= ?', @recent_event.position)
                        .where.not(id: @recent_event.id).position_asc.limit(20).reverse
      @events = bygone_events + [ @recent_event ] + future_events
    end
  end
end
