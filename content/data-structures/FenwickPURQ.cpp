/**
 * Author: Ramez Medhat
 * Description: Point update, range query. 1-INDEXED. The classic Fenwick:
 * f[i] holds the sum of the i & -i elements ending at i, so every prefix
 * splits into $O(\log n)$ buckets. Works for any invertible op (+, xor);
 * NOT min/max/gcd, since query() subtracts prefixes.
 * lower\_bound needs all elements $\geq 0$.
 * Usage: FenwickPURQ fw(n); fw.add(i, x); // a[i] += x
 * fw.query(l, r); // sum of a[l..r]
 * fw.lower_bound(v); // smallest i with prefix(i) >= v, n+1 if none
 * Time: O(\log N)
 */
struct FenwickPURQ {
    int n; vi f;
    FenwickPURQ(int n) : n(n), f(n + 1, 0) {}

    void add(int i, int v) { // a[i] += v
        for (; i <= n; i += i & -i) f[i] += v;
    }

    int prefix(int i) { // sum of a[1..i]
        int s = 0;
        for (; i > 0; i -= i & -i) s += f[i];
        return s;
    }

    int query(int l, int r) { return prefix(r) - prefix(l - 1); }

    // binary lifting: grow pos by decreasing powers of two while
    // the sum stays below v
    int lower_bound(int v) {
        int pos = 0;
        for (int pw = 1 << __lg(n); pw; pw >>= 1)
            if (pos + pw <= n && f[pos + pw] < v) v -= f[pos += pw];
        return pos + 1;
    }
};
