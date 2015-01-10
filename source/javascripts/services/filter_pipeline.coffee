
{filter, utils} = wirsing

EGA.service "filterPipeline", ->

  categoryChoices = filter.choices.on 'category'
  yearChoices = filter.choices.on 'year'
  countryChoices = filter.choices.on 'country'

  return {
    setCategoryChoices: (filterMap) -> categoryChoices.configure filterMap
    setYearChoices: (filterMap) -> yearChoices.configure filterMap
    setCountryChoices: (filterMap) -> countryChoices.configure filterMap
    filter: utils.chain [categoryChoices, yearChoices, countryChoices]
  }
