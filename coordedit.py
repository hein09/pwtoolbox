#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

from PyQt4.QtGui import *
from PyQt4.QtCore import Qt
from copy import deepcopy

class MolArea(QWidget):

        def __init__(self,parent):
                super(MolArea,self).__init__()
                self.initTab()
                self.parent = parent

        def initTab(self):
                # coord fmt dropdown selector
                self.fmt = QComboBox()
                self.fmt.setToolTip('Select format of coordinates')
                for i in ['angstrom','bohr','crystal','alat']:
                        self.fmt.addItem(i)
                self.fmt.setCurrentIndex(2)
                self.fmt.currentIndexChanged.connect(self.fillTab)

                # layout1
                hbox = QHBoxLayout()
                hbox.addWidget(QLabel('Coordinates:'))
                hbox.addWidget(self.fmt)

                # show coordinates in table
                self.table = QTableWidget()
                self.table.setColumnCount(4)
                self.table.setHorizontalHeaderLabels(['Type','x','y','z'])
                self.table.itemChanged.connect(self.cellHandler)
                #show actions in right click menu
                self.table.setContextMenuPolicy(Qt.ActionsContextMenu)

                # show celldm
                self.cellDm = QLineEdit()
                self.cellDm.editingFinished.connect(self.cdmHandler)

                # show cell vectors in table
                self.vtable = QTableWidget()
                self.vtable.setColumnCount(3)
                self.vtable.setRowCount(3)
                self.vtable.setFixedHeight(120)
                self.vtable.setHorizontalHeaderLabels(['x','y','z'])
                self.vtable.itemChanged.connect(self.vecHandler)

                #cell header with label and celldm
                hbox2=QHBoxLayout()
                hbox2.addWidget(QLabel('Cell vectors:'))
                hbox2.addStretch(1)
                hbox2.addWidget(QLabel('Cell dimension:'))
                hbox2.addWidget(self.cellDm)

                #New Atom button:
                newB = QPushButton('New Atom')
                newB.clicked.connect(self.newAtom)

                #Copy Atom button:
                copyB = QPushButton('Copy Atom(s)')
                copyB.clicked.connect(self.copyAt)

                #paste button:
                pasteB = QPushButton('Paste Atom(s)')
                pasteB.clicked.connect(self.pasteAt)

                #delete button:
                delB = QPushButton('Delete Atom(s)')
                delB.clicked.connect(self.delAt)

                #sort buttons
                btns = QHBoxLayout()
                btns.addWidget(copyB)
                btns.addWidget(pasteB)
                btns.addWidget(newB)
                btns.addWidget(delB)

                # actions
                self.newA = QAction('New Atom',self)
                self.newA.setShortcut('Ctrl+N')
                self.newA.triggered.connect(self.newAtom)
                self.table.addAction(self.newA)
                self.copyA = QAction('Copy Atom(s)',self)
                self.copyA.setShortcut('Ctrl+C')
                self.copyA.triggered.connect(self.copyAt)
                self.table.addAction(self.copyA)
                self.pasteA = QAction('Paste Atom(s)',self)
                self.pasteA.setShortcut('Ctrl+V')
                self.pasteA.triggered.connect(self.pasteAt)
                self.table.addAction(self.pasteA)
                self.delA = QAction('Delete Atom(s)',self)
                self.delA.setShortcut('Del')
                self.delA.triggered.connect(self.delAt)
                self.table.addAction(self.delA)

                # Action modifiers
                #TODO: cellHandler,newAt,delAt,pasteAt ?
                self.appAll = QCheckBox('Apply to all Molecules')
                self.scale = QCheckBox('Scale coordinates with cell')
                hbox3 = QHBoxLayout()
                hbox3.addWidget(self.appAll)
                hbox3.addWidget(self.scale)

                # set Layout for Tab
                vbox = QVBoxLayout()
                vbox.addLayout(hbox)
                vbox.addWidget(self.table)
                vbox.addLayout(btns)
                vbox.addLayout(hbox2)
                vbox.addWidget(self.vtable)
                vbox.addLayout(hbox3)

                self.setLayout(vbox)
                self.resize(self.sizeHint())

        #load selected molecule
        def setMol(self,mol):
                #connect molecule
                self.mol = mol
                #fill if visible
                if self.isVisible(): self.fillTab()

        def showEvent(self,e):
                if hasattr(self,'mol'): self.fillTab()

        ##################################################################
        # EDIT FUNCTIONS
        ##################################################################
        def newAtom(self):
                self.mol.create_atom()
                self.mol.set_bonds()
                self.mol.set_pbc_bonds()

                #update Main Widget
                self.parent.updateMolStep()

        def copyAt(self):
                self.sel = []
                for i in self.table.selectedRanges():
                        for j in range(i.topRow(),i.bottomRow()+1):
                                self.sel.append(self.mol.get_atom(j))

        def pasteAt(self):
                pos = self.table.currentRow()+1
                for at in reversed(self.sel):
                        self.mol.insert_atom(pos,at)
                self.mol.set_bonds()
                self.mol.set_pbc_bonds()

                #update Main Widget
                self.parent.updateMolStep()

        def delAt(self):
                delrange = set()
                for i in self.table.selectedRanges():
                        for j in range(i.topRow(),i.bottomRow()+1):
                                delrange.add(j)
                for i in sorted(delrange,reverse=True):
                        self.mol.del_atom(i)
                self.mol.set_bonds()
                self.mol.set_pbc_bonds()
                #update Main Widget
                self.parent.updateMolStep()

        #####################################################
        # UPDATE HANDLER
        ####################################################

        def cdmHandler(self):
                if self.updatedisable: return
                if float(self.cellDm.text()) == self.mol.get_celldm():return
                if self.appAll.isChecked():
                        if self.scale.isChecked():
                                par=self.parent
                                for i in range(int(par.maxStep.text())):
                                        mol=par.controller.get_mol(par.mlist.currentRow(),i)
                                        molc = deepcopy(mol)
                                        mol.set_celldm(float(self.cellDm.text()))
                                        for j in range(mol.get_nat()):
                                                mol.set_atom(j,*molc.get_atom(j,'crystal'))
                                        mol.set_bonds()
                                        mol.set_pbc_bonds()
                                        del(molc)
                        else:
                                par = self.parent
                                for i in range(int(par.maxStep.text())):
                                        par.controller.get_mol(par.mlist.currentRow(),i).set_celldm(float(self.cellDm.text()))
                else:
                        if self.scale.isChecked():
                                mol = deepcopy(self.mol)
                                self.mol.set_celldm(float(self.cellDm.text()))
                                for i in range(mol.get_nat()):
                                        self.mol.set_atom(i,*mol.get_atom(i,'crystal'))
                                self.mol.set_bonds()
                                self.mol.set_pbc_bonds()
                                del(mol)
                        else:
                            self.mol.set_celldm(float(self.cellDm.text()))

                #update Main Widget
                self.parent.updateMolStep()

        def cellHandler(self):
                if self.updatedisable: return
                atom = self.table.currentRow()
                name = str(self.table.item(atom,0).text())
                coord = [0,0,0]
                for j in [0,1,2]:
                        coord[j]=float(self.table.item(atom,j+1).text())
                self.mol.set_atom(atom,name,coord,self.fmt.currentText())
                self.mol.set_bonds()
                self.mol.set_pbc_bonds()

                #update Main Widget
                self.parent.updateMolStep()

        def vecHandler(self):
                if self.updatedisable: return
                vec=[[0,0,0],[0,0,0],[0,0,0]]
                for i in [0,1,2]:
                        for j in [0,1,2]:
                                vec[i][j]=float(self.vtable.item(i,j).text())
                if vec == self.mol.get_vec().tolist(): return
                if self.appAll.isChecked():
                        if self.scale.isChecked():
                                par = self.parent
                                for i in range(int(par.maxStep.text())):
                                        mol = par.controller.get_mol(par.mlist.currentRow(),i)
                                        #molc = deepcopy(mol)
                                        mol.set_vec(vec)
                                        for j in range(mol.get_nat()):
                                                mol.set_atom(j,*mol.get_atom(j,'crystal'))
                                                #mol.set_atom(j,*molc.get_atom(j,'crystal'))
                                        mol.set_bonds()
                                        mol.set_pbc_bonds()
                                        #del(molc)
                        else:
                                par = self.parent
                                for i in range(int(par.maxStep.text())):
                                        par.controller.get_mol(par.mlist.currentRow(),i).set_vec(vec)
                else:
                        if self.scale.isChecked():
                                mol = deepcopy(self.mol)
                                self.mol.set_vec(vec)
                                for i in range(mol.get_nat()):
                                        self.mol.set_atom(i,*mol.get_atom(i,'crystal'))
                                self.mol.set_bonds()
                                self.mol.set_pbc_bonds()
                                del(mol)
                        else:
                                self.mol.set_vec(vec)

                #update Main Widget
                self.parent.updateMolStep()

        ##############################################################
        # MAIN WIDGET UPDATE FUNCTION
        #############################################################

        def fillTab(self):
                #prevent handling of cell changes during fill
                self.updatedisable = True
                self.cellDm.setText(str(self.mol.get_celldm()))
                #fill atom table
                self.table.setRowCount(self.mol.get_nat())
                for i in range(self.mol.get_nat()):
                        at = self.mol.get_atom(i,self.fmt.currentText())
                        self.table.setItem(i,0,QTableWidgetItem(at[0]))
                        for j in [0,1,2]:
                                self.table.setItem(i,j+1,QTableWidgetItem(str(at[1][j])))
                #fill cell vec list
                vec = self.mol.get_vec()
                for i in [0,1,2]:
                        for j in [0,1,2]:
                                self.vtable.setItem(i,j,QTableWidgetItem(str(vec[i,j])))
                #reenable handling
                self.updatedisable = False
