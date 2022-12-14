function foo() {
  echo " hello foo"
}
function go_build() {
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go
}
function ssh_agent_do() {
  eval $(ssh-agent -s)
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  echo "${ARG_PRIVATE_KEY}" | tr -d '\r' | ssh-add - >/dev/null
  echo "[${ARG_KNOWN_HOSTS}]:${SSH_KNOWN_PORT} ${SSH_HOST_ECDSA_KEY}" >~/.ssh/known_hosts
  chmod 644 ~/.ssh/known_hosts
  cat ~/.ssh/known_hosts
}

function upload_do() {
  if [ ${ENV_NAME} = 'production' ]; then
    ENV_SUFFIX=""
  else
    ENV_SUFFIX="-${ENV_NAME}"
  fi
  ARG_UPLOAD_TO="root@${ARG_KNOWN_HOSTS} -p ${SSH_KNOWN_PORT}"
  ARG_UPLOAD_HOME="/home/upload${ENV_SUFFIX}/${SERVICE_GROUP}-${SERVICE_NAME}"
  printf "\033[1;36m${ARG_UPLOAD_TO}\033[0m # id\n"
  ssh ${ARG_UPLOAD_TO} 'id'
  ssh ${ARG_UPLOAD_TO} "mkdir -p ${ARG_UPLOAD_HOME}"
  scp -P ${SSH_KNOWN_PORT} ./main root@${ARG_KNOWN_HOSTS}:${ARG_UPLOAD_HOME}/
}
