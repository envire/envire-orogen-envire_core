PROJECT(envire_core)
cmake_minimum_required(VERSION 2.6)

SET (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
SET (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/.orogen/config")
INCLUDE(envire_coreBase)

# FIND_PACKAGE(KDL)
# FIND_PACKAGE(OCL)

