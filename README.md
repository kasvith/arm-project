# Image processing with ARM

This is a simple ARM program which allows manipulation of matrixes.

Input `[rows] [cols] [opcode] {data}`

Opcodes are follow

- Original        **0**
- Inversion       **1**
- Rotate by 180   **2**
- Flip            **3**

# Example

Input

```3 4 1 43 45 123 132 164 234 12 211 32 121 1 200```

Output

```
Inversion
212 210 132 123
91 21 243 44
223 134 254 55
```
