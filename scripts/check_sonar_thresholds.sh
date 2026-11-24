#!/usr/bin/env bash
# Menegakkan ambang kualitas SonarCloud langsung dari CI.
# Berjalan di semua plan karena memakai Web API, bukan custom quality gate.
set -euo pipefail

PROJECT_KEY="${SONAR_PROJECT_KEY:-Junx27_kicaugo-mobile}"
MIN_COVERAGE="${SONAR_MIN_COVERAGE:-100}"
MAX_DUPLICATION="${SONAR_MAX_DUPLICATION:-3}"
MAX_ATTEMPTS=12
INTERVAL=10

METRICS='security_rating,reliability_rating,maintainability_rating,security_hotspots_reviewed,coverage,duplicated_lines_density,new_security_rating,new_reliability_rating,new_maintainability_rating,new_security_hotspots_reviewed,new_coverage,new_duplicated_lines_density,new_lines'

curl_args=(
  --silent --show-error
  --user "${SONAR_TOKEN}:"
  --get 'https://sonarcloud.io/api/measures/component'
  --data-urlencode "component=${PROJECT_KEY}"
  --data-urlencode "metricKeys=${METRICS}"
)

# Analisis PR memakai pullRequest, analisis push ke master memakai branch.
if [[ -n "${PR_NUMBER:-}" ]]; then
  curl_args+=(--data-urlencode "pullRequest=${PR_NUMBER}")
else
  curl_args+=(--data-urlencode "branch=${BRANCH_NAME:-master}")
fi

# Hasil analisis belum langsung tersedia setelah scanner selesai upload.
response=''
for ((attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)); do
  response="$(curl "${curl_args[@]}" || true)"
  if printf '%s' "$response" |
    jq -e '.component.measures | length > 0' >/dev/null 2>&1; then
    break
  fi
  if ((attempt == MAX_ATTEMPTS)); then
    echo "Gagal mengambil metrik SonarCloud setelah ${MAX_ATTEMPTS} percobaan."
    printf '%s\n' "$response"
    exit 1
  fi
  sleep "$INTERVAL"
done

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

failures=()

check_rating() {
  local key="$1" label="$2" value
  value="$(metric_value "$key")"
  if [[ "$value" != '1' ]]; then
    failures+=("${label}: $(rating_label "$value") (wajib A)")
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

# Overall code: kode lama ikut dinilai, tidak seperti gate bawaan SonarCloud.
check_rating security_rating 'Security (overall)'
check_rating reliability_rating 'Reliability (overall)'
check_rating maintainability_rating 'Maintainability (overall)'
check_number security_hotspots_reviewed 'Hotspots reviewed (overall)' ge 100
check_number coverage 'Coverage (overall)' ge "$MIN_COVERAGE"
check_number duplicated_lines_density 'Duplication (overall)' le "$MAX_DUPLICATION"

# New code dilewati bila tidak ada baris baru (misal push pertama ke master).
new_lines="$(metric_value new_lines)"
if [[ "$new_lines" != 'nan' && "$new_lines" != '0' ]]; then
  check_rating new_security_rating 'Security (new code)'
  check_rating new_reliability_rating 'Reliability (new code)'
  check_rating new_maintainability_rating 'Maintainability (new code)'
  check_number new_security_hotspots_reviewed 'Hotspots reviewed (new code)' ge 100
  check_number new_coverage 'Coverage (new code)' ge "$MIN_COVERAGE"
  check_number new_duplicated_lines_density 'Duplication (new code)' le "$MAX_DUPLICATION"
fi

if ((${#failures[@]} > 0)); then
  echo 'SonarCloud quality threshold gagal:'
  printf '  - %s\n' "${failures[@]}"
  exit 1
fi

echo "SonarCloud quality threshold lolos (coverage >= ${MIN_COVERAGE}%)."
