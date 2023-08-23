package terminal

import (
	"bytes"
	"log"
	"net/http"
	"os"
	"strings"

	terminal "github.com/buildkite/terminal-to-html/v3"
)

var previewTemplate = `
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="UTF-8">
			<title>terminal-to-html Preview</title>
			<style>STYLESHEET</style>
		</head>
		<body>
			<div class="term-container">CONTENT</div>
		</body>
	</html>
`

func wrapPreview(s []byte) ([]byte, error) {
	s = bytes.Replace([]byte(previewTemplate), []byte("CONTENT"), s, 1)
	styleSheet, err := terminal.TerminalCSS()
	if err != nil {
		return nil, err
	}
	s = bytes.Replace(s, []byte("STYLESHEET"), styleSheet, 1)
	return s, nil
}

// PerviewHandler ..
func PerviewHandler(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	log.Printf("perview file %s", name)

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
		log.Printf("error writing response: %v", err)
	}
}
