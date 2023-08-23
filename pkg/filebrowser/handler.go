package filebrowser

import (
	"net/http"
	"os"
	"text/template"
)

// BrowerHandler ..
func BrowerHandler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Path[1:]
	if path == "" {
		path = "."
	}

	fileList, err := os.ReadDir(path)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	tmpl := template.Must(template.ParseFiles("index.html"))
	tmpl.Execute(w, fileList)
}
