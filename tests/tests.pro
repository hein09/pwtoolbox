#-------------------------------------------------
#
# Project created by QtCreator 2016-10-08T14:48:06
#
#-------------------------------------------------

QT       += testlib

QT       -= gui

TARGET = tst_libvipstertest
CONFIG   += console\
            c++11
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += tst_libvipstertest.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libvipster/release/ -lvipster
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libvipster/debug/ -lvipster
else:unix: LIBS += -L$$OUT_PWD/../libvipster/ -lvipster
unix:CONFIG(debug, debug|release) {
    LIBS += -lgcov
    QMAKE_CXXFLAGS += -fprofile-arcs -ftest-coverage -O0
    QMAKE_LFLAGS += -fprofile-arcs -ftest-coverage -O0
}

INCLUDEPATH += $$PWD/../libvipster
DEPENDPATH += $$PWD/../libvipster