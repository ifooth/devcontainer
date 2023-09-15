// Package filebrowser ...
package filebrowser

import (
	"embed"
	"errors"
	"io"
	"log/slog"
	"net/http"
	"os"
	"path"
	"text/template"

	"github.com/dustin/go-humanize"
)

//go:embed index.html
var fs embed.FS

func webTemplate() *template.Template {
	return template.Must(template.New("").ParseFS(fs, "*.html"))
}

type file struct {
	root string
	tmpl *template.Template
}

// NewFileHandler ..
func NewFileHandler(root string) http.Handler {
	f := &file{
		root: root,
		tmpl: webTemplate(),
	}
	return f
}

func (f *file) getFileHandler(w http.ResponseWriter, r *http.Request) {
	p := path.Join(f.root, r.URL.Path)
	info, err := os.Stat(p)
	if err != nil && errors.Is(err, os.ErrNotExist) {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if info.IsDir() {
		fileList, rErr := os.ReadDir(path.Join(f.root, r.URL.Path))
		if err != nil {
			http.Error(w, rErr.Error(), http.StatusInternalServerError)
			return
		}
		data := map[string]any{
			"fileList": fileList,
		}
		f.tmpl.ExecuteTemplate(w, "index.html", data) // nolint
		return
	}

	reader, err := os.Open(p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "text/plain; charset=UTF-8")
	io.Copy(w, reader)
}

func (f *file) uploadFileHandler(w http.ResponseWriter, r *http.Request) {
	// 获取文件内容 要这样获取
	file, head, err := r.FormFile("upfile")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer file.Close()

	name := path.Join(f.root, path.Dir(r.URL.Path), head.Filename)
	fW, err := os.Create(name)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer fW.Close()

	size, err := io.Copy(fW, file)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	slog.Info("upload file success", "name", name, "size", humanize.Bytes(uint64(size)))
	w.Write([]byte("success"))
}

// ServeHTTP ..
func (f *file) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		f.uploadFileHandler(w, r)
		return
	}

	f.getFileHandler(w, r)

}
