
{choices} = wirsing.filter
{chain} = wirsing.utils

EGA.service "filterPipeline", ->

  categoryChoices = choices.on 'category'
  yearChoices = choices.on 'year'

  return {
    setCategoryChoices: (filterMap) -> categoryChoices.configure filterMap
    setYearChoices: (filterMap) -> yearChoices.configure filterMap
    filter: chain [categoryChoices, yearChoices]
  }
