Ports = new Meteor.Collection "ports"
Meteor.subscribe "ports"


Template.main.rendered = ->
  $('body').animate backgroundColor: '#333'

Template.main.port = ->
  Session.get "port"


Template.form.events = 
  'submit #newPortfolio': (e,t) ->
    e.preventDefault()

    if Ports.find(title: t.find('#p-title').value).count()
      alert "Portfolio already exists!"
    else
      Ports.insert
        name: t.find('#p-name').value
        title: t.find('#p-title').value
        photos: []
      , -> window.location.href = "/!/#{t.find('#p-title').value}"
      
    

Template.port.events = 
  'click #heading button': (e,t) ->
    filepicker.getFile 'image/*', multiple: true, persist: true, (uploads) ->
      _.each uploads, (image) ->
        Ports.update(
          {title: unescape(Session.get("port"))},
          {$push: photos: image.url}
        )
    
    
Template.port.data = ->
  port = Ports.findOne(title: unescape(Session.get("port")))
  port.photos = port.photos.reverse() if port
  port
    

AppRouter = Backbone.Router.extend
  routes:
    "": "main"
    "!/:port": "port"

  main:  ->
    Session.set "port", null
    
  port: (port) ->
    Session.set "port", port

Router = new AppRouter
Meteor.startup ->  
  filepicker.setKey 'ACSqjiD5pQAmoP5oCArRsz'
  Backbone.history.start pushState: true  