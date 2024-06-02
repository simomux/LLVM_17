; ModuleID = 'Foo.bc'
source_filename = "LoopUnguarded.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @calculateVectors(i32 noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, ptr noundef %4) #0 !dbg !9 {
  br label %6, !dbg !12

6:                                                ; preds = %19, %5
  %.0 = phi i32 [ 0, %5 ], [ %20, %19 ], !dbg !13
  %7 = icmp slt i32 %.0, %0, !dbg !14
  br i1 %7, label %8, label %36

8:                                                ; preds = %6
  %9 = sext i32 %.0 to i64, !dbg !15
  %10 = getelementptr inbounds i32, ptr %2, i64 %9, !dbg !15
  %11 = load i32, ptr %10, align 4, !dbg !15
  %12 = sdiv i32 1, %11, !dbg !16
  %13 = sext i32 %.0 to i64, !dbg !17
  %14 = getelementptr inbounds i32, ptr %3, i64 %13, !dbg !17
  %15 = load i32, ptr %14, align 4, !dbg !17
  %16 = mul nsw i32 %12, %15, !dbg !18
  %17 = sext i32 %.0 to i64, !dbg !19
  %18 = getelementptr inbounds i32, ptr %1, i64 %17, !dbg !19
  store i32 %16, ptr %18, align 4, !dbg !20
  br label %24, !dbg !21

19:                                               ; preds = %24
  %20 = add nsw i32 %.0, 1, !dbg !22
  br label %6, !dbg !23, !llvm.loop !24

21:                                               ; No predecessors!
  br label %22, !dbg !26

22:                                               ; preds = %34, %21
  %.1 = phi i32 [ 0, %21 ], [ %35, %34 ], !dbg !27
  %23 = icmp slt i32 %.0, %0, !dbg !28
  br label %34

24:                                               ; preds = %8
  %25 = sext i32 %.0 to i64, !dbg !29
  %26 = getelementptr inbounds i32, ptr %1, i64 %25, !dbg !29
  %27 = load i32, ptr %26, align 4, !dbg !29
  %28 = sext i32 %.0 to i64, !dbg !30
  %29 = getelementptr inbounds i32, ptr %3, i64 %28, !dbg !30
  %30 = load i32, ptr %29, align 4, !dbg !30
  %31 = add nsw i32 %27, %30, !dbg !31
  %32 = sext i32 %.0 to i64, !dbg !32
  %33 = getelementptr inbounds i32, ptr %4, i64 %32, !dbg !32
  store i32 %31, ptr %33, align 4, !dbg !33
  br label %19, !dbg !34

34:                                               ; preds = %22
  %35 = add nsw i32 %.0, 1, !dbg !35
  br label %22, !dbg !36, !llvm.loop !37

36:                                               ; preds = %6
  ret void, !dbg !38
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.dbg.cu = !{!6}
!llvm.ident = !{!8}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 5]}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = distinct !DICompileUnit(language: DW_LANG_C11, file: !7, producer: "clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 48350d3603ba5887a7b62677ebd80cbedb62411b)", isOptimized: false, runtimeVersion: 0, emissionKind: NoDebug, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.5.sdk", sdk: "MacOSX14.5.sdk")
!7 = !DIFile(filename: "LoopUnguarded.c", directory: "/Users/simone/LLVM_17/TEST/Assignment4")
!8 = !{!"clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 48350d3603ba5887a7b62677ebd80cbedb62411b)"}
!9 = distinct !DISubprogram(name: "calculateVectors", scope: !7, file: !7, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6)
!10 = !DISubroutineType(types: !11)
!11 = !{}
!12 = !DILocation(line: 3, column: 8, scope: !9)
!13 = !DILocation(line: 3, scope: !9)
!14 = !DILocation(line: 3, column: 17, scope: !9)
!15 = !DILocation(line: 4, column: 16, scope: !9)
!16 = !DILocation(line: 4, column: 14, scope: !9)
!17 = !DILocation(line: 4, column: 23, scope: !9)
!18 = !DILocation(line: 4, column: 21, scope: !9)
!19 = !DILocation(line: 4, column: 5, scope: !9)
!20 = !DILocation(line: 4, column: 10, scope: !9)
!21 = !DILocation(line: 5, column: 3, scope: !9)
!22 = !DILocation(line: 3, column: 23, scope: !9)
!23 = !DILocation(line: 3, column: 3, scope: !9)
!24 = distinct !{!24, !23, !21, !25}
!25 = !{!"llvm.loop.mustprogress"}
!26 = !DILocation(line: 7, column: 8, scope: !9)
!27 = !DILocation(line: 7, scope: !9)
!28 = !DILocation(line: 7, column: 17, scope: !9)
!29 = !DILocation(line: 8, column: 12, scope: !9)
!30 = !DILocation(line: 8, column: 19, scope: !9)
!31 = !DILocation(line: 8, column: 17, scope: !9)
!32 = !DILocation(line: 8, column: 5, scope: !9)
!33 = !DILocation(line: 8, column: 10, scope: !9)
!34 = !DILocation(line: 9, column: 3, scope: !9)
!35 = !DILocation(line: 7, column: 23, scope: !9)
!36 = !DILocation(line: 7, column: 3, scope: !9)
!37 = distinct !{!37, !36, !34, !25}
!38 = !DILocation(line: 10, column: 3, scope: !9)
