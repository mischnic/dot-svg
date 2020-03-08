// Mostly taken from https://github.com/mdaines/viz.js
#include <graphviz/gvc.h>

extern gvplugin_library_t gvplugin_core_LTX_library;
extern gvplugin_library_t gvplugin_dot_layout_LTX_library;

char *errorMessage = NULL;

int vizErrorf(char *buf) {
  errorMessage = buf;
  return 0;
}

char* vizLastErrorMessage() {
  return errorMessage;
}

char* vizRenderFromString(const char *src, const char *format, const char *engine) {
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

void freeStringRenderString(char *data) {
  gvFreeRenderData(data);
}


void test(char* string){
  char *result = vizRenderFromString(string, "svg", "dot");
  printf("%lu\n", result ? strlen(result) : 0);
  freeStringRenderString(result);
  
  char *lastError = vizLastErrorMessage();
  if(lastError) printf("Error: %s\n\n", lastError);
}

int main(){
  test("digraph graphname\
{\
    a -> b -> c;\
    b -> d;\
}");

  test("digraph graphname\
{\
    a -> b -> c;\
    b -> d;\
");

  test("digraph graphname\
{\
    a -> b -> c;\
    b -> d;\
}");

  return 0;
}