# Speakerboxxx...

This let's you route your company's GitHub notifications in a smart way.

## Usage

### Installing

<a href="https://speakerboxxx.atmos.org/auth/slack"><img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcset="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" /></a>

### Chat Enabling and Routing

![](https://cloud.githubusercontent.com/assets/38/16897583/88b45282-4b6a-11e6-9e3a-6a09d8ea69e0.png)

## Testing


```console
$ bin/setup
$ bin/cibuild
```

### Deploying your own to Heroku

* [Create a GitHub OAuth app](https://github.com/settings/applications/new)
* [Create a Slack app](https://api.slack.com/apps/new)
* [Create this app on Heroku](https://heroku.com/deploy?template=https://github.com/atmos/speakerboxxx)
* heroku plugins:install heroku-redis
* heroku redis:promote HEROKU_REDIS_SOMECOLOR -a heroku-app-you-created
