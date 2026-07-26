/**
 * Author: Mohamed El-Sayed
 * Description:    Mo's algorithm (offline) for answering range‐distinct queries.
  Sorts queries into sqrt-blocks by L, then R, and moves two pointers
  to maintain current range, updating a frequency table.
 * Time: O((N + Q)*sqrt(N)) Memory O(N + Q).
 * Status: stress-tested
 */

struct Query {
    int l, r, idx;
    bool operator<(const Query &other) const {
        const int BLOCK = 450;            // sqrt(max(N))
        int b1 = l / BLOCK;
        int b2 = other.l / BLOCK;
        if (b1 != b2) return b1 < b2;
        return r < other.r;
    }
};

void solve() {
    fastio();
    int n, q;
    cin >> n >> q;
    vector<int> a(n);
    for (int &x : a) cin >> x;

    vector<Query> queries(q);
    for (int i = 0; i < q; ++i) {
        int l, r;
        cin >> l >> r;
        queries[i] = {l - 1, r - 1, i};
    }

    sort(queries.begin(), queries.end());

    const int MAXV = 1'000'005;
    vector<int> freq(MAXV, 0);
    int distinct = 0, curL = 0, curR = -1;
    vector<int> ans(q);

    for (auto &qr : queries) {
        while (curR < qr.r) {
            if (++freq[a[++curR]] == 1) ++distinct;
        }
        while (curR > qr.r) {
            if (--freq[a[curR--]] == 0) --distinct;
        }
        while (curL < qr.l) {
            if (--freq[a[curL++]] == 0) --distinct;
        }
        while (curL > qr.l) {
            if (++freq[a[--curL]] == 1) ++distinct;
        }
        ans[qr.idx] = distinct;
    }

    for (int x : ans) {
        cout << x << '\n';
    }
}
