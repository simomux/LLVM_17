; ModuleID = 'Fibonacci.c'
source_filename = "Fibonacci.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@__stdoutp = external local_unnamed_addr global ptr, align 8
@.str = private unnamed_addr constant [9 x i8] c"f(0) = 0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"f(1) = 1\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"f(%d) = f(%d) + f(%d)\00", align 1

; Function Attrs: nofree nounwind ssp uwtable(sync)
define i32 @printf(ptr nocapture noundef readonly %0, ...) local_unnamed_addr #0 !dbg !9 {
  %2 = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #4, !dbg !12
  call void @llvm.va_start(ptr nonnull %2), !dbg !13
  %3 = load ptr, ptr @__stdoutp, align 8, !dbg !14, !tbaa !15
  %4 = load ptr, ptr %2, align 8, !dbg !19, !tbaa !15
  %5 = call i32 @vfprintf(ptr noundef %3, ptr noundef %0, ptr noundef %4), !dbg !20
  call void @llvm.va_end(ptr nonnull %2), !dbg !21
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #4, !dbg !22
  ret i32 %5, !dbg !23
}

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start(ptr) #2

; Function Attrs: nofree nounwind
declare noundef i32 @vfprintf(ptr nocapture noundef, ptr nocapture noundef readonly, ptr noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end(ptr) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nofree nounwind ssp uwtable(sync)
define i32 @Fibonacci(i32 noundef %0) local_unnamed_addr #0 !dbg !24 {
  br label %2, !dbg !25

2:                                                ; preds = %5, %1
  %3 = phi i32 [ 0, %1 ], [ %10, %5 ]
  %4 = phi i32 [ %0, %1 ], [ %7, %5 ]
  switch i32 %4, label %5 [
    i32 0, label %12
    i32 1, label %11
  ], !dbg !26

5:                                                ; preds = %2
  %6 = add nsw i32 %4, -1, !dbg !27
  %7 = add nsw i32 %4, -2, !dbg !28
  %8 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef %4, i32 noundef %6, i32 noundef %7), !dbg !29
  %9 = tail call i32 @Fibonacci(i32 noundef %6), !dbg !30
  %10 = add nsw i32 %9, %3, !dbg !31
  br label %2, !dbg !25

11:                                               ; preds = %2
  br label %12, !dbg !32

12:                                               ; preds = %2, %11
  %13 = phi ptr [ @.str.1, %11 ], [ @.str, %2 ]
  %14 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) %13), !dbg !32
  %15 = add nsw i32 %4, %3, !dbg !31
  ret i32 %15, !dbg !33
}

attributes #0 = { nofree nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { nofree nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.dbg.cu = !{!6}
!llvm.ident = !{!8}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 2]}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = distinct !DICompileUnit(language: DW_LANG_C99, file: !7, producer: "Apple clang version 15.0.0 (clang-1500.1.0.2.5)", isOptimized: true, runtimeVersion: 0, emissionKind: NoDebug, splitDebugInlining: false, nameTableKind: None, sysroot: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk", sdk: "MacOSX.sdk")
!7 = !DIFile(filename: "Fibonacci.c", directory: "/Users/simone/LLVM_17/TEST")
!8 = !{!"Apple clang version 15.0.0 (clang-1500.1.0.2.5)"}
!9 = distinct !DISubprogram(name: "printf", scope: !7, file: !7, line: 4, type: !10, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6, retainedNodes: !11)
!10 = !DISubroutineType(types: !11)
!11 = !{}
!12 = !DILocation(line: 6, column: 3, scope: !9)
!13 = !DILocation(line: 7, column: 3, scope: !9)
!14 = !DILocation(line: 8, column: 18, scope: !9)
!15 = !{!16, !16, i64 0}
!16 = !{!"any pointer", !17, i64 0}
!17 = !{!"omnipotent char", !18, i64 0}
!18 = !{!"Simple C/C++ TBAA"}
!19 = !DILocation(line: 8, column: 34, scope: !9)
!20 = !DILocation(line: 8, column: 9, scope: !9)
!21 = !DILocation(line: 9, column: 3, scope: !9)
!22 = !DILocation(line: 12, column: 1, scope: !9)
!23 = !DILocation(line: 11, column: 3, scope: !9)
!24 = distinct !DISubprogram(name: "Fibonacci", scope: !7, file: !7, line: 14, type: !10, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6, retainedNodes: !11)
!25 = !DILocation(line: 24, column: 29, scope: !24)
!26 = !DILocation(line: 15, column: 7, scope: !24)
!27 = !DILocation(line: 23, column: 40, scope: !24)
!28 = !DILocation(line: 23, column: 47, scope: !24)
!29 = !DILocation(line: 23, column: 3, scope: !24)
!30 = !DILocation(line: 24, column: 10, scope: !24)
!31 = !DILocation(line: 24, column: 27, scope: !24)
!32 = !DILocation(line: 0, scope: !24)
!33 = !DILocation(line: 25, column: 1, scope: !24)
