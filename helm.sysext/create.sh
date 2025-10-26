#!/usr/bin/env bash

RELOAD_SERVICES_ON_MERGE="false"

function list_available_versions() {
  list_github_releases "helm" "helm"
}
# --

function populate_sysext_root() {
  local sysextroot="$1"
  local arch="$2"
  local version="$3"

  local baseurl="https://get.helm.sh/"

  arch="$(arch_transform 'x86-64' 'amd64' "${arch}")"

  tarball="helm-v${version}-linux-${arch}.tar.gz"
  shasum="helm-v${version}-linux-${arch}.tar.gz.sha256sum"

  tarball_url="${baseurl}/${tarball}"
  shasum_url="${baseurl}/${shasum}"
  echo "Downloading ${tarball_url}"

  curl --parallel --fail --silent --show-error --location \
    --output "${tarball}" "${tarball_url}" \
    --output "${shasum}" "${shasum_url}"

  sha256sum -c --ignore-missing "${shasum}" 

  mkdir -p "${sysextroot}/usr/local/bin"
  tar --force-local -xf "${tarball}" -C "${sysextroot}/usr/local/bin" "linux-${arch}/helm"
  mv "${sysextroot}/usr/local/bin/linux-${arch}/helm" "${sysextroot}/usr/local/bin/helm"
  rm -rf "${sysextroot}/usr/local/bin/linux-${arch}"
  chmod +x "${sysextroot}/usr/local/bin/helm"
}
# --
