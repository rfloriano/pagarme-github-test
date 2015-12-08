User = require '../../modules/models/User'
should = require 'should'
request = require 'supertest'
app = require '../index'

describe "User", ->

    beforeEach (done) ->
        User.removeAll(done)

    describe "#getOrCreateByGithub()", ->

        it "should create user if there is no such one", (done) ->

            params =
                id: "github"
                emails: [
                    value: "user@gmail.com"
                ]
                username: "user"

            User.getOrCreateByGithub(params, "1234", (error, user) ->
                should.not.exist(error)

                user.value.githubId.should.eql("github")
                user.value.email.should.eql("user@gmail.com")
                user.value.username.should.eql("user")
                user.value.accessToken.should.eql("1234")

                User.count (error, count) ->
                    count.should.eql(1)
                    done()
            )

        it "should return user if there is one", (done) ->

            params =
                githubId: "github2"
                id: "github2"
                emails: [
                    value: "user2@gmail.com"
                ]
                username: "user2"
                accessToken: "12345"

            (new User params).save (error) ->

                User.getOrCreateByGithub(params, "12345", (error, user) ->
                    user.value.githubId.should.eql("github2")
                    user.value.email.should.eql("user2@gmail.com")
                    user.value.username.should.eql("user2")
                    user.value.accessToken.should.eql("12345")

                    User.count (error, count) ->
                        count.should.eql(1)
                        done()
                )

    describe "RestApi", ->
        it "should get empty users list", (done) ->
            request(app)
                .get('/api/users/')
                .expect('Content-Type', /json/)
                .expect(200)
                .expect([], done)

        it "should get users list", (done) ->
            params =
                githubId: "github"
                email: "user@gmail.com"
                username: "user"
                accessToken: "12345"

            user = new User(params)
            user.save()

            request(app)
                .get('/api/users/')
                .expect('Content-Type', /json/)
                .expect(200)
                .expect((res) ->
                    res.body.should.length(1)
                    res.body[0]._id.should.match(/[\d\w]+/);
                    res.body[0].githubId.should.eql("github")
                    res.body[0].email.should.eql("user@gmail.com")
                    res.body[0].username.should.eql("user")
                    res.body[0].accessToken.should.eql("12345")
                ).end(done)

        it "should get user id", (done) ->
            params =
                githubId: "github"
                email: "user@gmail.com"
                username: "user"
                accessToken: "12345"

            user = new User(params)
            user.save()

            request(app)
                .get('/api/users/' + user.id)
                .expect('Content-Type', /json/)
                .expect(200)
                .expect((res) ->
                    res.body._id.should.match(/[\d\w]+/);
                    res.body.githubId.should.eql("github")
                    res.body.email.should.eql("user@gmail.com")
                    res.body.username.should.eql("user")
                    res.body.accessToken.should.eql("12345")
                ).end(done)

        it "should post a user", (done) ->
            params =
                githubId: "github"
                email: "user@gmail.com"
                username: "user"
                accessToken: "12345"

            request(app)
                .post('/api/users/')
                .set('Content-Type', 'application/json')
                .send(params)
                .expect('Content-Type', /json/)
                .expect(201)
                .expect((res) ->
                    res.body._id.should.match(/[\d\w]+/);
                    res.body.githubId.should.eql("github")
                    res.body.email.should.eql("user@gmail.com")
                    res.body.username.should.eql("user")
                    res.body.accessToken.should.eql("12345")
                ).end(done)

        it "should put a user", (done) ->
            params =
                githubId: "github"
                email: "user@gmail.com"
                username: "user"
                accessToken: "12345"

            user = new User(params)
            user.save()

            request(app)
                .put('/api/users/' + user.id)
                .set('Content-Type', 'application/json')
                .send({githubId: "updatedGithubId"})
                .expect(200)
                .expect((res) ->
                    res.body._id.should.match(/[\d\w]+/);
                    res.body.githubId.should.eql("github")
                    res.body.email.should.eql("user@gmail.com")
                    res.body.username.should.eql("user")
                    res.body.accessToken.should.eql("12345")
                ).end(done)

        it "should delete a user", (done) ->
            params =
                githubId: "github"
                email: "user@gmail.com"
                username: "user"
                accessToken: "12345"

            user = new User(params)
            user.save()

            request(app)
                .delete('/api/users/' + user.id)
                .expect(204, done)
