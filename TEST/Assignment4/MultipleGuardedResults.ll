; ModuleID = 'Foo.bc'
source_filename = "MultipleGuarded.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @calcoli(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, i32 noundef %4) #0 !dbg !9 {
  %6 = icmp sgt i32 %4, 0, !dbg !12
  br i1 %6, label %7, label %39

7:                                                ; preds = %5
  br label %8, !dbg !13

8:                                                ; preds = %20, %7
  %.01 = phi i32 [ 0, %7 ], [ %19, %20 ], !dbg !14
  %9 = sext i32 %.01 to i64, !dbg !15
  %10 = getelementptr inbounds i32, ptr %1, i64 %9, !dbg !15
  %11 = load i32, ptr %10, align 4, !dbg !15
  %12 = sdiv i32 1, %11, !dbg !16
  %13 = sext i32 %.01 to i64, !dbg !17
  %14 = getelementptr inbounds i32, ptr %2, i64 %13, !dbg !17
  %15 = load i32, ptr %14, align 4, !dbg !17
  %16 = mul nsw i32 %12, %15, !dbg !18
  %17 = sext i32 %.01 to i64, !dbg !19
  %18 = getelementptr inbounds i32, ptr %0, i64 %17, !dbg !19
  store i32 %16, ptr %18, align 4, !dbg !20
  %19 = add nsw i32 %.01, 1, !dbg !21
  br label %26, !dbg !22

20:                                               ; preds = %26
  %21 = icmp slt i32 %19, %4, !dbg !23
  br i1 %21, label %8, label %39

22:                                               ; No predecessors!
  br label %23, !dbg !24

23:                                               ; preds = %22
  %24 = icmp sgt i32 %4, 0, !dbg !25
  br i1 %24, label %25, label %40, !dbg !26

25:                                               ; preds = %23
  br label %26, !dbg !27

26:                                               ; preds = %8, %37, %25
  %27 = sext i32 %.01 to i64, !dbg !28
  %28 = getelementptr inbounds i32, ptr %0, i64 %27, !dbg !28
  %29 = load i32, ptr %28, align 4, !dbg !28
  %30 = sext i32 %.01 to i64, !dbg !29
  %31 = getelementptr inbounds i32, ptr %2, i64 %30, !dbg !29
  %32 = load i32, ptr %31, align 4, !dbg !29
  %33 = add nsw i32 %29, %32, !dbg !30
  %34 = sext i32 %.01 to i64, !dbg !31
  %35 = getelementptr inbounds i32, ptr %3, i64 %34, !dbg !31
  store i32 %33, ptr %35, align 4, !dbg !32
  %36 = add nsw i32 %.01, 1, !dbg !33
  br label %20, !dbg !34

37:                                               ; No predecessors!
  %38 = icmp slt i32 %36, %4, !dbg !35
  br i1 %38, label %26, label %39, !dbg !34, !llvm.loop !36

39:                                               ; preds = %20, %5, %37
  br label %40, !dbg !39

40:                                               ; preds = %39, %23
  %41 = icmp sgt i32 25, 0, !dbg !40
  br i1 %41, label %42, label %74

42:                                               ; preds = %40
  br label %43, !dbg !41

43:                                               ; preds = %55, %42
  %.0 = phi i32 [ 0, %42 ], [ %54, %55 ], !dbg !14
  %44 = sext i32 %.0 to i64, !dbg !42
  %45 = getelementptr inbounds i32, ptr %1, i64 %44, !dbg !42
  %46 = load i32, ptr %45, align 4, !dbg !42
  %47 = sdiv i32 1, %46, !dbg !43
  %48 = sext i32 %.0 to i64, !dbg !44
  %49 = getelementptr inbounds i32, ptr %2, i64 %48, !dbg !44
  %50 = load i32, ptr %49, align 4, !dbg !44
  %51 = mul nsw i32 %47, %50, !dbg !45
  %52 = sext i32 %.0 to i64, !dbg !46
  %53 = getelementptr inbounds i32, ptr %0, i64 %52, !dbg !46
  store i32 %51, ptr %53, align 4, !dbg !47
  %54 = add nsw i32 %.0, 1, !dbg !48
  br label %61, !dbg !49

55:                                               ; preds = %61
  %56 = icmp slt i32 %54, 25, !dbg !50
  br i1 %56, label %43, label %74

57:                                               ; No predecessors!
  br label %58, !dbg !51

58:                                               ; preds = %57
  %59 = icmp sgt i32 25, 0, !dbg !52
  br i1 %59, label %60, label %75, !dbg !53

60:                                               ; preds = %58
  br label %61, !dbg !54

61:                                               ; preds = %43, %72, %60
  %62 = sext i32 %.0 to i64, !dbg !55
  %63 = getelementptr inbounds i32, ptr %0, i64 %62, !dbg !55
  %64 = load i32, ptr %63, align 4, !dbg !55
  %65 = sext i32 %.0 to i64, !dbg !56
  %66 = getelementptr inbounds i32, ptr %2, i64 %65, !dbg !56
  %67 = load i32, ptr %66, align 4, !dbg !56
  %68 = add nsw i32 %64, %67, !dbg !57
  %69 = sext i32 %.0 to i64, !dbg !58
  %70 = getelementptr inbounds i32, ptr %3, i64 %69, !dbg !58
  store i32 %68, ptr %70, align 4, !dbg !59
  %71 = add nsw i32 %.0, 1, !dbg !60
  br label %55, !dbg !61

72:                                               ; No predecessors!
  %73 = icmp slt i32 %71, 25, !dbg !62
  br i1 %73, label %61, label %74, !dbg !61, !llvm.loop !63

74:                                               ; preds = %55, %40, %72
  br label %75, !dbg !65

75:                                               ; preds = %74, %58
  ret void, !dbg !66
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
!7 = !DIFile(filename: "MultipleGuarded.c", directory: "/Users/simone/LLVM_17/TEST/Assignment4")
!8 = !{!"clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 48350d3603ba5887a7b62677ebd80cbedb62411b)"}
!9 = distinct !DISubprogram(name: "calcoli", scope: !7, file: !7, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6)
!10 = !DISubroutineType(types: !11)
!11 = !{}
!12 = !DILocation(line: 3, column: 11, scope: !9)
!13 = !DILocation(line: 4, column: 9, scope: !9)
!14 = !DILocation(line: 0, scope: !9)
!15 = !DILocation(line: 5, column: 22, scope: !9)
!16 = !DILocation(line: 5, column: 21, scope: !9)
!17 = !DILocation(line: 5, column: 27, scope: !9)
!18 = !DILocation(line: 5, column: 26, scope: !9)
!19 = !DILocation(line: 5, column: 13, scope: !9)
!20 = !DILocation(line: 5, column: 18, scope: !9)
!21 = !DILocation(line: 6, column: 15, scope: !9)
!22 = !DILocation(line: 7, column: 9, scope: !9)
!23 = !DILocation(line: 7, column: 20, scope: !9)
!24 = !DILocation(line: 8, column: 5, scope: !9)
!25 = !DILocation(line: 10, column: 11, scope: !9)
!26 = !DILocation(line: 10, column: 9, scope: !9)
!27 = !DILocation(line: 11, column: 9, scope: !9)
!28 = !DILocation(line: 12, column: 20, scope: !9)
!29 = !DILocation(line: 12, column: 25, scope: !9)
!30 = !DILocation(line: 12, column: 24, scope: !9)
!31 = !DILocation(line: 12, column: 13, scope: !9)
!32 = !DILocation(line: 12, column: 18, scope: !9)
!33 = !DILocation(line: 13, column: 15, scope: !9)
!34 = !DILocation(line: 14, column: 9, scope: !9)
!35 = !DILocation(line: 14, column: 20, scope: !9)
!36 = distinct !{!36, !27, !37, !38}
!37 = !DILocation(line: 14, column: 23, scope: !9)
!38 = !{!"llvm.loop.mustprogress"}
!39 = !DILocation(line: 15, column: 5, scope: !9)
!40 = !DILocation(line: 19, column: 11, scope: !9)
!41 = !DILocation(line: 20, column: 9, scope: !9)
!42 = !DILocation(line: 21, column: 22, scope: !9)
!43 = !DILocation(line: 21, column: 21, scope: !9)
!44 = !DILocation(line: 21, column: 27, scope: !9)
!45 = !DILocation(line: 21, column: 26, scope: !9)
!46 = !DILocation(line: 21, column: 13, scope: !9)
!47 = !DILocation(line: 21, column: 18, scope: !9)
!48 = !DILocation(line: 22, column: 15, scope: !9)
!49 = !DILocation(line: 23, column: 9, scope: !9)
!50 = !DILocation(line: 23, column: 20, scope: !9)
!51 = !DILocation(line: 24, column: 5, scope: !9)
!52 = !DILocation(line: 26, column: 11, scope: !9)
!53 = !DILocation(line: 26, column: 9, scope: !9)
!54 = !DILocation(line: 27, column: 9, scope: !9)
!55 = !DILocation(line: 28, column: 20, scope: !9)
!56 = !DILocation(line: 28, column: 25, scope: !9)
!57 = !DILocation(line: 28, column: 24, scope: !9)
!58 = !DILocation(line: 28, column: 13, scope: !9)
!59 = !DILocation(line: 28, column: 18, scope: !9)
!60 = !DILocation(line: 29, column: 15, scope: !9)
!61 = !DILocation(line: 30, column: 9, scope: !9)
!62 = !DILocation(line: 30, column: 20, scope: !9)
!63 = distinct !{!63, !54, !64, !38}
!64 = !DILocation(line: 30, column: 23, scope: !9)
!65 = !DILocation(line: 31, column: 5, scope: !9)
!66 = !DILocation(line: 32, column: 1, scope: !9)
