passport = require 'passport'
User = require './models/User'
GitHubStrategy = require("passport-github2")
config = require "../config"

passport.serializeUser (user, done) ->
    done(null, user?.value?.github?.toString())

passport.deserializeUser (id, done) ->
    done(null, new User _id: id)

guard = (req, res, next) ->
    if req.isAuthenticated()
        next()
    else
        res.statusCode = 403
        res.end()

module.exports = class Security

    @for: (expressApp) ->
        @app = expressApp

        @app.use(passport.initialize())
        @app.use(passport.session())

        passport.use new GitHubStrategy(
            clientID: config.githubAppId
            clientSecret: config.githubAppSecret
            callbackURL: config.githubAppRedirect,
            (accessToken, refreshToken, profile, done) ->
                User.getOrCreateByGithub(profile, accessToken, done)
                expressApp.github.authenticate({
                    type: "oauth",
                    token: accessToken
                })
        )

        authenticate = passport.authenticate("github",
            successRedirect: '/app'
            failureRedirect: '/'
            scope: ['user']
        )

        @app.get("/login/github", authenticate)

        @app.get(config.githubRedirectRoute, passport.authenticate("github"), (req, res) ->
            res.redirect("/app")
        )

        @app.get("/logout", (req, res) ->
            req.logout()
            res.redirect("/")
        )

    @protect: (path) ->
        @app.all(path, guard)
