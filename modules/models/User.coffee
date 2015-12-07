mongoose = require 'mongoose'

userSchema = mongoose.Schema(
    email: String
    githubId: String
    username: String
    accessToken: String
    registeredAt:
        type: Date
        default: -> new Date
    lastSeenAt: Date
    ips: [String]
    isAdmin: { type: Boolean, default: false }
)

userSchema.statics.getOrCreateByGithub = (profile, accessToken, done) ->
    query = githubId: profile.id
    options = upsert: true, "new": true
    sort = {}
    update = $set:
        githubId: profile.id
        email: profile.emails[0].value
        username: profile.username
        accessToken: accessToken
    @collection.findAndModify(query, sort, update, options, done)

userSchema.statics.removeAll = (done) ->
    @collection.remove {}, {w: 0}, done

module.exports = mongoose.model("users", userSchema)
