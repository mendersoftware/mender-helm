#!/bin/bash

set -euo pipefail

# Global variables
TMP_DIR=""
NAMESPACE=""
HELM_RELEASE=""
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RAND_SUFFIX=$(od -An -N3 -tx1 /dev/urandom 2>/dev/null | tr -d ' \n')
SUPPORT_BUNDLE="mender_support_${TIMESTAMP}_${RAND_SUFFIX}.tar.gz"
MASK_SECRETS="${MASK_SECRETS:-true}" # Can be disabled with MASK_SECRETS=false
MAX_LOG_LINES="${MAX_LOG_LINES:-1000}"
MONGO_IMAGE="${MONGO_IMAGE:-mongo:8.0}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Security: Set restrictive umask
umask 077

# Cleanup function
cleanup() {
  local exit_code=$?
  echo -e "\n${YELLOW}Cleaning up...${NC}"
  if [[ -n "$TMP_DIR" ]] && [[ -d "$TMP_DIR" ]]; then
    if command -v shred >/dev/null 2>&1; then
      find "$TMP_DIR" -type f -exec shred -fz {} \; 2>/dev/null || true
    else
      print_msg "$YELLOW" "Warning: 'shred' not available - temp files removed with rm only (not cryptographically wiped)"
    fi
    rm -rf "$TMP_DIR"
    echo -e "${GREEN}Temporary directory cleaned up${NC}"
  fi
  exit $exit_code
}

# Set trap for cleanup on script exit
trap cleanup EXIT INT TERM

# Function to print colored messages
print_msg() {
  local color=$1
  local msg=$2
  echo -e "${color}${msg}${NC}"
}

# Function to check if a command exists and is in a secure location
check_command() {
  local cmd=$1
  local cmd_path

  if ! cmd_path=$(command -v "$cmd" 2>/dev/null); then
    print_msg "$RED" "Error: $cmd is not installed or not in PATH"
    return 1
  fi

  # Security: Warn if command is not in standard system paths
  case "$cmd_path" in
  /usr/bin/* | /usr/local/bin/* | /bin/* | /sbin/* | /usr/sbin/*)
    print_msg "$GREEN" "✓ $cmd is installed at $cmd_path"
    ;;
  *)
    print_msg "$YELLOW" "⚠ Warning: $cmd is installed in non-standard location: $cmd_path"
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      return 1
    fi
    ;;
  esac
  return 0
}

# Function to check all required tools
check_requirements() {
  print_msg "$YELLOW" "Checking required tools..."
  local all_good=true

  for tool in helm kubectl jq; do
    if ! check_command "$tool"; then
      all_good=false
    fi
  done

  if [[ "$all_good" == false ]]; then
    print_msg "$RED" "Please install missing tools before running this script"
    exit 1
  fi

  # Verify kubectl cluster connectivity before proceeding
  print_msg "$YELLOW" "Verifying cluster connectivity..."
  if ! kubectl cluster-info >/dev/null 2>&1; then
    print_msg "$RED" "Error: Cannot connect to Kubernetes cluster."
    print_msg "$RED" "Check your kubeconfig and cluster availability."
    exit 1
  fi
  print_msg "$GREEN" "✓ Cluster connectivity verified"

  echo ""
}

# Function to validate namespace name (security: prevent injection)
validate_name() {
  local name=$1
  local type=$2

  # Allow only alphanumeric, dash, underscore, and dot
  if [[ ! "$name" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    print_msg "$RED" "Error: Invalid $type name. Contains forbidden characters."
    exit 1
  fi

  # Prevent directory traversal
  if [[ "$name" == *".."* ]]; then
    print_msg "$RED" "Error: Invalid $type name. Directory traversal detected."
    exit 1
  fi
}

# Function to select namespace
select_namespace() {
  print_msg "$YELLOW" "Fetching available namespaces..."

  # Get namespaces and store in array (safe from word splitting)
  local namespaces=()
  while IFS= read -r ns; do
    namespaces+=("$ns")
  done < <(kubectl get ns -o json | jq -r '.items[].metadata.name' | sort)

  if [[ ${#namespaces[@]} -eq 0 ]]; then
    print_msg "$RED" "No namespaces found"
    exit 1
  fi

  print_msg "$GREEN" "Available namespaces:"
  for i in "${!namespaces[@]}"; do
    printf "%3d) %s\n" $((i + 1)) "${namespaces[$i]}"
  done

  while true; do
    read -p "Select namespace (1-${#namespaces[@]}): " selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && ((selection >= 1 && selection <= ${#namespaces[@]})); then
      NAMESPACE="${namespaces[$((selection - 1))]}"
      validate_name "$NAMESPACE" "namespace"
      print_msg "$GREEN" "Selected namespace: $NAMESPACE"
      echo ""
      break
    else
      print_msg "$RED" "Invalid selection. Please try again."
    fi
  done
}

# Function to select helm release
select_helm_release() {
  print_msg "$YELLOW" "Fetching Helm releases in namespace '$NAMESPACE'..."

  # Get helm releases in the selected namespace (safe from word splitting)
  local releases=()
  while IFS= read -r release; do
    releases+=("$release")
  done < <(helm ls -n "$NAMESPACE" -o json | jq -r '.[].name' | sort)

  if [[ ${#releases[@]} -eq 0 ]]; then
    print_msg "$RED" "No Helm releases found in namespace '$NAMESPACE'"
    exit 1
  fi

  # Check if 'mender' exists in the releases
  local default_selection=""
  for i in "${!releases[@]}"; do
    if [[ "${releases[$i]}" == "mender" ]]; then
      default_selection=$((i + 1))
      break
    fi
  done

  print_msg "$GREEN" "Available Helm releases:"
  for i in "${!releases[@]}"; do
    if [[ "${releases[$i]}" == "mender" ]]; then
      printf "%3d) %s (default)\n" $((i + 1)) "${releases[$i]}"
    else
      printf "%3d) %s\n" $((i + 1)) "${releases[$i]}"
    fi
  done

  while true; do
    if [[ -n "$default_selection" ]]; then
      read -p "Select Helm release (1-${#releases[@]}) [default: $default_selection]: " selection
      selection=${selection:-$default_selection}
    else
      read -p "Select Helm release (1-${#releases[@]}): " selection
    fi

    if [[ "$selection" =~ ^[0-9]+$ ]] && ((selection >= 1 && selection <= ${#releases[@]})); then
      HELM_RELEASE="${releases[$((selection - 1))]}"
      validate_name "$HELM_RELEASE" "release"
      print_msg "$GREEN" "Selected Helm release: $HELM_RELEASE"
      echo ""
      break
    else
      print_msg "$RED" "Invalid selection. Please try again."
    fi
  done
}

# Function to create temporary directory with secure permissions
create_tmp_dir() {
  print_msg "$YELLOW" "Creating temporary directory..."
  # Security: Create temp dir with restricted permissions (700)
  TMP_DIR=$(mktemp -d -t mender-support-XXXXXX)
  chmod 700 "$TMP_DIR"
  print_msg "$GREEN" "Temporary directory created: $TMP_DIR (mode 700)"
  echo ""
}

# Function to collect helm history
collect_helm_history() {
  local output_file="$TMP_DIR/helm_history.txt"
  print_msg "$YELLOW" "Collecting Helm history for release '$HELM_RELEASE'..."

  {
    echo "Helm History for release: $HELM_RELEASE"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  if helm history "$HELM_RELEASE" -n "$NAMESPACE" >>"$output_file" 2>&1; then
    chmod 600 "$output_file"
    print_msg "$GREEN" "✓ Helm history saved to $(basename "$output_file")"
  else
    print_msg "$YELLOW" "⚠ Error collecting helm history, see $(basename "$output_file") for details"
  fi
}

# Function to collect helm list output
collect_helm_list() {
  local output_file="$TMP_DIR/helm_list.txt"
  print_msg "$YELLOW" "Collecting Helm list output..."

  {
    echo "Helm List Output"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  if helm ls -n "$NAMESPACE" -a >>"$output_file" 2>&1; then
    chmod 600 "$output_file"
    print_msg "$GREEN" "✓ Helm list saved to $(basename "$output_file")"
  else
    print_msg "$YELLOW" "⚠ Error collecting helm list, see $(basename "$output_file") for details"
  fi
}

# Function to mask secrets in output.
# NOTE: ["\s] inside sed [] is broken - always use ["[:space:]] for clarity.
# NOTE: [^\s] inside sed [] is broken - always use [^[:space:]] for clarity.
mask_secrets() {
  if [[ "$MASK_SECRETS" != "true" ]]; then
    cat
    return
  fi

  sed -E \
    -e 's/(password[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(passwd["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(pwd["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(secret[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(token[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(api[-_]?key[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(api[-_]?secret[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(access[-_]?key[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(private[-_]?key[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(credential[s]?["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(auth["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(authorization["[:space:]]*:["[:space:]]*)[^"\n]+/\1***MASKED***/gi' \
    -e 's/(bearer["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(jwt["[:space:]]*:["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/gi' \
    -e 's/(AWS_ACCESS_KEY_ID["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(AWS_SECRET_ACCESS_KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(AWS_SESSION_TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(AWS_SECURITY_TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(AZURE_[A-Z_]*SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(AZURE_[A-Z_]*KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(AZURE_[A-Z_]*TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(AZURE_CLIENT_SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(GCP_[A-Z_]*KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(GOOGLE_[A-Z_]*KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(GCLOUD_[A-Z_]*KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(GITHUB_TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(GITLAB_TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(DOCKER_[A-Z_]*TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(DOCKER_PASSWORD["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(NPM_TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(DATABASE_URL["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(MONGODB_URI["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(MONGO_URL["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(MONGO_CONN_STR["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(POSTGRES_PASSWORD["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(MYSQL_[A-Z_]*PASSWORD["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(REDIS_PASSWORD["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(RABBITMQ_PASSWORD["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(ELASTIC[A-Z_]*PASSWORD["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(STRIPE_[A-Z_]*KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(SLACK_[A-Z_]*TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(SENDGRID_API_KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(MAILGUN_API_KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(TWILIO_[A-Z_]*TOKEN["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(SSH_[A-Z_]*KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(RSA_[A-Z_]*KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(OIDC_[A-Z_]*SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(OAUTH_[A-Z_]*SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(JWT_SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(SESSION_SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(ENCRYPTION_KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(SIGNING_KEY["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(CLIENT_SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(CONSUMER_SECRET["[:space:]]*[=:]["[:space:]]*)[^"[:space:],}]+/\1***MASKED***/g' \
    -e 's/(password|passwd|secret|token|credential|api[-_]?key|private[-_]?key|auth)[a-zA-Z_0-9-]*[[:space:]]*=[[:space:]]*[^"[:space:],}]+/\1=***MASKED***/gi' \
    -e 's/(AKID[A-Z0-9]{16})/***AWS_ACCESS_KEY***/g' \
    -e 's/(AKIA[A-Z0-9]{16})/***AWS_ACCESS_KEY***/g' \
    -e 's/(ASIA[A-Z0-9]{16})/***AWS_TEMP_KEY***/g' \
    -e 's/mongodb(\+srv)?:\/\/[^[:space:]"]+/***MONGODB_URL***/g' \
    -e 's/eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]*/***JWT_TOKEN***/g' \
    -e 's/(-----BEGIN[^-]+-----)[^-]+(-----END[^-]+-----)/\1***CERTIFICATE_CONTENT***\2/g' \
    -e 's/(Bearer[[:space:]]+)[^[:space:]]+/\1***MASKED***/gi' \
    -e 's/(Basic[[:space:]]+)[^[:space:]]+/\1***MASKED***/gi' \
    -e 's/(ghp_[a-zA-Z0-9]{36})/***GITHUB_TOKEN***/g' \
    -e 's/(ghs_[a-zA-Z0-9]{36})/***GITHUB_TOKEN***/g' \
    -e 's/(glpat-[a-zA-Z0-9_-]{20,})/***GITLAB_TOKEN***/g' \
    -e 's/(sk_live_[a-zA-Z0-9]{24,})/***STRIPE_LIVE_KEY***/g' \
    -e 's/(sk_test_[a-zA-Z0-9]{24,})/***STRIPE_TEST_KEY***/g' \
    -e 's/(xox[baprs]-[a-zA-Z0-9-]+)/***SLACK_TOKEN***/g'
}

# Function to collect helm values
collect_helm_values() {
  local output_file="$TMP_DIR/helm_values.yaml"
  print_msg "$YELLOW" "Collecting Helm values for release '$HELM_RELEASE' (secrets will be masked)..."

  # First, get the values into a temporary variable to avoid pipe failures
  local values_output
  if values_output=$(helm get values "$HELM_RELEASE" -n "$NAMESPACE" --all 2>&1); then
    {
      echo "# Helm Values for release: $HELM_RELEASE"
      echo "# Namespace: $NAMESPACE"
      echo "# Timestamp: $(date)"
      echo "# Note: Sensitive values have been masked with ***MASKED***"
      echo "# ----------------------------------------"
      echo "$values_output" | mask_secrets
    } >"$output_file"
    chmod 600 "$output_file"
    print_msg "$GREEN" "✓ Helm values saved to $(basename "$output_file")"
  else
    {
      echo "# Helm Values for release: $HELM_RELEASE"
      echo "# Namespace: $NAMESPACE"
      echo "# Timestamp: $(date)"
      echo "# ----------------------------------------"
      echo "Error collecting helm values:"
      echo "$values_output"
    } >"$output_file"
    chmod 600 "$output_file"
    print_msg "$YELLOW" "⚠ Error collecting helm values, see $(basename "$output_file") for details"
  fi
}

# Function to collect pod information (with secret masking)
collect_pods() {
  local output_file="$TMP_DIR/kubectl_pods.txt"
  print_msg "$YELLOW" "Collecting pod information..."

  {
    echo "Kubernetes Pods"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  if kubectl get pods -n "$NAMESPACE" -o wide >>"$output_file" 2>&1; then
    echo "" >>"$output_file"
    echo "----------------------------------------" >>"$output_file"
    echo "Pod Descriptions:" >>"$output_file"
    echo "----------------------------------------" >>"$output_file"

    # Get pod names safely (prevent word splitting)
    local pod_names=()
    while IFS= read -r pod; do
      [[ -n "$pod" ]] && pod_names+=("$pod")
    done < <(kubectl get pods -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n')

    for pod in "${pod_names[@]}"; do
      echo "" >>"$output_file"
      echo "=== Pod: $pod ===" >>"$output_file"
      # Mask environment variables and other secrets in pod descriptions
      kubectl describe pod "$pod" -n "$NAMESPACE" 2>&1 | mask_secrets >>"$output_file" || true
      echo "" >>"$output_file"
    done
    chmod 600 "$output_file"
    print_msg "$GREEN" "✓ Pod information saved to $(basename "$output_file")"
  else
    chmod 600 "$output_file"
    print_msg "$YELLOW" "⚠ Error collecting pod information, see $(basename "$output_file") for details"
  fi
}

# Function to collect logs from pods with specific labels
collect_pod_logs() {
  local logs_dir="$TMP_DIR/pod_logs"
  mkdir -p "$logs_dir" && chmod 700 "$logs_dir"

  print_msg "$YELLOW" "Collecting pod logs for specific components..."

  # Define the labels to look for
  local labels=(
    "app.kubernetes.io/component=useradm"
    "app.kubernetes.io/component=tenantadm"
    "app.kubernetes.io/component=deployments"
    "app.kubernetes.io/component=auditlogs"
    "app.kubernetes.io/component=api-gateway"
    "app.kubernetes.io/component=create-artifact-worker"
    "app.kubernetes.io/component=device-auth"
    "app.kubernetes.io/component=deviceconfig"
    "app.kubernetes.io/component=deviceconnect"
    "app.kubernetes.io/component=devicemonitor"
    "app.kubernetes.io/component=gui"
    "app.kubernetes.io/component=inventory"
    "app.kubernetes.io/component=iot-manager"
    "app.kubernetes.io/component=workflows-server"
    "app.kubernetes.io/component=workflows-worker"
    "app.kubernetes.io/component=generate-delta-worker"
  )

  local found_any=false

  for label in "${labels[@]}"; do
    local component=$(echo "$label" | cut -d'=' -f2)
    print_msg "$YELLOW" "  Checking for pods with label: $label"

    # Get pods with this label
    local pod_names
    if pod_names=$(kubectl get pods -n "$NAMESPACE" -l "$label" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); then
      if [[ -n "$pod_names" ]]; then
        found_any=true
        for pod in $pod_names; do
          local log_file="$logs_dir/${component}_${pod}.log"
          print_msg "$YELLOW" "    Collecting logs from pod: $pod"

          {
            echo "Pod: $pod"
            echo "Component: $component"
            echo "Namespace: $NAMESPACE"
            echo "Timestamp: $(date)"
            echo "----------------------------------------"
          } >"$log_file"

          # Get the logs (last 1000 lines), filter noise, mask secrets
          if kubectl logs "$pod" -n "$NAMESPACE" 2>&1 | grep -viE 'health|alive|status' | tail -n"${MAX_LOG_LINES}" | mask_secrets >>"$log_file"; then
            print_msg "$GREEN" "    ✓ Logs saved for $pod"
          else
            echo "" >>"$log_file"
            echo "Note: Current container logs not available, trying previous container..." >>"$log_file"
            echo "----------------------------------------" >>"$log_file"
            if kubectl logs "$pod" -n "$NAMESPACE" --previous 2>&1 | grep -viE 'health|alive|status' | tail -n"${MAX_LOG_LINES}" | mask_secrets >>"$log_file"; then
              print_msg "$YELLOW" "    ⚠ Got previous container logs for $pod"
            else
              print_msg "$YELLOW" "    ⚠ Could not retrieve logs for $pod"
            fi
          fi
        done
      else
        print_msg "$YELLOW" "    No pods found with label: $label"
      fi
    fi
  done

  if [[ "$found_any" == true ]]; then
    print_msg "$GREEN" "✓ Pod logs collected in pod_logs directory"
  else
    print_msg "$YELLOW" "⚠ No pods found with the specified component labels"
    # Create a note file
    echo "No pods found with the following labels:" >"$logs_dir/NO_LOGS_FOUND.txt"
    for label in "${labels[@]}"; do
      echo "  - $label" >>"$logs_dir/NO_LOGS_FOUND.txt"
    done
  fi
}

# Function to collect ConfigMaps with content
collect_configmaps() {
  local output_file="$TMP_DIR/configmaps.yaml"
  print_msg "$YELLOW" "Collecting ConfigMaps from namespace '$NAMESPACE'..."

  {
    echo "# ConfigMaps in namespace: $NAMESPACE"
    echo "# Timestamp: $(date)"
    echo "# Note: ConfigMap contents may contain sensitive data - secrets are masked"
    echo "# ============================================"
    echo ""
  } >"$output_file"

  # Get list of ConfigMaps (safe from word splitting)
  local configmaps=()
  while IFS= read -r cm; do
    [[ -n "$cm" ]] && configmaps+=("$cm")
  done < <(kubectl get configmaps -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n')

  if [[ ${#configmaps[@]} -eq 0 ]]; then
    echo "No ConfigMaps found in namespace '$NAMESPACE'" >>"$output_file"
    chmod 600 "$output_file"
    print_msg "$YELLOW" "⚠ No ConfigMaps found in namespace"
    return
  fi

  print_msg "$GREEN" "Found ${#configmaps[@]} ConfigMap(s)"

  for cm in "${configmaps[@]}"; do
    print_msg "$YELLOW" "  Processing ConfigMap: $cm"
    {
      echo "---"
      echo "# ConfigMap: $cm"
      echo "# ----------------------------------------"
    } >>"$output_file"

    # Get the ConfigMap in YAML format and mask secrets if enabled
    if kubectl get configmap "$cm" -n "$NAMESPACE" -o yaml 2>&1 | mask_secrets >>"$output_file"; then
      echo "" >>"$output_file"
      print_msg "$GREEN" "    ✓ ConfigMap '$cm' collected"
    else
      echo "# Error retrieving ConfigMap: $cm" >>"$output_file"
      print_msg "$YELLOW" "    ⚠ Error collecting ConfigMap '$cm'"
    fi
  done

  chmod 600 "$output_file"
  print_msg "$GREEN" "✓ ConfigMaps saved to $(basename "$output_file")"
}

# Function to list Secrets (without content)
collect_secrets_list() {
  local output_file="$TMP_DIR/secrets_list.txt"
  print_msg "$YELLOW" "Collecting list of Secrets from namespace '$NAMESPACE'..."

  {
    echo "Secrets List (metadata only - no sensitive content)"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "============================================"
    echo ""
    echo "SECURITY NOTE: Secret contents are NOT included in this file."
    echo "Only metadata (name, type, creation time, size) is collected."
    echo ""
    echo "============================================"
    echo ""
  } >"$output_file"

  # Get detailed list of secrets without the actual data
  echo "SECRET NAME                          TYPE                                  DATA   CREATED" >>"$output_file"
  echo "---------------------------------------------------------------------------------------------------" >>"$output_file"

  # Get secrets with details but without actual secret data
  if kubectl get secrets -n "$NAMESPACE" -o json 2>/dev/null |
    jq -r '.items[] |
            "\(.metadata.name)|\(.type)|
            \(.data | if . then (. | keys | length) else 0 end)|
            \(.metadata.creationTimestamp)"' |
    while IFS='|' read -r name type data_count created; do
      # Format output without age calculation to avoid date parsing issues
      printf "%-36s %-36s %-6s %s\n" \
        "$name" \
        "$type" \
        "$data_count" \
        "$created"
    done >>"$output_file"; then

    echo "" >>"$output_file"
    echo "============================================" >>"$output_file"
    echo "Summary:" >>"$output_file"

    # Count secrets by type
    echo "" >>"$output_file"
    echo "Secrets by Type:" >>"$output_file"
    kubectl get secrets -n "$NAMESPACE" -o json 2>/dev/null |
      jq -r '.items[].type' | sort | uniq -c |
      while read count type; do
        printf "  %3d x %s\n" "$count" "$type"
      done >>"$output_file"

    # Total count - ensure integer
    local total_secrets
    total_secrets=$(kubectl get secrets -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | tr -d ' ')
    total_secrets=${total_secrets:-0}
    echo "" >>"$output_file"
    echo "Total Secrets: $total_secrets" >>"$output_file"

    # Check for potentially problematic secrets
    echo "" >>"$output_file"
    echo "Security Observations:" >>"$output_file"

    # Check for default service account tokens - ensure integer
    local default_tokens
    default_tokens=$(kubectl get secrets -n "$NAMESPACE" -o json 2>/dev/null |
      jq -r '.items[] | select(.type == "kubernetes.io/service-account-token") | .metadata.name' |
      grep -c "^default-token" || echo "0")
    default_tokens=$(echo "$default_tokens" | tr -d ' ')
    default_tokens=${default_tokens:-0}

    if [ "$default_tokens" -gt 0 ] 2>/dev/null; then
      echo "  - Found $default_tokens default service account token(s)" >>"$output_file"
    fi

    # Check for Opaque secrets - ensure integer
    local opaque_secrets
    opaque_secrets=$(kubectl get secrets -n "$NAMESPACE" -o json 2>/dev/null |
      jq -r '.items[] | select(.type == "Opaque") | .metadata.name' | wc -l | tr -d ' ')
    opaque_secrets=${opaque_secrets:-0}

    if [ "$opaque_secrets" -gt 0 ] 2>/dev/null; then
      echo "  - Found $opaque_secrets Opaque secret(s) (may contain credentials)" >>"$output_file"
    fi

    # Check for TLS secrets - ensure integer
    local tls_secrets
    tls_secrets=$(kubectl get secrets -n "$NAMESPACE" -o json 2>/dev/null |
      jq -r '.items[] | select(.type == "kubernetes.io/tls") | .metadata.name' | wc -l | tr -d ' ')
    tls_secrets=${tls_secrets:-0}

    if [ "$tls_secrets" -gt 0 ] 2>/dev/null; then
      echo "  - Found $tls_secrets TLS certificate secret(s)" >>"$output_file"
    fi

    # Check for docker registry secrets - ensure integer
    local registry_secrets
    registry_secrets=$(kubectl get secrets -n "$NAMESPACE" -o json 2>/dev/null |
      jq -r '.items[] | select(.type == "kubernetes.io/dockerconfigjson") | .metadata.name' | wc -l | tr -d ' ')
    registry_secrets=${registry_secrets:-0}

    if [ "$registry_secrets" -gt 0 ] 2>/dev/null; then
      echo "  - Found $registry_secrets Docker registry credential secret(s)" >>"$output_file"
    fi

    chmod 600 "$output_file"
    print_msg "$GREEN" "✓ Secrets list saved to $(basename "$output_file") (metadata only, no sensitive content)"
  else
    echo "Error retrieving secrets list" >>"$output_file"
    chmod 600 "$output_file"
    print_msg "$YELLOW" "⚠ Error collecting secrets list"
  fi
}

# Function to create support bundle
create_support_bundle() {
  print_msg "$YELLOW" "Creating support bundle..."

  # Collect cluster context for audit trail
  local cluster_server
  cluster_server=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null || echo "unknown")
  local kube_user
  kube_user=$(kubectl config view --minify -o jsonpath='{.users[0].name}' 2>/dev/null || echo "unknown")
  local kube_context
  kube_context=$(kubectl config current-context 2>/dev/null || echo "unknown")

  # Add a README file to the bundle
  cat >"$TMP_DIR/README.txt" <<EOF
Mender Server Support Bundle
===================
Generated: $(date)
Namespace: $NAMESPACE
Helm Release: $HELM_RELEASE
Secrets Masked: $MASK_SECRETS

Audit:
- Cluster: $cluster_server
- Context: $kube_context
- Kubeconfig User: $kube_user
- System User: $(id -un 2>/dev/null || echo "unknown")

Contents:
- helm_history.txt: History of the Helm release
- helm_list.txt: List of all Helm releases in the namespace
- helm_values.yaml: Values used for the Helm release (secrets masked: $MASK_SECRETS)
- kubectl_pods.txt: Pod information and descriptions
- pod_logs/: Directory containing logs from specific component pods
  * useradm pods (app.kubernetes.io/component=useradm)
  * tenantadm pods (app.kubernetes.io/component=tenantadm)
  * deployments pods (app.kubernetes.io/component=deployments)
- configmaps.yaml: All ConfigMaps in the namespace with their content (secrets masked: $MASK_SECRETS)
- secrets_list.txt: List of all Secrets in the namespace (METADATA ONLY - no secret values)
- list_tenants.txt: List of all tenants in Mender (secrets masked: $MASK_SECRETS)
- mongo_deployment_service.txt: dump of the deployment_service-* databases
- mongo_deviceauth.txt: dump of the deviceauth database
- mongo_inventory.txt: dump of the inventory-* databases
- mongo_tenantadm.txt: dump of the tenantadm database
- mongo_useradm.txt: dump of the useradm database
- mongo_workflows.txt
- README.txt: This file

Security Notes:
- All sensitive information has been masked with ***MASKED*** if MASK_SECRETS=true
- ConfigMap contents are included but may contain configuration data
- Secret VALUES are NOT included - only metadata (name, type, age, data count)
- Pod logs contain the last $MAX_LOG_LINES lines from each pod
- This bundle may still contain sensitive information - handle with care
- Recommended: Transfer using encrypted channels only
- Recommended: Delete after use with secure deletion (shred -vfz)
- Note: shred effectiveness depends on storage type; not guaranteed on SSDs

File Permissions:
- All files created with mode 600 (owner read/write only)
- Bundle created with mode 600
- Temporary directory created with mode 700
EOF
  chmod 600 "$TMP_DIR/README.txt"

  # Create the tarball with restricted permissions
  tar -czf "$SUPPORT_BUNDLE" -C "$TMP_DIR" .
  chmod 600 "$SUPPORT_BUNDLE"

  print_msg "$GREEN" "✓ Support bundle created: $SUPPORT_BUNDLE (mode 600)"
  print_msg "$GREEN" "Bundle size: $(du -h "$SUPPORT_BUNDLE" | cut -f1)"
  print_msg "$YELLOW" "⚠ Security: Bundle contains potentially sensitive data. Handle with care!"
}

list_tenants() {
  local output_file="$TMP_DIR/list_tenants.txt"
  print_msg "$YELLOW" "Collecting tenant information..."

  {
    echo "tenantadm list-tenants"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  if kubectl get deploy mender-tenantadm -n "$NAMESPACE" >/dev/null 2>&1; then
    # Use array to avoid word-splitting and quoting bugs with string-based command vars
    local -a tenantadm=(kubectl exec -n "$NAMESPACE" deploy/mender-tenantadm -- tenantadm)
    "${tenantadm[@]}" list-tenants | jq . | mask_secrets >>"$output_file" || true
    chmod 600 "$output_file"
    print_msg "$GREEN" "✓ tenantadm list-tenants information saved to $(basename "$output_file")"
  else
    chmod 600 "$output_file"
    print_msg "$YELLOW" "⚠ Error collecting tenantadm list-tenants information, see $(basename "$output_file") for details"
  fi
}

# Helper: run a mongosh script in a disposable debug pod.
# Credentials are injected via envFrom from the existing mongodb-common k8s secret.
# The MongoDB URL is NEVER passed as a command-line argument (not visible in ps aux).
# The JS script is base64-encoded and decoded inside the container to avoid quoting issues.
_run_mongosh_pod() {
  local pod_name="$1"
  local js_script="$2"
  local output_file="$3"

  # Verify the secret exists before attempting to spin up a pod
  if ! kubectl get secret mongodb-common -n "$NAMESPACE" >/dev/null 2>&1; then
    print_msg "$YELLOW" "  Secret 'mongodb-common' not found in namespace '$NAMESPACE' - skipping"
    return 1
  fi

  # Base64-encode the JS script - safe to embed in a single-quoted shell argument
  # (base64 output only contains A-Za-z0-9+/= and we strip newlines)
  local script_b64
  script_b64=$(printf '%s' "$js_script" | base64 | tr -d '\n')

  # Build bash command for inside the container.
  # $MONGO_URL is expanded by bash INSIDE the container from the envFrom-injected env var.
  # It is NOT expanded on the local machine (note the escaped \$MONGO_URL).
  local bash_cmd="echo '${script_b64}' | base64 -d | mongosh \"\$MONGO_URL\" --quiet"

  # Build the pod override JSON using jq for correct escaping.
  # envFrom injects MONGO_URL from the existing mongodb-common secret -
  # the credential value never appears in the command line or in ps output.
  local overrides
  overrides=$(jq -n \
    --arg pod_name "$pod_name" \
    --arg bash_cmd "$bash_cmd" \
    --arg image "$MONGO_IMAGE" \
    '{
      spec: {
        containers: [{
          name: $pod_name,
          image: $image,
          command: ["bash", "-c", $bash_cmd],
          envFrom: [{secretRef: {name: "mongodb-common"}}]
        }]
      }
    }')

  kubectl run "$pod_name" \
    -n "$NAMESPACE" \
    --image="${MONGO_IMAGE}" \
    --restart=Never \
    --overrides="$overrides" \
    --attach=true 2>&1 | mask_secrets >>"$output_file" || true

  kubectl delete pod "$pod_name" -n "$NAMESPACE" >/dev/null 2>&1 || true
  kubectl wait --for=delete pod "$pod_name" -n "$NAMESPACE" --timeout=30s >/dev/null 2>&1 || true
}

# Generate a unique pod name suffix to prevent collisions on concurrent runs
_mongosh_pod_name() {
  echo "mongosh-$(od -An -N4 -tx1 /dev/urandom 2>/dev/null | tr -d ' \n')"
}

mongo_dump_useradm() {
  local output_file="$TMP_DIR/mongo_useradm.txt"
  print_msg "$YELLOW" "Collecting mongo useradm information (useradm + useradm-*)..."

  {
    echo "mongosh use useradm / useradm-*"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  local js_script
  js_script=$(cat <<'JSEOF'
var allDbs = db.getSiblingDB('admin').runCommand({ 'listDatabases': 1 }).databases;
var dbNames = allDbs.map(function(d) { return d.name; });

if (dbNames.indexOf('useradm') !== -1) {
  print('-----------------------------------------');
  print('Processing database: useradm');
  print('-----------------------------------------');
  var useradmDb = db.getSiblingDB('useradm');
  useradmDb.getCollectionNames().forEach(function(collectionName) {
    print('Collection: ' + collectionName);
    useradmDb[collectionName].find().forEach(function(doc) { printjson(doc); });
  });
}

allDbs.forEach(function(database) {
  if (database.name.startsWith('useradm-')) {
    print('-----------------------------------------');
    print('Processing database: ' + database.name);
    print('-----------------------------------------');
    var currentDb = db.getSiblingDB(database.name);
    currentDb.getCollectionNames().forEach(function(collectionName) {
      print('Collection: ' + collectionName);
      currentDb[collectionName].find().forEach(function(doc) { printjson(doc); });
    });
  }
});
quit;
JSEOF
)

  _run_mongosh_pod "$(_mongosh_pod_name)" "$js_script" "$output_file"
  chmod 600 "$output_file"
  print_msg "$GREEN" "✓ mongosh useradm information saved to $(basename "$output_file")"
}

mongo_dump_deployment_service() {
  local output_file="$TMP_DIR/mongo_deployment_service.txt"
  print_msg "$YELLOW" "Collecting mongo deployment service information..."

  {
    echo "mongosh use deployment_service-*"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  local js_script
  js_script=$(cat <<'JSEOF'
var dbs = db.getSiblingDB('admin').runCommand({ 'listDatabases': 1 }).databases;

dbs.forEach(function(database) {
  if (database.name.startsWith('deployment_service-')) {
    print('-----------------------------------------');
    print('Processing database: ' + database.name);
    print('-----------------------------------------');

    var currentDb = db.getSiblingDB(database.name);
    var collections = currentDb.getCollectionNames();

    collections.forEach(function(collectionName) {
      print('Collection: ' + collectionName);
      currentDb[collectionName].find().forEach(function(doc) {
        printjson(doc);
      });
    });
  }
});
quit;
JSEOF
)

  _run_mongosh_pod "$(_mongosh_pod_name)" "$js_script" "$output_file"
  chmod 600 "$output_file"
  print_msg "$GREEN" "✓ mongosh deployment service information saved to $(basename "$output_file")"
}

mongo_dump_deviceauth() {
  local output_file="$TMP_DIR/mongo_deviceauth.txt"
  print_msg "$YELLOW" "Collecting mongo deviceauth service information (deviceauth + deviceauth-*)..."

  {
    echo "mongosh use deviceauth / deviceauth-*"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  local js_script
  js_script=$(cat <<'JSEOF'
var allDbs = db.getSiblingDB('admin').runCommand({ 'listDatabases': 1 }).databases;
var dbNames = allDbs.map(function(d) { return d.name; });

if (dbNames.indexOf('deviceauth') !== -1) {
  print('-----------------------------------------');
  print('Processing database: deviceauth');
  print('-----------------------------------------');
  var deviceauthDb = db.getSiblingDB('deviceauth');
  deviceauthDb.getCollectionNames().forEach(function(collectionName) {
    print('Collection: ' + collectionName);
    deviceauthDb[collectionName].find().forEach(function(doc) { printjson(doc); });
  });
}

allDbs.forEach(function(database) {
  if (database.name.startsWith('deviceauth-')) {
    print('-----------------------------------------');
    print('Processing database: ' + database.name);
    print('-----------------------------------------');
    var currentDb = db.getSiblingDB(database.name);
    currentDb.getCollectionNames().forEach(function(collectionName) {
      print('Collection: ' + collectionName);
      currentDb[collectionName].find().forEach(function(doc) { printjson(doc); });
    });
  }
});
quit;
JSEOF
)

  _run_mongosh_pod "$(_mongosh_pod_name)" "$js_script" "$output_file"
  chmod 600 "$output_file"
  print_msg "$GREEN" "✓ mongosh deviceauth information saved to $(basename "$output_file")"
}

mongo_dump_inventory() {
  local output_file="$TMP_DIR/mongo_inventory.txt"
  print_msg "$YELLOW" "Collecting mongo inventory information (inventory + inventory-*)..."

  {
    echo "mongosh use inventory / inventory-*"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  local js_script
  js_script=$(cat <<'JSEOF'
var allDbs = db.getSiblingDB('admin').runCommand({ 'listDatabases': 1 }).databases;
var dbNames = allDbs.map(function(d) { return d.name; });

if (dbNames.indexOf('inventory') !== -1) {
  print('-----------------------------------------');
  print('Processing database: inventory');
  print('-----------------------------------------');
  var inventoryDb = db.getSiblingDB('inventory');
  inventoryDb.getCollectionNames().forEach(function(collectionName) {
    print('Collection: ' + collectionName);
    inventoryDb[collectionName].find().forEach(function(doc) { printjson(doc); });
  });
}

allDbs.forEach(function(database) {
  if (database.name.startsWith('inventory-')) {
    print('-----------------------------------------');
    print('Processing database: ' + database.name);
    print('-----------------------------------------');
    var currentDb = db.getSiblingDB(database.name);
    currentDb.getCollectionNames().forEach(function(collectionName) {
      print('Collection: ' + collectionName);
      currentDb[collectionName].find().forEach(function(doc) { printjson(doc); });
    });
  }
});
quit;
JSEOF
)

  _run_mongosh_pod "$(_mongosh_pod_name)" "$js_script" "$output_file"
  chmod 600 "$output_file"
  print_msg "$GREEN" "✓ mongosh inventory information saved to $(basename "$output_file")"
}

mongo_dump_tenantadm() {
  local output_file="$TMP_DIR/mongo_tenantadm.txt"
  print_msg "$YELLOW" "Collecting mongo tenantadm service information..."

  {
    echo "mongosh use tenantadm"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  local js_script
  js_script=$(cat <<'JSEOF'
use tenantadm;
var collections = db.getCollectionNames();
collections.forEach(function(collectionName) {
  print('Collection: ' + collectionName);
  db[collectionName].find().forEach(function(doc) {
    printjson(doc);
  });
});
quit;
JSEOF
)

  _run_mongosh_pod "$(_mongosh_pod_name)" "$js_script" "$output_file"
  chmod 600 "$output_file"
  print_msg "$GREEN" "✓ mongosh tenantadm information saved to $(basename "$output_file")"
}

mongo_dump_workflows() {
  local output_file="$TMP_DIR/mongo_workflows.txt"
  print_msg "$YELLOW" "Collecting mongo workflows service information..."

  {
    echo "mongosh use workflows"
    echo "Namespace: $NAMESPACE"
    echo "Timestamp: $(date)"
    echo "----------------------------------------"
  } >"$output_file"

  local js_script
  js_script=$(cat <<'JSEOF'
use workflows;
db.migration_info.find();
db.jobs.find();
quit;
JSEOF
)

  _run_mongosh_pod "$(_mongosh_pod_name)" "$js_script" "$output_file"
  chmod 600 "$output_file"
  print_msg "$GREEN" "✓ mongosh workflows information saved to $(basename "$output_file")"
}

show_security_warning() {
  print_msg "$YELLOW" "╔══════════════════════════════════════════════════════════════╗"
  print_msg "$YELLOW" "║                    SECURITY NOTICE                           ║"
  print_msg "$YELLOW" "╠══════════════════════════════════════════════════════════════╣"
  print_msg "$YELLOW" "║ This script collects potentially sensitive information.      ║"
  print_msg "$YELLOW" "║                                                              ║"
  print_msg "$YELLOW" "║ The support bundle may contain:                              ║"
  print_msg "$YELLOW" "║ - Configuration values (secrets are masked by default)       ║"
  print_msg "$YELLOW" "║ - Pod logs (may contain sensitive application data)          ║"
  print_msg "$YELLOW" "║ - Cluster information                                        ║"
  print_msg "$YELLOW" "║                                                              ║"
  print_msg "$YELLOW" "║ Security measures in place:                                  ║"
  print_msg "$YELLOW" "║ - Temporary files created with mode 700                      ║"
  print_msg "$YELLOW" "║ - Output files created with mode 600                         ║"
  print_msg "$YELLOW" "║ - Secrets masked in values and logs (if enabled)             ║"
  print_msg "$YELLOW" "║ - Secure deletion of temp files on exit                      ║"
  print_msg "$YELLOW" "║ - MongoDB credentials never passed as command-line args      ║"
  print_msg "$YELLOW" "║                                                              ║"
  print_msg "$YELLOW" "║ Recommendations:                                             ║"
  print_msg "$YELLOW" "║ - Review the bundle contents before sharing                  ║"
  print_msg "$YELLOW" "║ - Transfer using encrypted channels only                     ║"
  print_msg "$YELLOW" "║ - Delete with: shred -vfz support_*.tar.gz                   ║"
  print_msg "$YELLOW" "║   (shred may not be effective on SSDs/copy-on-write FS)      ║"
  print_msg "$YELLOW" "╚══════════════════════════════════════════════════════════════╝"
  echo ""

  read -p "Do you understand and want to proceed? (y/N): " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_msg "$RED" "Aborted by user"
    exit 1
  fi
  echo ""
}

# Main function
main() {
  print_msg "$GREEN" "=== Helm Support Bundle Generator ==="
  echo ""

  # Show security warning
  show_security_warning

  # Check requirements
  check_requirements

  # Select namespace
  select_namespace

  # Select helm release
  select_helm_release

  # Create temporary directory
  create_tmp_dir

  # Collect information
  collect_helm_history
  collect_helm_list
  collect_helm_values
  collect_pods
  collect_pod_logs
  collect_configmaps
  collect_secrets_list
  list_tenants
  mongo_dump_useradm
  mongo_dump_deployment_service
  mongo_dump_deviceauth
  mongo_dump_inventory
  mongo_dump_tenantadm
  mongo_dump_workflows

  # Create support bundle
  echo ""
  create_support_bundle

  echo ""
  print_msg "$GREEN" "=== Support bundle generation completed successfully ==="
  print_msg "$GREEN" "File: $SUPPORT_BUNDLE"
  print_msg "$YELLOW" "Remember to:"
  print_msg "$YELLOW" "  1. Review contents before sharing"
  print_msg "$YELLOW" "  2. Transfer securely (encrypted channel)"
  print_msg "$YELLOW" "  3. Delete securely when done: shred -vfz $SUPPORT_BUNDLE"
}

# Run main function
main
