# Who Wants to Be a Millionare?

###### Ruby: `3.0.3` Rails: `6.1.4`

### About

[Ruby on Rails](https://rubyonrails.org/) version of the world-famous game [Who Wants to Be a Millionare](https://en.wikipedia.org/wiki/Who_Wants_to_Be_a_Millionaire).

- **15 Questions**
- **15 Difficulty levels**
- **3 Lifelines**
  - 50:50 (Fifty-Fifty)
  - Phone a Friend
  - Ask the Audience
- **3 Guarantee points**
  - 1000
  - 32000
  - 1000000
- **0 Mistakes**

The application is covered with tests using: `RSpec` `Capybara` `factory-bot`

It is possible to recover the password from the account using e-mail.

Users with `admin` status can load questions.

### Usage
1. Clone repo
```
git clone git@github.com:phobco/millionaire-game.git
```

2. Install gems
```
bundle install
```

3. Create database and run migrations (`PostgreSQL` database is used)
```
rails db:create
rails db:migrate
```

4. Load demo questions
```
rails db:seed
```

5. Start server
```
rails s
```

Open `localhost:3000` in a browser.

#### Adding questions

To see admin panel — set `User` attribute `is_admin` to `true`
