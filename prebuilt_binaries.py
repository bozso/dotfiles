import subprocess as sub
import os.path as path

from collections import namedtuple
from abc import ABC, abstractmethod
from shlex import split

__options = namedtuple(
    "Options",
    ("to", "tag", "rename", "force_exec", "asset")
)


class Options(__options):
    def with_tag(self, tpl: str, tag: str, **kwargs) -> "Options":
        strip = kwargs.pop("strip", None)

        tpl_tag = tag
        if strip is not None:
            tpl_tag = tag.strip(strip)

        return self._replace(
            tag=tag,
            asset=tpl.format(tag=tpl_tag),
            **kwargs
        )

    def filename(self) -> str:
        rename, asset = self.rename, self.asset
        filename = rename if rename is not None else asset

        to = self.to
        outdir = to if to is not None else "."

        return path.join(outdir, filename)


class AssetManager(ABC):
    @abstractmethod
    def download(project: str, options: Options):
        pass


def proc_flags(tpl: str, flags):
    for key, val in flags.items():
        if val is not None:
            yield tpl.format(key=key, val=val)


def parse_flags(flags) -> str:
    return " ".join((
        flag for flag in proc_flags("--{key} {val}", flags)
    ))


def parse_flags_join_path(options: Options) -> str:
    flags = {
        "asset": options.asset,
        "tag": options.tag,
    }

    flags = parse_flags(flags)
    return "%s --to %s" % (flags, options.filename())


def parse_flags_with_rename(options: Options) -> str:
    flags = {
        "rename": options.rename,
        "to": options.to,
        "asset": options.asset,
        "tag": options.tag,
    }

    return parse_flags(flags)


class Eget(namedtuple("Eget", ("executable", "extra_flags", "flag_parser"))):
    @classmethod
    def default(cls) -> "Eget":
        return cls(
            executable="eget",
            extra_flags=None,
            flags_parser=parse_flags_with_rename,
        )

    @classmethod
    def detect_version(cls, executable: str, extra_flags: str) -> "Eget":
        version = sub.check_output([executable, "--version"]).decode().split()

        if version[-1] == "0.1.3":
            fn = parse_flags_join_path
        else:
            fn = parse_flags_with_rename

        return cls(
            executable=executable,
            extra_flags=extra_flags,
            flag_parser=fn,
        )

    def download(self, project: str, options: Options):
        flags = self.flag_parser(options)

        if options.force_exec:
            flags = "%s -x" % flags

        extra_flags = self.extra_flags
        if extra_flags is not None:
            flags = "%s %s" % (flags, extra_flags)

        cmd = (
            "{executable} {flags} {project}"
            .format(
                executable=self.executable,
                project=project,
                flags=flags,
            )
        )
        print(cmd)

        proc = sub.Popen(split(cmd), stdout=sub.PIPE)

        for line in proc.stdout:
            print(line.decode(), end="\r")

        proc.wait()


class NoOverwrite(namedtuple("NoOverwrite", ("manager"))):
    def download(self, project: str, options: Options):
        if (options.asset, options.rename) == (None, None):
            raise ValueError("expected options to define either 'asset' "
                             "or 'rename' fields for checking "
                             "output filename")


        if not path.exists(options.filename()):
            self.manager.download(project, options)


AssetManager.register(Eget)
AssetManager.register(NoOverwrite)


def main():
    target_dir = path.expanduser(
        path.join("~", "packages", "usr", "bin")
    )

    asset_manager = NoOverwrite(Eget.detect_version("eget", None))

    opt = Options(
        rename=None,
        force_exec=True,
        asset=None,
        tag=None,
        to=target_dir,
    )

    projects = {
        "jarun/nnn": opt.with_tag(
            rename="nnn",
            tpl="nnn-static-4.2.x86_64.tar.gz",
            tag="v4.2",
        ),

        "dandavison/delta": opt.with_tag(
            rename="delta",
            tpl="delta-{tag}-x86_64-unknown-linux-gnu.tar.gz",
            tag="0.8.3",
        ),

        "denoland/deno": opt.with_tag(
            rename="deno",
            tpl="deno-x86_64-unknown-linux-gnu.zip",
            tag="v1.13.1",
        ),

        "junegunn/fzf": opt.with_tag(
            rename="fzf",
            tpl="fzf-{tag}-linux_amd64.tar.gz",
            tag="0.27.2",
        ),

        "jgm/pandoc": opt.with_tag(
            rename="pandoc",
            tpl="pandoc-{tag}-linux-amd64.tar.gz",
            tag="2.14.1",
        ),

        "starship/starship": opt.with_tag(
            rename="starship",
            tpl="starship-x86_64-unknown-linux-gnu.tar.gz",
            tag="v0.56.0",
        ),

        "sharkdp/bat": opt.with_tag(
            rename="bat",
            tpl="bat-{tag}-x86_64-unknown-linux-gnu.tar.gz",
            tag="v0.18.2",
        ),

        "ogham/exa": opt.with_tag(
            rename="exa",
            tpl="exa-linux-x86_64-{tag}.zip",
            tag="v0.10.1",
        ),

        "BurntSushi/ripgrep": opt.with_tag(
            rename="rigrep",
            tpl="ripgrep-{tag}-x86_64-unknown-linux-musl.tar.gz",
            tag="13.0.0",
        ),

        "leighmcculloch/tldr": opt.with_tag(
            rename="tldr",
            tpl="tldr_{tag}_linux_x64.tar.gz",
            tag="v1.1.2",
            strip="v",
        ),

        "sharkdp/hyperfine": opt.with_tag(
            rename="hpf",
            tpl="hyperfine-{tag}-x86_64-unknown-linux-gnu.tar.gz",
            tag="v1.11.0",
        ),

        "rs/curlie": opt.with_tag(
            rename="crl",
            tpl="curlie_{tag}_linux_amd64.tar.gz",
            tag="v1.6.0",
            strip="v"
        ),

        "https://cancel.fm/dl/Ripcord-0.4.29-x86_64.AppImage": opt._replace(
            rename="ripcord",
        ),

        "bootandy/dust": opt.with_tag(
            rename="dust",
            tpl="dust-{tag}-x86_64-unknown-linux-musl.tar.gz",
            tag="v0.6.2",
        ),

        "tectonic-typesetting/tectonic": opt.with_tag(
            rename="tectonic",
            tpl="tectonic-{tag}-x86_64-unknown-linux-musl.tar.gz",
            tag="tectonic@0.7.1",
            strip="textonic@",
        ),

        "d-language-server/dls": opt.with_tag(
            rename="dls",
            tpl="dls-{tag}.linux.x86_64.zip",
            tag="v0.26.2",
        ),

        "https://github.com/premake/premake-core/"\
        "releases/download/v5.0.0-alpha16/"\
        "premake-5.0.0-alpha16-linux.tar.gz": opt._replace(
            rename="premake5",
        ),

        "GitJournal/GitJournal": opt.with_tag(
            rename="gj",
            tpl="GitJournal-linux-x86_64.AppImage",
            tag="v1.80.0",
        ),
    }

    for project, options in projects.items():
        asset_manager.download(project=project, options=options)


if __name__ == "__main__":
    main()

"""
"https://libreoffice.soluzioniopen.com/stable/full/LibreOffice-still.full-x86_64.AppImage": opt._replace(
    rename="libreoffice",
),
"""
