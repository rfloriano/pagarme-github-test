module.exports =

    mongoUrl: process.env.MONGO_URL or "mongodb://localhost/pagarme-github-test"
    sessionSecret: process.env.SESSION_SECRET or "9a205fba94b140e59456d3a5128075bd"
    port: process.env.PORT or 3000

    githubAppId: process.env.GITHUB_APP_ID or "9e0a6ba06413b22eea38"
    githubAppSecret: process.env.GITHUB_APP_SECRET or "580bca105f63c8173cfa72832c99f7d96a832662"
    githubRedirectRoute: "/login/github/callback"
    githubAppRedirect: process.env.GITHUB_APP_REDIRECT or "http://local.pagarme-github-test.com:3000/login/github/callback"
