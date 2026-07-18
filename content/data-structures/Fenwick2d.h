/**
 * Author: Ramez Medhat
 * Description: 2D point update, range query. 1-INDEXED. Same as 1D but
 * every bucket is itself a Fenwick over the second coordinate.
 * Rectangle sum by inclusion-exclusion of four prefix rectangles.
 * Usage: Fenwick2DPURQ fw(n, m); fw.add(x, y, v); // a[x][y] += v
 * fw.sum(x1, y1, x2, y2); // sum over the rectangle
 * Time: $O(\log N \cdot \log M)$
 */
#pragma once
struct Fenwick2DPURQ {
    int n, m;
    vector<vi> f;
    Fenwick2DPURQ(int n, int m) : n(n), m(m), f(n + 1, vi(m + 1, 0)) {}

    void add(int x, int y, int v) { // a[x][y] += v
        for (int i = x; i <= n; i += i & -i)
            for (int j = y; j <= m; j += j & -j)
                f[i][j] += v;
    }

    int prefix(int x, int y) { // sum of a[1..x][1..y]
        int s = 0;
        for (int i = x; i > 0; i -= i & -i)
            for (int j = y; j > 0; j -= j & -j)
                s += f[i][j];
        return s;
    }

    int sum(int x1, int y1, int x2, int y2) {
        return prefix(x2, y2) - prefix(x1 - 1, y2)
             - prefix(x2, y1 - 1) + prefix(x1 - 1, y1 - 1);
    }
};
