#ifndef STEPFORMATTER_H
#define STEPFORMATTER_H

#include "step.h"

namespace Vipster {

class StepProper;
class StepFormatter : public Step
{
public:
    friend class StepProper;
    StepFormatter(StepProper* s, AtomFmt at_fmt);
    StepFormatter(StepProper* s, const StepFormatter& rhs);
    // Atoms
    void            newAtom();
    void            newAtom(const Atom& at);
    void            newAtoms(size_t i);
    void            delAtom(size_t idx);
    AtomRef         operator[](size_t idx);
    const AtomRef   operator[](size_t idx) const;

    // Cell
    void    setCellDim(float cdm, CdmFmt at_fmt, bool scale=false);
    float   getCellDim(CdmFmt at_fmt) const noexcept;
    void    setCellVec(const Mat &vec, bool scale=false);
    Mat     getCellVec() const noexcept;
    Mat     getInvVec(void) const noexcept;
    Vec     getCenter(CdmFmt at_fmt, bool com=false) const noexcept;

    // Comment
    void                setComment(const std::string &s);
    const std::string&  getComment() const noexcept;
private:
    StepProper*     step;
    mutable bool    at_outdated{true};
    void            evaluateCache() const;
};

}

#endif // STEPFORMATTER_H
