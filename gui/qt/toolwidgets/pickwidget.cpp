#include "../mainwindow.h"
#include "pickwidget.h"
#include "ui_pickwidget.h"

using namespace Vipster;

PickWidget::PickWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::PickWidget)
{
    ui->setupUi(this);

    connect(&vApp, &MainWindow::selChanged, this, &PickWidget::updateSelection);
    connect(&vApp, &MainWindow::activeStepChanged,
            this, [&](const Step &, const Step::selection &sel) { updateSelection(sel); });
}

PickWidget::~PickWidget()
{
    delete ui;
}

static inline void printDist(QPlainTextEdit& text,
                      QString idx1, QString idx2, double dist)
{
    QString tmp = "Dist " + idx1 + '-' + idx2 + ": " +
            QLocale::system().toString(dist) + " Å";
    text.appendPlainText(tmp);
}

static inline void printAngle(QPlainTextEdit& text,
                       QString idx1, QString idx2, QString idx3, double ang)
{
    QString tmp = "Angle " + idx1 + '-' +
            idx2 + '-' + idx3 + ": " +
            QString::number(ang) + "°";
    text.appendPlainText(tmp);
}

static inline void printDihed(QPlainTextEdit& text,
                       QString idx1, QString idx2, QString idx3, QString idx4, double dihed)
{
    QString tmp = "Dihed " +
            idx1 + '-' + idx2 + '-' +
            idx3 + '-' + idx4 + ": " +
            QString::number(dihed) + "°";
    text.appendPlainText(tmp);
}

void PickWidget::updateSelection(const Step::selection &s)
{
    auto sel = s.asFmt(AtomFmt::Angstrom);
    auto& text = *ui->PickText;
    text.setPlainText("Atoms:");

    const size_t nat = sel.getNat();
    std::vector<QString> names;
    std::map<size_t, int> count;
    for(auto it = sel.cbegin(); it != sel.cend() ;++it){
        names.push_back(QString::number(it->idx) + QString{count[it->idx]++, '\''});
        const SizeVec& off = it->off;
        if(off != SizeVec{}){
            text.appendPlainText(names.back() + '(' +
                                 QString::fromStdString(it->name) + ") <" +
                                 QString::number(off[0]) + ',' +
                                 QString::number(off[1]) + ',' +
                                 QString::number(off[2]) + '>');
        }else{
            text.appendPlainText(names.back()+'('+
                                 QString::fromStdString(it->name)+')');
        }
    }

    switch(nat){
    case 2:
        text.appendPlainText(QString{"Distance %1-%2: %3"}
                             .arg(names[0])
                             .arg(names[1])
                             .arg(Vec_length(sel[0].coord - sel[1].coord)));
        break;
    case 3:
    {
        const auto diff01 = sel[0].coord - sel[1].coord;
        const auto diff21 = sel[2].coord - sel[1].coord;
        const auto dist01 = Vec_length(diff01);
        const auto dist21 = Vec_length(diff21);
        const auto ang012 = (std::acos(Vec_dot(diff01, diff21) / (dist01 * dist21))) * rad2deg;
        text.appendPlainText(QString{"Angle %1-%2-%3: %4"}
                             .arg(names[0])
                             .arg(names[1])
                             .arg(names[2])
                             .arg(ang012));
        break;
    }
    case 4:
    {
        auto diff01 = sel[0].coord - sel[1].coord;
        auto diff21 = sel[2].coord - sel[1].coord;
        auto cross012 = Vec_cross(diff01, diff21);
        auto len012 = Vec_length(cross012);
        auto diff23 = sel[2].coord - sel[3].coord;
        auto cross123 = Vec_cross(diff21, diff23);
        auto len123 = Vec_length(cross123);
        auto dihed0123 = (std::acos(Vec_dot(cross012, cross123) / (len012 * len123)))
                         * rad2deg;
        text.appendPlainText(QString{"Dihedral %1-%2-%3-%4: %5"}
                             .arg(names[0])
                             .arg(names[1])
                             .arg(names[2])
                             .arg(names[3])
                             .arg(dihed0123));
        break;
    }
    default:
        break;
    }
}
