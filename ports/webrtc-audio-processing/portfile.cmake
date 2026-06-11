vcpkg_download_distfile(ARCHIVE
    URLS "https://freedesktop.org/software/pulseaudio/webrtc-audio-processing/webrtc-audio-processing-${VERSION}.tar.xz"
    FILENAME "webrtc-audio-processing-${VERSION}.tar.xz"
    SHA512 534af17db1082e900ebd964042679685f26e8452c2e08c6f29660d0484bd5b079c804104600e972281d1ddcbca7762c63cc58b561b175b73447d069dd00f1a61
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES fix-abseil-nullability-compat.patch
)

set(MESON_OPTIONS "")
if(VCPKG_TARGET_IS_WINDOWS)
    # Designated initializers in the WebRTC source require C++20 on MSVC
    list(APPEND MESON_OPTIONS "-Dcpp_std=vc++20")
endif()

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${MESON_OPTIONS}
)

vcpkg_install_meson()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT VCPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
