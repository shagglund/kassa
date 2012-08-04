class Kaljakassa extends Batman.App

  @root 'homes#index'

# Make Kaljakassa available in the global namespace so it can be used
# as a namespace and bound to in views.
window.Kaljakassa = Kaljakassa
