restful = require "node-restful"
GitHubApi = require "github"
User = require "../models/User"
Log = require "../Log"
models = require "../models"
config = require "../../config"


class Handler
    constructor: (app)->
        @github = new GitHubApi(
            version: "3.0.0",
            debug: true,
            protocol: "https",
            host: "api.github.com",
            pathPrefix: "/api/v3",
            timeout: 5000,
            pathPrefix: '',
            headers: {
                "user-agent": "My-Cool-GitHub-App"
            }
        )

        app.github = @github

        app.get("/", (req, res) ->
            if req.isAuthenticated()
                res.redirect("/app")
            else
                res.render("landing")
        )

        app.get("/app", (req, res) ->
            app.github.repos.getAll({}, (err, data) ->
                if err
                    res.send(err)
                    res.end()
                    return
                for repository in data
                    models.repos.getOrCreateByGithub(repository)
                res.redirect("/api/repos/")
            )
        )

        for name, model of models
            schema = model.model(name).schema
            rest = restful.model(name, schema).methods(['get', 'post', 'put', 'delete'])
            rest.register(app, "/api/#{name}");

module.exports = Handler
