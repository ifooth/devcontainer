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

	"github.com/ifooth/devcontainer/pkg/terminal"
)

var (
	bindAddr string
	port     int
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
	return cmd
}

func runServerCmd() error {
	r := chi.NewRouter()

	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("hello devcontainer"))
	})

	r.Get("/terminal/preview", terminal.PerviewHandler)

	addr := net.JoinHostPort(bindAddr, strconv.Itoa(port))
	slog.Info("listening for requests and metrics", "addr", addr)

	return http.ListenAndServe(addr, r)
}