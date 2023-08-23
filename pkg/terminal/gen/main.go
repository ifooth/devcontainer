//go:build ignore

package main

import (
	"fmt"
	"os"
	"path"
	"strings"

	"github.com/bitfield/script"
)

var files = []string{
	"https://raw.githubusercontent.com/buildkite/terminal-to-html/%s/internal/assets/terminal.css",
	"https://raw.githubusercontent.com/buildkite/terminal-to-html/%s/internal/assets/assets.go",
}

func getVersion() (string, error) {
	c, err := script.File("../../go.mod").Match("github.com/buildkite/terminal-to-html").Column(2).String()
	if err != nil {
		return "", err
	}

	c = strings.TrimSpace(c)
	return c, err
}

func fetchFile() error {
	v, err := getVersion()
	if err != nil {
		return err
	}

	for _, file := range files {
		f := fmt.Sprintf(file, v)
		name, err := script.Echo(f).Basename().String()
		if err != nil {
			return err
		}
		name = strings.TrimSpace(name)

		_, err = script.Get(f).Replace("func TerminalCSS", "// TerminalCSS ..\nfunc TerminalCSS").WriteFile(path.Join("./assets/", name))
		if err != nil {
			return err
		}
		fmt.Println("generate", v, name, "done")
	}

	return nil
}

func main() {
	err := fetchFile()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
