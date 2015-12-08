express = require 'express'
require "express-resource"
config = require './config'
Security = require "./modules/Security"
Handler = require "./modules/handlers"
passport = require "passport"

app = express()

app.set("view engine", "jade")
app.set("views", __dirname + "/views")

app.use(express.bodyParser())
app.use(express.cookieParser(config.sessionSecret))
app.use(express.cookieSession())

app.use("/", express.static __dirname + "/build/lib")
app.use("/img", express.static __dirname + "/build/lib")
app.use("/fonts", express.static __dirname + "/build/lib")
app.use("/", express.static __dirname + "/build")
app.use("/", express.static __dirname + "/public/images")

Security.for(app)
new Handler(app)

module.exports = app
