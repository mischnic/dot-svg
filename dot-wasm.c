// Mostly taken from https://github.com/mdaines/viz.js

#include <gvc.h>
#include <emscripten.h>

extern gvplugin_library_t gvplugin_core_LTX_library;
extern gvplugin_library_t gvplugin_dot_layout_LTX_library;

char *errorMessage = NULL;

int vizErrorf(char *buf) {
  errorMessage = buf;
  return 0;
}

EMSCRIPTEN_KEEPALIVE char* graphvizLastErrorMessage() {
  return errorMessage;
}

EMSCRIPTEN_KEEPALIVE char* graphvizRenderFromString(const char *src, const char *format, const char *engine) {
  errorMessage = NULL;
  GVC_t *context;
  Agraph_t *graph;
  char *result = NULL;
  unsigned int length;
  
  context = gvContext();
  gvAddLibrary(context, &gvplugin_core_LTX_library);
  gvAddLibrary(context, &gvplugin_dot_layout_LTX_library);

  agseterr(AGERR);
  agseterrf(vizErrorf);
  
  agreadline(1);
  
  while ((graph = agmemread(src))) {
    if (result == NULL) {
      gvLayout(context, graph, engine);
      gvRenderData(context, graph, format, &result, &length);
      gvFreeLayout(context, graph);
    }
    
    agclose(graph);
    
    src = "";
  }
  
  return result;
}

EMSCRIPTEN_KEEPALIVE void freeStringRenderString(char* data) {
  gvFreeRenderData(data);
}