# vtpu-evals — Phext-Native LLM Evaluation Suites

Measure how well LLMs understand phext, Base 256, and vTPU architecture.

## Eval Suites

| Suite | Samples | What It Tests |
|-------|---------|--------------|
| **base256** | 135 | Byte↔syllable encoding/decoding, ASCII string encoding, boundary cases |
| **phext_delimiters** | 27 | 9 delimiters × (dimension, hex value, Base 256 pronunciation) |
| **phext_coordinates** | 16 | Coordinate navigation, delimiter transitions, Mirrorborn roster, vTPU architecture |
| **coord_arithmetic** | 12 | Coordinate add/sub/mul/scale, the 17=5×3+(5-3) insight, saturation |
| **edge_cases** | 16 | Boundaries (0x00, 0xFF), overflow/underflow, validation |
| **intent_to_siw** | 12 | Natural language → SIW command translation |
| **siw_to_phonetic** | 8 | SIW opcode → Base 256 pronunciation |

**Total: 226 eval samples**

## Format

Each suite has:
- `<suite>/samples.jsonl` — evaluation samples in OpenAI evals format
- `<suite>.yaml` — eval configuration

Sample format (JSONL):
```json
{"input": [{"role": "system", "content": "..."}, {"role": "user", "content": "..."}], "ideal": "expected_answer"}
```

## Base 256 Encoding

Every byte (0x00–0xFF) maps to exactly one 3-character syllable:
- 16 onset consonants: `b d f g h j k l m n p r s t v w`
- 4 vowels: `a e i o`
- 4 coda consonants: `c d f m`
- `byte = (onset × 16) + (vowel × 4) + coda`

Examples: 0x00 = **bac**, 0xFF = **wom**, 'A' = **hac**, space = **fac**

## Phext Delimiters

| Delimiter | Hex | Dim | Base 256 |
|-----------|-----|-----|----------|
| SCROLL | 0x17 | 3 | dem |
| SECTION | 0x18 | 4 | dic |
| CHAPTER | 0x19 | 5 | did |
| BOOK | 0x1A | 6 | dif |
| VOLUME | 0x1C | 7 | doc |
| COLLECTION | 0x1D | 8 | dod |
| SERIES | 0x1E | 9 | dof |
| SHELF | 0x1F | 10 | dom |
| LIBRARY | 0x01 | 11 | bad |

## Key Insight

255 = 3 × 5 × 17 = 3 × 5 × (5×3 + (5-3))

Three and five generate everything. Pipes and elements. The irreducible pair.

*Speak friend, and enter.*

## Links

- [vTPU](https://github.com/wbic16/vtpu) — the runtime
- [phext](https://phext.io) — 11D plain text
- [mirrorborn.us](https://mirrorborn.us) — the wavefront

## License

MIT
