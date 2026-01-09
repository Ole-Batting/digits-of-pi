import argparse
import math

log = math.log

def mul_mod(a: int, b: int, m: int) -> int:
    return (float(a) * float(b)) % m

def inv_mod(x: int, y: int) -> int:
    q: int
    t: int
    u: int = x
    v: int = y
    c: int = 1
    a: int = 0

    while True:
        q = v // u

        t = c
        c = a - q * c
        a = t

        t = u
        u = v - q * u
        v = t

        if u == 0:
            break

    a = a % y
    if a < 0:
        a = y + a
    return a

def pow_mod(a: int, b: int, m: int) -> int:
    r: int = 1
    aa: int = a

    while True:
        if b & 1:
            r = mul_mod(r, aa, m)
        b = b >> 1
        if b == 0:
            break
        aa = mul_mod(aa, aa, m)

    return r

def is_prime(n: int) -> bool:
    r: int
    i: int

    if n % 2 == 0:
        return False

    r = int(n**0.5)
    for i in range(3, r+1, 2):
        if n % i == 0:
            return False

    return True

def next_prime(n: int) -> int:
    while True:
        n += 1
        if is_prime(n):
            break
    return n

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", required=True, type=int)
    args = parser.parse_args()

    n: int = args.n
    assert n > 0

    av: int
    vmax: int
    num: int
    den: int
    k: int
    kq: int
    kq2: int
    t: int
    v: int
    s: int
    i: int

    N: int = int((n + 20) * log(10) / log(2))

    _sum: float = 0

    a: int = 3
    while a <= 2 * N:
        vmax = int(log(2 * N) / log(a))
        av = 1
        for i in range(vmax):
            av = av * a

        s = 0
        num = 1
        den = 1
        v = 0
        kq = 1
        kq2 = 1

        for k in range(1, N+1):

            t = k
            if kq >= a:
                while True:
                    t = t / a
                    v -= 1
                    if t % a != 0:
                        break
                kq = 0
            kq += 1
            num = mul_mod(num, t, av)

            t = 2 * k - 1
            if kq2 >= a:
                if kq2 == a:
                    while True:
                        t = t / a
                        v -= 1
                        if t % a != 0:
                            break
                kq2 -= a
            den = mul_mod(den, t, av)
            kq2 += 2

            if v > 0:
                t = inv_mod(den, av)
                t = mul_mod(t, num, av)
                t = mul_mod(t, k, av)
                for i in range(v, vmax):
                    t = mul_mod(t, a, av)
                s += t
                if s >= av:
                    s -= av

        t = pow_mod(10, n - 1, av)
        s = mul_mod(s, t, av)
        _sum = (_sum + float(s) / float(av)) % 1

        a = next_prime(a)
    print(f"Decimal digits of pi at position {n}: {int(_sum * 1e9):09d}")

if __name__ == "__main__":
    main()
