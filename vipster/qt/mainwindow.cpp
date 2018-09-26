#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "savefmtdialog.h"
#include <QMessageBox>
#include <QFileDialog>
#include <QInputDialog>
#include <QApplication>
#include <QStyle>

using namespace Vipster;

MainWindow::MainWindow(QString path, QWidget *parent):
    QMainWindow{parent},
    ui{new Ui::MainWindow},
    path{path}
{
    ui->setupUi(this);
    connect(ui->actionAbout_Qt, &QAction::triggered, qApp, &QApplication::aboutQt);
    connect(&playTimer, &QTimer::timeout, ui->stepEdit, &QSpinBox::stepUp);
    setupUI();
    newMol();
}

MainWindow::MainWindow(QString path, std::vector<IO::Data> &&d, QWidget *parent):
    QMainWindow{parent},
    ui{new Ui::MainWindow},
    path{path}
{
    ui->setupUi(this);
    setupUI();
    connect(ui->actionAbout_Qt, &QAction::triggered, qApp, &QApplication::aboutQt);
    connect(&playTimer, &QTimer::timeout, ui->stepEdit, &QSpinBox::stepUp);
    for(auto&& mol: d){
        newData(std::move(mol));
    }
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::setupUI()
{
    ui->firstStepButton->setIcon(style()->standardIcon(QStyle::SP_MediaSkipBackward));
    ui->preStepButton->setIcon(style()->standardIcon(QStyle::SP_MediaSeekBackward));
    ui->playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
    ui->nextStepButton->setIcon(style()->standardIcon(QStyle::SP_MediaSeekForward));
    ui->lastStepButton->setIcon(style()->standardIcon(QStyle::SP_MediaSkipForward));
    // setup left dock-area
    baseWidgets = {
        ui->paramDock,
        ui->configDock,
        ui->settingsDock,
        ui->mpseDock,
        ui->pseDock,
        ui->dataDock,
    };
    for(auto& w: baseWidgets){
        tabifyDockWidget(ui->molDock, w);
    }
    ui->molDock->raise();
    // setup right dock-area
    toolWidgets = {
        ui->scriptDock,
        ui->pickDock,
        ui->cellModDock,
        ui->millerDock,
    };
    for(auto& w: toolWidgets){
        auto action = ui->toolBar->addAction(w->windowTitle());
        action->setCheckable(true);
        connect(action, &QAction::toggled, w, &QWidget::setVisible);
        w->hide();
    }
#ifdef Q_OS_MACOS
    setDockOptions(dockOptions()^VerticalTabs);
#endif
    // fill in global PSE
    ui->pseWidget->setPSE(&Vipster::pse);
    // fill in menu-options
    for(const auto& pair:IOPlugins){
        const auto& param_map = Vipster::params[pair.first];
        if(!param_map.empty()){
            auto* param_menu = ui->menuLoad_Parameter_set->addMenu(
                        QString::fromStdString(pair.second->name));
            for(const auto& p: param_map){
                param_menu->addAction(QString::fromStdString(p.first),
                                      this, &MainWindow::loadParam);
            }
        }
        const auto& conf_map = Vipster::configs[pair.first];
        if(!conf_map.empty()){
            auto* conf_menu = ui->menuLoad_IO_Config->addMenu(
                        QString::fromStdString(pair.second->name));
            for(const auto& p: conf_map){
                conf_menu->addAction(QString::fromStdString(p.first),
                                     this, &MainWindow::loadConfig);
            }
        }
    }
}

void MainWindow::updateWidgets(uint8_t change)
{
    ui->openGLWidget->updateWidget(change);
    ui->molWidget->updateWidget(change);
    for(auto& w: baseWidgets){
        static_cast<BaseWidget*>(w->widget())->updateWidget(change);
    }
    for(auto& w: toolWidgets){
        static_cast<BaseWidget*>(w->widget())->updateWidget(change);
    }
}

void MainWindow::setFmt(int i, bool apply, bool scale)
{
    fmt = static_cast<AtomFmt>(i);
    if(apply){
        curStep->setFmt(fmt, scale);
        updateWidgets(guiStepChanged);
    }else{
        updateWidgets(GuiChange::fmt);
    }
}

AtomFmt MainWindow::getFmt()
{
    return fmt;
}

void MainWindow::setMol(int i)
{
    curMol = &*std::next(molecules.begin(), i);
    int steps = static_cast<int>(curMol->getNstep());
    //Step-control
    ui->stepLabel->setText(QString::number(steps));
    QSignalBlocker boxBlocker(ui->stepEdit);
    QSignalBlocker slideBlocker(ui->stepSlider);
    ui->stepEdit->setMaximum(steps);
    ui->stepSlider->setMaximum(steps);
    if(steps == 1){
        ui->stepEdit->setDisabled(true);
        ui->stepSlider->setDisabled(true);
    }else{
        ui->stepEdit->setEnabled(true);
        ui->stepSlider->setEnabled(true);
    }
    setStep(static_cast<int>(steps));
    updateWidgets(guiMolChanged);
}

void MainWindow::setStep(int i)
{
    if(playTimer.isActive() && (i == static_cast<int>(curMol->getNstep()))){
        playTimer.stop();
        ui->playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
    }
    curStep = &curMol->getStep(static_cast<size_t>(i-1));
    curSel = &curStep->getLastSelection();
    fmt = curStep->getFmt();
    //Handle control-elements
    QSignalBlocker boxBlocker(ui->stepEdit);
    QSignalBlocker slideBlocker(ui->stepSlider);
    ui->stepEdit->setValue(i);
    ui->stepSlider->setValue(i);
    if(i == 1){
        ui->preStepButton->setDisabled(true);
        ui->firstStepButton->setDisabled(true);
    }else{
        ui->preStepButton->setEnabled(true);
        ui->firstStepButton->setEnabled(true);
    }
    if(i == static_cast<int>(curMol->getNstep())){
        ui->nextStepButton->setDisabled(true);
        ui->lastStepButton->setDisabled(true);
    }else{
        ui->nextStepButton->setEnabled(true);
        ui->lastStepButton->setEnabled(true);
    }
    //Update child widgets
    updateWidgets(guiStepChanged);
}

void MainWindow::stepBut(QAbstractButton* but)
{
    if(but == ui->firstStepButton){
        setStep(1);
    }else if(but == ui->lastStepButton){
        setStep(static_cast<int>(curMol->getNstep()));
    }else if(but == ui->playButton){
        if(playTimer.isActive()){
            playTimer.stop();
            ui->playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
        }else{
            playTimer.start(1000);
            ui->playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPause));
        }
    }
}

void MainWindow::editAtoms()
{
    const QObject *sender = QObject::sender();
    if ( sender == ui->actionNew_Atom){
        curStep->newAtom();
    }else if ( sender == ui->actionDelete_Atom_s){
        curSel->delAtoms();
    }else if ( sender == ui->actionHide_Atom_s){
        for(auto& at: *curSel){
            at.properties->flags[AtomFlag::Hidden] = 1;
        }
    }else if ( sender == ui->actionShow_Atom_s){
        for(auto& at: *curSel){
            at.properties->flags[AtomFlag::Hidden] = 0;
        }
    }
    updateWidgets(GuiChange::atoms);
}

void MainWindow::newMol()
{
    molecules.emplace_back();
    ui->molWidget->registerMol(molecules.back().getName());
}

void MainWindow::newData(IO::Data &&d)
{
    molecules.push_back(std::move(d.mol));
    ui->molWidget->registerMol(molecules.back().getName());
    if(d.param){
        ui->paramWidget->registerParam(d.fmt, std::move(d.param));
    }
    for(auto& dat: d.data){
        data.push_back(std::move(dat));
        ui->dataWidget->registerData(data.back()->name);
    }
}

void MainWindow::loadMol()
{
    // File dialog
    QStringList files;
    QFileDialog fileDiag{this};
    fileDiag.setDirectory(path);
    fileDiag.setFileMode(QFileDialog::ExistingFiles);
    // Format dialog
    QStringList formats{};
    for(auto &iop: IOPlugins){
        formats << QString::fromStdString(iop.second->name);
    }
    QString fmt_s;
    IOFmt fmt;
    bool got_fmt{false};
    if(fileDiag.exec() != 0){
        files = fileDiag.selectedFiles();
        path = fileDiag.directory();
        if(files.count() != 0){
            fmt_s = QInputDialog::getItem(this, "Select format", "Format:",
                                          formats, 0, false, &got_fmt);
            if(got_fmt){
                fmt = static_cast<IOFmt>(formats.indexOf(fmt_s));
                for(auto &file: files){
                    newData(readFile(file.toStdString(), fmt));
                }
            }
        }
    }
}

void MainWindow::saveMol()
{
    QFileDialog fileDiag{this};
    fileDiag.setDirectory(path);
    fileDiag.setAcceptMode(QFileDialog::AcceptSave);
    if(fileDiag.exec() != 0){
        auto target = fileDiag.selectedFiles()[0].toStdString();
        path = fileDiag.directory();
        SaveFmtDialog sfd{this};
        if(sfd.exec() != 0){
            writeFile(target, sfd.fmt, *curMol,
                      sfd.getParam(), sfd.getConfig(),
                      IO::State{static_cast<size_t>(ui->stepSlider->value()-1),
                                this->fmt,
                                ui->molWidget->getCellFmt()});
        }
    }
}


const std::vector<std::pair<IOFmt, std::unique_ptr<IO::BaseParam>>>& MainWindow::getParams() const noexcept
{
    return ui->paramWidget->params;
}

const std::vector<std::pair<IOFmt, std::unique_ptr<IO::BaseConfig>>>& MainWindow::getConfigs() const noexcept
{
    return ui->configWidget->configs;
}

void MainWindow::addExtraData(GUI::Data* dat)
{
    ui->openGLWidget->addExtraData(dat);
    updateWidgets(GuiChange::extra);
}

void MainWindow::delExtraData(GUI::Data* dat)
{
    ui->openGLWidget->delExtraData(dat);
    updateWidgets(GuiChange::extra);
}

const GUI::GlobalData& MainWindow::getGLGlobals()
{
    return ui->openGLWidget->globals;
}

void MainWindow::loadParam()
{
    auto* s = static_cast<QAction*>(sender());
    auto* p = static_cast<QMenu*>(s->parent());
    IOFmt fmt = [](QString name){
        for(const auto& pair:IOPlugins){
            if(name == pair.second->name.c_str()){
                return pair.first;
            }
        }
        throw Error("Invalid parameter set");
    }(p->title());
    auto pos = Vipster::params[fmt].find(s->text().toStdString());
    if(pos != Vipster::params[fmt].end()){
        ui->paramWidget->registerParam(fmt, pos->second->copy());
    }else{
        throw Error("Invalid parameter set");
    }
}

void MainWindow::loadConfig()
{
    auto* s = static_cast<QAction*>(sender());
    auto* p = static_cast<QMenu*>(s->parent());
    IOFmt fmt = [](QString name){
        for(const auto& pair:IOPlugins){
            if(name == pair.second->name.c_str()){
                return pair.first;
            }
        }
        throw Error("Invalid IO-config");
    }(p->title());
    auto pos = Vipster::configs[fmt].find(s->text().toStdString());
    if(pos != Vipster::configs[fmt].end()){
        ui->configWidget->registerConfig(fmt, pos->second->copy());
    }else{
        throw Error("Invalid IO-config");
    }
}

void MainWindow::saveParam()
{
    if(!ui->paramWidget->curParam){
        return;
    }
    bool ok;
    auto name = QInputDialog::getText(this, "Save parameter set", "Name of preset",
                                      QLineEdit::Normal, QString(), &ok);
    if(ok){
        Vipster::params[ui->paramWidget->curFmt][name.toStdString()] =
                ui->paramWidget->curParam->copy();
    }
}

void MainWindow::saveConfig()
{
    if(!ui->configWidget->curConfig){
        return;
    }
    bool ok;
    auto name = QInputDialog::getText(this, "Save IO-Config", "Name of preset",
                                      QLineEdit::Normal, QString(), &ok);
    if(ok){
        Vipster::configs[ui->configWidget->curFmt][name.toStdString()] =
                ui->configWidget->curConfig->copy();
    }
}

void MainWindow::about()
{
    QMessageBox::about(this,QString("About Vipster"),
    QString("<h2>Vipster</h2>"
            "<p>"
            "©Sebastian Gsänger, 2018"
            "<br>"
            "<a href='https://sgsaenger.github.io/vipster'>Homepage</a>"
            "<br>"
            "<a href='https://github.com/sgsaenger/vipster'>Source</a>"
            "</p>"
            "<p>"
            "This program is provided under the GPLv3."
            "<br>"
            "It uses"
            "<a href='https://github.com/nlohmann/json'>JSON for Modern C++</a>, "
            "<a href='https://github.com/CLIUtils/CLI11'>CLI11</a>,"
            "<a href='https://github.com/catchorg/catch2'>Catch2</a> and "
            "<a href='https://github.com/pybind/pybind11'>pybind11</a>."
            "</p>"));
}

BaseWidget::BaseWidget(QWidget* parent)
    :QWidget{parent}
{
    for(auto *w: qApp->topLevelWidgets()){
        if(auto *t = qobject_cast<MainWindow*>(w)){
            master = t;
            return;
        }
    }
    throw Error("Could not determine MainWindow-instance.");
}

void BaseWidget::triggerUpdate(uint8_t change)
{
    updateTriggered = true;
    master->updateWidgets(change);
}
