package rss

import (
	"fmt"
	"os"
	"text/template"
)

type Config struct {
	GithubRepos []GithubRss `mapstructure:"github_repos"`
}

func (cfg Config) Step() error {
	mainTpl, err := template.New("github_rss").Parse(githubTpl)
	if err != nil {
		return err
	}

	github := mainTpl.Lookup("github_rss")
	w := os.Stdout

	// fmt.Printf("%#v\n", cfg.GithubRepos)
	for _, gh := range cfg.GithubRepos {
		for _, mode := range gh.Modes {
			for _, repo := range gh.Repos {
				curr := Github{
					User: gh.User,
					Repo: repo,
					Mode: mode,
				}
				err := github.Execute(w, curr)
				if err != nil {
					return err
				}

				_, err = fmt.Fprint(w, "\n")
				if err != nil {
					return err
				}
			}
		}
	}

	return nil
}
