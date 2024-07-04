# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appCampus-Guide_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appCampus-Guide_autogen.dir\\ParseCache.txt"
  "appCampus-Guide_autogen"
  )
endif()
