Signal = require "./signal"

class Entity
  constructor: (options = {}) ->
    @_components = {}
    @onComponentAdded = new Signal()
    @onComponentRemoved = new Signal()

  hasComponent: (componentName) ->
    @getComponent(componentName) != undefined

  getComponent: (componentName) ->
    @_components["$#{componentName}"]

  addComponent: (component) ->
    @_components["$#{component.name}"] = component
    @onComponentAdded.emit component.name

  removeComponent: (componentName) ->
    @_components["$#{componentName}"] = undefined
    @onComponentRemoved.emit componentName

module.exports = Entity
