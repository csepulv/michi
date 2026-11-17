# Vendored files

The library's search uses MiniSearch, copied here unchanged so that a library works from disk without a network.

| File | Source | Version | SHA-256 |
|---|---|---|---|
| `minisearch.js` | npm `minisearch`, `dist/umd/index.js` | 7.2.0 | `03c27931eb603af1d3358579e9885eafdb6a2f5fa9929557b3e77d7e99d06d03` |
| `minisearch-LICENSE.txt` | npm `minisearch`, `LICENSE.txt` (MIT) | 7.2.0 | |

`build-html.sh` copies both into every build. To update, take the new version's files from `npm pack minisearch@<version>`,
record the version and checksum here, and rerun the library's checks.
