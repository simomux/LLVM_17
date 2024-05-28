; ModuleID = 'LoopGuarded.c'
source_filename = "LoopGuarded.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @calcoli(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, i32 noundef %4) #0 !dbg !9 {
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store ptr %0, ptr %6, align 8
  store ptr %1, ptr %7, align 8
  store ptr %2, ptr %8, align 8
  store ptr %3, ptr %9, align 8
  store i32 %4, ptr %10, align 4
  store i32 0, ptr %11, align 4, !dbg !12
  %12 = load i32, ptr %10, align 4, !dbg !13
  %13 = icmp sgt i32 %12, 0, !dbg !14
  br i1 %13, label %14, label %39, !dbg !13

14:                                               ; preds = %5
  br label %15, !dbg !15

15:                                               ; preds = %34, %14
  %16 = load ptr, ptr %7, align 8, !dbg !16
  %17 = load i32, ptr %11, align 4, !dbg !17
  %18 = sext i32 %17 to i64, !dbg !16
  %19 = getelementptr inbounds i32, ptr %16, i64 %18, !dbg !16
  %20 = load i32, ptr %19, align 4, !dbg !16
  %21 = sdiv i32 1, %20, !dbg !18
  %22 = load ptr, ptr %8, align 8, !dbg !19
  %23 = load i32, ptr %11, align 4, !dbg !20
  %24 = sext i32 %23 to i64, !dbg !19
  %25 = getelementptr inbounds i32, ptr %22, i64 %24, !dbg !19
  %26 = load i32, ptr %25, align 4, !dbg !19
  %27 = mul nsw i32 %21, %26, !dbg !21
  %28 = load ptr, ptr %6, align 8, !dbg !22
  %29 = load i32, ptr %11, align 4, !dbg !23
  %30 = sext i32 %29 to i64, !dbg !22
  %31 = getelementptr inbounds i32, ptr %28, i64 %30, !dbg !22
  store i32 %27, ptr %31, align 4, !dbg !24
  %32 = load i32, ptr %11, align 4, !dbg !25
  %33 = add nsw i32 %32, 1, !dbg !25
  store i32 %33, ptr %11, align 4, !dbg !25
  br label %34, !dbg !26

34:                                               ; preds = %15
  %35 = load i32, ptr %11, align 4, !dbg !27
  %36 = load i32, ptr %10, align 4, !dbg !28
  %37 = icmp slt i32 %35, %36, !dbg !29
  br i1 %37, label %15, label %38, !dbg !26, !llvm.loop !30

38:                                               ; preds = %34
  br label %39, !dbg !33

39:                                               ; preds = %38, %5
  store i32 0, ptr %11, align 4, !dbg !34
  %40 = load i32, ptr %10, align 4, !dbg !35
  %41 = icmp sgt i32 %40, 0, !dbg !36
  br i1 %41, label %42, label %66, !dbg !35

42:                                               ; preds = %39
  br label %43, !dbg !37

43:                                               ; preds = %61, %42
  %44 = load ptr, ptr %6, align 8, !dbg !38
  %45 = load i32, ptr %11, align 4, !dbg !39
  %46 = sext i32 %45 to i64, !dbg !38
  %47 = getelementptr inbounds i32, ptr %44, i64 %46, !dbg !38
  %48 = load i32, ptr %47, align 4, !dbg !38
  %49 = load ptr, ptr %8, align 8, !dbg !40
  %50 = load i32, ptr %11, align 4, !dbg !41
  %51 = sext i32 %50 to i64, !dbg !40
  %52 = getelementptr inbounds i32, ptr %49, i64 %51, !dbg !40
  %53 = load i32, ptr %52, align 4, !dbg !40
  %54 = add nsw i32 %48, %53, !dbg !42
  %55 = load ptr, ptr %9, align 8, !dbg !43
  %56 = load i32, ptr %11, align 4, !dbg !44
  %57 = sext i32 %56 to i64, !dbg !43
  %58 = getelementptr inbounds i32, ptr %55, i64 %57, !dbg !43
  store i32 %54, ptr %58, align 4, !dbg !45
  %59 = load i32, ptr %11, align 4, !dbg !46
  %60 = add nsw i32 %59, 1, !dbg !46
  store i32 %60, ptr %11, align 4, !dbg !46
  br label %61, !dbg !47

61:                                               ; preds = %43
  %62 = load i32, ptr %11, align 4, !dbg !48
  %63 = load i32, ptr %10, align 4, !dbg !49
  %64 = icmp slt i32 %62, %63, !dbg !50
  br i1 %64, label %43, label %65, !dbg !47, !llvm.loop !51

65:                                               ; preds = %61
  br label %66, !dbg !53

66:                                               ; preds = %65, %39
  ret void, !dbg !54
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
!6 = distinct !DICompileUnit(language: DW_LANG_C11, file: !7, producer: "clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 51024e0c6951617afcef9e3df7e8bd60c8bcc8ed)", isOptimized: false, runtimeVersion: 0, emissionKind: NoDebug, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.5.sdk", sdk: "MacOSX14.5.sdk")
!7 = !DIFile(filename: "LoopGuarded.c", directory: "/Users/simone/LLVM_17/TEST/Assignment4")
!8 = !{!"clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 51024e0c6951617afcef9e3df7e8bd60c8bcc8ed)"}
!9 = distinct !DISubprogram(name: "calcoli", scope: !7, file: !7, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6)
!10 = !DISubroutineType(types: !11)
!11 = !{}
!12 = !DILocation(line: 2, column: 9, scope: !9)
!13 = !DILocation(line: 4, column: 9, scope: !9)
!14 = !DILocation(line: 4, column: 11, scope: !9)
!15 = !DILocation(line: 5, column: 9, scope: !9)
!16 = !DILocation(line: 6, column: 22, scope: !9)
!17 = !DILocation(line: 6, column: 24, scope: !9)
!18 = !DILocation(line: 6, column: 21, scope: !9)
!19 = !DILocation(line: 6, column: 27, scope: !9)
!20 = !DILocation(line: 6, column: 29, scope: !9)
!21 = !DILocation(line: 6, column: 26, scope: !9)
!22 = !DILocation(line: 6, column: 13, scope: !9)
!23 = !DILocation(line: 6, column: 15, scope: !9)
!24 = !DILocation(line: 6, column: 18, scope: !9)
!25 = !DILocation(line: 7, column: 15, scope: !9)
!26 = !DILocation(line: 8, column: 9, scope: !9)
!27 = !DILocation(line: 8, column: 18, scope: !9)
!28 = !DILocation(line: 8, column: 22, scope: !9)
!29 = !DILocation(line: 8, column: 20, scope: !9)
!30 = distinct !{!30, !15, !31, !32}
!31 = !DILocation(line: 8, column: 23, scope: !9)
!32 = !{!"llvm.loop.mustprogress"}
!33 = !DILocation(line: 9, column: 5, scope: !9)
!34 = !DILocation(line: 10, column: 6, scope: !9)
!35 = !DILocation(line: 11, column: 9, scope: !9)
!36 = !DILocation(line: 11, column: 11, scope: !9)
!37 = !DILocation(line: 12, column: 9, scope: !9)
!38 = !DILocation(line: 13, column: 20, scope: !9)
!39 = !DILocation(line: 13, column: 22, scope: !9)
!40 = !DILocation(line: 13, column: 25, scope: !9)
!41 = !DILocation(line: 13, column: 27, scope: !9)
!42 = !DILocation(line: 13, column: 24, scope: !9)
!43 = !DILocation(line: 13, column: 13, scope: !9)
!44 = !DILocation(line: 13, column: 15, scope: !9)
!45 = !DILocation(line: 13, column: 18, scope: !9)
!46 = !DILocation(line: 14, column: 15, scope: !9)
!47 = !DILocation(line: 15, column: 9, scope: !9)
!48 = !DILocation(line: 15, column: 18, scope: !9)
!49 = !DILocation(line: 15, column: 22, scope: !9)
!50 = !DILocation(line: 15, column: 20, scope: !9)
!51 = distinct !{!51, !37, !52, !32}
!52 = !DILocation(line: 15, column: 23, scope: !9)
!53 = !DILocation(line: 16, column: 5, scope: !9)
!54 = !DILocation(line: 17, column: 1, scope: !9)
