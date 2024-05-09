; ModuleID = 'loop.c'
source_filename = "loop.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@g = global i32 0, align 4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @loop(i32 noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !8 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  store i32 %1, ptr %5, align 4
  store i32 %2, ptr %6, align 4
  store i32 0, ptr %8, align 4, !dbg !11
  %9 = load i32, ptr %4, align 4, !dbg !12
  store i32 %9, ptr %7, align 4, !dbg !13
  br label %10, !dbg !14

10:                                               ; preds = %18, %3
  %11 = load i32, ptr %7, align 4, !dbg !15
  %12 = load i32, ptr %5, align 4, !dbg !16
  %13 = icmp slt i32 %11, %12, !dbg !17
  br i1 %13, label %14, label %21, !dbg !18

14:                                               ; preds = %10
  %15 = load i32, ptr %6, align 4, !dbg !19
  %16 = load i32, ptr @g, align 4, !dbg !20
  %17 = add nsw i32 %16, %15, !dbg !20
  store i32 %17, ptr @g, align 4, !dbg !20
  br label %18, !dbg !21

18:                                               ; preds = %14
  %19 = load i32, ptr %7, align 4, !dbg !22
  %20 = add nsw i32 %19, 1, !dbg !22
  store i32 %20, ptr %7, align 4, !dbg !22
  br label %10, !dbg !18, !llvm.loop !23

21:                                               ; preds = %10
  %22 = load i32, ptr %8, align 4, !dbg !25
  %23 = load i32, ptr @g, align 4, !dbg !26
  %24 = add nsw i32 %22, %23, !dbg !27
  ret i32 %24, !dbg !28
}

;attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6}
!llvm.ident = !{!7}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 0c62c85834f4e5ba23b4fe8aead4e0f9fc71aa3c)", isOptimized: false, runtimeVersion: 0, emissionKind: NoDebug, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!1 = !DIFile(filename: "loop.c", directory: "/Users/simone/LLVM_17/TEST/Assignment3")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"uwtable", i32 1}
!6 = !{i32 7, !"frame-pointer", i32 1}
!7 = !{!"clang version 17.0.6 (https://github.com/simomux/LLVM_17.git 0c62c85834f4e5ba23b4fe8aead4e0f9fc71aa3c)"}
!8 = distinct !DISubprogram(name: "loop", scope: !1, file: !1, line: 3, type: !9, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0)
!9 = !DISubroutineType(types: !10)
!10 = !{}
!11 = !DILocation(line: 4, column: 10, scope: !8)
!12 = !DILocation(line: 6, column: 12, scope: !8)
!13 = !DILocation(line: 6, column: 10, scope: !8)
!14 = !DILocation(line: 6, column: 8, scope: !8)
!15 = !DILocation(line: 6, column: 15, scope: !8)
!16 = !DILocation(line: 6, column: 19, scope: !8)
!17 = !DILocation(line: 6, column: 17, scope: !8)
!18 = !DILocation(line: 6, column: 3, scope: !8)
!19 = !DILocation(line: 7, column: 10, scope: !8)
!20 = !DILocation(line: 7, column: 7, scope: !8)
!21 = !DILocation(line: 8, column: 3, scope: !8)
!22 = !DILocation(line: 6, column: 23, scope: !8)
!23 = distinct !{!23, !18, !21, !24}
!24 = !{!"llvm.loop.mustprogress"}
!25 = !DILocation(line: 10, column: 10, scope: !8)
!26 = !DILocation(line: 10, column: 16, scope: !8)
!27 = !DILocation(line: 10, column: 14, scope: !8)
!28 = !DILocation(line: 10, column: 3, scope: !8)
