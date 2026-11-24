#!/usr/bin/env bash
# Menegakkan ambang kualitas SonarCloud langsung dari CI.
# Berjalan di semua plan karena memakai Web API, bukan custom quality gate.
set -euo pipefail

PROJECT_KEY="${SONAR_PROJECT_KEY:-Junx27_kicaugo-mobile}"
MIN_COVERAGE="${SONAR_MIN_COVERAGE:-100}"
MAX_DUPLICATION="${SONAR_MAX_DUPLICATION:-3}"
MAX_ATTEMPTS=12
INTERVAL=10

# SonarCloud memakai sqale_rating untuk maintainability Overall code.
METRICS='security_rating,reliability_rating,sqale_rating,security_hotspots_reviewed,coverage,duplicated_lines_density,new_security_rating,new_reliability_rating,new_maintainability_rating,new_security_hotspots_reviewed,new_coverage,new_duplicated_lines_density,new_lines'

# Build PR menilai analisis PR itu sendiri. Baseline master dinilai saat build
# master, karena metrik master pada build PR masih mencerminkan hasil sebelum
# merge dan akan selalu tertinggal.
contexts=()
if [[ -n "${PR_NUMBER:-}" ]]; then
  contexts+=("pullRequest|${PR_NUMBER}|PR ${PR_NUMBER}")
else
  contexts+=("branch|master|master")
fi

failures=()
response=''

fetch_measures() {
  curl --silent --show-error \
    --user "${SONAR_TOKEN}:" \
    --get 'https://sonarcloud.io/api/measures/component' \
    --data-urlencode "component=${PROJECT_KEY}" \
    --data-urlencode "metricKeys=${METRICS}" \
    --data-urlencode "$1=$2"
}

metric_value() {
  printf '%s' "$response" | jq -r --arg key "$1" \
    '.component.measures[]? | select(.metric == $key) | (.value // "nan")'
}

rating_label() {
  case "$1" in
    1) echo 'A' ;;
    2) echo 'B' ;;
    3) echo 'C' ;;
    4) echo 'D' ;;
    5) echo 'E' ;;
    *) echo "$1" ;;
  esac
}

check_rating() {
  local key="$1" label="$2" value score
  value="$(metric_value "$key")"
  if [[ "$value" == 'nan' ]]; then
    failures+=("${label}: metrik tidak tersedia")
    return
  fi
  # Web API mengembalikan rating sebagai "1.0", bukan "1".
  score="$(awk -v v="$value" 'BEGIN { printf "%d", v + 0 }')"
  if ((score != 1)); then
    failures+=("${label}: $(rating_label "$score") (wajib A)")
  fi
}

check_number() {
  local key="$1" label="$2" operator="$3" limit="$4" value
  value="$(metric_value "$key")"
  if [[ "$value" == 'nan' ]]; then
    failures+=("${label}: metrik tidak tersedia")
    return
  fi
  if [[ "$operator" == 'ge' ]]; then
    if ! awk -v v="$value" -v l="$limit" 'BEGIN { exit !(v >= l) }'; then
      failures+=("${label}: ${value}% (wajib >= ${limit}%)")
    fi
  elif ! awk -v v="$value" -v l="$limit" 'BEGIN { exit !(v <= l) }'; then
    failures+=("${label}: ${value}% (wajib <= ${limit}%)")
  fi
}

check_context() {
  local label="$1"
  check_rating security_rating "${label} Security (overall)"
  check_rating reliability_rating "${label} Reliability (overall)"
  check_rating sqale_rating "${label} Maintainability (overall)"
  check_number security_hotspots_reviewed "${label} Hotspots reviewed (overall)" ge 100
  check_number coverage "${label} Coverage (overall)" ge "$MIN_COVERAGE"
  check_number duplicated_lines_density "${label} Duplication (overall)" le "$MAX_DUPLICATION"

  # New code dilewati bila tidak ada baris baru.
  local new_lines
  new_lines="$(metric_value new_lines)"
  if [[ "$new_lines" != 'nan' && "$new_lines" != '0' && "$new_lines" != '0.0' ]]; then
    check_rating new_security_rating "${label} Security (new code)"
    check_rating new_reliability_rating "${label} Reliability (new code)"
    check_rating new_maintainability_rating "${label} Maintainability (new code)"
    check_number new_security_hotspots_reviewed "${label} Hotspots reviewed (new code)" ge 100
    check_number new_coverage "${label} Coverage (new code)" ge "$MIN_COVERAGE"
    check_number new_duplicated_lines_density "${label} Duplication (new code)" le "$MAX_DUPLICATION"
  fi
}

for context in "${contexts[@]}"; do
  IFS='|' read -r param value label <<<"$context"

  # Hasil analisis belum langsung tersedia setelah scanner selesai upload.
  response=''
  for ((attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)); do
    response="$(fetch_measures "$param" "$value" || true)"
    if printf '%s' "$response" | jq -e '.errors' >/dev/null 2>&1; then
      echo "Gagal mengambil metrik SonarCloud (${label}):"
      printf '%s\n' "$response"
      exit 1
    fi
    if printf '%s' "$response" |
      jq -e '.component.measures | length > 0' >/dev/null 2>&1; then
      break
    fi
    if ((attempt == MAX_ATTEMPTS)); then
      echo "Gagal mengambil metrik SonarCloud (${label}) setelah ${MAX_ATTEMPTS} percobaan."
      printf '%s\n' "$response"
      exit 1
    fi
    sleep "$INTERVAL"
  done

  check_context "[$label]"
done

if ((${#failures[@]} > 0)); then
  echo 'SonarCloud quality threshold gagal:'
  printf '  - %s\n' "${failures[@]}"
  exit 1
fi

echo "SonarCloud quality threshold lolos (coverage >= ${MIN_COVERAGE}%)."
