#ifndef BONDWIDGET_H
#define BONDWIDGET_H

#include <QWidget>
#include "vipster/molecule.h"
#include "bondmodel.h"

namespace Ui {
    class BondWidget;
}

class BondWidget : public QWidget
{
    Q_OBJECT

public:
    explicit BondWidget(QWidget *parent = nullptr);
    ~BondWidget();

private:
    void setActiveStep(Vipster::Step &step, Vipster::Step::selection &sel);
    void updateStep(Vipster::Step &step);
    void recalculateBonds();
    void bondModeHandler(int index);
    void updateOverlap();
    void ovlpTableSelectionHandler();

    Ui::BondWidget *ui;
    BondModel bondModel{};
};

#endif // BONDWIDGET_H