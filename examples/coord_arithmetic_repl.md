# Coordinate Arithmetic REPL Examples

## Basic Operations

### Addition (CADD)
```
vtpu> status
vTPU Status
  Fleet: 9 sentrons (0 running)
  Total cycles: 0

vtpu> # Load coordinate (3,3,3,...)
vtpu> sindex r3 3.3.3/3.3.3/3.3.3.3.3
Coordinate r3 = [3.3.3/3.3.3/3.3.3.3.3]

vtpu> # Load coordinate (5,5,5,...)  
vtpu> sindex r5 5.5.5/5.5.5/5.5.5.5.5
Coordinate r5 = [5.5.5/5.5.5/5.5.5.5.5]

vtpu> # Add them: r8 = r3 + r5 = (8,8,8,...)
vtpu> cadd r8, r3, r5
Coordinate r8 = [8.8.8/8.8.8/8.8.8.8.8]
```

### Subtraction (CSUB)
```
vtpu> # Subtract: r2 = r5 - r3 = (2,2,2,...)
vtpu> csub r2, r5, r3
Coordinate r2 = [2.2.2/2.2.2/2.2.2.2.2]
```

### Multiplication (CMUL)
```
vtpu> # Multiply: r15 = r3 * r5 = (15,15,15,...)
vtpu> cmul r15, r3, r5
Coordinate r15 = [15.15.15/15.15.15/15.15.15.15.15]
```

### Scale (CSCALE)
```
vtpu> # Scale: r21 = r3 * 7 = (21,21,21,...)
vtpu> cscale r21, r3, 7
Coordinate r21 = [21.21.21/21.21.21/21.21.21.21.21]
```

---

## The Core Insight: 17 = 5×3 + (5-3)

**Problem:** Base-13 addressing limits coordinates to 1-13 per dimension.  
**Solution:** Compute coordinate 17 from base coordinates 3 and 5.

```
vtpu> # Step 1: Load base coordinates
vtpu> sindex r3 3.3.3/3.3.3/3.3.3.3.3
Coordinate r3 = [3.3.3/3.3.3/3.3.3.3.3]

vtpu> sindex r5 5.5.5/5.5.5/5.5.5.5.5
Coordinate r5 = [5.5.5/5.5.5/5.5.5.5.5]

vtpu> # Step 2: Compute product = 3 × 5 = 15
vtpu> cmul r15, r3, r5
Coordinate r15 = [15.15.15/15.15.15/15.15.15.15.15]

vtpu> # Step 3: Compute difference = 5 - 3 = 2
vtpu> csub r2, r5, r3
Coordinate r2 = [2.2.2/2.2.2/2.2.2.2.2]

vtpu> # Step 4: Compute 17 = 15 + 2
vtpu> cadd r17, r15, r2
Coordinate r17 = [17.17.17/17.17.17/17.17.17.17.17]

vtpu> # SUCCESS: We can now access coordinate 17!
vtpu> # This breaks the base-13 addressing limit
```

---

## Edge Cases

### Underflow (Saturation to 0)
```
vtpu> # What happens when we subtract larger from smaller?
vtpu> sindex r3 3.3.3/3.3.3/3.3.3.3.3
Coordinate r3 = [3.3.3/3.3.3/3.3.3.3.3]

vtpu> sindex r10 10.10.10/10.10.10/10.10.10.10.10
Coordinate r10 = [10.10.10/10.10.10/10.10.10.10.10]

vtpu> # r3 - r10 should saturate to 0 (not go negative)
vtpu> csub rz, r3, r10
Coordinate rz = [0.0.0/0.0.0/0.0.0.0.0]
```

### Overflow (Saturation to MAX_DIM = 2047)
```
vtpu> # What happens when we multiply large values?
vtpu> sindex r100 100.100.100/100.100.100/100.100.100.100.100
Coordinate r100 = [100.100.100/100.100.100/100.100.100.100.100]

vtpu> # 100 × 100 = 10,000 > MAX_DIM (2047)
vtpu> cmul rmax, r100, r100
Coordinate rmax = [2047.2047.2047/2047.2047.2047/2047.2047.2047.2047.2047]

vtpu> # Saturated to MAX_DIM, no panic
```

### Identity Element
```
vtpu> # Zero is the identity for addition
vtpu> sindex rz 0.0.0/0.0.0/0.0.0.0.0
Coordinate rz = [0.0.0/0.0.0/0.0.0.0.0]

vtpu> sindex r42 42.42.42/42.42.42/42.42.42.42.42
Coordinate r42 = [42.42.42/42.42.42/42.42.42.42.42]

vtpu> # r42 + 0 = r42
vtpu> cadd r42b, r42, rz
Coordinate r42b = [42.42.42/42.42.42/42.42.42.42.42]

vtpu> # r42 - 0 = r42
vtpu> csub r42c, r42, rz
Coordinate r42c = [42.42.42/42.42.42/42.42.42.42.42]
```

---

## Mixed Dimensions

```
vtpu> # Non-uniform coordinates
vtpu> sindex ra 1.2.3/4.5.6/7.8.9.10.11
Coordinate ra = [1.2.3/4.5.6/7.8.9.10.11]

vtpu> sindex rb 10.20.30/40.50.60/70.80.90.100.110
Coordinate rb = [10.20.30/40.50.60/70.80.90.100.110]

vtpu> # Element-wise addition
vtpu> cadd rc, ra, rb
Coordinate rc = [11.22.33/44.55.66/77.88.99.110.121]

vtpu> # Each dimension adds independently
```

---

## Commutativity Verification

```
vtpu> # Addition is commutative: a + b = b + a
vtpu> sindex r3 3.3.3/3.3.3/3.3.3.3.3
vtpu> sindex r5 5.5.5/5.5.5/5.5.5.5.5

vtpu> cadd rab, r3, r5
Coordinate rab = [8.8.8/8.8.8/8.8.8.8.8]

vtpu> cadd rba, r5, r3
Coordinate rba = [8.8.8/8.8.8/8.8.8.8.8]

vtpu> # rab == rba ✓

vtpu> # Multiplication is commutative: a × b = b × a
vtpu> cmul rab, r3, r5
Coordinate rab = [15.15.15/15.15.15/15.15.15.15.15]

vtpu> cmul rba, r5, r3
Coordinate rba = [15.15.15/15.15.15/15.15.15.15.15]

vtpu> # rab == rba ✓
```

---

## Expected Behavior Summary

| Operation | Input | Expected Output | Notes |
|-----------|-------|-----------------|-------|
| `cadd r, a, b` | a=(3,3,...), b=(5,5,...) | r=(8,8,...) | Element-wise |
| `csub r, a, b` | a=(10,10,...), b=(3,3,...) | r=(7,7,...) | Element-wise |
| `cmul r, a, b` | a=(3,3,...), b=(5,5,...) | r=(15,15,...) | Element-wise |
| `cscale r, a, k` | a=(7,7,...), k=3 | r=(21,21,...) | Broadcast |
| Underflow | a=(3,...), b=(10,...), `a-b` | (0,0,...) | Saturate to 0 |
| Overflow | a=(100,...), b=(100,...), `a*b` | (2047,...) | Saturate to MAX |
| Identity | a=(42,...), b=(0,...), `a+b` | (42,...) | Zero identity |

---

## Unexpected Behavior to Avoid

**DO NOT:**
- Wrap on overflow (should saturate to 2047)
- Go negative on underflow (should saturate to 0)
- Panic on invalid input (should return error gracefully)
- Modify dimensions independently of operation (element-wise only)
- Assume modular arithmetic (we use saturation)

**DO:**
- Saturate to bounds (0 ≤ value ≤ 2047)
- Operate element-wise across all 11 dimensions
- Preserve commutativity and associativity
- Return predictable results for edge cases
