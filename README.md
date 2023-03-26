# Развертывание c Docker
---
1. Setup .env:
>__.env__
>```
>PRIVATE_KEY = ...
>
>```

2.
```
docker-compose up
```

# Развертывание без Docker
---

1. Setup .env:
>__.env__
>```
>PRIVATE_KEY = ...
>
>```

2. Bundle
```
bundle install
```
3. Create database.
```
bundle exec rails db:create
```
4. Run database migrations.
```
bundle exec rails db:migrate
```
5. Start rails server.
```
bundle exec rails s
```
