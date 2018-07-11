#ifndef DATAWIDGET_H
#define DATAWIDGET_H

#include <QWidget>
#include "mainwindow.h"

namespace Ui {
class DataWidget;
}

class DataBase: public QWidget
{
    Q_OBJECT

public:
    explicit DataBase(QWidget *parent = nullptr);
    virtual ~DataBase() = default;
    virtual void setData(const Vipster::BaseData *d)=0;
};

class DataWidget : public QWidget, public BaseWidget
{
    Q_OBJECT

public:
    explicit DataWidget(QWidget *parent = nullptr);
    ~DataWidget() override;
    void updateWidget(uint8_t change) override;
    void registerData(const std::string& name);

private slots:
    void on_DataSel_currentIndexChanged(int index);

private:
    Ui::DataWidget *ui;
    const Vipster::BaseData* curData{nullptr};
};

#endif // DATAWIDGET_H
