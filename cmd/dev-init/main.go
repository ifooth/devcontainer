package main

import (
	"fmt"
	"log/slog"
	"os"

	"github.com/bitfield/script"
)

// MustExecWithArg ..
func MustExecWithArg(cmdLine string, a ...any) {
	cmd := fmt.Sprintf(cmdLine, a...)
	_, err := script.Exec(cmd).String()
	if err != nil {
		slog.Error("exited", "cmd", cmd, "err", err)
		os.Exit(1)
	}
}

func main() {
	if gitUserName != "" {
		MustExecWithArg("git config --global user.name %s", gitUserName)
	}
}
