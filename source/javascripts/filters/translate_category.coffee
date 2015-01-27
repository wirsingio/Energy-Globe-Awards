EGA.filter "translateCategory", ->
  translations =
    fire: 'Feuer'
    water: 'Wasser'
    air: 'Luft'
    earth: 'Erde'
    youth: 'Jugend'
    other: 'Andere'

  return (english) -> translations[english]
