/**
 * Author: Ramez Medhat
 * Description: Range update, point query. 1-INDEXED. Trick: Fenwick over
 * the DIFFERENCE array d[i] = a[i] - a[i-1]. Adding v on [l,r] only
 * changes d[l] += v and d[r+1] -= v; a[i] is then the prefix sum d[1..i].
 * Usage: FenwickRUPQ fw(n); fw.add(l, r, v); // a[l..r] += v
 * fw.query(i); // value of a[i]
 * Time: O(\log N)
 */
struct FenwickRUPQ {
    int n; vi f;
    FenwickRUPQ(int n) : n(n), f(n + 1, 0) {}

    void upd(int i, int v) { // d[i] += v (no-op if i = n+1)
        for (; i <= n; i += i & -i) f[i] += v;
    }

    void add(int l, int r, int v) { upd(l, v); upd(r + 1, -v); }

    int query(int i) { // a[i] = sum of d[1..i]
        int s = 0;
        for (; i > 0; i -= i & -i) s += f[i];
        return s;
    }
};
