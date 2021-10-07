PROJECT(envire_core)
cmake_minimum_required(VERSION 2.6)

# class_loader (and rock.core package_set patch) setting boost targets as libs
# so we need search for them here
find_package(Boost COMPONENTS system thread)

SET (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
SET (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/.orogen/config")
INCLUDE(envire_coreBase)

# FIND_PACKAGE(KDL)
# FIND_PACKAGE(OCL)

