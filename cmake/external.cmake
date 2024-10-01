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

find_library(XM_FUNCTIONALPLUS functionalplus)
if (XM_FUNCTIONALPLUS)

else()
    handle_missing_library("functionalplus")
    FetchContent_Declare(
            functionalplus
            GIT_REPOSITORY https://github.com/Dobiasd/FunctionalPlus.git
            GIT_TAG v0.2.25
    )
    message(STATUS "---------------------")
    FetchContent_MakeAvailable(functionalplus)

#    set(FunctionalPlus_DIR ${functionalplus_SOURCE_DIR}/cmake)

    message("${functionalplus_SOURCE_DIR}")
    message("${functionalplus_BINARY_DIR}")
endif()

find_library(XM_NLOHMANN_JSON nlohmann_json)
if (XM_NLOHMANN_JSON)

else()
    handle_missing_library("nlohmann_json")
    FetchContent_Declare(
            nlohmann_json
            GIT_REPOSITORY https://github.com/nlohmann/json.git
            GIT_TAG v3.11.3
    )
    message(STATUS "---------------------")
    FetchContent_MakeAvailable(nlohmann_json)

 #   set(nlohmann_json_DIR ${nlohmann_json_SOURCE_DIR}/cmake)


    message("${nlohmann_json_SOURCE_DIR}")
    message("${nlohmann_json_BINARY_DIR}")
endif()



find_library(XM_FDEEP fdeep)
if (XM_FDEEP)

else()
    handle_missing_library("fdeep")
    FetchContent_Declare(
            fdeep
            GIT_REPOSITORY https://github.com/Dobiasd/frugally-deep.git
            GIT_TAG v0.16.0
    )
    message(STATUS "---------------------")

    FetchContent_GetProperties(fdeep)
    if(NOT fdeep_POPULATED)
      FetchContent_Populate(fdeep)
    endif()



    FetchContent_MakeAvailable(fdeep)
    #include_directories(${incbin_BINARY_DIR}/src/include)
    message("${fdeep_SOURCE_DIR}")
    message("${fdeep_BINARY_DIR}")
    #add_definitions(-DXM_INCBIN_LIB_DIR="${incbin_BINARY_DIR}/lib")
    #add_definitions(-DXM_INCBIN_INCLUDE_DIR="${incbin_BINARY_DIR}/src/include")
    #add_link_options(-L${incbin_BINARY_DIR}/lib)
endif()


find_library(XM_EIGEN eigen)
if (XM_EIGEN)

else()
    handle_missing_library("eigen")
    FetchContent_Declare(
            eigen
            GIT_REPOSITORY https://gitlab.com/libeigen/eigen.git
            GIT_TAG 3.4.0
    )
    message(STATUS "---------------------")
    FetchContent_MakeAvailable(eigen)

 #   set(nlohmann_json_DIR ${nlohmann_json_SOURCE_DIR}/cmake)


    message("${eigen_SOURCE_DIR}")
    message("${eigen_BINARY_DIR}")
endif()


find_library(XM_MIMALLOC mimalloc)
if (XM_MIMALLOC)

else()
    handle_missing_library("mimalloc")
    FetchContent_Declare(
            mimalloc
            GIT_REPOSITORY https://github.com/microsoft/mimalloc.git
            GIT_TAG v2.1.7
    )
    message(STATUS "---------------------")
    FetchContent_MakeAvailable(mimalloc)

 #   set(nlohmann_json_DIR ${nlohmann_json_SOURCE_DIR}/cmake)


    message("${mimalloc_SOURCE_DIR}")
    message("${mimalloc_BINARY_DIR}")
endif()

find_library(XM_CIVETWEB civetweb)
if (XM_CIVETWEB)

else()
    handle_missing_library("civetweb")
    FetchContent_Declare(
            civetweb
            GIT_REPOSITORY https://github.com/civetweb/civetweb.git
            GIT_TAG v1.16
    )
    message(STATUS "---------------------")

    #set(CIVETWEB_ENABLE_LUA OFF)
    #set(CIVETWEB_ENABLE_IPV6 OFF)
    #set(CIVETWEB_SERVE_NO_FILES ON)
    #set(CIVETWEB_BUILD_TESTING ON)

    FetchContent_MakeAvailable(civetweb)

 #   set(nlohmann_json_DIR ${nlohmann_json_SOURCE_DIR}/cmake)


    message("${civetweb_SOURCE_DIR}")
    message("${civetweb_BINARY_DIR}")
endif()
