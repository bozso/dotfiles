package rss

type (
	User       string
	Repository string
	Mode       string
)

type GithubRss struct {
	User  User       `mapstructure:"user"`
	Repo  Repository `mapstructure:"repo"`
	Modes []Mode     `mapstructure:"modes"`
}

type Github struct {
	User User
	Repo Repository
	Mode Mode
}

const githubTpl = "https://github.com/{{.User}}/{{.Repo}}/{{.Mode}}.atom"
