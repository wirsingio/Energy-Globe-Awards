## Energy Globe Awards App

#### To install assets and run local dev server

```
bundle install  
# install bower globaly  
npm install bower -g  
# install asset dependencies  
bower install  
# run static web server with livereload  
bundle exec middleman  
```

#### To run scraper

Running `./bin/scrape` will

1. scrape the pages
2. cache the requests made
3. save a json file of the results under `./data/awards.json`

### To run the tests

You can run the scraper tests with `ruby spec/award_spec.rb`. For running your Jasmine specs, you can either start your app and go to http://localhost:4567/jasmine or run them directly from the command line:

```bash
rake middleman_jasmine:ci
```

LICENSE: MIT
