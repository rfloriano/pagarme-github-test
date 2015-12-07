mongoose = require 'mongoose'

repoSchema = mongoose.Schema(
    name: String
    githubId: String
)

repoSchema.statics.getOrCreateByGithub = (repo, done) ->
    query = githubId: repo.id
    options = upsert: true, "new": true
    sort = {}
    update = $set:
        githubId: repo.id
        name: repo.name
    @collection.findAndModify(query, sort, update, options, done)

module.exports = mongoose.model("repos", repoSchema)
