Template.form.events = 
  'submit #newPortfolio': (e,t) ->
    e.preventDefault()



AppRouter = Backbone.Router.extend
  routes:
    "": "main"

  main:  ->
    console.log 'loaded main'

Router = new AppRouter
Meteor.startup ->  
  Backbone.history.start pushState: true  