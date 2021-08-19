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


class AssetManager(ABC):
    @abstractmethod
    def download(project: str, options: Options):
        pass


def proc_flags(tpl: str, flags):
    for key, val in flags.items():
        if val is not None:
            yield tpl.format(key=key, val=val)


class Eget(namedtuple("Eget", ("executable", "extra_flags"))):
    @classmethod
    def default(cls) -> "Eget":
        return cls(
            executable="eget",
            extra_flags=None,
        )

    def download(self, project: str, options: Options):
        flags = {
            "rename": options.rename,
            "asset": options.asset,
            "tag": options.tag,
            "to": options.to,
        }

        flags = " ".join((
            flag for flag in proc_flags("--{key} {val}", flags)
        ))

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
            print(line.decode(), end="")

        proc.wait()


class NoOverwrite(namedtuple("NoOverwrite", ("manager"))):
    def download(self, project: str, options: Options):
        asset, rename = options.asset, options.rename,

        if (asset, rename) == (None, None):
            raise ValueError("expected options to define either 'asset' "
                             "or 'rename' fields for checking "
                             "output filename")

        filename = rename if rename is not None else asset

        to = options.to

        outdir = to if to is not None else "."
        outfile = path.join(outdir, filename)

        if not path.exists(outfile):
            self.manager.download(project, options)


AssetManager.register(Eget)
AssetManager.register(NoOverwrite)


def main():
    target_dir = "/home/istvan/packages/usr/bin"

    asset_manager = NoOverwrite(Eget.default())

    opt = Options(
        rename=None,
        force_exec=True,
        asset=None,
        tag=None,
        to=target_dir,
    )

    projects = {
        # "neovim/neovim": Options(
        #     rename=None,
        #     force_exec=True,
        #     asset="nvim.appimage"
        # ),

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
        )
    }

    for project, options in projects.items():
        asset_manager.download(project=project, options=options)


if __name__ == "__main__":
    main()