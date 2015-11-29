Dreamhost is disallowing sudo for their VPSs soon ☹

http://wiki.dreamhost.com/How_to_manage_your_VPS_without_an_admin_user

Which means when mongo crashes the VPS again (and it will) I'm not sure how I'm going to restart it. When it crashes it leaves behind a lock file you need sudo to remove. It won't restart until you clear the lock file...

Anyway, seems like a quick and dirty verison using sqlite and mojo lite could work short term if need be.

It's too bad, I liked the nodejs + mongo tharn.org...

Replaces https://github.com/sethaj/tharn.org
