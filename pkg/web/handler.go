package web

import (
	"net/http"
	"net/http/pprof"
)

// ProfilerHandler ..
func ProfilerHandler() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/debug/pprof/", pprof.Index)
	mux.HandleFunc("/debug/pprof/cmdline", pprof.Cmdline)
	mux.HandleFunc("/debug/pprof/profile", pprof.Profile)
	mux.HandleFunc("/debug/pprof/symbol", pprof.Symbol)
	mux.HandleFunc("/debug/pprof/trace", pprof.Trace)

	return mux
}

// HealthzHandler Healthz 接口
//
//	@Summary  Healthz 接口
//	@Tags     Healthz
//	@Success  200  {string}  string
//	@Router   /healthz [get]
func HealthzHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}

// HealthyHandler 健康检查
func HealthyHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}

// ReadyHandler 健康检查
func ReadyHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}
