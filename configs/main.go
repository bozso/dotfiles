package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/bozso/dotfiles/configs/rss"
	"github.com/yuin/gluamapper"
	lua "github.com/yuin/gopher-lua"
)

type Config struct {
	Rss rss.Config `mapstructure:"rss"`
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
		"rss": cfg.Rss,
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

func main() {
	err := Main()
	if err != nil {
		fmt.Printf("error: '%s'", err)
	}
}
