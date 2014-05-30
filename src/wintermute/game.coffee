Family = require "./family"
_ = require "lodash"

class Game
  constructor: (options = {}) ->
    @container = options.container
    @_families = {}
    @_systems = []
    @_entities = []

  addEntity: (entity) ->
    for family in @_families
      family.addEntityIfMatches entity

    entity.onComponentAdded.add (entity, component) =>
      @onComponentAdded entity, component

    entity.onComponentRemoved.add (entity, component) =>
      @onComponentRemoved entity, component

    @_entities.push entity

  removeEntity: (entity) ->
    for id, family of @_families
      family.removeEntity entity

    @_entities = _.without @_entities, entity
    @_entities.length

  getEntities: (componentNames) ->
    familyId = "$#{componentNames.join(",")}"
    unless @_families[familyId]
      @_families[familyId] = new Family componentNames

      for entity in @_entities
        @_families[familyId].addEntityIfMatches entity

    @_families[familyId].getEntities()

  addSystem: (system) ->
    system.game = this
    @_systems.push system

  removeSystem: (system) ->
    system.game = null
    @_systems = _.without @_systems, system
    @_systems.length

  update: (delta) ->
    for system in @_systems
      system.update delta

  onComponentAdded: (entity, componentName) ->
    for id, family of @_families
      family.onComponentAdded entity, componentName

  onComponentRemoved: (entity, componentName) ->
    for id, family of @_families
      family.onComponentRemoved entity, componentName

module.exports = Game
