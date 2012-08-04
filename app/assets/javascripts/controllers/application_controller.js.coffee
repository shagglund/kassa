class Kaljakassa.ApplicationController extends Batman.Controller

  # Add filters or functions you would like all your controllers to inherit to this controller.
  @beforeFilter {}, 'authenticateUser'

  signOut: () ->
    unset('current_user') if @get('current_user')

  authenticateUser= ()=>
    if @get('currentUser') == undefined or @get('currentUser.dirty')
      user = new Kaljakassa.User()
      user.url = '/sessions/current'
      user.load (err) -> throw err if err
      @set('currentUser', user)