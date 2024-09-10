option(DOWNLOAD_MISSING_LIBRARIES "download and build missing libraries if needed" ON)
cmake_print_variables(DOWNLOAD_MISSING_LIBRARIES)
function(handle_missing_library LIB_NAME)
    message(STATUS "------${LIB_NAME}---------")
    if(DOWNLOAD_MISSING_LIBRARIES)
        message(STATUS "${LIB_NAME} library is not found and will be downloaded automatically")
    else()
        message(FATAL_ERROR "${LIB_NAME} library is not found. Install it or pass -DDOWNLOAD_MISSING_LIBRARIES=On during cmake generation")
    endif()
endfunction()

find_library(XM_INCBIN incbin)
if(XM_INCBIN)
    #add_library( STATIC IMPORTED ${KPHP_H3})
else()
    handle_missing_library("incbin")
    FetchContent_Declare(
            incbin
            GIT_REPOSITORY https://github.com/graphitemaster/incbin.git
            GIT_TAG 6e576cae5ab5810f25e2631f2e0b80cbe7dc8cbf
            # GIT_TAG master
    )
    message(STATUS "---------------------")
    FetchContent_MakeAvailable(incbin)
    #include_directories(${incbin_BINARY_DIR}/src/include)
    message("${incbin_SOURCE_DIR}")
    message("${incbin_BINARY_DIR}")
    add_definitions(-DXM_INCBIN_LIB_DIR="${incbin_BINARY_DIR}/lib")
    add_definitions(-DXM_INCBIN_INCLUDE_DIR="${incbin_BINARY_DIR}/src/include")
    add_link_options(-L${incbin_BINARY_DIR}/lib)
endif()

find_library(XM_TABULATE tabulate)
if (XM_TABULATE)

else()
    handle_missing_library("tabulate")
    FetchContent_Declare(
            tabulate
            GIT_REPOSITORY https://github.com/p-ranav/tabulate.git
            GIT_TAG v1.5
    )
    message(STATUS "---------------------")
    FetchContent_MakeAvailable(tabulate)
    #include_directories(${incbin_BINARY_DIR}/src/include)
    message("${tabulate_SOURCE_DIR}")
    message("${tabulate_BINARY_DIR}")
    #add_definitions(-DXM_INCBIN_LIB_DIR="${incbin_BINARY_DIR}/lib")
    #add_definitions(-DXM_INCBIN_INCLUDE_DIR="${incbin_BINARY_DIR}/src/include")
    #add_link_options(-L${incbin_BINARY_DIR}/lib)
endif()

find_library(XM_FASTTEXT fasttext)
if (XM_FASTTEXT)

else()
    handle_missing_library("fasttext")
    FetchContent_Declare(
            fasttext
            GIT_REPOSITORY https://github.com/facebookresearch/fastText.git
            GIT_TAG v0.9.2
    )
    message(STATUS "---------------------")
    FetchContent_MakeAvailable(fasttext)
    #include_directories(${incbin_BINARY_DIR}/src/include)
    message("${fasttext_SOURCE_DIR}")
    message("${fasttext_BINARY_DIR}")
    #add_definitions(-DXM_INCBIN_LIB_DIR="${incbin_BINARY_DIR}/lib")
    #add_definitions(-DXM_INCBIN_INCLUDE_DIR="${incbin_BINARY_DIR}/src/include")
    #add_link_options(-L${incbin_BINARY_DIR}/lib)
endif()

