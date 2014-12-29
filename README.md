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

if you haven't bundled  
`bundle install`  
then  
`./bin/scrape`

this will

1. scrape the pages
2. cache the requests made
3. save a json file of the results under `./data/awards.json`

### To run the scraper tests

if you haven't bundled  
`bundle install`  
then  
`ruby spec/award_spec.rb`

### OSS Projects Used

- [bootstrap combobox](https://github.com/danielfarrell/bootstrap-combobox)
- [unUISlider](https://github.com/leongersen/noUiSlider)
- [middleman](middlemanapp.com)

LICENSE: MIT
