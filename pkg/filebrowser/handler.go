package filebrowser

import (
	"embed"
	"errors"
	"io"
	"net/http"
	"os"
	"path"
	"text/template"
)

//go:embed index.html
var fs embed.FS

func webTemplate() *template.Template {
	return template.Must(template.New("").ParseFS(fs, "*.html"))
}

// FileHandler ..
func FileHandler(root string) http.Handler {
	tmpl := webTemplate()
	fn := func(w http.ResponseWriter, r *http.Request) {
		p := path.Join(root, r.URL.Path)
		info, err := os.Stat(p)
		if err != nil && errors.Is(err, os.ErrNotExist) {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		if info.IsDir() {
			fileList, err := os.ReadDir(path.Join(root, r.URL.Path))
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			data := map[string]any{
				"fileList": fileList,
			}
			tmpl.ExecuteTemplate(w, "index.html", data) // nolintr
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

	return http.HandlerFunc(fn)
}
