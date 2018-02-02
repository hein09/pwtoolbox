QT       -= gui core

TARGET = test_libvipster
CONFIG   += c++14
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += \
    catch_main.cpp \
    vec.cpp \
    step.cpp

win32: CONFIG += static
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
