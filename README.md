# YORUKURU OSS配布物

YORUKURUのブラウザー内HEIC・HEIF画像変換で使用するWebAssembly配布物と、再生成に必要な情報を公開します。

## 対象

- `libheif` 1.23.2
- `libde265` 1.1.1（HEVC復号）
- Emscripten `6.0.8`

ライセンスは`licenses/`、配信済みのビルド成果物は`dist/`、対応ソースと固定版の情報は`source/`、適用パッチは`patches/`、再生成手順は`scripts/`にあります。

## 再生成

```sh
./scripts/build-libheif-wasm.sh
```

このスクリプトは固定した上流コミット、libde265の取得先とSHA-256、Emscriptenイメージを検証してから`dist/`へ生成します。

## 注意

このリポジトリはYORUKURU本体ではありません。YORUKURU本体のソース、設定、秘密情報、利用者データは含めません。
