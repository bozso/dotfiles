import * as window from "./window.ts";

export interface Socket {
  name?: string;
  path?: string;
}

export interface Global {
  config_file: string;
  try_use_utf8: boolean;
  verbose_logging: boolean;
  socket: Socket;
}

export interface Config {
  global: Global;
  windows?: window.Map;
}

export interface Pane {
  windows: window.Like[];
}

export interface Workspace {
  public: Record<string, Pane>;
}
