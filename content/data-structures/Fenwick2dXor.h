/**
 * Author: Ramez Medhat
 * Description: 2D range XOR update, range XOR query. 1-INDEXED.
 * Xor has no multiplication, so the RURQ weight trick fails; instead
 * a corner update at (i,j) reaches a[x][y] an odd number of times iff
 * (x-i) and (y-j) are both even, i.e. x,y have the same parities as i,j.
 * Keep 4 trees indexed by (x&1, y&1) and update/query only the
 * matching one.
 * Usage: Fenwick2DXor fw(n, m);
 * fw.update(x1, y1, x2, y2, v); // rectangle ^= v
 * fw.query(x1, y1, x2, y2); // xor over rectangle
 * Time: $O(\log N \cdot \log M)$
 */
#pragma once
struct Fenwick2DXor {
    int n, m;
    vector<vi> bit[2][2]; // one tree per (x parity, y parity)

    Fenwick2DXor(int n, int m) : n(n), m(m) {
        for (int px = 0; px < 2; px++)
            for (int py = 0; py < 2; py++)
                bit[px][py].assign(n + 1, vi(m + 1, 0));
    }

    void corner(int x, int y, int v) {
        for (int i = x; i <= n; i += i & -i)
            for (int j = y; j <= m; j += j & -j)
                bit[x & 1][y & 1][i][j] ^= v;
    }

    void update(int x1, int y1, int x2, int y2, int v) {
        corner(x1, y1, v);     corner(x2 + 1, y1, v);
        corner(x1, y2 + 1, v); corner(x2 + 1, y2 + 1, v);
    }

    int prefix(int x, int y) { // xor over a[1..x][1..y]
        if (x <= 0 || y <= 0) return 0;
        int s = 0;
        for (int i = x; i > 0; i -= i & -i)
            for (int j = y; j > 0; j -= j & -j)
                s ^= bit[x & 1][y & 1][i][j];
        return s;
    }

    int query(int x1, int y1, int x2, int y2) {
        return prefix(x2, y2) ^ prefix(x1 - 1, y2)
             ^ prefix(x2, y1 - 1) ^ prefix(x1 - 1, y1 - 1);
    }
};
