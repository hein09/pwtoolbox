#-------------------------------------------------
#
# Project created by QtCreator 2016-08-03T17:38:47
#
#-------------------------------------------------

QT       -= core gui

TARGET = vipster
TEMPLATE = lib

DEFINES += LIBVIPSTER_LIBRARY

CONFIG += c++11

SOURCES += \
    config.cpp \
    molecule.cpp \
    step.cpp \
    iowrapper.cpp \
    vec.cpp

HEADERS += \
    config.h \
    molecule.h \
    json.hpp \
    step.h \
    iowrapper.h \
    ioplugin.h \
    global.h \
    atom.h \
    bond.h \
    vec.h \
    ioplugins/xyz.hpp \
    ioplugins/pwinput.hpp

unix {
    target.path = /usr/lib/vipster
    INSTALLS += target
}
unix:CONFIG(debug, debug|release) {
    LIBS += -lgcov
    QMAKE_CXXFLAGS += -fprofile-arcs -ftest-coverage -O0
    QMAKE_LFLAGS += -fprofile-arcs -ftest-coverage -O0
}

DISTFILES += \
    default.json