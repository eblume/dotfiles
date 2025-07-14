# Sudoku in Markdown
# https://github.com/benstaniford/vim-sudoku
# :SudokuSolve	Solve the puzzle under cursor
# :SudokuEmpty	Insert empty grid
# :SudokuGenerate [clues]	Generate new puzzle
# :SudokuGiveClue	Get a single hint
# :SudokuAddWeeklyPuzzle	Add weekly puzzle section
{ pkgs, ... }:
let
  vim-sudoku = pkgs.vimUtils.buildVimPlugin {
    name = "vim-sudoku";
    src = pkgs.fetchFromGitHub {
      owner = "benstaniford";
      repo = "vim-sudoku";
      rev = "0b161f4dca59794e288d8bcac01cacb933e32339";
      sha256 = "BW0C4PGGrnIzUtLIELkmPQvxgyloJeKlI3i/2wWQnH4=";
    };
  };
in
{
  plugins = [
    vim-sudoku
  ];
}
