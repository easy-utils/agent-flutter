{{flutter_js}}
{{flutter_build_config}}

// Custom bootstrap: keep a DOM splash on screen while the engine + Dart bundle
// load, then remove it once Flutter has painted its first frame. The splash
// mirrors `lib/widgets/loading_screen.dart` (and the other clients): client
// MARK + "ABCP Agent" + a ring.
window.addEventListener('flutter-first-frame', function () {
  var el = document.getElementById('agent-splash');
  if (el) el.remove();
});

_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
  },
});
