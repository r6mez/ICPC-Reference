/**
 * Author: Ramez Medhat
 * Description: 2D range update, range query for sums. 1-INDEXED.
 * 2D version of RURQ: a range add is a 2D difference update at the 4
 * rectangle corners; four weighted trees make the prefix sum come out as
 * prefix(x,y) = s1*x*y - s2*x - s3*y + s4 (same idea as B1/B2 in 1D,
 * one tree per term of (x - i + 1)(y - j + 1) expanded).
 * Usage: Fenwick2DRURQ fw(n, m);
 * fw.update(x1, y1, x2, y2, v); // rectangle += v
 * fw.query(x1, y1, x2, y2); // sum over rectangle
 * Time: $O(\log N \cdot \log M)$
 */
#pragma once
struct Fenwick2DRURQ {
    int n, m;
    vector<vi> T1, T2, T3, T4; // 1, (y-1), (x-1), (x-1)(y-1) weights

    Fenwick2DRURQ(int n, int m) : n(n), m(m),
        T1(n + 1, vi(m + 1, 0)), T2(n + 1, vi(m + 1, 0)),
        T3(n + 1, vi(m + 1, 0)), T4(n + 1, vi(m + 1, 0)) {}

    void add(vector<vi>& t, int x, int y, int v) {
        for (int i = x; i <= n; i += i & -i)
            for (int j = y; j <= m; j += j & -j)
                t[i][j] += v;
    }

    void corner(int x, int y, int v) { // 2D difference at one corner
        add(T1, x, y, v);
        add(T2, x, y, v * (y - 1));
        add(T3, x, y, v * (x - 1));
        add(T4, x, y, v * (x - 1) * (y - 1));
    }

    void update(int x1, int y1, int x2, int y2, int v) {
        corner(x1, y1, v);      corner(x1, y2 + 1, -v);
        corner(x2 + 1, y1, -v); corner(x2 + 1, y2 + 1, v);
    }

    int prefix(int x, int y) { // sum of a[1..x][1..y]
        int s1 = 0, s2 = 0, s3 = 0, s4 = 0;
        for (int i = x; i > 0; i -= i & -i)
            for (int j = y; j > 0; j -= j & -j) {
                s1 += T1[i][j]; s2 += T2[i][j];
                s3 += T3[i][j]; s4 += T4[i][j];
            }
        return s1 * x * y - s2 * x - s3 * y + s4;
    }

    int query(int x1, int y1, int x2, int y2) {
        return prefix(x2, y2) - prefix(x1 - 1, y2)
             - prefix(x2, y1 - 1) + prefix(x1 - 1, y1 - 1);
    }
};
