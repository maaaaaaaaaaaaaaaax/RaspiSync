# REQUIRES: sshpass, install via brew install sshpass

syncRaspi() {
  if [[ ! -f .env ]]; then
    echo "No .env file found in current directory"
    return 1
  fi

  # PARSE .env
  while IFS='=' read -r key value || [[ -n "$key" ]]; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    export "$key=$value"
  done < .env

  # VALIDATE .env
  local missing=()
  for var in SSH_HOST SSH_PROJECT_PATH SSH_PYTHON_EXEC; do
    [[ -z "${(P)var}" ]] && missing+=($var)
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Missing required .env variables: ${missing[*]}"
    return 1
  fi

  local python_bin="${SSH_PYTHON_EXEC%% *}"
  local exec_file="${1:-${SSH_PYTHON_EXEC#* }}"

  echo "Syncing to ${SSH_HOST}:${SSH_PROJECT_PATH}..."

  rsync -avz \
    --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='.env' \
    --exclude='.venv' \
    ./ "${SSH_HOST}:${SSH_PROJECT_PATH}/"

  if [[ $? -ne 0 ]]; then
    echo "Sync failed"
    return 1
  fi

  echo "Executing: ${python_bin} ${exec_file}"

  ssh "$SSH_HOST" \
    "cd ${SSH_PROJECT_PATH} && echo '${SSH_SUDO_PASSWORD}' | sudo -S ${SSH_PROJECT_PATH}/${python_bin} ${exec_file}"
}
