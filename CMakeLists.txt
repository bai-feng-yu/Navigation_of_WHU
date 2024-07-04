cmake_minimum_required(VERSION 3.16)

project(Campus-Guide VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
find_package(Qt6 COMPONENTS Core Sql REQUIRED)
find_package(Qt6 COMPONENTS Widgets REQUIRED)
qt_standard_project_setup()

qt_add_executable(appCampus-Guide
    main.cpp
)

qt_add_qml_module(appCampus-Guide
    URI Campus-Guide
    VERSION 1.0
    QML_FILES
        Main.qml
        Triggerable_Button.qml
        SOURCES Point.h
        SOURCES historymodel.h
        SOURCES historymodel.cpp
        SOURCES Point.cpp
        SOURCES Road.h
        SOURCES Road.cpp
        SOURCES Graph.h
        SOURCES Graph.cpp
        SOURCES connection.h
        SOURCES connection.cpp


)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCampus-Guide PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCampus-Guide
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCampus-Guide
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::Sql
    PRIVATE Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS appCampus-Guide
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
