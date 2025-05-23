#!/usr/bin/env bash
set -euxo pipefail
cd "$(dirname "$0")/.."

(
  cd packages/nextcloud/packages/nextcloud_test_presets
  rm -rf docker/presets/*
  fvm dart run nextcloud_test_presets:generate_presets

  # Does not support OCS
  rm docker/presets/terms_of_service/2.5
)

(
  cd packages/nextcloud
  fvm dart run generate_support_table.dart
)
