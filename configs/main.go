package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/bozso/dotfiles/configs/download"
	"github.com/bozso/dotfiles/configs/rss"
	"github.com/yuin/gluamapper"
	lua "github.com/yuin/gopher-lua"
)

type Config struct {
	Download download.Config `mapstructure:"download"`
	Rss      rss.Config      `mapstructure:"rss"`
}

type (
	Step interface {
		Step() error
	}

	Steps map[string]Step
)

func run(L *lua.LState) error {
	step := L.CheckString(1)
	if len(step) == 0 {
		return fmt.Errorf("first argument should be a non empty string")
	}

	tbl := L.CheckTable(2)
	if tbl == nil {
		return fmt.Errorf("second argument should be a non nil table")
	}

	var cfg Config
	err := gluamapper.Map(tbl, &cfg)
	if err != nil {
		return err
	}

	steps := Steps{
		"rss":      cfg.Rss,
		"download": cfg.Download,
	}
	stepStruct, ok := steps[step]
	if !ok {
		return fmt.Errorf("step not found: '%s'", step)
	}

	err = stepStruct.Step()
	return err
}

func Main() error {
	L := lua.NewState()

	stepFn := L.NewFunction(func(L *lua.LState) int {
		err := run(L)
		if err != nil {
			L.Error(lua.LString(err.Error()), 0)
		}

		return 0
	})

	L.SetGlobal("run", stepFn)

	flags := flag.NewFlagSet("configs", flag.ContinueOnError)
	var file string

	flags.StringVar(&file, "source", "configs.lua", "lua sourcefile to run")

	flags.Parse(os.Args)
	err := L.DoFile(file)
	if err != nil {
		return err
	}

	defer L.Close()

	return nil
}

func MainNew() error {
	cfg := Config{
		Download: download.Config{
			EveOst: download.EveOst{
				Url: "https://www.modenstudios.com/EVE/music/",
				Dir: "/home/istvan/Zenék/eve",
			},
			Arkenfox: download.Arkenfox{
				URL:    "https://raw.githubusercontent.com/arkenfox/user.js/996881aef184246a011ac29382e91d634cda7b65/user.js",
				User:   "istvan",
				UserID: "5okjrwhs.default-release",
				File:   "/tmp/user.js",
			},
		},
	}

	return cfg.Download.Step()
}

func main() {
	err := MainNew()
	if err != nil {
		fmt.Printf("error: '%s'", err)
	}
}
