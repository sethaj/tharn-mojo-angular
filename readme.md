What is this thing?
-------------------

A silly site I made for fun. Makes a ~~ugly~~  _awesome_ collages of images based on a word.

Since 2013 it's collected over 1,000,000 images, thumbnails and metadata over time.


Why is this thing?
------------------

Hard question. We'll see. Short answer: it replaces https://github.com/sethaj/tharn.org

Dreamhost is disallowing sudo for their VPSs soon ☹

http://wiki.dreamhost.com/How_to_manage_your_VPS_without_an_admin_user

Which means when mongo crashes the VPS again (and it will) I'm not sure how I'm going to restart it. When it crashes it leaves behind a lock file you need sudo to remove. It won't restart until you clear the lock file...

Anyway, seems like a quick and dirty verison using sqlite and mojolicious lite and angular.js could work short term if need be.

It's too bad, I liked the nodejs + mongo tharn.org...


Install
-------

* You need a word database and images. Not included in this repo.
* Install [perlbrew](http://perlbrew.pl/) or [plenv](https://github.com/tokuhirom/plenv)

    `cpanm --installdeps .`

    `./server.sh`
