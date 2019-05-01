# Maintainer: Aleksandr Mezin <mezin.alexander@gmail.com>

_pkgbase=amdgpu-amd-drm-next-git
pkgname=$_pkgbase-dkms
pkgver=5.1.0.rc5.816ac566867f
pkgrel=1
pkgdesc="amdgpu driver built as dkms package"
arch=('x86_64')
url="https://cgit.freedesktop.org/~agd5f/linux"
license=('GPL2')
depends=('dkms')
conflicts=("${_pkgbase}")
source=("git+git://people.freedesktop.org/~agd5f/linux#branch=drm-next"
        'dkms.conf'
        'Makefile')
md5sums=('SKIP'
         '6df862acb27f4bdacd9339f856c22321'
         'a3e4200a442b81ebb4776c45aa162dfe')

pkgver() {
  cd linux
  VERSION=$(sed -n 's/^VERSION = \(.*\)/\1/p' Makefile)
  PATCHLEVEL=$(sed -n 's/^PATCHLEVEL = \(.*\)/\1/p' Makefile)
  SUBLEVEL=$(sed -n 's/^SUBLEVEL = \(.*\)/\1/p' Makefile)
  EXTRAVERSION=$(sed -n 's/^EXTRAVERSION = \(.*\)/\1/p' Makefile | tr - .)
  echo $VERSION.$PATCHLEVEL.$SUBLEVEL$EXTRAVERSION.$(git rev-parse --short HEAD)
}

prepare() {
  cd linux
  git revert -n bb1c08f9828889ebe3496cf94f6a5f9d6c27fdaf
}

package() {
  # Copy dkms.conf
  install_src_dir="${pkgdir}"/usr/src/${_pkgbase}-${pkgver}

  install -dm755 "${install_src_dir}"
  install -Dm644 dkms.conf "${install_src_dir}"/
  install -Dm644 Makefile "${install_src_dir}"/

  # Set name and version
  sed -e "s/@PKGBASE@/${_pkgbase}/" \
      -e "s/@PKGVER@/${pkgver}/" \
      -i "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/dkms.conf

  cp -r linux/drivers/gpu/drm/{amd,ttm,scheduler} "${install_src_dir}"/
  sed -e "s!#define TRACE_INCLUDE_PATH .*!#define TRACE_INCLUDE_PATH \./!" -i "${install_src_dir}"/scheduler/gpu_scheduler_trace.h
  sed -e "s!#define TRACE_INCLUDE_PATH .*!#define TRACE_INCLUDE_PATH \./!" -i "${install_src_dir}"/amd/amdgpu/amdgpu_trace.h

  install -dm755 "${install_src_dir}"/include/drm
  cp -r linux/include/drm/{ttm,gpu_scheduler.h,spsc_queue.h,amd_*.h,drm_vma_manager.h} "${install_src_dir}"/include/drm/
  ln -s "${install_src_dir}"/scheduler/gpu_scheduler_trace.h "${install_src_dir}"/include/drm/
  ln -s "${install_src_dir}"/amd/amdgpu/amdgpu_trace.h "${install_src_dir}"/include/drm/

  install -dm755 "${install_src_dir}"/include/uapi/drm
  cp -r linux/include/uapi/drm/amdgpu_drm.h "${install_src_dir}"/include/uapi/drm/
  sed -e "s!\"drm\.h\"!<drm/drm\.h>!" -i "${install_src_dir}"/include/uapi/drm/amdgpu_drm.h

  install -dm755 "${install_src_dir}"/include/uapi/linux
  cp -r linux/include/uapi/linux/kfd_ioctl.h "${install_src_dir}"/include/uapi/linux/

  install -dm755 "${install_src_dir}"/radeon
  cp -r linux/drivers/gpu/drm/radeon/cik_reg.h "${install_src_dir}"/radeon/
}
