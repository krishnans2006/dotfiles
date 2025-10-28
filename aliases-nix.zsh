# Utility

## Nix/NixOS
devf() {
    [[ -s flake.nix ]] && git add flake.nix
    [[ -s flake.lock ]] && git add flake.lock

    echo "use flake" > .envrc

    direnv allow .
}

## General
alias indent="sed 's/^/  /'"

copy() {
    if [[ "${XDG_SESSION_TYPE}" == "wayland" ]]
    then
        wl-copy
    else
        xclip -sel clip
    fi
}

alias copy-cmd='fc -ln -1 | copy'  # Copy the last command to the clipboard

mkcd() {
    mkdir -p "$1"
    cd "$1"
}

## Command Abbreviations
alias dc='docker compose'  # Docker Compose
alias pmpy='python manage.py'  # Django manage.py

## Git/GitHub
alias g-size='echo "Calculating..." && git gc --quiet && git count-objects -vH | grep "size-pack: "'

gc-past() {
    export GIT_AUTHOR_DATE="$1"
    export GIT_COMMITTER_DATE="$1"
    shift
    git commit "$@"
    unset GIT_AUTHOR_DATE
    unset GIT_COMMITTER_DATE
}

# Git Submodule Update Subrepo Update
gsusu() {
    if [ "$1" != "" ] && [ "$2" != "" ]
    then
        COMMIT_MSG=$(git -C "$2" log -1 --pretty='format:%B' HEAD)
        git subrepo pull "$1" -m "$COMMIT_MSG"
        git push
        git add .
        git commit -m "Bump $2 submodule"
        sleep 30
        git push
    else
        echo "Usage: gsusu <path/to/subrepo> <path/to/submodule>"
    fi
}

## Wireguard
vpnon() {
    default="tjcsl"
    if [ "$1" != "" ]
    then
        sudo systemctl start wg-quick-"$1"
    else
        sudo systemctl start wg-quick-"$default"
    fi
}
vpnoff() {
    default="tjcsl"
    if [ "$1" != "" ]
    then
        sudo systemctl stop wg-quick-"$1"
    else
        sudo systemctl stop wg-quick-"$default"
    fi
}


# Folders

## Classes
alias 106='cd ~/School/24_25Fall/ANTH106'
alias 110='cd ~/School/24_25Fall/ECE110'
alias 120='cd ~/School/24_25Fall/ECE120'
alias 213='cd ~/School/24_25Fall/MATH213'
alias 285='cd ~/School/24_25Fall/MATH285'

alias 210='cd ~/School/24_25Spring/ECE210'
alias 220='cd ~/School/24_25Spring/ECE220'
alias 313='cd ~/School/24_25Spring/ECE313'
alias 314='cd ~/School/24_25Spring/ECE314'

alias 225='cd ~/School/25_26Fall/CS225'
alias 385='cd ~/School/25_26Fall/ECE385'
alias 391='cd ~/School/25_26Fall/ECE391'
alias 370='cd ~/School/25_26Fall/PHYS370'

## Tech
alias t='cd ~/Tech'
alias th='cd ~/Tech/Hobby'
alias tjcsl='cd ~/Tech/tjCSL'
alias tjuav='cd ~/Tech/TJUAV'


# TJUAV

tjuav-sim() {
    # Run an ArduPilot SITL simulation
    if [ "$1" != "" ]
    then
        ~/Tech/TJUAV/ardupilot/Tools/autotest/sim_vehicle.py --no-mavproxy -v ArduPlane --add-param-file ~/Tech/TJUAV/ardupilot/Tools/autotest/default_params/avalon.parm -L "$1"
    else
        ~/Tech/TJUAV/ardupilot/Tools/autotest/sim_vehicle.py --no-mavproxy -v ArduPlane --add-param-file ~/Tech/TJUAV/ardupilot/Tools/autotest/default_params/avalon.parm -L FARM_RC
    fi
}

tjuav-server() {
    # Start the TJUAV backend server
    cd ~/Tech/TJUAV/GroundStation/server/
    source ~/Tech/TJUAV/GroundStation/server/venv/bin/activate
    python ~/Tech/TJUAV/GroundStation/server/app.py
}

alias tjuav-client='npm start --prefix ~/Tech/TJUAV/GroundStation/client'  # Start the TJUAV frontend client

alias mission-planner='mono ~/Tech/TJUAV/MissionPlanner/MissionPlanner.exe'  # Start Mission Planner


# TJ CSL

raw-passcard() {
    # Decrypt a passcard and print it to the terminal (primarily for piping to other commands)
    gpg -d ~/Tech/tjCSL/keybase-passcard/passwords/"$1".txt.gpg 2>/dev/null
}

p() {
    # Decrypt a passcard, copy it, and optionally print it to the terminal (primarily for shell usage)
    password=$(gpg -d ~/Tech/tjCSL/keybase-passcard/passwords/"$1".txt.gpg 2>/dev/null)
    echo "$password" | copy
    if [[ "$2" != "" ]]
    then
        echo "$password"
    fi
}

p-grep() {
    # List all passcards that include some text
    ls ~/Tech/tjCSL/keybase-passcard/passwords | grep "$1"
}

alias p-pull='git -C ~/Tech/tjCSL/keybase-passcard pull'  # Fetch passcard updates

tjssh() {
    CSL_USERNAME="2024kshankar"
    PASSCARD_DIR="/home/krishnan/Tech/tjCSL/keybase-passcard"

    # Set INPUT as server
    INPUT="$1"

    # Set HOST as server.csl.tjhsst.edu
    if [[ "$INPUT" == *"@"* ]]
    then
        HOST=$(echo "$INPUT" | cut -d"@" -f2)
    else
        HOST="$INPUT"
    fi

    # Set SERVER as user@server.csl.tjhsst.edu
    if [[ "$INPUT" != *"."* ]]
    then
        SERVER="$INPUT".csl.tjhsst.edu
        HOST="$HOST".csl.tjhsst.edu
    fi

    if ping -c 1 "$HOST" &> /dev/null
    then
        if [ -e "$PASSCARD_DIR"/passwords/"$INPUT".txt.gpg ]
        then
            export SSHPASS=$(gpg -d "$PASSCARD_DIR"/passwords/"$INPUT".txt.gpg 2>/dev/null)
            if [[ "$SSHPASS" != "" ]]
            then
                echo Found passcard! SSHing...
                sshpass -e ssh "${@:2}" "$SERVER"
            else
                echo No access to passcard! SSHing...
                ssh "${@:2}" "$SERVER"
            fi
        else
            echo -n "No passcard! Enter alternate passcard (leave blank to continue): "
            read PASSCARD_NAME
            if [[ "$PASSCARD_NAME" != "" ]]
            then
                if [ -e "$PASSCARD_DIR"/passwords/"$PASSCARD_NAME".txt.gpg ]
                then
                    export SSHPASS=$(gpg -d "$PASSCARD_DIR"/passwords/"$PASSCARD_NAME".txt.gpg 2>/dev/null)
                    if [[ "$SSHPASS" != "" ]]
                    then
                        echo Found passcard! SSHing...
                        sshpass -e ssh "${@:2}" "$SERVER"
                    else
                        echo No access to passcard! SSHing...
                        ssh "${@:2}" "$SERVER"
                    fi
                else
                    echo Passcard not found! SSHing...
                    ssh "${@:2}" "$SERVER"
                fi
            else
                echo SSHing...
                ssh "${@:2}" "$SERVER"
            fi
        fi
    else
        echo Unpingable! Using ras host-chaining...
        ssh "${@:2}" -J "$CSL_USERNAME"@ras2.tjhsst.edu "$SERVER"
    fi
}

tjans() {
    # Run a tjCSL ansible playbook intelligently (using ssh passcards, vault password files, etc.)
    ANSIBLE_DIR="/home/krishnan/Tech/tjCSL/ansible"
    CONN_FILE="/home/krishnan/.ansible-playbook-runner-1.sh"
    VAULT_FILE="/home/krishnan/.ansible-playbook-runner-2.sh"

    NUM_FORKS="100"
    CONNECT_USER="root"
    PLAY="$1"
    SSH_PASS_NAME=""
    VAULT_PASS_NAME="ansible"

    if [[ "$PLAY" == "" ]]
    then
        echo "usage: tjans (playbook) [options]..."
        return
    fi

    if [[ "$PLAY" != "-h" ]] && [[ "$PLAY" != "--help" ]]
    then
        shift
    fi

    other_args=()

    while [[ $# -gt 0 ]]
    do
        case $1 in
            -h | --help)
                echo "usage: tjans (playbook) [options]..."
                echo Run a tjCSL ansible play intelligently
                echo
                echo "  -p, --pass PASS                 Specify the name of the passcard file to use when connecting"
                echo "  -v, --vault, --vault-pass PASS  Specify the name of the vault passcard file (excluding \"_vault\") to use"
                echo "  -u, --user USERNAME             Specify the username to connect with"
                echo "  -f, --forks N                   Set the number of concurrent processes to use at once"
                echo
                echo "  ...any other valid ansible-playbook options are also permitted and will be passed to ansible"
                return
                ;;
            -p | --pass)
                SSH_PASS_NAME="$2"
                shift
                shift
                ;;
            -v | --vault | --vault-pass)
                VAULT_PASS_NAME="$2"
                shift
                shift
                ;;
            -u | --user)
                CONNECT_USER="$2"
                shift
                shift
                ;;
            -f | --forks)
                NUM_FORKS="$2"
                shift
                shift
                ;;
            -* | --*)
                other_args+=("$1")
                shift
                ;;
            *)
                other_args+=("$1")
                shift
                ;;
        esac
    done

    set -- "${other_args[@]}"

    export SSHPASS=$(raw-passcard "$SSH_PASS_NAME")
    echo "#!/usr/bin/env bash" > "$CONN_FILE"
    echo 'echo $SSHPASS' >> "$CONN_FILE"
    chmod +x "$CONN_FILE"

    export VAULTPASS=$(raw-passcard "$VAULT_PASS_NAME"_vault)
    echo "#!/usr/bin/env bash" > "$VAULT_FILE"
    echo 'echo $VAULTPASS' >> "$VAULT_FILE"
    chmod +x "$VAULT_FILE"

    echo RUNNING COMMAND: "\n"    ansible-playbook "$ANSIBLE_DIR"/"$PLAY".yml -i "$ANSIBLE_DIR"/hosts -f "$NUM_FORKS" -u "$CONNECT_USER" "$@"
    git -C "$ANSIBLE_DIR" pull
    ansible-playbook "$ANSIBLE_DIR"/"$PLAY".yml -i "$ANSIBLE_DIR"/hosts --connection-password-file "$CONN_FILE" --vault-password-file "$VAULT_FILE" -f "$NUM_FORKS" -u "$CONNECT_USER" "$@"
}

deploy-tin() {
    # Quickly deploy tin using the ansible playbook
    read -s -k "?Create a GitHub release at https://github.com/tjcsl/tin/releases/new, then press ENTER to deploy..."
    echo
    tjans tin -p tin -v tin -t tin-django
}
