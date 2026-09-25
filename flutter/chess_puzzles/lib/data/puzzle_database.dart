import '../../core/chess/chess_models.dart';
import 'models/puzzle_model.dart';

class PuzzleDatabase {
  static const List<ChessPuzzle> allPuzzles = [
    // --- MATE IN 1 ---
    ChessPuzzle(
      id: 'm1_01',
      title: 'Queen\'s Kiss of Death',
      description: 'Find the single move that delivers checkmate on the exposed king.',
      fen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
      moves: ['f3f7'],
      theme: PuzzleTheme.mateIn1,
      rating: 800,
      explanation: 'The Queen captures the undefended f7 pawn protected by the c4 Bishop, delivering a classic Scholar\'s Mate kiss of death.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_02',
      title: 'Back Rank Guillotine',
      description: 'Exploit the blocked black king on the back rank.',
      fen: '6k1/5ppp/8/8/8/8/5PPP/R5K1 w - - 0 1',
      moves: ['a1a8'],
      theme: PuzzleTheme.mateIn1,
      rating: 850,
      explanation: 'Black\'s own pawns block any escape squares on the 7th rank, creating a fatal back-rank checkmate with the Rook.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_03',
      title: 'Smothered Mate Ambush',
      description: 'Deliver checkmate with the jumping Knight.',
      fen: '6rk/6pp/7N/8/8/8/8/7K w - - 0 1',
      moves: ['h6f7'],
      theme: PuzzleTheme.mateIn1,
      rating: 900,
      explanation: 'The black king is completely trapped by its own pieces (Rook and pawns). The Knight jumps to f7 for a classic Smothered Mate!',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_04',
      title: 'Operatic Queen Finish',
      description: 'White has forced the black king onto d8.',
      fen: '1k1r4/ppp5/8/8/8/8/PP3PPP/3R2K1 w - - 0 1',
      moves: ['d1d8'],
      theme: PuzzleTheme.mateIn1,
      rating: 850,
      explanation: 'Rook captures on d8 with checkmate as black is pinned and overwhelmed on the d-file.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_05',
      title: 'Diagonal Crossfire',
      description: 'White Bishop slides in for the kill.',
      fen: 'k7/8/1K6/8/8/8/8/1B6 w - - 0 1',
      moves: ['b1e4'],
      theme: PuzzleTheme.mateIn1,
      rating: 950,
      explanation: 'The Bishop cuts along the diagonal h1-a8 while the White King controls all escape squares (a7, b8).',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_06',
      title: 'Black\'s Counter-Punch',
      description: 'Black to deliver immediate checkmate on White.',
      fen: '4k3/8/8/8/8/8/4r3/3K3R b - - 0 1',
      moves: ['e2e1'],
      theme: PuzzleTheme.mateIn1,
      rating: 900,
      explanation: 'Rook to e1 delivers checkmate on the back rank.',
      playerColor: PieceColor.black,
    ),
    ChessPuzzle(
      id: 'm1_07',
      title: 'Rook Corner Trap',
      description: 'Deliver checkmate along the open h-file.',
      fen: '5rk1/5p1p/8/8/8/8/8/R6K w - - 0 1',
      moves: ['a1g1'],
      theme: PuzzleTheme.mateIn1,
      rating: 850,
      explanation: 'Rook cuts across the g-file, driving the king into the corner with no legal moves left.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_08',
      title: 'Anastasia\'s Knight & Rook Mate',
      description: 'The Knight guards e7 and g7 while the Rook strikes.',
      fen: '5r1k/6pp/5N2/8/8/8/8/R6K w - - 0 1',
      moves: ['a1a8'],
      theme: PuzzleTheme.mateIn1,
      rating: 950,
      explanation: 'Rook on a8 pins and mates on the back rank.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_09',
      title: 'Boden\'s Criss-Cross Bishops',
      description: 'Two laser bishops criss-crossing the enemy king.',
      fen: '2kr4/ppp5/8/8/8/8/8/2B1K2B w - - 0 1',
      moves: ['h1g2'],
      theme: PuzzleTheme.mateIn1,
      rating: 950,
      explanation: 'The bishop on g2 cuts across the long diagonal with the dark-squared bishop.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm1_10',
      title: 'Epaulette Mate in the Center',
      description: 'Black Rooks flank their own King.',
      fen: '3rkr2/8/8/8/8/8/4Q3/4K3 w - - 0 1',
      moves: ['e2e7'],
      theme: PuzzleTheme.mateIn1,
      rating: 900,
      explanation: 'Queen to e7 checkmate; both friendly rooks obstruct lateral escape squares on d8 and f8.',
      playerColor: PieceColor.white,
    ),

    // --- MATE IN 2 & 3 ---
    ChessPuzzle(
      id: 'm2_01',
      title: 'Classic Anastasia Sacrifice',
      description: 'White forces checkmate in 2 with an unstoppable Rook and Knight coordination.',
      fen: '5rk1/1p3ppp/pN6/8/8/8/1P3PPP/R1Q3K1 w - - 0 1',
      moves: ['c1c8', 'f8c8', 'a1c8'],
      theme: PuzzleTheme.mateIn2,
      rating: 1200,
      explanation: 'White deflects the defending black rook by sacrificing the Queen on c8, followed by back-rank mate with the Rook.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm2_02',
      title: 'Queen & Knight Net',
      description: 'White breaks open the f7 square.',
      fen: 'r1bqk2r/ppppbppp/2n5/4P3/2B3n1/5N2/PB3PPP/RN1Q1RK1 w kq - 0 1',
      moves: ['c4f7', 'e8f7', 'd1d5'],
      theme: PuzzleTheme.mateIn2,
      rating: 1350,
      explanation: 'Bxf7+ strips the black king of castling rights and leads into a crushing Queen centralization.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm2_03',
      title: 'Arabian Mate Finale',
      description: 'Knight on f6 and Rook combine to corner the King.',
      fen: '7k/1R6/5N2/8/8/8/8/7K w - - 0 1',
      moves: ['b7h7'],
      theme: PuzzleTheme.mateIn2,
      rating: 1100,
      explanation: 'Rook to h7 delivers the famous Arabian Mate supported by the Knight on f6.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm2_04',
      title: 'Damiano\'s Defense Trap',
      description: 'Punish Black\'s early f6 weakness with a tactical battery.',
      fen: 'rnbqkbnr/pppp2pp/5p2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 2',
      moves: ['f3e5', 'f6e5', 'd1h5'],
      theme: PuzzleTheme.mateIn2,
      rating: 1250,
      explanation: 'Knight sacrifice on e5 blows open the vulnerable diagonal e8-h5 for a deadly Queen check.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'm2_05',
      title: 'Corner Rook Lift',
      description: 'Black king has no breath on h8.',
      fen: '5r1k/p4p1p/8/8/8/4R3/5PPP/6K1 w - - 0 1',
      moves: ['e3g3', 'h7h6', 'g3g8'],
      theme: PuzzleTheme.mateIn2,
      rating: 1300,
      explanation: 'Rook lifts to g3 sealing the g-file and setting up an unstoppable invasion.',
      playerColor: PieceColor.white,
    ),

    // --- FORK & DOUBLE ATTACK ---
    ChessPuzzle(
      id: 'fork_01',
      title: 'Royal Family Knight Fork',
      description: 'White Knight lands on c7 to win decisive material.',
      fen: 'r1b1k2r/pp1p1ppp/2n1pn2/q7/2B1P3/2N2N2/PP3PPP/R1BQK2R w KQkq - 0 1',
      moves: ['c1d2', 'a5c5', 'c4e2'],
      theme: PuzzleTheme.fork,
      rating: 1150,
      explanation: 'Developing with tempo attacks the queen while setting up tactical outpost squares.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'fork_02',
      title: 'Center Fork Trick',
      description: 'Classic e4/d4 pawn fork recovering piece with advantage.',
      fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
      moves: ['f3e5', 'c6e5', 'd2d4'],
      theme: PuzzleTheme.fork,
      rating: 1200,
      explanation: 'Nxe5 followed by d4 forks the black Bishop on c4 and Knight on e5, regaining the piece with dominant center control.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'fork_03',
      title: 'Queen Fork on King & Rook',
      description: 'Find the check that simultaneously attacks the loose Rook on a8.',
      fen: 'r3k2r/ppp2ppp/2n5/3q4/3P4/5N2/PP3PPP/R2QKB1R b KQkq - 0 1',
      moves: ['d5a5', 'd1d2', 'a5d2'],
      theme: PuzzleTheme.fork,
      rating: 1300,
      explanation: 'Black checks on a5, forcing a queen exchange or winning active initiative.',
      playerColor: PieceColor.black,
    ),
    ChessPuzzle(
      id: 'fork_04',
      title: 'Rook Skewer & Fork',
      description: 'Exploit undefended pieces on the 7th rank.',
      fen: '4k3/4r3/8/8/8/8/4R3/4K3 w - - 0 1',
      moves: ['e2e7', 'e8e7'],
      theme: PuzzleTheme.fork,
      rating: 1100,
      explanation: 'Trading rooks into a straightforward won king and pawn endgame.',
      playerColor: PieceColor.white,
    ),

    // --- PIN & SKEWER ---
    ChessPuzzle(
      id: 'pin_01',
      title: 'Absolute Queen Pin',
      description: 'Pin the enemy Queen to the King using the Bishop.',
      fen: 'r1b1k2r/pppp1ppp/8/4q3/1bP5/2N5/PP1BPPPP/R2QKB1R w KQkq - 0 1',
      moves: ['d2f4', 'e5f4'],
      theme: PuzzleTheme.pin,
      rating: 1350,
      explanation: 'Bishop strikes actively on f4 exploiting black\'s open queen file.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'pin_02',
      title: 'Rook Skewer Through the King',
      description: 'Skewering Black\'s King to win the unguarded Rook on h8.',
      fen: '7r/8/8/8/8/8/1K5R/6k1 w - - 0 1',
      moves: ['h2h8'],
      theme: PuzzleTheme.pin,
      rating: 1050,
      explanation: 'White captures the Rook on h8 directly on the open file.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'pin_03',
      title: 'Cross-Pin Exploitation',
      description: 'Exploit the pinned pawn that cannot defend its comrade.',
      fen: 'r1b1k2r/ppp2ppp/2n1pn2/3q4/3P4/2PB1N2/P1P2PPP/R1BQK2R w KQkq - 0 1',
      moves: ['e1g1', 'e8g8'],
      theme: PuzzleTheme.pin,
      rating: 1200,
      explanation: 'Castling brings the king to safety and activates the rook onto the open e-file.',
      playerColor: PieceColor.white,
    ),

    // --- DISCOVERED ATTACK ---
    ChessPuzzle(
      id: 'disc_01',
      title: 'Discovered Check Blow',
      description: 'Move the Bishop to unleash an unstoppable discovered attack from the Queen.',
      fen: 'r1bqk2r/pppp1ppp/2n5/4P3/1bB1n3/2N2N2/PB3PPP/R2QK2R w KQkq - 0 1',
      moves: ['c4f7', 'e8f7', 'd1d5'],
      theme: PuzzleTheme.discoveredAttack,
      rating: 1450,
      explanation: 'Bxf7+ forces the king out, then Qd5+ forks king and knight to win back the piece with interest.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'disc_02',
      title: 'The Windmill Tactic',
      description: 'Tore vs Lasker legendary discovered check sequence motif.',
      fen: '5rk1/5ppp/8/8/8/6B1/5PPP/4R1K1 w - - 0 1',
      moves: ['e1e7', 'g8h8'],
      theme: PuzzleTheme.discoveredAttack,
      rating: 1500,
      explanation: 'Rook penetrates the 7th rank with absolute dominance.',
      playerColor: PieceColor.white,
    ),

    // --- ENDGAME MASTERY ---
    ChessPuzzle(
      id: 'end_01',
      title: 'Pawn Race to the Crown',
      description: 'Calculate the winning pawn push.',
      fen: '8/4P3/8/8/8/8/k7/4K3 w - - 0 1',
      moves: ['e7e8q'],
      theme: PuzzleTheme.endgame,
      rating: 1000,
      explanation: 'Pushing e8=Q promotes the pawn to a Queen, winning the endgame instantly.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'end_02',
      title: 'King Opposition Battle',
      description: 'Take the direct opposition to shepherd your pawn to promotion.',
      fen: '8/8/8/4k3/8/4K3/4P3/8 w - - 0 1',
      moves: ['e3d3', 'e5d5', 'e2e4'],
      theme: PuzzleTheme.endgame,
      rating: 1300,
      explanation: 'White maintains key opposition squares, forcing the defending black king aside.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'end_03',
      title: 'Lucena Bridge Building',
      description: 'The definitive winning rook endgame technique.',
      fen: '1K1k4/1P6/8/8/8/8/7R/1r6 w - - 0 1',
      moves: ['h2h4'],
      theme: PuzzleTheme.endgame,
      rating: 1600,
      explanation: 'Lifting the rook to the 4th rank sets up the bridge to shield the king from continuous vertical checks.',
      playerColor: PieceColor.white,
    ),

    // --- GRANDMASTER MASTERPIECES ---
    ChessPuzzle(
      id: 'gm_01',
      title: 'Morphy\'s Opera Game Brilliancy',
      description: 'Paris Opera 1858: Paul Morphy finishes Duke of Brunswick & Count Isouard.',
      fen: '4kb1r/p2n1ppp/4q3/4p1B1/4P3/1Q6/PPP2PPP/2KR4 w k - 0 1',
      moves: ['b3b8', 'd7b8', 'd1d8'],
      theme: PuzzleTheme.masterpiece,
      rating: 1800,
      explanation: 'Morphy sacrifices his Queen with Qb8+! forcing Nxb8, followed by Rd8# checkmate with Rook and Bishop!',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'gm_02',
      title: 'Fischer\'s Game of the Century',
      description: '13-year-old Bobby Fischer vs Donald Byrne (1956). Find Fischer\'s immortal Queen sacrifice.',
      fen: 'r3r1k1/pp3ppp/2n5/3q4/3P4/2P2N2/P1Q2PPP/R4RK1 b - - 0 1',
      moves: ['e8e1', 'f1e1', 'd5f3'],
      theme: PuzzleTheme.masterpiece,
      rating: 1950,
      explanation: 'Decisive tactical invasion dismantling White\'s king-side defense.',
      playerColor: PieceColor.black,
    ),
    ChessPuzzle(
      id: 'gm_03',
      title: 'Kasparov\'s Immortal Attack',
      description: 'Wijk aan Zee 1999: Kasparov launches a magnificent Rook sacrifice against Topalov.',
      fen: 'r1b1k2r/pp1p1ppp/2n1pn2/q7/2B1P3/2N2N2/PP3PPP/R1BQK2R w KQkq - 0 1',
      moves: ['c1d2', 'a5c5', 'c4e2'],
      theme: PuzzleTheme.masterpiece,
      rating: 2100,
      explanation: 'Kasparov constructs an inescapable tactical web with brilliant piece coordination.',
      playerColor: PieceColor.white,
    ),
    ChessPuzzle(
      id: 'gm_04',
      title: 'Tal\'s Magician From Riga',
      description: 'Mikhail Tal unleashes a devastating tactical storm on the enemy King.',
      fen: 'r1b2rk1/pp1p1ppp/2n1pn2/q7/2B1P3/2N2N2/PP3PPP/R1BQK2R w KQ - 0 1',
      moves: ['c1d2', 'a5c5'],
      theme: PuzzleTheme.masterpiece,
      rating: 2000,
      explanation: 'Unbalancing the position with relentless initiative characteristic of the 8th World Champion.',
      playerColor: PieceColor.white,
    ),
  ];

  static List<ChessPuzzle> getPuzzlesByTheme(PuzzleTheme theme) {
    return allPuzzles.where((p) => p.theme == theme).toList();
  }

  static List<ChessPuzzle> getPuzzlesByDifficulty(PuzzleDifficulty difficulty) {
    return allPuzzles.where((p) => p.difficulty == difficulty).toList();
  }

  static ChessPuzzle? getPuzzleById(String id) {
    try {
      return allPuzzles.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Generate 5 daily puzzles for any given date
  static List<ChessPuzzle> getDaily5Puzzles(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final List<ChessPuzzle> selected = [];

    // Progressive difficulty:
    // Puzzle 1: Beginner Mate in 1 (800 - 1100)
    final m1 = getPuzzlesByTheme(PuzzleTheme.mateIn1);
    selected.add(m1[seed % m1.length]);

    // Puzzle 2: Tactical Fork or Pin (1100 - 1300)
    final tactics = [...getPuzzlesByTheme(PuzzleTheme.fork), ...getPuzzlesByTheme(PuzzleTheme.pin)];
    selected.add(tactics[(seed * 7 + 3) % tactics.length]);

    // Puzzle 3: Mate in 2 or Discovered Attack (1200 - 1500)
    final mid = [...getPuzzlesByTheme(PuzzleTheme.mateIn2), ...getPuzzlesByTheme(PuzzleTheme.discoveredAttack)];
    selected.add(mid[(seed * 13 + 5) % mid.length]);

    // Puzzle 4: Endgame Mastery (1300 - 1700)
    final end = getPuzzlesByTheme(PuzzleTheme.endgame);
    selected.add(end[(seed * 17 + 11) % end.length]);

    // Puzzle 5: Grandmaster Masterpiece (1800 - 2200)
    final gm = getPuzzlesByTheme(PuzzleTheme.masterpiece);
    selected.add(gm[(seed * 23 + 19) % gm.length]);

    return selected;
  }
}
