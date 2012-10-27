# const definitions
ts = ts || {}
ts.consts = ts.consts || {}

# priority
ts.consts.prio =  ts.consts.prio || {}
ts.consts.prio.VERY_LOW = 1
ts.consts.prio.LOW = 2
ts.consts.prio.MEDIUM = 3
ts.consts.prio.HIGH = 4
ts.consts.prio.VERY_HIGH = 5
ts.consts.prio.dict =
  1: '很闲时再做'
  2: '不急不急'
  3: '请抽空完成'
  4: '越快完成越好'
  5: '请即刻去做'

# expiration
ts.consts.EXPIRE_IN_3_DAYS = 3 * 24 * 3600 * 1000
ts.consts.EXPIRE_IN_1_WEEK = 7 * 24 * 3600 * 1000
ts.consts.EXPIRE_IN_2_WEEKS = 14 * 24 * 3600 * 1000
ts.consts.EXPIRE_INFINITE = 365 * 24 * 3600 * 1000

# filter
ts.consts.filter = ts.consts.filter || {}
ts.consts.filter.FINISHED = {0: '全部', 1: '未完成', 2: '已完成'}
ts.consts.filter.PRIORITY = {1:1, 2:2, 3:3, 4:4, 5:5}
ts.consts.filter.DEADLINE = {0: '全部', 1: '3天内', 2: '一周内', 3: '两周内'}
ts.consts.filter.TYPE = ->
  types = {}
  _.each ts.sparks.types(), (item) ->
    types[item.id] = item.name

  return types

ts.consts.filter.MEMBERS = ->
  members = {}
  _.each ts.members.all().fetch(), (item) ->
    members[item._id] = item.username
  members['all'] = '全部'
  return members

# member points
ts.consts.points = {}
ts.consts.points.CREATE_SPARK = 4
ts.consts.points.FINISH_SPARK = 16
ts.consts.points.COMMENT = 2
ts.consts.points.SUPPORT = 1