# Pembungkus perintah Flutter per flavor.
#
# Contoh:
#   make run-dev
#   make run-stg device=emulator-5554
#   make build-apk-production
#
# `FLUTTER_APP_FLAVOR` tidak ditaruh di env/*.json karena dikelola Flutter
# lewat `--flavor` / `default-flavor` di pubspec.yaml.

FLUTTER ?= flutter
device ?=
ENV_DIR := env

.PHONY: help pod-install \
	run-dev run-stg run-production \
	build-apk-dev build-apk-stg build-apk-production \
	build-ios-dev build-ios-stg build-ios-production

help: ## Tampilkan daftar target
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-24s %s\n", $$1, $$2}'

pod-install: ## Pasang Pod untuk skema flavor iOS
	cd ios && pod install

run-dev: ## Jalankan flavor dev (fake data by default)
	$(FLUTTER) run $(if $(device),-d "$(device)",) --flavor dev --dart-define-from-file=$(ENV_DIR)/dev.json

run-stg: ## Jalankan flavor staging
	$(FLUTTER) run $(if $(device),-d "$(device)",) --flavor stg --dart-define-from-file=$(ENV_DIR)/stg.json

run-production: ## Jalankan flavor produksi
	$(FLUTTER) run $(if $(device),-d "$(device)",) --flavor production --dart-define-from-file=$(ENV_DIR)/production.json

build-apk-dev: ## Build APK debug flavor dev
	$(FLUTTER) build apk --flavor dev --debug --dart-define-from-file=$(ENV_DIR)/dev.json

build-apk-stg: ## Build APK release flavor staging
	$(FLUTTER) build apk --flavor stg --release --dart-define-from-file=$(ENV_DIR)/stg.json

build-apk-production: ## Build APK release flavor produksi
	$(FLUTTER) build apk --flavor production --release --dart-define-from-file=$(ENV_DIR)/production.json

build-ios-dev: ## Build iOS simulator flavor dev
	$(FLUTTER) build ios --flavor dev --simulator --no-codesign --dart-define-from-file=$(ENV_DIR)/dev.json

build-ios-stg: ## Build iOS simulator flavor staging
	$(FLUTTER) build ios --flavor stg --simulator --no-codesign --dart-define-from-file=$(ENV_DIR)/stg.json

build-ios-production: ## Build iOS simulator flavor produksi
	$(FLUTTER) build ios --flavor production --simulator --no-codesign --dart-define-from-file=$(ENV_DIR)/production.json
