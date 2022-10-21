package download

import (
	"fmt"
	"path/filepath"

	"github.com/melbahja/got"
)

const tpl = "https://raw.githubusercontent.com/{{.User}}/{{.Repo}}user.js/{{.Revision}}/user.js"

type Arkenfox struct {
	URL    string
	UserID string
	User   string
	ID     string
	File   string
}

func (a Arkenfox) Setup() error {
	g := got.New()

	err := g.Download(a.URL, a.File)
	if err != nil {
		return err
	}

	base := filepath.Base(a.File)
	dst := fmt.Sprintf("/home/%s/.mozilla/firefox/%s/%s", a.User, a.UserID, base)

	err = CopyFile(a.File, dst)
	if err != nil {
		return err
	}

	return nil
}
