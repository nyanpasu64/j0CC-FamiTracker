#-------------------------------------------------
#
# Project created by QtCreator 2013-02-05T19:20:22
#
#-------------------------------------------------

TARGET = famitracker
TEMPLATE = lib

QT += core \
      gui

greaterThan(QT_MAJOR_VERSION,4) {
   QT += widgets
   CONFIG += c++11
   macx {
      QMAKE_CFLAGS += -mmacosx-version-min=10.7
      QMAKE_LFLAGS += -mmacosx-version-min=10.7
   }
}

TOP = ../..

macx {
    MAC_SDK  = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk
    if( !exists( $$MAC_SDK) ) {
        error("The selected Mac OSX SDK does not exist at $$MAC_SDK!")
    }
    macx:QMAKE_MAC_SDK = macosx10.13
}

CONFIG += warn_off

CONFIG(release, debug|release) {
   DESTDIR = release
} else {
   DESTDIR = debug
   #DEFINES += _DEBUG
}

OBJECTS_DIR = $$DESTDIR
MOC_DIR = $$DESTDIR
RCC_DIR = $$DESTDIR
UI_DIR = $$DESTDIR

win32 {
   DEPENDENCYROOTPATH = $$TOP/deps
   DEPENDENCYPATH = $$DEPENDENCYROOTPATH/Windows
}
mac {
   DEPENDENCYROOTPATH = $$TOP/deps
   DEPENDENCYPATH = $$DEPENDENCYROOTPATH/osx
}
unix:!mac {
   DEPENDENCYROOTPATH = $$TOP/deps
   DEPENDENCYPATH = $$DEPENDENCYROOTPATH/linux
}

DEFINES -= UNICODE
DEFINES += NOMINMAX NULL=0

INCLUDEPATH += \
   . \
   Source \
   $$TOP/common

# Boost is (thankfully) a generic dependency.
BOOST_CXXFLAGS=-I$$DEPENDENCYROOTPATH/boost_1_64_0

win32 {
   SDL_CXXFLAGS = -I$$DEPENDENCYPATH/SDL
   SDL_LIBS =  -L$$DEPENDENCYPATH/SDL/ -lsdl
}

mac {
   SDL_CXXFLAGS = -I$$DEPENDENCYPATH/SDL.framework/Headers
   SDL_LIBS = -F$$DEPENDENCYPATH -framework SDL

   WINE_CXXFLAGS = -I $$DEPENDENCYROOTPATH/wine/include -DWINE_UNICODE_NATIVE -I $$DEPENDENCYPATH -I $$DEPENDENCYPATH/stdafxhack

   QMAKE_POST_LINK += install_name_tool -change librtmidi.1.dylib \
       @executable_path/../Frameworks/librtmidi.1.dylib \
       $$DESTDIR/libfamitracker.dylib $$escape_expand(\n\t)
}

unix:!mac {
    SDL_CXXFLAGS = $$system(sdl-config --cflags)
    SDL_LIBS = $$system(sdl-config --libs)

    WINE_CXXFLAGS = -I $$DEPENDENCYROOTPATH/wine/include -DUSE_WS_PREFIX -DWINE_UNICODE_NATIVE

   PREFIX = $$(PREFIX)
   isEmpty (PREFIX) {
      PREFIX = /usr/local
   }

   isEmpty (BINDIR) {
                BINDIR=$$PREFIX/bin
   }

   target.path = $$BINDIR
   INSTALLS += target
}

RTMIDI_CXXFLAGS = -I$$DEPENDENCYROOTPATH/rtmidi
RTMIDI_LIBS = -L$$DEPENDENCYROOTPATH/rtmidi/$$DESTDIR -lrtmidi

QMAKE_CXXFLAGS += $$SDL_CXXFLAGS $$BOOST_CXXFLAGS $$RTMIDI_CXXFLAGS $$WINE_CXXFLAGS
QMAKE_CFLAGS += $$SDL_CXXFLAGS $$BOOST_CXXFLAGS $$RTMIDI_CXXFLAGS $$WINE_CXXFLAGS
LIBS += $$SDL_LIBS $$RTMIDI_LIBS

INCLUDEPATH += Source/APU

SOURCES += \
    $$TOP/common/cqtmfc.cpp \
    cqtmfc_famitracker.cpp \
    Source/AboutDlg.cpp \
    Source/Accelerator.cpp \
    Source/Action.cpp \
    Source/APU/APU.cpp \
    Source/APU/DPCM.cpp \
    Source/APU/emu2149.c \
    Source/APU/emu2413.c \
    Source/APU/FDS.cpp \
    Source/APU/FDSSound.cpp \
    Source/APU/Mixer.cpp \
    Source/APU/MMC5.cpp \
    Source/APU/N163.cpp \
    Source/APU/Noise.cpp \
    Source/APU/S5B.cpp \
    Source/APU/Square.cpp \
    Source/APU/Triangle.cpp \
    Source/APU/VRC6.cpp \
    Source/APU/VRC7.cpp \
    Source/Blip_Buffer/Blip_Buffer.cpp \
    Source/ChannelHandler.cpp \
    Source/ChannelMap.cpp \
    Source/Channels2A03.cpp \
    Source/ChannelsDlg.cpp \
    Source/ChannelsFDS.cpp \
    Source/ChannelsMMC5.cpp \
    Source/ChannelsN163.cpp \
    Source/ChannelsS5B.cpp \
    Source/ChannelsVRC6.cpp \
    Source/ChannelsVRC7.cpp \
    Source/Chunk.cpp \
    Source/ChunkRenderBinary.cpp \
    Source/ChunkRenderText.cpp \
    Source/Clipboard.cpp \
    Source/CommandLineExport.cpp \
    Source/CommentsDlg.cpp \
    Source/Compiler.cpp \
    Source/ConfigAppearance.cpp \
    Source/ConfigGeneral.cpp \
    Source/ConfigMIDI.cpp \
    Source/ConfigMixer.cpp \
    Source/ConfigShortcuts.cpp \
    Source/ConfigSound.cpp \
    Source/ConfigWindow.cpp \
    Source/ControlPanelDlg.cpp \
    Source/CreateWaveDlg.cpp \
    Source/CustomControls.cpp \
    Source/CustomExporter.cpp \
    Source/CustomExporter_C_Interface.cpp \
    Source/CustomExporters.cpp \
    Source/DialogReBar.cpp \
    Source/DirectSound.cpp \
    Source/DocumentFile.cpp \
    Source/DocumentWrapper.cpp \
    Source/DSample.cpp \
    Source/ExportDialog.cpp \
    Source/FamiTracker.cpp \
    Source/FamiTrackerDoc.cpp \
    Source/FamiTrackerView.cpp \
    Source/FFT/Fft.cpp \
    Source/FrameAction.cpp \
    Source/FrameEditor.cpp \
    Source/GraphEditor.cpp \
    Source/Graphics.cpp \
    Source/Instrument.cpp \
    Source/Instrument2A03.cpp \
    Source/InstrumentEditDlg.cpp \
    Source/InstrumentEditor2A03.cpp \
    Source/InstrumentEditorDPCM.cpp \
    Source/InstrumentEditorFDS.cpp \
    Source/InstrumentEditorFDSEnvelope.cpp \
    Source/InstrumentEditorN163.cpp \
    Source/InstrumentEditorN163Wave.cpp \
    Source/InstrumentEditorS5B.cpp \
    Source/InstrumentEditorVRC6.cpp \
    Source/InstrumentEditorVRC7.cpp \
    Source/InstrumentEditPanel.cpp \
    Source/InstrumentFDS.cpp \
    Source/InstrumentFileTree.cpp \
    Source/InstrumentListCtrl.cpp \
    Source/InstrumentN163.cpp \
    Source/InstrumentS5B.cpp \
    Source/InstrumentVRC6.cpp \
    Source/InstrumentVRC7.cpp \
    Source/MainFrm.cpp \
    Source/MIDI.cpp \
    Source/ModSequenceEditor.cpp \
    Source/ModuleImportDlg.cpp \
    Source/ModulePropertiesDlg.cpp \
    Source/PatternAction.cpp \
    Source/PatternCompiler.cpp \
    Source/PatternData.cpp \
    Source/PatternEditor.cpp \
    Source/PatternEditorTypes.cpp \
    Source/PCMImport.cpp \
    Source/resampler/resample.cpp \
    Source/resampler/resample.inl \
    Source/resampler/sinc.cpp \
    Source/SampleEditorDlg.cpp \
    Source/SampleEditorView.cpp \
    Source/Sequence.cpp \
    Source/SequenceEditor.cpp \
    Source/SequenceSetting.cpp \
    Source/Settings.cpp \
    Source/SizeEditor.cpp \
    Source/SoundGen.cpp \
    Source/SpeedDlg.cpp \
    Source/TextExporter.cpp \
    Source/TrackerChannel.cpp \
    Source/VisualizerScope.cpp \
    Source/VisualizerSpectrum.cpp \
    Source/VisualizerStatic.cpp \
    Source/VisualizerWnd.cpp \
    Source/WaveEditor.cpp \
    Source/WaveFile.cpp \
    Source/WavProgressDlg.cpp

HEADERS += \
    $$TOP/common/afxmsg_.h \
    $$TOP/common/cqtmfc.h \
    cqtmfc_famitracker.h \
    resource.h \
    Source/AboutDlg.h \
    Source/Accelerator.h \
    Source/Action.h \
    Source/APU/2413tone.h \
    Source/APU/APU.h \
    Source/APU/Channel.h \
    Source/APU/DPCM.h \
    Source/APU/emu2149.h \
    Source/APU/emu2413.h \
    Source/APU/External.h \
    Source/APU/FDS.H \
    Source/APU/FDSSound.h \
    Source/APU/Mixer.h \
    Source/APU/MMC5.H \
    Source/APU/N163.H \
    Source/APU/Noise.h \
    Source/APU/S5B.h \
    Source/APU/Square.h \
    Source/APU/Triangle.h \
    Source/APU/Types.h \
    Source/APU/VRC6.H \
    Source/APU/VRC7.h \
    Source/APU/vrc7tone.h \
    Source/Blip_Buffer/Blip_Buffer.h \
    Source/ChannelHandler.h \
    Source/ChannelMap.h \
    Source/Channels2A03.h \
    Source/ChannelsDlg.h \
    Source/ChannelsFDS.h \
    Source/ChannelsMMC5.h \
    Source/ChannelsN163.h \
    Source/ChannelsS5B.h \
    Source/ChannelsVRC6.h \
    Source/ChannelsVRC7.h \
    Source/Chunk.h \
    Source/ChunkRenderBinary.h \
    Source/ChunkRenderText.h \
    Source/Clipboard.h \
    Source/ColorScheme.h \
    Source/CommandLineExport.h \
    Source/CommentsDlg.h \
    Source/Common.h \
    Source/Compiler.h \
    Source/ConfigAppearance.h \
    Source/ConfigGeneral.h \
    Source/ConfigMIDI.h \
    Source/ConfigMixer.h \
    Source/ConfigShortcuts.h \
    Source/ConfigSound.h \
    Source/ConfigWindow.h \
    Source/ControlPanelDlg.h \
    Source/CreateWaveDlg.h \
    Source/CustomControls.h \
    Source/CustomExporter.h \
    Source/CustomExporter_C_Interface.h \
    Source/CustomExporterInterfaces.h \
    Source/CustomExporters.h \
    Source/DialogReBar.h \
    Source/DirectSound.h \
    Source/DocumentFile.h \
    Source/DocumentWrapper.h \
    Source/Driver.h \
    Source/drivers/config.h \
    Source/drivers/drv_2a03.h \
    Source/drivers/drv_fds.h \
    Source/drivers/drv_mmc5.h \
    Source/drivers/drv_n163.h \
    Source/drivers/drv_vrc6.h \
    Source/drivers/drv_vrc7.h \
    Source/DSample.h \
    Source/ExportDialog.h \
    Source/FamiTracker.h \
    Source/FamiTrackerDoc.h \
    Source/FamiTrackerTypes.h \
    Source/FamiTrackerTypes.h \
    Source/FamiTrackerView.h \
    Source/FFT/Complex.h \
    Source/FFT/Fft.h \
    Source/FrameEditor.h \
    Source/GraphEditor.h \
    Source/Graphics.h \
    Source/Instrument.h \
    Source/InstrumentEditDlg.h \
    Source/InstrumentEditor2A03.h \
    Source/InstrumentEditorDPCM.h \
    Source/InstrumentEditorFDS.h \
    Source/InstrumentEditorFDSEnvelope.h \
    Source/InstrumentEditorN163.h \
    Source/InstrumentEditorN163Wave.h \
    Source/InstrumentEditorS5B.h \
    Source/InstrumentEditorVRC6.h \
    Source/InstrumentEditorVRC7.h \
    Source/InstrumentEditPanel.h \
    Source/InstrumentFileTree.h \
    Source/MainFrm.h \
    Source/MIDI.h \
    Source/ModSequenceEditor.h \
    Source/ModuleImportDlg.h \
    Source/ModulePropertiesDlg.h \
    Source/PatternCompiler.h \
    Source/PatternData.h \
    Source/PatternEditor.h \
    Source/PatternEditorTypes.h \
    Source/PCMImport.h \
    Source/resampler/resample.hpp \
    Source/resampler/sinc.hpp \
    Source/SampleEditorDlg.h \
    Source/SampleEditorView.h \
    Source/Sequence.h \
    Source/SequenceEditor.h \
    Source/SequenceSetting.h \
    Source/Settings.h \
    Source/SizeEditor.h \
    Source/SoundGen.h \
    Source/SpeedDlg.h \
    Source/stdafx.h \
    Source/TextExporter.h \
    Source/TrackerChannel.h \
    Source/VisualizerScope.h \
    Source/VisualizerSpectrum.h \
    Source/VisualizerStatic.h \
    Source/VisualizerWnd.h \
    Source/WaveEditor.h \
    Source/WaveFile.h \
    Source/WavProgressDlg.h \
    version.h

symbian {
    MMP_RULES += EXPORTUNFROZEN
    TARGET.UID3 = 0xEABB3021
    TARGET.CAPABILITY =
    TARGET.EPOCALLOWDLLDATA = 1
    addFiles.sources = famitracker.dll
    addFiles.path = !:/sys/bin
    DEPLOYMENT += addFiles
}

win32 {
    HEADERS += stdafx.h
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /usr/lib
    }
    INSTALLS += target
}

OTHER_FILES += \
    famitracker-lib.pro

FORMS +=

RESOURCES += \
    $$TOP/common/resource.qrc
