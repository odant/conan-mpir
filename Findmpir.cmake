find_path(mpir_INCLUDE_DIR
    NAMES mpir.h
    PATHS ${CONAN_INCLUDE_DIRS_MPIR}
    NO_DEFAULT_PATH
)

find_library(mpir_LIBRARY
    NAMES mpir
    PATHS ${CONAN_LIB_DIRS_MPIR}
    NO_DEFAULT_PATH
)

if(mpir_INCLUDE_DIR)

    file(STRINGS ${mpir_INCLUDE_DIR}/mpir.h DEFINE_mpir_MAJOR REGEX "^#define __MPIR_VERSION")
    string(REGEX REPLACE "^.*__MPIR_VERSION +([0-9]+).*$" "\\1" mpir_VERSION_MAJOR "${DEFINE_mpir_MAJOR}")

    file(STRINGS ${mpir_INCLUDE_DIR}/mpir.h DEFINE_mpir_MINOR REGEX "^#define __MPIR_VERSION_MINOR")
    string(REGEX REPLACE "^.*__MPIR_VERSION_MINOR +([0-9]+).*$" "\\1" mpir_VERSION_MINOR "${DEFINE_mpir_MINOR}")

    file(STRINGS ${mpir_INCLUDE_DIR}/mpir.h DEFINE_mpir_REVISION REGEX "^#define __MPIR_VERSION_PATCHLEVEL")
    string(REGEX REPLACE "^.*__MPIR_VERSION_PATCHLEVEL +([0-9]+).*$" "\\1" mpir_VERSION_TWEAK "${DEFINE_mpir_REVISION}")

    set(mpir_VERSION_STRING "${mpir_VERSION_MAJOR}.${mpir_VERSION_MINOR}.${mpir_VERSION_TWEAK}")
    set(mpir_VERSION ${mpir_VERSION_STRING})
    set(mpir_VERSION_COUNT 3)

endif()


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(mpir
    REQUIRED_VARS mpir_INCLUDE_DIR mpir_LIBRARY
    VERSION_VAR mpir_VERSION
)


if(mpir_FOUND AND NOT TARGET mpir::mpir)
    add_library(mpir::mpir UNKNOWN IMPORTED)

    set_target_properties(mpir::mpir PROPERTIES
        IMPORTED_LOCATION "${mpir_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${mpir_INCLUDE_DIR}"
        INTERFACE_COMPILE_DEFINITIONS "${CONAN_COMPILE_DEFINITIONS_MPIR}"
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    )

    mark_as_advanced(mpir_INCLUDE_DIR mpir_LIBRARY)

    set(mpir_INCLUDE_DIRS ${mpir_INCLUDE_DIR})
    set(mpir_LIBRARIES ${mpir_LIBRARY})
    set(mpir_DEFINITIONS ${CONAN_COMPILE_DEFINITIONS_MPIR})

endif()

