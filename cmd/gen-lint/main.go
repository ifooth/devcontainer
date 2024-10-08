// gen-lint is a program for auto generate .golangci.yml for mod
package main

import (
	"errors"
	"fmt"
	"log"
	"os"
	"path"
	"regexp"
	"strings"

	"github.com/bitfield/script"
)

var (
	tmplPaths = []string{
		"./root/.golangci.yml",
		"/root/.golangci.yml",
	}
)

func findTmpl() string {
	for _, tmpl := range tmplPaths {
		if _, err := os.Stat(tmpl); errors.Is(err, os.ErrNotExist) {
			continue
		}
		return tmpl
	}

	return ""
}

func main() {
	tmpl := findTmpl()
	if tmpl == "" {
		log.Fatalf("golangci tmpl not found")
	}

	mods, err := script.FindFiles("./").Match("go.mod").String()
	if err != nil {
		log.Fatalf("go.mod not found")
	}

	re := regexp.MustCompile(`module\s+(.*)`)
	for _, line := range strings.Split(mods, "\n") {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		v, err := script.File(line).String()
		if err != nil {
			continue
		}
		match := re.FindStringSubmatch(v)
		if len(match) <= 1 {
			continue
		}
		module := match[1]
		d := path.Dir(line)
		_, err = script.File(tmpl).
			Replace("# - gci", "- gci").
			Replace("# goimports", "goimports").
			Replace("#   local-prefixes: github.com/ifooth/devcontainer", fmt.Sprintf("  local-prefixes: %s", module)).
			Replace("# gci", "gci").
			Replace("#   sections", "  sections").
			Replace("#     - standard", "    - standard").
			Replace("#     - default", "    - default").
			Replace("#     - prefix(github.com/ifooth/devcontainer)", fmt.Sprintf("    - prefix(%s)", module)).
			Replace("run:", "# Code generated by gen-lint. DO NOT EDIT.\n\nrun:").
			WriteFile(path.Join(d, "./.golangci.yml"))
		if err != nil {
			log.Fatalf("failed to write golangci.yml, err: %s", err)
		}
		fmt.Printf("generate .golangci.yml to %s done.\n", d)
	}
}
