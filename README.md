# Speakerboxxx...

This let's you route your company's GitHub notifications in a smart way.

## Usage

### Enabling

![](https://cloud.githubusercontent.com/assets/38/16291814/d3bf8e76-38bf-11e6-87a7-770d907a96a6.png)

### Routing

![](https://cloud.githubusercontent.com/assets/38/16548170/27031d54-413b-11e6-9045-aced244f7a29.png)

## Testing


```console
$ bin/setup
$ bin/cibuild
```

## Installing

# Speakerboxxx <a href="https://speakerboxxx.atmos.org/auth/slack"><img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcset="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" /></a>

### Deploying your own to Heroku

* [Create a GitHub OAuth app](https://github.com/settings/applications/new)
* [Create a Slack app](https://api.slack.com/apps/new)
* [Create this app on Heroku](https://heroku.com/deploy?template=https://github.com/atmos/speakerboxxx)
* heroku plugins:install heroku-redis
* heroku redis:promote HEROKU_REDIS_SOMECOLOR -a heroku-app-you-created
