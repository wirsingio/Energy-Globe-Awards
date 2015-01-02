describe 'AwardsController', ->
  beforeEach module('ega')

  randomName = ->
    Math.random().toString(36).replace(/[^a-z]+/g, '')

  beforeEach inject ($injector) ->
    @httpBackend = $injector.get('$httpBackend')
    @controller = $injector.get('$controller')

  it 'fetches the awards data initially', ->
    awards = [{myaward: randomName()}]
    @httpBackend
      .when 'GET', 'data/awards.json'
      .respond awards
    scope = {}

    @controller 'AwardsController', $scope: scope
    @httpBackend.flush()

    expect(scope.awards).toEqual awards

    @httpBackend.verifyNoOutstandingExpectation()
    @httpBackend.verifyNoOutstandingRequest()

