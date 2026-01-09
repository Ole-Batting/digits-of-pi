const std = @import("std");
const print = std.debug.print;

fn logInt(a: i32, b: i32) i32 {
    const a_f: f64 = @floatFromInt(a);
    const b_f: f64 = @floatFromInt(b);
    return @as(i32, @intFromFloat(@log(a_f) / @log(b_f)));
}

fn logFloat(a: i32, b: i32) f64 {
    const a_f: f64 = @floatFromInt(a);
    const b_f: f64 = @floatFromInt(b);
    return @log(a_f) / @log(b_f);
}

fn sqrtInt(a: i32) i32 {
    const a_f: f64 = @floatFromInt(a);
    return @intFromFloat(@sqrt(a_f));
}

fn mulMod(a: i32, b: i32, m: i32) i32 {
    const a_f: f64 = @floatFromInt(a);
    const b_f: f64 = @floatFromInt(b);
    const m_f: f64 = @floatFromInt(m);
    return @as(i32, @intFromFloat(@mod((a_f * b_f), m_f)));
}

fn invMod(x: i32, y: i32) i32 {
    var u: i32 = x;
    var v: i32 = y;
    var c: i32 = 1;
    var a: i32 = 0;

    var q: i32 = undefined;
    var t: i32 = undefined;
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
    a = @mod(a, y);
    if (a < 0) {
        a = y + a;
    }
    return a;
}

fn powMod(a: i32, b: i32, m: i32) i32 {
    var r: i32 = 1;
    var aa: i32 = a;
    var c: i32 = b;
    while (true) {
        if (c & 1 == 1)
            r = mulMod(r, aa, m);
        c = c >> 1;
        if (c == 0)
            break;
        aa = mulMod(aa, aa, m);
    }
    return r;
}

fn isPrime(n: i32) bool {
    var r: i32 = undefined;
    if (@mod(n, 2) == 0)
        return false;

    r = sqrtInt(n);
    var i: i32 = 3;
    while (i <= r) : (i += 2) {
        if (@mod(n, i) == 0) {
            return false;
        }
    }
    return true;
}

fn nextPrime(n: i32) i32 {
    var m: i32 = n;
    while (true) {
        m += 1;
        if (isPrime(m)) {
            break;
        }
    }
    return m;
}

pub fn main() !void {
    var args = std.process.args();
    _ = args.skip();
    const n = try std.fmt.parseInt(i32, args.next().?, 10);

    const N: i32 = @intFromFloat((@as(f64, @floatFromInt(n)) + 20.0) * logFloat(10, 2));
    var sum: f64 = 0;

    var av: i32 = undefined;
    var vmax: i32 = undefined;
    var num: i32 = undefined;
    var den: i32 = undefined;
    var kq: i32 = undefined;
    var kq2: i32 = undefined;
    var t: i32 = undefined;
    var v: i32 = undefined;
    var s: i32 = undefined;

    var a: i32 = 3;
    while (a <= (2 * N)) : (a = nextPrime(a)) {
        vmax = logInt(2 * N, a);
        av = 1;
        for (0..@intCast(vmax)) |_| {
            av *= a;
        }

        s = 0;
        num = 1;
        den = 1;
        v = 0;
        kq = 1;
        kq2 = 1;

        for (1..@intCast(N + 1)) |k| {
            t = @intCast(k);
            if (kq >= a) {
                while (true) {
                    t = @divTrunc(t, a);
                    v -= 1;
                    if (@mod(t, a) != 0) {
                        break;
                    }
                }
                kq = 0;
            }
            kq += 1;
            num = mulMod(num, t, av);

            t = 2 * @as(i32, @intCast(k)) - 1;
            if (kq2 >= a) {
                if (kq2 == a) {
                    while (true) {
                        t = @divTrunc(t, a);
                        v += 1;
                        if (@mod(t, a) != 0) {
                            break;
                        }
                    }
                }
                kq2 -= a;
            }
            den = mulMod(den, t, av);
            kq2 += 2;

            if (v > 0) {
                t = invMod(den, av);
                t = mulMod(t, num, av);
                t = mulMod(t, @intCast(k), av);
                for (@intCast(v)..@intCast(vmax)) |_| {
                    t = mulMod(t, a, av);
                }
                s += t;
                if (s >= av) {
                    s -= av;
                }
            }
        }

        t = powMod(10, n - 1, av);
        s = mulMod(s, t, av);
        sum = @mod(sum + @as(f64, @floatFromInt(s)) / @as(f64, @floatFromInt(av)), 1);
    }

    print("Decimal digits of pi at position {d}: {d:09}\n", .{ n, @as(usize, @intFromFloat(sum * 1e9)) });
}
