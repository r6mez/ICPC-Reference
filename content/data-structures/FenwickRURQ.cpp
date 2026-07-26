/**
 * Author: Ramez Medhat
 * Description: Range update, range query. 1-INDEXED. Two Fenwicks:
 * after update(l,r,v), prefix(i) = i * sumB1(i) - sumB2(i), where B1
 * holds the difference array (slope) and B2 the correction so that
 * the linear term is exact at both ends of the range.
 * Usage: FenwickRURQ fw(n); fw.update(l, r, v); // a[l..r] += v
 * fw.query(l, r); // sum of a[l..r]
 * Time: O(\log N)
 */
struct FenwickRURQ {
    int n; vi B1, B2;
    FenwickRURQ(int n) : n(n), B1(n + 1, 0), B2(n + 1, 0) {}

    void add(vi& f, int i, int v) {
        for (; i <= n; i += i & -i) f[i] += v;
    }

    void update(int l, int r, int v) {
        add(B1, l, v); add(B1, r + 1, -v);
        add(B2, l, v * (l - 1)); add(B2, r + 1, -v * r);
    }

    int sum(vi& f, int i) {
        int s = 0;
        for (; i > 0; i -= i & -i) s += f[i];
        return s;
    }

    int prefix(int i) { return i * sum(B1, i) - sum(B2, i); }

    int query(int l, int r) { return prefix(r) - prefix(l - 1); }
};
