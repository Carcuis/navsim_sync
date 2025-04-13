# shellcheck disable=SC2034

BOLD="$(printf '\033[1m')"; TAIL="$(printf '\033[0m')"; UNDERLINE="$(printf '\033[4m')"
RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"; YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"; BLUE="$(printf '\033[34m')"; WHITE="$(printf '\033[37m')"

REMOTE="polyu:github/navsim"
LOCAL="$HOME/github/navsim"

REMOTE_EXP="$REMOTE/exp"
LOCAL_EXP="$LOCAL/exp"

REMOTE_GIT="$REMOTE/.git"
LOCAL_GIT="$LOCAL/.git"

rsync_cmd="rsync -a --info=progress2"
delete_flag=false
target="root"

function mesg()     { echo -e "${WHITE}$1${TAIL}"; }
function info()     { mesg "${CYAN}$1"; }
function bold()     { mesg "${BOLD}$1"; }
function success()  { bold "${GREEN}$1 ✔"; }
function warning()  { bold "${YELLOW}$1"; }
function error()    { bold "${RED}$1" 1>&2; }

function has_file() { [[ -f "$1" ]]; }

function run_rsync() {
    name=$1
    src=$2/
    dest=$3/
    delete=$4
    exclude=$5

    motion="Syncing"
    if [[ "$delete" == true ]]; then
        motion="${BOLD}Force syncing${TAIL}${WHITE}"
        rsync_cmd+=" --delete"
    fi

    mesg "$motion ${BOLD}$name${TAIL}${WHITE} from ${UNDERLINE}$src${TAIL}${WHITE} to ${UNDERLINE}$dest${TAIL}"

    if [[ -n $exclude ]]; then
        info "Excluding: $(echo $exclude | sed -E "s/,/, /g")"
        rsync_cmd+=" $(echo $exclude | sed -E "s/,/ --exclude=/g;s/^/--exclude=/;s/'//g")"
    fi

    $rsync_cmd $src $dest
}

