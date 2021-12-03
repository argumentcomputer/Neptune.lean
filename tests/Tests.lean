import Neptune

def main: IO Unit := do
  println! "r={Neptune.poseidon #[1, 1].toList.toByteArray}"
