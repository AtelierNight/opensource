# libheif 1.23.7 対応ソース

- 上流固定コミット: `12a259a5882dd99d45ec5fc77e296a3b620d1e2e`
- 上流: https://github.com/strukturag/libheif/tree/12a259a5882dd99d45ec5fc77e296a3b620d1e2e
- 適用パッチ: `patches/libheif-emscripten-6.patch`
- 再生成手順: `scripts/build-libheif-wasm.sh`

上流ソースへパッチを適用し、指定されたEmscripten環境とlibde265版で`dist/`の成果物を再生成します。

パッチはC++リンカーとlibde265の版確認関数を使い、単一スレッドWASM向けのビルドでは上流テスト実行物を生成しません。上流の`read_color_profile_properties`はnativeビルドで別途検査します。

過去の1.23.2配布物の固定コミットは`ac1cb05c39008f01525c991ff8b88f84ddf70fd2`です。当時のパッチと手順は[公開履歴](https://github.com/AtelierNight/opensource/tree/06291f0)に保持しています。
