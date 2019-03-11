#!/usr/bin/env sh
# Run a XWorkspace Container

set -e

#######################################
# Print usage instructions to STDIN
# Arguments:
#   None
# Returns:
#   None
#######################################
usage() {

cat << USAGE

Usage: $SELF [OPTIONS] [COMMAND]
Run a XWorkspace in a new container

Options:
      --dev                 Use "dev" tag instead of "latest"
      --dry                 Automatically remove the container when it exits
      --git                 Bind mount ~/.gitconfig read-only to container
      --help                Print usage
  -h, --hostname string     Container hostname (default 'xworkspace')
      --image               Container image (default 'ashenm/xworkspace')
  -m, --mount path          Bind mount specified directory to ~/workspace
  -n, --name                Assign a name to the container
  -p, --publish             Publish container's 8080, 8081 and 8082 ports to the host
      --ssh                 Bind mount ~/.ssh directory read-only to container
  -v, --volume              Bind mount additional volumes
  -w, --workdir             Working directory inside the container

USAGE

}

#######################################
# Print invalid argument details to STDERR
# Arguments:
#   Invalid argument
# Returns:
#   None
#######################################
invalid() {

cat >&2 << INVALID

$SELF: unrecognized option '$1'
Try '$SELF --help' for more information.

INVALID

}

# script reference
SELF="$(basename "$0")"

# docker options
COMMAND="docker run --detach --publish 5050:5050 --hostname xworkspace"

# parse options
while [ $# -ne 0 ]
do

  case "$1" in

    --help)
      usage
      exit 0
      ;;

    --dry)
      COMMAND="$COMMAND --rm"
      shift
      ;;

    --ssh)
      COMMAND="$COMMAND --volume $(readlink -m ~/.ssh):/home/ubuntu/.ssh:ro"
      shift
      ;;

    --git)
      COMMAND="$COMMAND --volume $(readlink -m ~/.gitconfig):/home/ubuntu/.gitconfig"
      shift
      ;;

    -p|--publish)
      COMMAND="$COMMAND --publish 8080:8080 --publish 8081:8081 --publish 8082:8082"
      shift
      ;;

    -h|--hostname)
      COMMAND="$COMMAND --hostname ${2:?Invalid HOSTNAME}"
      shift 2
      ;;

    -w|--workdir)
      COMMAND="$COMMAND --workdir ${2:?Invalid WORKDIR}"
      shift 2
      ;;

    -v|--volume)
      COMMAND="$COMMAND --volume ${2:?Invalid BIND}"
      shift 2
      ;;

    -n|--name)
      COMMAND="$COMMAND --name ${2:?Invalid NAME}"
      shift 2
      ;;

    -m|--mount)
      CONTAINER_MOUNT="${2:?Invalid VOLUME}"
      shift 2
      ;;

    --image)
      CONTAINER_IMAGE="${2:?Invalid IMAGE}"
      shift 2
      ;;

    --dev)
      CONTAINER_IMAGE_TAG="dev"
      shift
      ;;

    -*|--*)
      invalid "$1"
      exit 1
      ;;

    *)
      break
      ;;

  esac

done

# expand absolute path and append
# if directory bind mount specified
test "$CONTAINER_MOUNT" && \
  COMMAND="$COMMAND --volume $(readlink -m $CONTAINER_MOUNT):/home/ubuntu/workspace"

# handle windows terminal
# emulators Cygwin, MSYS, ...
test "$OS" = "Windows_NT" && \
  COMMAND_PREFIX="winpty"

# override default image
# if explicitly specified
COMMAND="$COMMAND ${CONTAINER_IMAGE:-ashenm/xworkspace}:${CONTAINER_IMAGE_TAG:-latest}"

# spawn container
exec $COMMAND_PREFIX $COMMAND $@
