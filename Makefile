PROJECT := QRTC.ART

default: usage
usage:
	bin/makefile/usage

prettier:
	bundle exec rubocop -A

build:
	bundle
	RAILS_ENV=test bin/rails db:drop db:create db:migrate
	bundle exec rubocop .
	bundle exec rspec spec

d.PHONY: deploy
deploy:
	RAILS_MASTER_KEY=`cat config/master.key` \
		HEROKU_APP_NAME=qrtc-art \
		HEROKU_DOMAIN=qrtc.art \
		bin/makefile/heroku-create
