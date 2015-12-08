mongoose = require 'mongoose'
config = require './config'
app = require './server'
Log = require "./modules/Log"

mongoose.connect(config.mongoUrl, (error) ->
    Log.error(error) if error
    Log.info("Mongoose connected to #{config.mongoUrl}.") unless error
)

app.listen(config.port, ->
    Log.info "Listening on #{config.port}..."
)
