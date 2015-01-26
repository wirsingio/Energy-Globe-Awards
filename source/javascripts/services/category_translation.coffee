EGA.service "categoryTranslation", ->
  translations =
    fire: 'Feuer'
    water: 'Wasser'
    air: 'Luft'
    earth: 'Erde'
    youth: 'Jugend'
    other: 'Andere'

  return {
    translate: (english) -> translations[english]
  }
