#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
output_dir="$repo_root/dist"
build_root=$(mktemp -d /tmp/yorukuru-libheif.XXXXXX)
trap 'rm -rf "$build_root"' EXIT

libheif_commit=12a259a5882dd99d45ec5fc77e296a3b620d1e2e
libde265_version=1.1.1
libde265_sha256=fd48a927e94ed74fc7ce8829d222b9d8599fcbfe8b6448ba66705babc56ab219
emscripten_image='emscripten/emsdk@sha256:f174124ff798a3ead1abef247d9a849c270b642d552fea500a42565ff210f765'

git clone --filter=blob:none https://github.com/strukturag/libheif.git "$build_root/libheif"
git -C "$build_root/libheif" checkout --detach "$libheif_commit"
git -C "$build_root/libheif" apply \
  "$repo_root/patches/libheif-emscripten-6.patch"
mkdir "$build_root/libheif/buildjs"

libde265_archive="$build_root/libheif/buildjs/libde265-$libde265_version.tar.gz"
curl --fail --location --silent --show-error \
  "https://github.com/strukturag/libde265/releases/download/v$libde265_version/libde265-$libde265_version.tar.gz" \
  --output "$libde265_archive"
actual_libde265=$(shasum -a 256 "$libde265_archive" | cut -d ' ' -f 1)
test "$actual_libde265" = "$libde265_sha256"
tar xzf "$libde265_archive" -C "$build_root/libheif/buildjs"
mkdir "$build_root/libheif/buildjs/libde265-build"

docker run --rm --platform linux/arm64 \
  -v "$build_root/libheif:/src" \
  -w /src/buildjs/libde265-build \
  "$emscripten_image" \
  bash -lc "emcmake cmake ../libde265-$libde265_version \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DENABLE_SIMD=OFF \
    -DENABLE_SDL=OFF \
    -DENABLE_DECODER=OFF \
    -DENABLE_ENCODER=OFF \
    -DENABLE_SHERLOCK265=OFF \
    -DENABLE_INTERNAL_DEVELOPMENT_TOOLS=OFF \
    -DWITH_FUZZERS=OFF && \
    emmake cmake --build . --parallel 4 && \
    mkdir -p ../libde265-$libde265_version/libde265/.libs && \
    cp libde265/libde265.a ../libde265-$libde265_version/libde265/.libs/libde265.a && \
    cp libde265/de265-version.h ../libde265-$libde265_version/libde265/de265-version.h"

docker run --rm --platform linux/arm64 \
  -v "$build_root/libheif:/src" \
  -w /src/buildjs \
  "$emscripten_image" \
  bash -lc "CORES=4 LIBDE265_VERSION=$libde265_version USE_WASM=1 USE_ES6=1 USE_TYPESCRIPT=0 USE_UNSAFE_EVAL=0 ../build-emscripten.sh .."

expected_js=c75f00a9bc8dc0d98244f0529fe2cce2fd1b44ea91560d0ced5b0dc4f111c722
expected_wasm=08f173cdfc5eea2c8530d1417cb9823f653851e476245032fd5344205b39458e
actual_js=$(shasum -a 256 "$build_root/libheif/buildjs/libheif.js" | cut -d ' ' -f 1)
actual_wasm=$(shasum -a 256 "$build_root/libheif/buildjs/libheif.wasm" | cut -d ' ' -f 1)
test "$actual_js" = "$expected_js"
test "$actual_wasm" = "$expected_wasm"

cp "$build_root/libheif/buildjs/libheif.js" "$output_dir/libheif-1.23.7.js"
cp "$build_root/libheif/buildjs/libheif.wasm" "$output_dir/libheif-1.23.7.wasm"
cp "$build_root/libheif/COPYING" "$repo_root/licenses/libheif-COPYING.txt"
cp "$build_root/libheif/buildjs/libde265-$libde265_version/COPYING" "$repo_root/licenses/libde265-COPYING.txt"
