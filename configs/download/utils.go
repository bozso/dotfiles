package download

import (
	"bufio"
	"io"
	"os"
)

func CopyFile(from, to string) error {
	srcf, err := os.Open(from)
	if err != nil {
		return err
	}

	defer srcf.Close()

	dstf, err := os.Create(to)
	if err != nil {
		return err
	}

	defer dstf.Close()

	src := bufio.NewReader(srcf)
	dst := bufio.NewWriter(dstf)

	_, err = io.Copy(dst, src)
	return err
}
