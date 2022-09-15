package download

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

type EveOst struct {
	Url string `mapstructure:"url"`
	Dir string `mapstructure:"dir"`
}

func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if err == nil {
		return true
	}
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

type nopCloser struct{}

func (nopCloser) Close() error {
	return nil
}

func download(url, target string) error {
	fmt.Printf("url: %s, target: %s\n", url, target)
	if fileExists(target) {
		return nil
	}

	resp, err := http.Get(url)
	if err != nil {
		return err
	}

	f, err := os.Create(target)
	if err != nil {
		return err
	}

	bf := bufio.NewWriter(f)

	_, err = io.Copy(bf, resp.Body)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	return nil
}

func (eve EveOst) getPage() (io.Reader, io.Closer, error) {
	const path = "/tmp/eve_music.html"
	if fileExists(path) {
		f, err := os.Open(path)
		if err != nil {
			return nil, nil, err
		}

		bf := bufio.NewReader(f)
		return bf, f, nil
	}

	resp, err := http.Get(eve.Url)
	if err != nil {
		return nil, nil, err
	}

	f, err := os.Create(path)
	if err != nil {
		return nil, nil, err
	}

	var b []byte
	sb := bytes.NewBuffer(b)
	bf := bufio.NewWriter(f)
	mw := io.MultiWriter(sb, bf)

	_, err = io.Copy(mw, resp.Body)
	if err != nil {
		return nil, nil, err
	}

	defer resp.Body.Close()

	defer f.Close()

	return sb, nopCloser{}, nil
}

func (eve EveOst) extractLinks() ([]string, error) {
	var links []string

	r, closer, err := eve.getPage()
	if err != nil {
		return links, err
	}
	defer closer.Close()

	doc, err := goquery.NewDocumentFromReader(r)
	if err != nil {
		return links, err
	}

	links = make([]string, 0, 30)
	doc.Find("a").Each(func(_ int, sel *goquery.Selection) {
		link, ok := sel.Attr("href")
		if ok && strings.Contains(link, ".mp3") {
			links = append(links, link)
		}
	})

	return links, nil
}

func (eve EveOst) Download() error {
	links, err := eve.extractLinks()
	if err != nil {
		return err
	}
	// root, err := url.Parse(eve.Url)
	// if err != nil {
	// 	return err
	// }
	fmt.Printf("%s\n", eve.Url)

	err = os.MkdirAll(eve.Dir, 0775)
	if err != nil {
		return err
	}

	for _, link := range links {
		outpath := filepath.Join(eve.Dir, link)
		currUrl := fmt.Sprintf("%s%s", eve.Url, link)
		// fmt.Printf("%s\n", currUrl)
		err = download(currUrl, outpath)
		if err != nil {
			return err
		}
		// _, err := grab.Get(eve.Dir, currUrlStr)
		// currUrl, err := url.Parse(currUrlStr)
		// if err != nil {
		// 	return err
		// }
		//
	}

	return nil
}

// func getHost(u *url.URL) string {
// 	if u.IsAbs() {
// 		host := r.Host
// 		// Slice off any port information.
// 		if i := strings.Index(host, ":"); i != -1 {
// 			host = host[:i]
// 		}
// 		return host
// 	}
// 	return r.URL.Host
// }
