import argparse
import io
import json
import re
from pathlib import Path

import chess
import pymupdf
from fontTools.cffLib import CFFFontSet
from fontTools.pens.svgPathPen import SVGPathPen

TOTAL_PUZZLES = 5334
SOLUTION_OVERRIDES = {3518: "1.Ke7"}
PIECE_CODES = {
    "K": "K", "J": "K", "Q": "Q", "L": "Q", "R": "R", "S": "R",
    "A": "B", "B": "B", "M": "N", "N": "N", "O": "P", "P": "P",
    "k": "k", "j": "k", "q": "q", "l": "q", "r": "r", "s": "r",
    "a": "b", "b": "b", "m": "n", "n": "n", "o": "p", "p": "p",
}
PUZZLE_GROUPS = (
    (306, "mateIn1", "Mate in one", 900),
    (3718, "mateIn2", "Mate in two", 1250),
    (4462, "mateIn3", "Mate in three", 1550),
    (5062, "miniatureGames", "Miniature game", 1750),
    (5206, "endgame", "Endgame", 1600),
    (TOTAL_PUZZLES, "polgarCombinations", "Game combination", 2050),
)
RANK_PATTERN = re.compile(r"^[1-8][A-Za-z0-9]{8}$")
ENTRY_PATTERN = re.compile(r"^(\d{1,4})\s+(\S.*)$")


def encode_board(rows):
    fen_rows = []
    for row in rows:
        encoded = row[1:]
        fen_row = []
        empty_count = 0
        for code in encoded:
            piece = PIECE_CODES.get(code)
            if piece is not None:
                if empty_count:
                    fen_row.append(str(empty_count))
                    empty_count = 0
                fen_row.append(piece)
            elif code in "0Z":
                empty_count += 1
            else:
                raise ValueError(f"Unknown board glyph: {code}")
        if empty_count:
            fen_row.append(str(empty_count))
        fen_rows.append("".join(fen_row))
    return "/".join(fen_rows)


def extract_diagrams(document):
    diagrams = {}
    for page in document:
        lines = [line.strip() for line in page.get_text().splitlines()]
        for index, line in enumerate(lines[:-8]):
            if not line.isdigit():
                continue
            puzzle_id = int(line)
            if not 1 <= puzzle_id <= TOTAL_PUZZLES:
                continue
            rows = lines[index + 1:index + 9]
            if len(rows) != 8 or not all(RANK_PATTERN.fullmatch(row) for row in rows):
                continue
            if "".join(row[0] for row in rows) != "87654321":
                continue
            if puzzle_id in diagrams:
                raise ValueError(f"Puzzle {puzzle_id} has multiple diagrams")
            diagrams[puzzle_id] = encode_board(rows)
    return diagrams


def extract_solutions(document):
    solutions = {}
    current_id = None
    in_solutions = False
    for page in document:
        text = page.get_text()
        if not in_solutions:
            if "8.1 Solutions" not in text:
                continue
            in_solutions = True
        for line in text.splitlines():
            line = line.strip()
            if not line:
                continue
            match = ENTRY_PATTERN.fullmatch(line)
            if match:
                puzzle_id = int(match.group(1))
                rest = match.group(2)
                if rest.startswith("Problems"):
                    continue
                if 1 <= puzzle_id <= TOTAL_PUZZLES and re.match(r"^\d+\.", rest):
                    current_id = puzzle_id
                    solutions[current_id] = rest
                    continue
            if current_id is not None and not line.startswith("8.1 Solutions"):
                solutions[current_id] += " " + line
    return solutions


def remove_variations(text):
    result = []
    depth = 0
    for character in text:
        if character in "([":
            depth += 1
        elif character in ")]":
            depth = max(depth - 1, 0)
        elif depth == 0:
            result.append(character)
    return "".join(result)


def solution_tokens(text):
    text = text.split("\u00a0", 1)[0]
    text = re.sub(r"Di(?:a)?-\s*a?gram", "Diagram", text, flags=re.IGNORECASE)
    diagram_matches = list(re.finditer(r"\(\s*Diagram\s*\)", text, flags=re.IGNORECASE))
    diagram_index = diagram_matches[-1].start() if diagram_matches else -1
    has_diagram_marker = diagram_index >= 0
    diagram_text = ""
    if has_diagram_marker:
        diagram_text = text[diagram_matches[-1].end():]
        text = text[diagram_matches[-1].end():]
    mainline = remove_variations(text).replace("\u00a0", " ").replace("\u2013", "-")
    mainline = re.sub(r"O-O-\s+O", "O-O-O", mainline)
    mainline = re.sub(r"O-\s+O", "O-O", mainline)
    turn_match = re.match(r"\s*(\d+)\.(\.\.)?", mainline)
    fullmove = int(turn_match.group(1)) if turn_match else 1
    black_to_move = bool(turn_match and turn_match.group(2))
    mainline = re.sub(r"\b\d+\.(?:\.\.)?", " ", mainline)

    tokens = []
    for token in mainline.split():
        token = token.replace("0-0", "O-O").replace("X", "x")
        token = re.sub(r"[!?]+$", "", token)
        if token in {"1-0", "0-1", "1/2-1/2", "-", "-+", "+-", "½-½"}:
            break
        if token in {"...", "e.p.", "Diagram"} or not token:
            continue
        token = re.sub(r"([a-h][18])([QRBN])([+#]?)$", r"\1=\2\3", token)
        is_mate = token.endswith("m")
        if is_mate:
            token = token[:-1]
        tokens.append(token)
        if is_mate:
            break
    if has_diagram_marker and not tokens:
        variation = re.search(r"\(([^()]*)\)", diagram_text)
        if variation:
            variation_tokens, _, _, _ = solution_tokens(variation.group(1))
            return variation_tokens[1:], False, fullmove, has_diagram_marker
    return tokens, black_to_move, fullmove, has_diagram_marker


def build_fen_and_moves(placement, text):
    tokens, black_to_move, fullmove, has_diagram_marker = solution_tokens(text)
    if not tokens:
        raise ValueError("No solution moves")
    turn = chess.BLACK if black_to_move else chess.WHITE
    aligned_board = None
    if not has_diagram_marker and not black_to_move and fullmove == 1:
        replay = chess.Board()
        if replay.board_fen() == placement:
            aligned_board = replay
        else:
            for index, token in enumerate(tokens):
                try:
                    replay.push_san(token)
                except ValueError:
                    break
                if replay.board_fen() == placement:
                    tokens = tokens[index + 1:]
                    turn = replay.turn
                    fullmove = replay.fullmove_number
                    aligned_board = replay.copy()
                    break

    if not tokens:
        raise ValueError("Diagram occurs after the final solution move")

    if aligned_board is not None:
        rights = aligned_board.castling_xfen() or "-"
        ep_square = chess.square_name(aligned_board.ep_square) if aligned_board.ep_square is not None else "-"
    else:
        placement_board = chess.Board(placement)
        castling = set()
        home_squares = (
            (chess.WHITE, chess.E1, chess.H1, chess.A1, "K", "Q"),
            (chess.BLACK, chess.E8, chess.H8, chess.A8, "k", "q"),
        )
        for color, king_square, king_rook, queen_rook, kingside, queenside in home_squares:
            if placement_board.piece_at(king_square) == chess.Piece(chess.KING, color):
                if placement_board.piece_at(king_rook) == chess.Piece(chess.ROOK, color):
                    castling.add(kingside)
                if placement_board.piece_at(queen_rook) == chess.Piece(chess.ROOK, color):
                    castling.add(queenside)
        rights = "".join(code for code in "KQkq" if code in castling) or "-"
        ep_square = "-"
    ep_match = re.match(r"^[a-h]x([a-h][36])$", tokens[0])
    if ep_match and aligned_board is None:
        target = chess.parse_square(ep_match.group(1))
        target_file = chess.square_file(target)
        captured_rank = 4 if turn else 3
        captured = chess.square(target_file, captured_rank)
        source_rank = captured_rank
        source_file = ord(tokens[0][0]) - ord("a")
        source = chess.square(source_file, source_rank)
        if placement_board.piece_at(target) is None and placement_board.piece_at(captured) == chess.Piece(chess.PAWN, not turn) and placement_board.piece_at(source) == chess.Piece(chess.PAWN, turn):
            ep_square = chess.square_name(target)

    fen = f"{placement} {'w' if turn else 'b'} {rights} {ep_square} 0 {fullmove}"
    board = chess.Board(fen)
    uci_moves = []
    san_moves = []
    for index, token in enumerate(tokens):
        try:
            move = board.parse_san(token)
        except ValueError as error:
            if index == 0 and not black_to_move:
                board = chess.Board(f"{placement} {'b' if turn else 'w'} {rights} {ep_square} 0 {fullmove}")
                try:
                    move = board.parse_san(token)
                    turn = board.turn
                    fen = board.fen()
                except ValueError:
                    raise ValueError(f"Cannot parse {token!r} in {board.fen()}: {error}") from error
            elif uci_moves:
                break
            else:
                raise ValueError(f"Cannot parse {token!r} in {board.fen()}: {error}") from error
        san_moves.append(board.san(move))
        uci_moves.append(move.uci())
        board.push(move)
    return fen, uci_moves, san_moves, "white" if turn else "black"


def puzzle_metadata(puzzle_id):
    for last_id, theme, label, rating in PUZZLE_GROUPS:
        if puzzle_id <= last_id:
            return theme, label, rating
    raise ValueError(f"No category for puzzle {puzzle_id}")


def import_puzzles(pdf_path):
    document = pymupdf.open(pdf_path)
    diagrams = extract_diagrams(document)
    solutions = extract_solutions(document)
    missing_diagrams = sorted(set(range(1, TOTAL_PUZZLES + 1)) - diagrams.keys())
    missing_solutions = sorted(set(range(1, TOTAL_PUZZLES + 1)) - solutions.keys())
    if missing_diagrams or missing_solutions:
        raise ValueError(
            f"Expected {TOTAL_PUZZLES} entries; found {len(diagrams)} diagrams and "
            f"{len(solutions)} solutions. Missing diagrams: {missing_diagrams[:12]}; "
            f"missing solutions: {missing_solutions[:12]}"
        )

    puzzles = []
    errors = []
    for puzzle_id in range(1, TOTAL_PUZZLES + 1):
        try:
            solution = SOLUTION_OVERRIDES.get(puzzle_id, solutions[puzzle_id])
            fen, moves, san, color = build_fen_and_moves(diagrams[puzzle_id], solution)
            theme, label, rating = puzzle_metadata(puzzle_id)
            puzzles.append({
                "id": f"polgar_{puzzle_id:04d}",
                "title": f"Problem {puzzle_id}",
                "description": f"{label}. {color.capitalize()} to move.",
                "fen": fen,
                "moves": moves,
                "san": san,
                "theme": theme,
                "rating": rating,
                "color": color,
            })
        except Exception as error:
            errors.append(f"{puzzle_id}: {error}")
    if errors:
        raise ValueError(f"Could not validate {len(errors)} puzzles:\n" + "\n".join(errors[:30]))
    return puzzles


def dart_string(value):
    return json.dumps(value, ensure_ascii=True)


def write_dart(puzzles, output_path):
    lines = [
        "import '../core/chess/chess_models.dart';",
        "import 'models/puzzle_model.dart';",
        "",
        "const List<ChessPuzzle> polgarPuzzles = [",
    ]
    for puzzle in puzzles:
        moves = ", ".join(dart_string(move) for move in puzzle["moves"])
        san = " ".join(puzzle["san"])
        lines.extend([
            "  ChessPuzzle(",
            f"    id: {dart_string(puzzle['id'])},",
            f"    title: {dart_string(puzzle['title'])},",
            f"    description: {dart_string(puzzle['description'])},",
            f"    fen: {dart_string(puzzle['fen'])},",
            f"    moves: [{moves}],",
            f"    theme: PuzzleTheme.{puzzle['theme']},",
            f"    rating: {puzzle['rating']},",
            f"    explanation: {dart_string('Main line: ' + san)},",
            f"    playerColor: PieceColor.{puzzle['color']},",
            "  ),",
        ])
    lines.extend(["];"])
    Path(output_path).write_text("\n".join(lines) + "\n", encoding="utf-8")


def render_glyph_sheet(pdf_path, output_path):
    document = pymupdf.open(pdf_path)
    font_xref = next(
        font[0]
        for font in document.get_page_fonts(15, full=True)
        if "SkakNew-Diagram" in font[3]
    )
    cff = CFFFontSet()
    cff.decompile(io.BytesIO(document.extract_font(font_xref)[3]), None)
    font = cff[0]
    names = [name for name in font.charset if name != ".notdef"]

    elements = []
    for index, name in enumerate(names):
        pen = SVGPathPen(None)
        font.CharStrings[name].draw(pen)
        x = index % 9 * 78 + 4
        y = index // 9 * 105
        elements.append(
            f'<g transform="translate({x},{y + 78}) scale(.06,-.06)">'
            f'<path d="{pen.getCommands()}" fill="black"/></g>'
        )
        elements.append(
            f'<text x="{x + 14}" y="{y + 101}" font-size="18">{name}</text>'
        )

    svg = (
        '<svg xmlns="http://www.w3.org/2000/svg" width="710" height="330" '
        f'viewBox="0 0 710 330">{"".join(elements)}</svg>'
    )
    image = pymupdf.open(stream=svg.encode(), filetype="svg")
    image[0].get_pixmap().save(output_path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("pdf")
    parser.add_argument("output")
    args = parser.parse_args()
    puzzles = import_puzzles(args.pdf)
    write_dart(puzzles, args.output)
    print(f"Wrote {len(puzzles)} validated puzzles to {args.output}")


if __name__ == "__main__":
    main()