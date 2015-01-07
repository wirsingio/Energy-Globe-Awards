describe 'AwardsController', ->
  beforeEach module('ega')

  randomName = -> Math.random().toString(36).replace(/[^a-z]+/g, '')

  beforeEach inject ($injector) ->
    @httpBackend = $injector.get('$httpBackend')
    @controller = $injector.get('$controller')
    @scope = $injector.get('$rootScope').$new()

  it 'fetches the awards data initially', ->
    awards = [{myaward: randomName()}]
    @httpBackend
      .when 'GET', 'data/awards.json'
      .respond awards

    @controller 'AwardsController', $scope: @scope
    @httpBackend.flush()

    expect(@scope.awards).toEqual awards
