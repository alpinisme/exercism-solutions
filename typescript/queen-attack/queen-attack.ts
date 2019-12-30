type Position = [number, number];

export default class QueenAttack {
  public black: Position;
  public white: Position;

  constructor({ white, black }: { white: Position; black: Position }) {
    this.black = black;
    this.white = white;

    this.validate(); // throws error if invalid
  }

  private hasOverlappingQueens(): boolean {
    return this.white.join() === this.black.join();
  }

  private hasQueensOffBoard(): boolean {
    const offBoard = (x: number): boolean => x < 0 || x > 7;
    const isPieceOffBoard = (p: Position): boolean =>
      offBoard(p[0]) || offBoard(p[1]);
    return isPieceOffBoard(this.black) || isPieceOffBoard(this.white);
  }

  private validate(): void {
    if (this.hasOverlappingQueens()) {
      throw new Error("Queens cannot share the same space");
    }
    if (this.hasQueensOffBoard()) {
      throw new Error("Queens must fit on an 8 x 8 board");
    }
  }

  public toString(): string {
    const line = Array(8).fill("_");
    const board = [...Array(8)].map(_ => [...line]);
    board[this.white[0]][this.white[1]] = "W";
    board[this.black[0]][this.black[1]] = "B";
    const display = board.map(line => line.join(" ") + "\n").join("");

    return display;
  }

  public canAttack(): boolean {
    const xOffset = Math.abs(this.black[1] - this.white[1]);
    const yOffset = Math.abs(this.black[0] - this.white[0]);
    return xOffset === 0 || yOffset === 0 || xOffset - yOffset === 0;
  }
}
