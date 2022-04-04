#!/bin/bash
#
# Copyright (c) 2021 The Flatcar Maintainers.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# >>> This file is supposed to be SOURCED from the repository ROOT. <<<
#
# sdk_bootstrap() should be called w/ the positional INPUT parameters below.

# Bootstrap SDK build automation stub.
#  This script will use a seed SDK container + tarball to bootstrap a 
#   new SDK tarball.
#
# INPUT:
#
#   1. Version of the SEED SDK to use (string).
#       The seed SDK tarball must be available on https://mirror.release.flatcar-linux.net/sdk/ ...
#       The seed SDK container must be available from https://github.com/orgs/flatcar-linux/packages
#          (via ghcr.io/flatcar-linux/flatcar-sdk-all:[VERSION]).
#
#   2. Version of the TARGET SDK to build (string).
#       The version pattern 'MMMM.m.p' (e.g. '3051.0.0') denotes a "official" build, i.e. a release build to be published.
#       Use any version diverging from the pattern (e.g. '3051.0.0-nightly-4302') for development / CI builds.
#       A free-standing tagged commit will be created in the scripts repo and pushed upstream.
#
# OPTIONAL INPUT:
#
#   3. coreos-overlay repository tag to use (commit-ish).
#       This version will be checked out / pulled from remote in the coreos-overlay git submodule.
#       The submodule config will be updated to point to this version before the TARGET SDK tag is created and pushed.
#       Leave empty to use coreos-overlay as-is.
#
#   4. portage-stable repository tag to use (commit-ish).
#       This version will be checked out / pulled from remote in the portage-stable git submodule.
#       The submodule config will be updated to point to this version before the TARGET SDK tag is created and pushed.
#       Leave empty to use portage-stable as-is.
#
#   5. ARCH. Environment variable. Target architecture for the SDK to run on.
#        Either "amd64" or "arm64"; defaults to "amd64" if not set.
#
# OUTPUT:
#
#   1. SDK tarball (gentoo catalyst output) of the new SDK, pushed to buildcache.
#   2. Updated scripts repository
#        - version tag w/ submodules
#        - sdk_container/.repo/manifests/version.txt denotes new SDK version
#   3. "./ci-cleanup.sh" with commands to clean up temporary build resources,
#        to be run after this step finishes / when this step is aborted.

set -eu

function sdk_bootstrap() {
    local seed_version="$1"
    local version="$2"
    local coreos_git="$3"
    local portage_git="$4"
    : ${ARCH:="amd64"}

    source ci-automation/ci_automation_common.sh
    init_submodules

    check_version_string "${version}"

    if [ -n "${coreos_git}" ] ; then
        update_submodule "coreos-overlay" "${coreos_git}"
    fi
    if [ -n "${portage_git}" ] ; then
        update_submodule "portage-stable" "${portage_git}"
    fi

    # Create new tag in scripts repo w/ updated versionfile + submodules.
    # Also push the changes to the branch ONLY IF we're doing a nightly
    #   build of the 'main' branch AND we're definitely ON the main branch
    #   (`scripts` and submodules).
    local push_branch="false"
    if   [[ "${version}" =~ ^main-[0-9.]+-nightly-[-0-9]+$ ]] \
       && [ "$(git rev-parse --abbrev-ref HEAD)" = "main"  ] \
       && [ "$(git -C sdk_container/src/third_party/coreos-overlay/ rev-parse --abbrev-ref HEAD)" = "main"  ] \
       && [ "$(git -C sdk_container/src/third_party/portage-stable/ rev-parse --abbrev-ref HEAD)" = "main"  ] ; then
        push_branch="true"
        local existing_tag=""
        existing_tag=$(git tag --points-at HEAD) # exit code is always 0, output may be empty
        # If the found tag is a nightly tag, we stop this build if there are no changes
        if [[ "${existing_tag}" =~ ^main-[0-9.]+-nightly-[-0-9]+$ ]]; then
          local ret=0
          git diff --exit-code "${existing_tag}" || ret=$?
          if [ "$ret" = "0" ]; then
            echo "Stopping build because there are no changes since tag ${existing_tag}" >&2
            return 0
          elif [ "$ret" = "1" ]; then
            echo "Found changes since last tag ${existing_tag}" >&2
          else
            echo "Error: Unexpected git diff return code (${ret})" >&2
            return 1
          fi
        fi
    fi

    local vernum="${version#*-}" # remove alpha-,beta-,stable-,lts- version tag
    local git_vernum="${vernum}"

    # This will update FLATCAR_VERSION[_ID] and BUILD_ID in versionfile
    ./bootstrap_sdk_container -x ./ci-cleanup.sh "${seed_version}" "${vernum}"

    # push SDK tarball to buildcache
    source sdk_container/.repo/manifests/version.txt
    local vernum="${FLATCAR_SDK_VERSION}"
    local dest_tarball="flatcar-sdk-${ARCH}-${vernum}.tar.bz2"

    cd "__build__/images/catalyst/builds/flatcar-sdk"
    copy_to_buildcache "sdk/${ARCH}/${vernum}" "${dest_tarball}"*
    cd -

    update_and_push_version "${version}" "${push_branch}"
}
# --
