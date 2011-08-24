#!/usr/bin/env shell
dotcloud run microdata.www -- "cd ~/current && rake db:migrate posts:reload lsd:relink_packages && rm -r ~/current/public/javascripts/jsus/*"