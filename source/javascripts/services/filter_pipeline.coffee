
{filter, utils} = wirsing

EGA.service "filterPipeline", ->

  categoryChoices = filter.choices.on 'category'
  yearChoices = filter.choices.on 'year'

  return {
    setCategoryChoices: (filterMap) -> categoryChoices.configure filterMap
    setYearChoices: (filterMap) -> yearChoices.configure filterMap
    filter: utils.chain [categoryChoices, yearChoices]
  }
