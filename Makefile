PROJECT := QRTC.ART

default: usage
usage:
	bin/makefile/usage

d.PHONY: deploy
deploy:
	RAILS_MASTER_KEY=`cat config/master.key` \
		HEROKU_APP_NAME=qrtc-art \
		HEROKU_DOMAIN=qrtc.art \
		bin/makefile/heroku-create
