; ModuleID = 'LoopUnguarded.c'
source_filename = "LoopUnguarded.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @calculateVectors(i32 noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, ptr noundef %4) #0 !dbg !9 {
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  store i32 %0, ptr %6, align 4
  store ptr %1, ptr %7, align 8
  store ptr %2, ptr %8, align 8
  store ptr %3, ptr %9, align 8
  store ptr %4, ptr %10, align 8
  store i32 0, ptr %11, align 4, !dbg !12
  br label %12, !dbg !13

12:                                               ; preds = %33, %5
  %13 = load i32, ptr %11, align 4, !dbg !14
  %14 = load i32, ptr %6, align 4, !dbg !15
  %15 = icmp slt i32 %13, %14, !dbg !16
  br i1 %15, label %16, label %36, !dbg !17

16:                                               ; preds = %12
  %17 = load ptr, ptr %8, align 8, !dbg !18
  %18 = load i32, ptr %11, align 4, !dbg !19
  %19 = sext i32 %18 to i64, !dbg !18
  %20 = getelementptr inbounds i32, ptr %17, i64 %19, !dbg !18
  %21 = load i32, ptr %20, align 4, !dbg !18
  %22 = sdiv i32 1, %21, !dbg !20
  %23 = load ptr, ptr %9, align 8, !dbg !21
  %24 = load i32, ptr %11, align 4, !dbg !22
  %25 = sext i32 %24 to i64, !dbg !21
  %26 = getelementptr inbounds i32, ptr %23, i64 %25, !dbg !21
  %27 = load i32, ptr %26, align 4, !dbg !21
  %28 = mul nsw i32 %22, %27, !dbg !23
  %29 = load ptr, ptr %7, align 8, !dbg !24
  %30 = load i32, ptr %11, align 4, !dbg !25
  %31 = sext i32 %30 to i64, !dbg !24
  %32 = getelementptr inbounds i32, ptr %29, i64 %31, !dbg !24
  store i32 %28, ptr %32, align 4, !dbg !26
  br label %33, !dbg !27

33:                                               ; preds = %16
  %34 = load i32, ptr %11, align 4, !dbg !28
  %35 = add nsw i32 %34, 1, !dbg !28
  store i32 %35, ptr %11, align 4, !dbg !28
  br label %12, !dbg !17, !llvm.loop !29

36:                                               ; preds = %12
  store i32 0, ptr %11, align 4, !dbg !31
  br label %37, !dbg !32

37:                                               ; preds = %57, %36
  %38 = load i32, ptr %11, align 4, !dbg !33
  %39 = load i32, ptr %6, align 4, !dbg !34
  %40 = icmp slt i32 %38, %39, !dbg !35
  br i1 %40, label %41, label %60, !dbg !36

41:                                               ; preds = %37
  %42 = load ptr, ptr %7, align 8, !dbg !37
  %43 = load i32, ptr %11, align 4, !dbg !38
  %44 = sext i32 %43 to i64, !dbg !37
  %45 = getelementptr inbounds i32, ptr %42, i64 %44, !dbg !37
  %46 = load i32, ptr %45, align 4, !dbg !37
  %47 = load ptr, ptr %9, align 8, !dbg !39
  %48 = load i32, ptr %11, align 4, !dbg !40
  %49 = sext i32 %48 to i64, !dbg !39
  %50 = getelementptr inbounds i32, ptr %47, i64 %49, !dbg !39
  %51 = load i32, ptr %50, align 4, !dbg !39
  %52 = add nsw i32 %46, %51, !dbg !41
  %53 = load ptr, ptr %10, align 8, !dbg !42
  %54 = load i32, ptr %11, align 4, !dbg !43
  %55 = sext i32 %54 to i64, !dbg !42
  %56 = getelementptr inbounds i32, ptr %53, i64 %55, !dbg !42
  store i32 %52, ptr %56, align 4, !dbg !44
  br label %57, !dbg !45

57:                                               ; preds = %41
  %58 = load i32, ptr %11, align 4, !dbg !46
  %59 = add nsw i32 %58, 1, !dbg !46
  store i32 %59, ptr %11, align 4, !dbg !46
  br label %37, !dbg !36, !llvm.loop !47

60:                                               ; preds = %37
  ret void, !dbg !48
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
!7 = !DIFile(filename: "LoopUnguarded.c", directory: "/Users/simone/LLVM_17/TEST/Assignment4")
!8 = !{!"clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 51024e0c6951617afcef9e3df7e8bd60c8bcc8ed)"}
!9 = distinct !DISubprogram(name: "calculateVectors", scope: !7, file: !7, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6)
!10 = !DISubroutineType(types: !11)
!11 = !{}
!12 = !DILocation(line: 3, column: 10, scope: !9)
!13 = !DILocation(line: 3, column: 8, scope: !9)
!14 = !DILocation(line: 3, column: 15, scope: !9)
!15 = !DILocation(line: 3, column: 19, scope: !9)
!16 = !DILocation(line: 3, column: 17, scope: !9)
!17 = !DILocation(line: 3, column: 3, scope: !9)
!18 = !DILocation(line: 4, column: 16, scope: !9)
!19 = !DILocation(line: 4, column: 18, scope: !9)
!20 = !DILocation(line: 4, column: 14, scope: !9)
!21 = !DILocation(line: 4, column: 23, scope: !9)
!22 = !DILocation(line: 4, column: 25, scope: !9)
!23 = !DILocation(line: 4, column: 21, scope: !9)
!24 = !DILocation(line: 4, column: 5, scope: !9)
!25 = !DILocation(line: 4, column: 7, scope: !9)
!26 = !DILocation(line: 4, column: 10, scope: !9)
!27 = !DILocation(line: 5, column: 3, scope: !9)
!28 = !DILocation(line: 3, column: 23, scope: !9)
!29 = distinct !{!29, !17, !27, !30}
!30 = !{!"llvm.loop.mustprogress"}
!31 = !DILocation(line: 7, column: 10, scope: !9)
!32 = !DILocation(line: 7, column: 8, scope: !9)
!33 = !DILocation(line: 7, column: 15, scope: !9)
!34 = !DILocation(line: 7, column: 19, scope: !9)
!35 = !DILocation(line: 7, column: 17, scope: !9)
!36 = !DILocation(line: 7, column: 3, scope: !9)
!37 = !DILocation(line: 8, column: 12, scope: !9)
!38 = !DILocation(line: 8, column: 14, scope: !9)
!39 = !DILocation(line: 8, column: 19, scope: !9)
!40 = !DILocation(line: 8, column: 21, scope: !9)
!41 = !DILocation(line: 8, column: 17, scope: !9)
!42 = !DILocation(line: 8, column: 5, scope: !9)
!43 = !DILocation(line: 8, column: 7, scope: !9)
!44 = !DILocation(line: 8, column: 10, scope: !9)
!45 = !DILocation(line: 9, column: 3, scope: !9)
!46 = !DILocation(line: 7, column: 23, scope: !9)
!47 = distinct !{!47, !36, !45, !30}
!48 = !DILocation(line: 10, column: 3, scope: !9)
