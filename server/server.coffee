Ports = new Meteor.Collection "ports"

Meteor.startup ->
  Meteor.publish "ports", ->
    Ports.find()