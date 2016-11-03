#ifndef MOLWIDGET_H
#define MOLWIDGET_H

#include <QWidget>
#include <mainwindow.h>
#include <step.h>
#include <molecule.h>
#include <vector>

namespace Ui {
class MolWidget;
}

class MolWidget : public QWidget
{
    Q_OBJECT

public:
    explicit MolWidget(QWidget *parent = 0);
    ~MolWidget();
    void setStep(Vipster::Step *step);
    void setMolecules(const std::vector<Vipster::Molecule> &molecules);

private slots:
    void on_cellDimBox_valueChanged(double cdm);
    void on_cellVecTable_cellChanged(int row, int column);
    void on_atomTable_cellChanged(int row, int column);

private:
    MainWindow *parent;
    Ui::MolWidget *ui;
    Vipster::Step *curStep;
};

#endif // MOLWIDGET_H
