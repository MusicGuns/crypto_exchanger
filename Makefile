%:
	@:

test_alias=test t
t:
	make test
test:
	docker-compose run --rm app bundle exec rspec $(filter-out $(test_alias), $(MAKECMDGOALS))

c:
	make console
console:
	docker-compose run --rm app bundle exec rails c

ac:
	make assets_percompile
assets_percompile:
	docker-compose run --rm app bundle exec rake assets:precompile

b:
	make bash
bash:
	docker-compose run --rm app bash

a:
	make attach
attach:
	docker attach bitcoin_wallet_web-app-1

r:
	make restart
restart:
	docker restart bitcoin_wallet_web-app-1

s:
	make start
start:
	docker-compose up -d

deploy:
	git pull
	docker build -t crypto-exchanger .
	docker stack deploy -c docker-compose.prod.yml crypto-exchanger_prod

start_production:
	bundle exec rails assets:precompile
	bundle exec rails db:create || true
	bundle exec rails db:migrate
	bundle exec rails s -p 3000 -b 0.0.0.0
