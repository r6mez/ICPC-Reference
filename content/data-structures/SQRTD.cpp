
/**
 * Author: Mohamed El-Sayed
 * Description:   Square‐root decomposition for range sum queries with point updates.
  Preprocesses the array into blocks of size ~sqrt(n), maintaining the sum of each block.
  query(l, r): returns the sum of arr[l..r] in O(sqrt(n)) time.
  update(idx, val): updates arr[idx] to val and adjusts the corresponding block sum in O(1).
  When to use:
  - You have an array of size n (up to $10^5$) with mixed range‐sum queries and point updates.
  - You need better performance than O(n) per operation but segment trees are overkill.
 * Time: O(sqrt(n)) per query, O(1) per update.
 * Status: stress-tested
 */
#include <bits/stdc++.h>
using namespace std;

using vi = vector<int>;

int n, q, SQ;
vi arr, blkSum;

void preProcess() {
    for (int i = 0; i < n; ++i) {
        int blk = i / SQ;
        blkSum[blk] += arr[i];
    }
}

int query(int l, int r) {
    int ans = 0;
    while (l <= r) {
        if (l % SQ == 0 && l + SQ - 1 <= r) {
            ans += blkSum[l / SQ];
            l += SQ;
        } else {
            ans += arr[l];
            ++l;
        }
    }
    return ans;
}

void update(int idx, int val) {
    int blk = idx / SQ;
    blkSum[blk] -= arr[idx];
    arr[idx] = val;
    blkSum[blk] += val;
}

void solve() {
    cin >> n >> q;
    arr.resize(n);
    cin >> arr;

    SQ = ceil(sqrt(n));
    blkSum.assign((n + SQ - 1) / SQ, 0);

    preProcess();

    while (q--) {
        int op;
        cin >> op;
        if (op == 1) {
            int pos, val;
            cin >> pos >> val;
            update(pos - 1, val);
        } else {
            int l, r;
            cin >> l >> r;
            cout << query(l - 1, r - 1) << "\n";
        }
    }
}
