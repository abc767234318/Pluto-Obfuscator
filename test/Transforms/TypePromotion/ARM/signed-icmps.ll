; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=arm -type-promotion -verify -disable-type-promotion=false -S %s -o - | FileCheck %s

define i8 @eq_sgt(i8* %x, i8 *%y, i8 zeroext %z) {
; CHECK-LABEL: @eq_sgt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOAD0:%.*]] = load i8, i8* [[X:%.*]], align 1
; CHECK-NEXT:    [[LOAD1:%.*]] = load i8, i8* [[Y:%.*]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[LOAD0]], [[Z:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = sub i8 [[LOAD1]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[ADD]], -56
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 [[SUB]], [[ADD]]
; CHECK-NEXT:    [[RES0:%.*]] = select i1 [[CMP]], i8 35, i8 47
; CHECK-NEXT:    [[RES1:%.*]] = select i1 [[CMP1]], i8 [[RES0]], i8 [[SUB]]
; CHECK-NEXT:    ret i8 [[RES1]]
;
entry:
  %load0 = load i8, i8* %x, align 1
  %load1 = load i8, i8* %y, align 1
  %add = add i8 %load0, %z
  %sub = sub i8 %load1, 1
  %cmp = icmp eq i8 %add, 200
  %cmp1 = icmp sgt i8 %sub, %add
  %res0 = select i1 %cmp, i8 35, i8 47
  %res1 = select i1 %cmp1, i8 %res0, i8 %sub
  ret i8 %res1
}

define i16 @ugt_slt(i16 *%x, i16 zeroext %y, i16 zeroext %z) {
; CHECK-LABEL: @ugt_slt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOAD0:%.*]] = load i16, i16* [[X:%.*]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i16 [[LOAD0]], [[Z:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = sub i16 [[Y:%.*]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[ADD]], [[Z]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i16 [[SUB]], [[Z]]
; CHECK-NEXT:    [[RES0:%.*]] = select i1 [[CMP]], i16 35, i16 -1
; CHECK-NEXT:    [[RES1:%.*]] = select i1 [[CMP1]], i16 [[RES0]], i16 0
; CHECK-NEXT:    ret i16 [[RES1]]
;
entry:
  %load0 = load i16, i16* %x, align 1
  %add = add i16 %load0, %z
  %sub = sub i16 %y, 1
  %cmp = icmp slt i16 %add, %z
  %cmp1 = icmp ugt i16 %sub, %z
  %res0 = select i1 %cmp, i16 35, i16 -1
  %res1 = select i1 %cmp1, i16 %res0, i16 0
  ret i16 %res1
}

define void @urem_trunc_icmps(i16** %in, i32* %g, i32* %k) {
; CHECK-LABEL: @urem_trunc_icmps(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR:%.*]] = load i16*, i16** [[IN:%.*]], align 4
; CHECK-NEXT:    [[LD:%.*]] = load i16, i16* [[PTR]], align 2
; CHECK-NEXT:    [[CMP_I:%.*]] = icmp eq i16 [[LD]], 0
; CHECK-NEXT:    br i1 [[CMP_I]], label [[EXIT:%.*]], label [[COND_FALSE_I:%.*]]
; CHECK:       cond.false.i:
; CHECK-NEXT:    [[REM:%.*]] = urem i16 5, [[LD]]
; CHECK-NEXT:    [[EXTRACT_T:%.*]] = trunc i16 [[REM]] to i8
; CHECK-NEXT:    br label [[BODY:%.*]]
; CHECK:       body:
; CHECK-NEXT:    [[COND_IN_I_OFF0:%.*]] = phi i8 [ [[EXTRACT_T]], [[COND_FALSE_I]] ], [ [[ADD:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[COND_IN_I_OFF0]], 7
; CHECK-NEXT:    [[CONV5:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    store i32 [[CONV5]], i32* [[G:%.*]], align 4
; CHECK-NEXT:    [[DOTPR:%.*]] = load i32, i32* [[K:%.*]], align 4
; CHECK-NEXT:    [[TOBOOL13150:%.*]] = icmp eq i32 [[DOTPR]], 0
; CHECK-NEXT:    br i1 [[TOBOOL13150]], label [[FOR_INC]], label [[EXIT]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[ADD]] = add nuw i8 [[COND_IN_I_OFF0]], 1
; CHECK-NEXT:    br label [[BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %ptr = load i16*, i16** %in, align 4
  %ld = load i16, i16* %ptr, align 2
  %cmp.i = icmp eq i16 %ld, 0
  br i1 %cmp.i, label %exit, label %cond.false.i

cond.false.i:
  %rem = urem i16 5, %ld
  %extract.t = trunc i16 %rem to i8
  br label %body

body:
  %cond.in.i.off0 = phi i8 [ %extract.t, %cond.false.i ], [ %add, %for.inc ]
  %cmp = icmp sgt i8 %cond.in.i.off0, 7
  %conv5 = zext i1 %cmp to i32
  store i32 %conv5, i32* %g, align 4
  %.pr = load i32, i32* %k, align 4
  %tobool13150 = icmp eq i32 %.pr, 0
  br i1 %tobool13150, label %for.inc, label %exit

for.inc:
  %add = add nuw i8 %cond.in.i.off0, 1
  br label %body

exit:
  ret void
}