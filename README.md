# Little Post

Little Post is an email-to-print service for BERG's [Little Printer](http://bergcloud.com/littleprinter/). It allows you to set up an email address that will auto-print any message it receives.

For more about why this exists, see the [blog post](http://www.basilsafwat.com/projects/little-post/).

# Setup

The setup is pretty simple, but there are a few moving parts to put in place. These instructions describe setting up on Heroku, but of course you could host it anywhere.

## 0. You will need

1. Ruby (tested on 1.9.3)
2. [Heroku](https://www.heroku.com/) (if you're installing with these instructions)
3. About 20 minutes

## 1. Get the repo and gems

```bash
$ git clone git://github.com/bsaf/little-post.git
$ cd little-post
$ gem install bundler
$ bundle install
```

## 2. Create a Heroku app

You'll need to have a [Heroku account](https://www.heroku.com/) and to have Heroku installed. Once you've done this, create the server that will push emails to the printer.

```bash
$ heroku create -s cedar YOUR_APP_NAME # e.g. basil-post
$ git push heroku master
```

If you run `heroku open` you should see the app, with a message to set up your environment variables.

## 3. Set the environment variables

The server is protected with basic auth. You'll need to set a username and password first. To do this, run the following commands, substituting the XXX with the values you want.

```bash
$ heroku config:set DASHBOARD_USERNAME=XXX
$ heroku config:set DASHBOARD_PASSWORD=XXX
```

You also need to provide the app with your Little Printer direct print code which you can get [here](http://remote.bergcloud.com/developers/direct_print_codes). Set it with the following command:

```bash
$ heroku config:set LP_DIRECT_PRINT_CODE=XXX
```

## 4. Sign up to Mailgun

Mailgun is going to take our emails and forward them on to this app. They have a free plan which gives you 200 emails a day, which should be more than plenty.

Sign up [here](https://mailgun.net/signup?plan=free).

## 5. Set up a route

Almost there. The final step is to set up a route in Mailgun. A route is a 'rule' that matches incoming mail against a filter and carries out an action against that mail. On your Mailgun dashboard:

- Click 'Routes'
- Click 'Create a new route'
- For the filter expression, enter `catch_all()`
- For actions, enter:

```bash
forward("http://DASHBOARD_USERNAME:DASHBOARD_PASSWORD@YOUR_APP_NAME.herokuapp.com/letterbox")
```

Double check that last one. You need to replace your username and password, and the Heroku URL.

## 5. Try it!

Done! Now send an email to `anything@YOUR_MAILGUN_USERNAME.mailgun.org` and wait for the printer to start blinking.

# Making it nicer

## Set up a 'nice' email address

To make it a bit nicer, you can set up a filter on your normal email address to forward certain emails to your Mailgun address.

For example, if your email address is `myemail@gmail.com` you can filter emails sent to `myemail+printme@gmail.com` to forward to your Mailgun address. This will be easier for you and your friends to remember than the Mailgun address.

# Running the app locally

If you want to run the app locally, rename the `env-example` to `.env` and fill in the values in the file.

To start the server locally, run:

```bash
$ RACK_ENV=development bundle exec foreman start
```
