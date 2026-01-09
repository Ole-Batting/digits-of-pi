# Digits of \pi
Translated from Bellard's [implementation in c](pi.c) to zig.

# Translation Notes:
## do-while
The do-while loop is not available in zig so the following code in c:
```c
do {
    q = v / u;

    t = c;
    c = a - q * c;
    a = t;

    t = u;
    u = v - q * u;
    v = t;
} while (u != 0);
```
could be translated faithfully as such:
```zig
while (true) {
    q = @divTrunc(v, u);

    t = c;
    c = a - q * c;
    a = t;

    t = u;
    u = v - q * u;
    v = t;
    if (u == 0) {
        break;
    }
}
```
