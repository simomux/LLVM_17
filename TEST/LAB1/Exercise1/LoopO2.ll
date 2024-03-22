; ModuleID = 'Loop.bc'
source_filename = "Loop.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@g = common local_unnamed_addr global i32 0, align 4    ;int g (=0?)

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn uwtable(sync)
define i32 @g_incr(i32 noundef %0) local_unnamed_addr #0 {    ;int g_incr(int c)
  %2 = load i32, ptr @g, align 4, !tbaa !6    ;%2 = g
  %3 = add nsw i32 %2, %0                     ;%3 = g + c
  store i32 %3, ptr @g, align 4, !tbaa !6     ;g = %3
  ret i32 %3                                  ;return %3       
}

; Function Attrs: nofree norecurse nosync nounwind ssp uwtable(sync)
define i32 @loop(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {    ;int loop(int a, int b, int c)
  ;3: BB2
  %4 = load i32, ptr @g, align 4, !tbaa !6    ;%4 = g
  %5 = icmp sgt i32 %1, %0                    ;%5 = b > a
  br i1 %5, label %6, label %10               ;jump at BB3 or BB4 based on %5

6:  ;BB3
  %7 = sub i32 %1, %0                         ;%7 = b - a
  %8 = mul i32 %7, %2                         ;%8 = %7 * c
  %9 = add i32 %4, %8                         ;%9 = g + %8
  store i32 %9, ptr @g, align 4, !tbaa !6     ;g = %9
  br label %10                                ;jump at BB4

10:  ;BB4
  %11 = phi i32 [ %9, %6 ], [ %4, %3 ]        ;compute if %11 is %4 from BB2 or %9 from BB3
  ret i32 %11                                 ;return %11
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind ssp willreturn uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nofree norecurse nosync nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 2]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Apple clang version 15.0.0 (clang-1500.1.0.2.5)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
