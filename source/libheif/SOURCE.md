# libheif 1.23.2 対応ソース

- 上流固定コミット: `ac1cb05c39008f01525c991ff8b88f84ddf70fd2`
- 上流: https://github.com/strukturag/libheif/tree/ac1cb05c39008f01525c991ff8b88f84ddf70fd2
- 適用パッチ: `patches/libheif-emscripten-6.patch`
- 再生成手順: `scripts/build-libheif-wasm.sh`

上流ソースへパッチを適用し、指定されたEmscripten環境とlibde265版で`dist/`の成果物を再生成します。
