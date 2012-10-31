# team = { _id: uuid, name: '途客圈战队', authorId: userId, members: [userId1, userId2, ... ], createdAt: Date()}
Teams = new Meteor.Collection 'teams'

# profile = {_id: uuid, userId: userId, online: true/false, teamId: teamId, lastActive: new Date(), totalSeconds: integer}
Profiles = new Meteor.Collection 'profiles'

# project = { _id: uuid, name: 'cayman', description: 'cayman is a project', authorId: null, parent: null, teamId: teamId, createdAt: Date() }
Projects = new Meteor.Collection 'projects'

# spark = {
# _id: uuid, type: 'idea', authorId: userId, auditTrails: [],
# owners: [userId, ...], finishers: [userId, ...], progress: 10
# title: 'blabla', content: 'blabla', priority: 1, supporters: [userId1, userId2, ...],
# finished: false, projects: [projectId, ...], deadline: Date(), createdAt: Date(),
# updatedAt: Date(), teamId: teamId, points: 16, totalPoints: 64
# }
Sparks = new Meteor.Collection 'sparks'

# auditTrail = { _id: uuid, userId: userId, content: 'bla bla', teamId: teamId, projectId: projectId, sparkId: sparkId, createdAt: Date()}
AuditTrails = new Meteor.Collection 'auditTrails'

# notification = {
# _id: uuid, recipientId: userId, level: 1-5|debug|info|warning|important|urgent
# type: 1-5 | user | spark | project | team | site
# title: 'bla', content: 'html bla', url: 'url', createdAt: new Date(), readAt: new Date(), visitedAt: new Date() }
Notifications = new Meteor.Collection 'notifications'