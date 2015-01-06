
{choices, chain} = wirsing.filter

EGA.service "filterPipeline", ->

  categoryChoices = choices.on 'category'
  yearChoices = choices.on 'year'

  return {
    setCategoryChoices: (filterMap) -> categoryChoices.apply filterMap
    setYearChoices: (filterMap) -> yearChoices.apply filterMap
    filter: chain [categoryChoices, yearChoices]
  }
