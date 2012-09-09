Ports = new Meteor.Collection "ports"
Meteor.subscribe "ports"


Template.main.rendered = ->
  $('body').animate backgroundColor: '#333'
  $('title').text("#{Session.get('port')} | Portfolio") if Session.get('port')

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
        password: CryptoJS.SHA256(t.find('#p-pass').value).toString()
        photos: []
      , -> window.location.href = "/!/#{t.find('#p-title').value}"
      
    

Template.port.events = 
  'submit #password': (e,t) ->
    e.preventDefault()
    
    port = Ports.findOne(title: unescape(Session.get("port")))
    if port.password is CryptoJS.SHA256(t.find('input').value).toString()
      Session.set "authed", true
    else 
      alert "Wrong password!"
    
  'mouseenter .photo': (e,t) ->
    $(e.target).find('.btn').fadeIn(100)
    
  'mouseleave .photo': (e,t) ->
    $(e.target).find('.btn').fadeOut(100)
  
  'click #upload': (e,t) ->
    if Session.get "authed"
      filepicker.getFile 'image/*', multiple: true, persist: true, (uploads) ->
        _.each uploads, (image) ->
          Ports.update(
            {title: unescape(Session.get("port"))},
            {$push: photos: image.url}
          )
    else
      alert "You need to authenticate yourself first!"
        
  'click .delete': (e,t) ->
    if Session.get "authed"
      Ports.update(
        {title: unescape(Session.get("port"))},
        {$pull: photos: $(e.target).parents('.photo').find('img').attr('src')}
      )
    else
      alert "You need to authenticate yourself first!"
    

Template.port.authed = ->
  Session.get "authed"

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