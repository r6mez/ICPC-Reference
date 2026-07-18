/**
 * Author: Ramez Medhat
 * Description: Tree diameter (longest path, counted in edges) in one DFS.
 * dfs(u) returns the deepest downward path from u; keeping the two
 * deepest child depths, their sum is the best path bending at u.
 * Call dfs(root, -1); answer in diameter.
 * Time: O(V)
 */
vector<vi> adj;
int diameter = 0;

int dfs(int u, int p) { // returns height of u
    int max1 = 0, max2 = 0; // two deepest child depths
    for (int v : adj[u]) if (v != p) {
        int d = dfs(v, u) + 1;
        if (d > max1) max2 = max1, max1 = d;
        else if (d > max2) max2 = d;
    }
    diameter = max(diameter, max1 + max2);
    return max1;
}
