# Digits of $\pi$
Translated from Bellard's [implementation in c](pi.c) to zig.

# Translation Notes:
## invMod
```c
/* return the inverse of x mod y */
int inv_mod(int x, int y)
{
    int q, u, v, a, c, t;

    u = x;
    v = y;
    c = 1;
    a = 0;
    do {
        q = v / u;

        t = c;
        c = a - q * c;
        a = t;

        t = u;
        u = v - q * u;
        v = t;
    } while (u != 0);
    a = a % y;
    if (a < 0)
        a = y + a;
    return a;
}
```
The do-while loop is not available in zig so we'll have to adapt. However we can safely assume `x` and thereby the initial value of `u` will not be 0, as this would not be a solvable input. [Modular multiplicative inverse](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse)
We can even implement the modern example from [Extended euclidean algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Computing_multiplicative_inverses_in_modular_structures)
```zig
fn invMod(x: i32, m: i32) i32 {
    var t: i32 = 0;
    var newt: i32 = 1;
    var r: i32 = m;
    var newr: i32 = x;

    var q: i32 = undefined;
    var tmp: i32 = undefined;
    while (newr != 0) {
        q = @divTrunc(r, newr);

        tmp = newt;
        newt = t - q * newt;
        t = tmp;

        tmp = newr;
        newr = r - q * newr;
        r = tmp;
    }

    if (t < 0) {
        t = t + m;
    }
    return t;
}
```
