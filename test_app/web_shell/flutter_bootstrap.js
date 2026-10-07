{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  config: {canvasKitBaseUrl: '/canvaskit/'},
  onEntrypointLoaded: async (initializer) => {
    const runner = await initializer.initializeEngine({hostElement: document.querySelector('#flutter-host')});
    await runner.runApp();
    document.querySelector('#loading')?.remove();
  }
});
