describe 'module', ->
  it 'creates the module object', ->
    wirsing.module 'mymodule'
    expect(wirsing.mymodule).toEqual {}

    delete wirsing.mymodule

  it 'creates nested module objects', ->
    wirsing.module 'my.module'
    expect(wirsing.my).toEqual {module: {}}

    delete wirsing.my

  it "doesn't overwrite existing modules", ->
    wirsing.module 'importantStuff'
    wirsing.importantStuff.something = {}

    wirsing.module 'importantStuff'

    expect wirsing.importantStuff.something
      .toEqual {}

    delete wirsing.importantStuff

  it 'defines properties of the module', ->
    wirsing.module 'mymodule',
      name: 'rabbit'

    expect wirsing.mymodule.name
      .toEqual 'rabbit'

    delete wirsing.mymodule
