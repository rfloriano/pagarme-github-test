Repos = require '../../modules/models/Repos'
should = require 'should'
request = require 'supertest'
app = require '../index'

describe "Repos", ->

    beforeEach (done) ->
        Repos.removeAll(done)

    describe "#getOrCreateByGithub()", ->

        it "should create repo if there is no such one", (done) ->

            params =
                id: "repoId"
                name: "repoName"

            Repos.getOrCreateByGithub(params, (error, repo) ->
                should.not.exist(error)

                repo.value.githubId.should.eql("repoId")
                repo.value.name.should.eql("repoName")

                Repos.count (error, count) ->
                    count.should.eql(1)
                    done()
            )

        it "should return repo if there is one", (done) ->

            params =
                id: "repoId"
                githubId: "repoId"
                name: "repoName"

            (new Repos params).save (error) ->

                Repos.getOrCreateByGithub(params, (error, repo) ->
                    repo.value.githubId.should.eql("repoId")
                    repo.value.name.should.eql("repoName")

                    Repos.count (error, count) ->
                        count.should.eql(1)
                        done()
                )


    describe "RestApi", ->
        it "should get empty repos list", (done) ->
            request(app)
                .get('/api/repos/')
                .expect('Content-Type', /json/)
                .expect(200)
                .expect([], done)

        it "should get repos list", (done) ->
            params =
                githubId: "repoId"
                name: "repoName"

            repo = new Repos(params)
            repo.save()

            request(app)
                .get('/api/repos/')
                .expect('Content-Type', /json/)
                .expect(200)
                .expect((res) ->
                    res.body.should.length(1)
                    res.body[0]._id.should.match(/[\d\w]+/);
                    res.body[0].githubId.should.eql("repoId")
                    res.body[0].name.should.eql("repoName")
                ).end(done)

        it "should get repo id", (done) ->
            params =
                githubId: "repoId"
                name: "repoName"

            repo = new Repos(params)
            repo.save()

            request(app)
                .get('/api/repos/' + repo.id)
                .expect('Content-Type', /json/)
                .expect(200)
                .expect((res) ->
                    res.body._id.should.match(/[\d\w]+/);
                    res.body.githubId.should.eql("repoId")
                    res.body.name.should.eql("repoName")
                ).end(done)

        it "should post a repo", (done) ->
            params =
                githubId: "repoId"
                name: "repoName"

            request(app)
                .post('/api/repos/')
                .set('Content-Type', 'application/json')
                .send(params)
                .expect('Content-Type', /json/)
                .expect(201)
                .expect((res) ->
                    res.body._id.should.match(/[\d\w]+/);
                    res.body.githubId.should.eql("repoId")
                    res.body.name.should.eql("repoName")
                ).end(done)

        it "should put a repo", (done) ->
            params =
                githubId: "repoId"
                name: "repoName"

            repo = new Repos(params)
            repo.save()

            request(app)
                .put('/api/repos/' + repo.id)
                .set('Content-Type', 'application/json')
                .send({githubId: "updatedGithubId"})
                .expect(200)
                .expect((res) ->
                    res.body._id.should.match(/[\d\w]+/);
                    res.body.githubId.should.eql("repoId")
                    res.body.name.should.eql("repoName")
                ).end(done)

        it "should delete a repo", (done) ->
            params =
                githubId: "repoId"
                name: "repoName"

            repo = new Repos(params)
            repo.save()

            request(app)
                .delete('/api/repos/' + repo.id)
                .expect(204, done)
