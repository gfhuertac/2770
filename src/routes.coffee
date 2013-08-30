module.exports =
  '/sites/:query':
    controller: 'sites-controller'
    version: '1.0.0'
    actions:
      get: 'performQuery'
   
  # ressource widget
  # could define helper function to
  # generate this for each ressource
  '/widgets':
    controller: 'widgets-controller'
    actions:
      get: 'index'
      post: 'create'
        
  '/widget/:id':
    controller: 'widgets-controller'
    actions:
      get: 'show'
      put: 'update'
      del: 'destroy'
     
  # for creating API keys
  '/clients':
    controller: 'clients-controller'
    public: true
    actions:
      get: 'index'
      post: 'create'
     
  # for creating and retrieving QR codes
  '/qrcode':
    controller: 'qrcodes-controller'
    public: true
    actions:
      get: 'generate'
