### Developing on a local server

* create local deploy using fab script.
* Send some certs there.
* Local server will be at 127.0.0.1:80 and 127.0.0.1:443


### Email sending

Reddit runs the job for sending emails as a cron daemon.
You can see it by doing:

    grep email /etc/crond.d/reddit

AFAIU this job picks up all unsent emails from a queue (I assume in rabbitmq,
but I have not checked) and consumes them and sends.

For now, we don't have a good setup for sending email from the
reddit.internal.urbancompass.com box. (actually the box has postfix installed
and configured to only send email internally, so that there is no outgoing
email by mistake).

For this reason, the email sender is currently configured ( `UC_SEND_EMAILS`
config param in run.ini) to NOT send emails but just write them out to
`/var/log/syslog`


### How to be an admin

Admins are explicitly listed in the run.ini file, hence you should add your
name to the `r2/*.update` config files, run `make.ini` and restart in order to
be an admin.


### How to add config parameters

* for string config params, just add them straight in the .update files (or
  even in example .ini if you like, I'm avoiding touching it for now).
* if you want a typed config param, add it in `app_globals.py` in the right
  place.


### Known hacks that we may not want to correct.

* (ugo) Reddit-gold - There seems to be a bug related to displaying some
  reddit-gold info in new users pages. This seems to "interact" with the
  (relatively) new feature of having an "employee" property for users, so I
  have hacked it away.

* (ugo) Admins otp - I turned this off since I have no idea of where I should
  get an otp token from. I feel we would not want it.


### Known open issues

* (ugo) Local setup
  The local setup is not really working at this time. I have to provide full
  instructions.

* (ugo) Employee - how do I mark a user as "employee"?

* (ugo) Internal UI - we do not report errors correctly in the forms on
  `.../internal/reddit/reddit_controls`

* (ugo) Images - when posting images, the resulting post downloads the image on
  click.

* (ugo) Database cleanup and backup - how do we copy data from one machine to
  another, and how do we wipe databases?
