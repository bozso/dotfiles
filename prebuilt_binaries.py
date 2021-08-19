import subprocess as sub

from collections import namedtuple
from abc import ABC, abstractmethod
from shlex import split

__options = namedtuple(
    "Options", 
    ("to", "tag", "rename", "force_exec", "asset")
)


class Options(__options):
    def with_tag(self, tpl: str, tag: str, **kwargs) -> "Options":
        return self._replace(
            tag=tag,
            asset=tpl.format(tag=tag),
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


AssetManager.register(Eget)


def main():
    target_dir = "/home/istvan/packages/usr/bin"

    asset_manager = Eget.default()

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
    }

    for project, options in projects.items():
        asset_manager.download(project=project, options=options)


if __name__ == "__main__":
    main()
