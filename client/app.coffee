Ports = new Meteor.Collection "ports"
Meteor.subscribe "ports"


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
        color: t.find('button.active').innerText
      , -> window.location.href = "/ !/#{t.find('#p-title').value}"
      
    
    
    
Template.port.title = ->
  unescape Session.get "port"  
   
   
    

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
  Backbone.history.start pushState: true  