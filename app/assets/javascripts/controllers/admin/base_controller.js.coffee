class Kaljakassa.Admin.BaseController extends Kaljakassa.ApplicationController

  authenticate_admin= ()=>
    @redirect('/') unless @get('currentUser.admin')

  authenticate_staff= ()=>
    @redirect('/') unless @get('currentUser.staff')
  