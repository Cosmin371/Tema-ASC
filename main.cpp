#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <time.h>

std::ofstream fout("test0_10.in");

int dx[8] = {-1, -1, -1, 0, 1, 1, 1, 0};
int dy[8] = {-1, 0, 1, 1, 1, 0, -1, -1};

int main () {

    srand (time(NULL));
    while (1) {
        int a[100][100] = {0}, res[100][100] = {0};
        int n, m;
        n = std::rand () % 18 + 1;
        m = std::rand () % 18 + 1;
        for (int i = 1; i <= n; i += 1)
            for (int j = 1; j <= m; j += 1)
                a[i][j] = std::rand () % 2, res[i][j] = a[i][j];

        fout << n << '\n' << m << '\n';

        int nrUnu = 0;
        for (int i = 1; i <= n; i += 1)
            for (int j = 1; j <= m; j += 1)
                if (a[i][j] == 1)
                    nrUnu += 1;

        fout << nrUnu << '\n';

        for (int i = 1; i <= n; i += 1)
            for (int j = 1; j <= m; j += 1)
                if (a[i][j] == 1)
                    fout << i - 1 << '\n' << j - 1 << '\n';
/*
    for (int i = 1; i <= n; i += 1)
        for (int j = 1; j <= m; j += 1)
            if (a[i][j] == 1)
                std::cout << i << ' ' << j << '\n';
    std::cout << '\n';
*/
        int contor = 0;
        int k; k = std::rand () % 15 + 1; fout << k << '\n';
        for (int index = 0; index < k; index += 1) {
            for (int i = 1; i <= n; i += 1)
                for (int j = 1; j <= m; j += 1) {
                    contor = 0;
                    for (int k = 0; k < 8; k += 1) {
                        int newLine = i + dx[k];
                        int newColumn = j + dy[k];

                        contor += a[newLine][newColumn];
                    }

                    if (a[i][j] == 1) {
                        if (contor < 2 || contor > 3)
                            res[i][j] = 0;
                    } else {
                        if (contor == 3)
                            res[i][j] = 1;
                    }
                }

                for (int i = 1; i <= n; i += 1)
                    for (int j = 1; j <= m; j += 1)
                        a[i][j] = res[i][j];

                std::cout << index + 1 << ":\n";
                for (int i = 1; i <= n; i += 1) {
                    for (int j = 1; j <= m; j += 1)
                        std::cout << res[i][j] << ' ';
                    std::cout << '\n';
                }
                std::cout << '\n';
        }

        for (int i = 1; i <= n; i += 1) {
                for (int j = 1; j <= m; j += 1)
                    fout << res[i][j] << ' ';
                fout << '\n';
        }

        std::string stop; std::cin >> stop;
    }
    return 0;
}
