#!/bin/bash
# Run all vtpu evals and generate report

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==================================="
echo "vtpu Evals - Full Suite"
echo "==================================="
echo ""

# Check if vtpu is built
if [ ! -f "/source/vtpu/target/release/asi" ]; then
    echo "ERROR: vtpu not built. Run:"
    echo "  cd /source/vtpu && cargo build --release"
    exit 1
fi

# Run each eval category
EVALS=(
    "intent_to_siw"
    "siw_to_phonetic"
)

TOTAL_PASSED=0
TOTAL_FAILED=0

for eval_name in "${EVALS[@]}"; do
    echo "-----------------------------------"
    echo "Running: $eval_name"
    echo "-----------------------------------"
    
    if [ -f "evals/$eval_name/run.py" ]; then
        python3 "evals/$eval_name/run.py" || {
            echo "FAILED: $eval_name"
            ((TOTAL_FAILED++))
            continue
        }
        echo "PASSED: $eval_name"
        ((TOTAL_PASSED++))
    else
        echo "SKIP: $eval_name (no run.py found)"
    fi
    echo ""
done

echo "==================================="
echo "Results Summary"
echo "==================================="
echo "Passed: $TOTAL_PASSED"
echo "Failed: $TOTAL_FAILED"
echo ""

if [ $TOTAL_FAILED -gt 0 ]; then
    echo "❌ Some evals failed"
    exit 1
else
    echo "✅ All evals passed"
    exit 0
fi
