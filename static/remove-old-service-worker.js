// I had a service worker with elm-pages. Now it's gone, so we need to unregister
// it or it'll keep showing the wrong content. I'll probably drop this code
// eventually!
navigator.serviceWorker.getRegistrations().then(function(registrations) {
  for (var i = 0; i < registrations.length; i++) {
    registrations[i].unregister();
  }

  // do a hard reload to make sure we have all the latest assets etc.
  if (registrations.length > 0) {
    window.location.reload(true)
  }
})
