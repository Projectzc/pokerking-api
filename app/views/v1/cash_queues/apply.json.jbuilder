# meta info
json.partial! 'common/meta'

json.code     '0000'
json.msg      '报名成功'

json.data do
  json.id                @queue_member.id
  json.nickname          @queue_member.nickname
  json.index             @queue_member.get_index
  json.confirmed         @queue_member.confirmed
  json.created_at        @queue_member.created_at.to_i
end

