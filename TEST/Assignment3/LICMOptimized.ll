; ModuleID = 'LICM.bc'
source_filename = "LICM.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@.str = private unnamed_addr constant [25 x i8] c"%d,%d,%d,%d,%d,%d,%d,%d\0A\00", align 1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @foo(i32 noundef %0, i32 noundef %1) #0 !dbg !9 {
  %3 = add nsw i32 %0, 3, !dbg !12
  %4 = add nsw i32 %0, 7, !dbg !13
  %5 = add nsw i32 %0, 3, !dbg !14
  %6 = add nsw i32 %0, 4, !dbg !15
  %7 = add nsw i32 %3, 7, !dbg !16
  %8 = add nsw i32 %0, 7, !dbg !17
  %9 = add nsw i32 %4, 5, !dbg !18
  br label %10, !dbg !19

10:                                               ; preds = %20, %2
  %.05 = phi i32 [ 0, %2 ], [ %9, %20 ], !dbg !20
  %.04 = phi i32 [ 0, %2 ], [ %21, %20 ], !dbg !20
  %.03 = phi i32 [ 0, %2 ], [ %7, %20 ], !dbg !20
  %.01 = phi i32 [ 9, %2 ], [ %.1, %20 ], !dbg !20
  %.0 = phi i32 [ %1, %2 ], [ %11, %20 ]
  %11 = add nsw i32 %.0, 1, !dbg !21
  %12 = icmp slt i32 %11, 5, !dbg !22
  br i1 %12, label %13, label %15, !dbg !23

13:                                               ; preds = %10
  %14 = add nsw i32 %.01, 2, !dbg !24
  br label %20, !dbg !25

15:                                               ; preds = %10
  %16 = sub nsw i32 %.01, 1, !dbg !26
  %17 = icmp sge i32 %11, 10, !dbg !27
  br i1 %17, label %18, label %19, !dbg !28

18:                                               ; preds = %15
  %.lcssa4 = phi i32 [ %16, %15 ], !dbg !26
  %.lcssa3 = phi i32 [ %6, %15 ], !dbg !15
  %.05.lcssa = phi i32 [ %.05, %15 ], !dbg !20
  %.04.lcssa = phi i32 [ %.04, %15 ], !dbg !20
  %.03.lcssa = phi i32 [ %.03, %15 ], !dbg !20
  %.lcssa2 = phi i32 [ %11, %15 ], !dbg !21
  %.lcssa1 = phi i32 [ %3, %15 ], !dbg !12
  %.lcssa = phi i32 [ %4, %15 ], !dbg !13
  br label %22, !dbg !29

19:                                               ; preds = %15
  br label %20

20:                                               ; preds = %19, %13
  %.02 = phi i32 [ %5, %13 ], [ %6, %19 ], !dbg !20
  %.1 = phi i32 [ %14, %13 ], [ %16, %19 ], !dbg !20
  %21 = add nsw i32 %.02, 2, !dbg !30
  br label %10, !dbg !31

22:                                               ; preds = %18
  %23 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %.lcssa4, i32 noundef %.lcssa3, i32 noundef %.03.lcssa, i32 noundef %.04.lcssa, i32 noundef %.lcssa, i32 noundef %.05.lcssa, i32 noundef %.lcssa1, i32 noundef %.lcssa2), !dbg !32
  ret void, !dbg !33
}

declare i32 @printf(ptr noundef, ...) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !34 {
  call void @foo(i32 noundef 0, i32 noundef 4), !dbg !35
  call void @foo(i32 noundef 0, i32 noundef 12), !dbg !36
  ret i32 0, !dbg !37
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.dbg.cu = !{!6}
!llvm.ident = !{!8}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 4]}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = distinct !DICompileUnit(language: DW_LANG_C11, file: !7, producer: "clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 2b92382781fd8ce7ab5c56672bff8a6c3075bff6)", isOptimized: false, runtimeVersion: 0, emissionKind: NoDebug, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.4.sdk", sdk: "MacOSX14.4.sdk")
!7 = !DIFile(filename: "LICM.c", directory: "/Users/simone/LLVM_17/TEST/Assignment3")
!8 = !{!"clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 2b92382781fd8ce7ab5c56672bff8a6c3075bff6)"}
!9 = distinct !DISubprogram(name: "foo", scope: !7, file: !7, line: 3, type: !10, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6)
!10 = !DISubroutineType(types: !11)
!11 = !{}
!12 = !DILocation(line: 8, column: 9, scope: !9)
!13 = !DILocation(line: 9, column: 9, scope: !9)
!14 = !DILocation(line: 12, column: 11, scope: !9)
!15 = !DILocation(line: 15, column: 11, scope: !9)
!16 = !DILocation(line: 20, column: 9, scope: !9)
!17 = !DILocation(line: 22, column: 9, scope: !9)
!18 = !DILocation(line: 23, column: 9, scope: !9)
!19 = !DILocation(line: 4, column: 3, scope: !9)
!20 = !DILocation(line: 0, scope: !9)
!21 = !DILocation(line: 7, column: 9, scope: !9)
!22 = !DILocation(line: 10, column: 9, scope: !9)
!23 = !DILocation(line: 10, column: 7, scope: !9)
!24 = !DILocation(line: 11, column: 11, scope: !9)
!25 = !DILocation(line: 13, column: 3, scope: !9)
!26 = !DILocation(line: 14, column: 11, scope: !9)
!27 = !DILocation(line: 16, column: 11, scope: !9)
!28 = !DILocation(line: 16, column: 9, scope: !9)
!29 = !DILocation(line: 17, column: 7, scope: !9)
!30 = !DILocation(line: 21, column: 9, scope: !9)
!31 = !DILocation(line: 24, column: 3, scope: !9)
!32 = !DILocation(line: 26, column: 3, scope: !9)
!33 = !DILocation(line: 27, column: 1, scope: !9)
!34 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 29, type: !10, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !6)
!35 = !DILocation(line: 30, column: 3, scope: !34)
!36 = !DILocation(line: 31, column: 3, scope: !34)
!37 = !DILocation(line: 32, column: 3, scope: !34)
