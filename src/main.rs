mod board;

use board::Board;

fn main() {
    let board: Board = Board::new(10, 10);

    board.draw();
}
