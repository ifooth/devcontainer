package main

import (
	"log/slog"
	"net"
	"net/http"
	"os"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/spf13/cobra"
	httpSwagger "github.com/swaggo/http-swagger/v2"

	_ "github.com/ifooth/devcontainer/docs"
	"github.com/ifooth/devcontainer/pkg/filebrowser"
	"github.com/ifooth/devcontainer/pkg/terminal"
	"github.com/ifooth/devcontainer/pkg/web"
)

var (
	bindAddr string
	port     int
	pubDir   string
)

func serverCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "server",
		Short: "devcontainer server",
		Run: func(cmd *cobra.Command, args []string) {
			if err := runServerCmd(); err != nil {
				slog.Error("run server failed", "err", err)
				os.Exit(1)
			}
		},
	}

	cmd.Flags().StringVar(&bindAddr, "bind-addr", "0.0.0.0", "the IP address on which to listen")
	cmd.Flags().IntVar(&port, "port", 8022, "listen http/metrics port")
	cmd.Flags().StringVar(&pubDir, "pub-dir", "/data/pub", "the public content dir")
	return cmd
}

func getPort() string {
	p := os.Getenv("DEV_SERVER_PORT")
	if p != "" {
		return p
	}

	return strconv.Itoa(port)
}

func runServerCmd() error {
	r := chi.NewRouter()

	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	// 注册 HTTP 请求
	r.Get("/-/healthy", web.HealthyHandler)
	r.Get("/-/ready", web.ReadyHandler)
	r.Get("/healthz", web.HealthzHandler)
	r.Get("/swagger/*", httpSwagger.Handler(httpSwagger.URL("/swagger/doc.json")))
	r.Mount("/debug", web.ProfilerHandler())

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("hello devcontainer")) // nolint
	})

	r.Get("/terminal/preview", terminal.PreviewHandler)
	r.Route("/file/browser", func(r chi.Router) {
		r.Use(terminal.PreviewMiddleware)
		r.Mount("/", http.StripPrefix("/file/browser", filebrowser.NewFileHandler(pubDir)))
	})

	addr := net.JoinHostPort(bindAddr, getPort())
	slog.Info("listening for requests and metrics", "addr", addr)

	return http.ListenAndServe(addr, r)
}
