mongoose = require 'mongoose'
sinon = require 'sinon'
Log = require "../modules/Log"
config = require '../config'
app = require '../server'

app.listen(config.port, ->
    Log.info "Listening on #{config.port}..."
)

clock = null

before ->
    connectionString = process.env.CONNECTION_STRING or "mongodb://localhost/pagarme-github-test-test"
    mongoose.connect connectionString
    clock = sinon.useFakeTimers()

after ->
    mongoose.connection.close()
    clock.restore()

module.exports = app
