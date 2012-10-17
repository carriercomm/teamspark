# spark = {
# _id: uuid, type: 'idea', authorId: userId, auditTrails: [],
# currentOwnerId: userId, nextStep: 1, owners: [userId, ...], progress: 10
# title: 'blabla', content: 'blabla', priority: 1, supporters: [userId1, userId2, ...],
# finished: false, projects: [projectId, ...], deadline: Date(), createdAt: Date(),
# updatedAt: Date(), teamId: teamId
# }

_.extend Template.sparks,
  sparks: ->
    project = ts.State.filterSelected.get()
    order = ts.State.sparkOrder.get()
    type = ts.State.sparkTypeFilter.get()
    priority = ts.State.sparkPriorityFilter.get()
    author = ts.State.sparkAuthorFilter.get()
    owner = ts.State.sparkOwnerFilter.get()
    progress = ts.State.sparkProgressFilter.get()

    query = []

    if project isnt 'all'
      query.push projects: project

    if type isnt 'all'
      query.push type: type

    if priority isnt 'all'
      query.push priority: priority

    if author isnt 'all'
      query.push authorId: author

    if owner isnt 'all'
      query.push currentOwnerId: owner

    if progress isnt 'all'
      query.push progress: progress

    if order is 'createdAt'
      Sparks.find {$and: query}, {sort: createdAt: -1}
    else
      Sparks.find {$and: query}, {sort: updatedAt: -1}

_.extend Template.sparkFilter,
  events:
    'click .spark-list > li': (e) ->
      $node = $(e.currentTarget)
      id = $node.data('id')
      name = $node.data('name')

      ts.State.sparkToCreate.set {id: id, name: name}

      usernames = _.pluck ts.members().fetch(), 'username'
      $node = $('#spark-owner')
      $node.select2
        tags: usernames

        placeholder:'添加责任人'
        tokenSeparators: [' ']
        separator:';'

      $node = $('#spark-deadline')
      if not $node.data('done')
        $node.data('done', 'done')
        $node.datepicker({format: 'yyyy-mm-dd'}).on 'changeDate', (ev) -> $node.datepicker('hide')
      $('#add-spark').modal()

    'click #filter-spark-author > li': (e) ->
      $node = $(e.currentTarget)
      id = $node.data('id')
      name = $node.data('name')

      if id == ''
        ts.State.sparkAuthorFilter.set {id: 'all', name: 'all'}
      else
        ts.State.sparkAuthorFilter.set {id: id, name: name}

    'click #filter-spark-owner > li': (e) ->
      $node = $(e.currentTarget)
      id = $node.data('id')
      name = $node.data('name')

      if id == ''
        ts.State.sparkOwnerFilter.set {id: 'all', name: 'all'}
      else
        ts.State.sparkOwnerFilter.set {id: id, name: name}

    'click #filter-spark-type > li': (e) ->
      $node = $(e.currentTarget)
      id = $node.data('id')
      name = $node.data('name')

      if id == ''
        ts.State.sparkTypeFilter.set {id: 'all', name: 'all'}
      else
        ts.State.sparkTypeFilter.set {id: id, name: name}

  types: -> ts.sparks.types()


  isAuthorSelected: (id='all') ->
    if ts.State.sparkAuthorFilter.get() is id
      return 'icon-ok'
    return ''

  isOwnerSelected: (id='all') ->
    if ts.State.sparkOwnerFilter.get() is id
      return 'icon-ok'
    return ''

  isTypeSelected: (id='all') ->
    if ts.State.sparkTypeFilter.get() is id
      return 'icon-ok'
    return ''

_.extend Template.sparkInput,
  events:
    'click #add-spark-cancel': (e) ->
      $('#add-spark form')[0].reset()
      $('#add-spark').modal 'hide'

    'click #add-spark-submit': (e) ->
      $form = $('#add-spark form')
      $title = $('input[name="title"]', $form)
      title = $.trim($title.val())
      content = $('textarea[name="content"]', $form).val()
      priority = parseInt $('select[name="priority"]').val()
      type = ts.State.sparkToCreate.get()
      if ts.filteringProject()
        project = ts.State.filterSelected.get()
      else
        project = $('select[name="project"]', $form).val()

      owners = Meteor.users.find teamId: ts.State.teamId.get(), username: $in: $('input[name="owner"]', $form).val().split(';')
      owners = _.map owners.fetch(), (item) -> item._id

      deadlineStr = $('input[name="deadline"]', $form).val()


      console.log "name: #{name}, desc: #{content}, priority: #{priority}, type: #{type}, project: #{project}, owners:", owners, deadlineStr

      if not title
        $title.parent().addClass 'error'
        return null

      Meteor.call 'createSpark', title, content, type, project, owners, priority, deadlineStr, (error, result) ->
        $('.control-group', $form).removeClass 'error'
        $form[0].reset()
        $('#add-spark').modal 'hide'

  projects: -> Projects.find()

_.extend Template.spark,
# spark = {
  # _id: uuid, type: 'idea', authorId: userId, auditTrails: [],
  # currentOwnerId: userId, nextStep: 1, owners: [userId, ...], progress: 10
  # title: 'blabla', content: 'blabla', priority: 1, supporters: [userId1, userId2, ...],
  # finished: false, projects: [projectId, ...], deadline: Date(), createdAt: Date(),
  # updatedAt: Date(), teamId: teamId
  # }
  author: ->
    Meteor.users.findOne @authorId

  created: ->
    moment(@createdAt).fromNow()

  updated: ->
    moment(@updatedAt).fromNow()

  expired: ->
    moment(@deadline).fromNow()

  typeObj: ->
    obj = ts.sparks.type(@)

  activity: ->
    return @title

  project: ->
    if @projects?.length
      return Projects.findOne @projects[0]
    else
      return null

  currentOwner: ->
    if @currentOwnerId
      Meteor.users.findOne @currentOwnerId
    else
      return null

  nextOwner: ->
    if @currentOwnerId and @owners.length - 1 > @nextStep
      Meteor.users.findOne @owners[@nextStep]
    else
      return null

  supporttedUsers: ->
    Meteor.users.find _id: $in: @supporters

  urgentStyle: ->
    if ts.sparks.isUrgent(@)
      return 'urgent'
    return ''

  importantStyle: ->
    if ts.sparks.isImportant @
      return 'important'
    return ''

  info: ->
    typeObj = ts.sparks.type @
    text = [typeObj.name]
    if ts.sparks.isUrgent @
      text.push '紧急(3日内到期)'

    if ts.sparks.isImportant @
      text.push '重要(优先级4及以上)'

    if text.length == 1
      text.push '正常'

    return text.join(' | ')