export enum Mode {
  vertical,
  horizontal,
}

export enum Unit {
  percent,
  cells,
}

export class Size {
  constructor(
    public readonly num: number,
    public readonly unit: Unit,
  ) {}
  static percent(num: number) {
    return new Size(num, Unit.percent);
  }

  static cells(num: number) {
    return new Size(num, Unit.cells);
  }
}

export interface Window {
  command?: string;
  size: Size;
  mode: Mode;
}

export type Like = string | Window;

export type Map = Record<string, Window>;
