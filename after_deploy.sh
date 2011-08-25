#!/usr/bin/env shell
dotcloud run microdata.www -- "cd ~/current && rake lsd:relink_packages && rm -rf ~/current/public/javascripts/jsus/*"
#  db:migrate posts:reload