
{filter, utils} = wirsing

EGA.service "filterPipeline", ->

  categoryChoices = filter.choices.on 'category'
  yearChoices = filter.choices.on 'year'
  countryChoices = filter.choices.on 'country'
  search = filter.search in: 'title'

  return {
    setCategoryChoices: (filterMap) -> categoryChoices.configure filterMap
    setYearChoices: (filterMap) -> yearChoices.configure filterMap
    setCountryChoices: (filterMap) -> countryChoices.configure filterMap
    setSearchTerm: (input) -> search.configure term: input
    filter: utils.chain [categoryChoices, yearChoices, countryChoices, search]
  }
