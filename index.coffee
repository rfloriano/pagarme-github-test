express = require 'express'
mongoose = require 'mongoose'
require "express-resource"
config = require './config'
Security = require "./modules/Security"
Log = require "./modules/Log"
Handler = require "./modules/handlers"
passport = require "passport"

mongoose.connect(config.mongoUrl, (error) ->
    Log.error(error) if error
    Log.info("Mongoose connected to #{config.mongoUrl}.") unless error
)

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

app.listen(config.port, ->
    Log.info "Listening on #{config.port}..."
)
