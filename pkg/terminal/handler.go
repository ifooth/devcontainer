package terminal

//go:generate go run ./gen/main.go

import (
	"bytes"
	"log/slog"
	"net/http"
	"os"
	"strings"

	terminal "github.com/buildkite/terminal-to-html/v3"
	"github.com/go-chi/chi/v5/middleware"

	"github.com/ifooth/devcontainer/pkg/terminal/assets"
	"github.com/ifooth/devcontainer/pkg/web"
)

var previewTemplate = `
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="UTF-8">
			<title>terminal-to-html Preview</title>
			<style>STYLESHEET</style>
		</head>
		<body style="padding: 0px; margin: 0px;">
			<div class="term-container" style="border-radius: 0px;">CONTENT</div>
		</body>
	</html>
`

func wrapPreview(s []byte) ([]byte, error) {
	s = bytes.Replace([]byte(previewTemplate), []byte("CONTENT"), s, 1)
	styleSheet, err := assets.TerminalCSS()
	if err != nil {
		return nil, err
	}
	s = bytes.Replace(s, []byte("STYLESHEET"), styleSheet, 1)
	return s, nil
}

// PreviewHandler ..
func PreviewHandler(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	slog.Info("perview file", slog.String("name", name))

	if !strings.HasSuffix(name, ".diff") {
		http.NotFound(w, r)
		return
	}
	body, err := os.ReadFile(name)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	respBody, err := wrapPreview(terminal.Render(body))
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	_, err = w.Write(respBody)
	if err != nil {
		slog.Error("writing response error", slog.String("err", err.Error()))
	}
}

// PreviewMiddleware ..
func PreviewMiddleware(next http.Handler) http.Handler {
	fn := func(w http.ResponseWriter, r *http.Request) {
		// 只处理 diff 后缀文件类型
		if !strings.HasSuffix(r.URL.Path, ".diff") {
			next.ServeHTTP(w, r)
			return
		}

		bufWriter := web.NewResponseBufferWriter(w)
		ww := middleware.NewWrapResponseWriter(bufWriter, r.ProtoMajor)
		next.ServeHTTP(ww, r)

		buf := bufWriter.Buff()

		// 非200，文件未找到等, 直接返回
		if ww.Status() != 200 {
			w.Write(buf)
			return
		}

		slog.Info("perview file", slog.String("path", r.URL.Path))
		respBody, err := wrapPreview(terminal.Render(buf))
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadGateway)
			return
		}

		_, err = w.Write(respBody)
		if err != nil {
			slog.Error("writing response error", slog.String("err", err.Error()))
		}
	}

	return http.HandlerFunc(fn)
}
