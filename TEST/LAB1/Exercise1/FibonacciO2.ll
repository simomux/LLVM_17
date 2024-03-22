; ModuleID = './TEST/Exercise1/Fibonacci.c'
source_filename = "./TEST/Exercise1/Fibonacci.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@__stdoutp = external local_unnamed_addr global ptr, align 8
@.str = private unnamed_addr constant [9 x i8] c"f(0) = 0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"f(1) = 1\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"f(%d) = f(%d) + f(%d)\00", align 1

; Function Attrs: nofree nounwind ssp uwtable(sync)
define i32 @printf(ptr nocapture noundef readonly %0, ...) local_unnamed_addr #0 !dbg !9 {        ; printf(%0, ...) -> printf(*format, ...)
  %2 = alloca ptr, align 8                                                                        ; ptr %2 -> args        
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #4, !dbg !13                           ; lifetime.start(8, %2) -> lifetime.start(8, args)
  call void @llvm.va_start(ptr nonnull %2), !dbg !14                                              ; va_start(%2) -> va_start(args)
  %3 = load ptr, ptr @__stdoutp, align 8, !dbg !15, !tbaa !16                                     ; ptr %3 = @__stdoutp
  %4 = load ptr, ptr %2, align 8, !dbg !20, !tbaa !16                                             ; ptr %4 = *args
  %5 = call i32 @vfprintf(ptr noundef %3, ptr noundef %0, ptr noundef %4), !dbg !21               ; %5 = vfprintf(%3, %0, %4) -> ret = vfprintf(@__stdoutp, format, args)
  call void @llvm.va_end(ptr nonnull %2), !dbg !22                                                ; va_end(%2) -> va_end(args)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #4, !dbg !23                             ; lifetime.end(8, %2) -> lifetime.end(8, args)
  ret i32 %5, !dbg !24                                                                            ; return %5 -> return ret
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
define i32 @Fibonacci(i32 noundef %0) local_unnamed_addr #0 !dbg !25 {
  ; %1 = BB1
  br label %2, !dbg !26                           ; unconditional jump to BB2

2:                                                ; preds = %5, %1
  ; %2 = BB2
  %3 = phi i32 [ 0, %1 ], [ %10, %5 ]             ; %3 = 0 if last BB was BB1, %10 if last BB was BB5
  %4 = phi i32 [ %0, %1 ], [ %7, %5 ]             ; %4 = %0 if last BB was BB1, %7 if last BB was BB5
  ; Si didive in BB????
  switch i32 %4, label %5 [                       ; Read %4 and if no condition is true jump to BB5
    i32 0, label %12                              ; If %4 == 0 jump to label 12 -> Base case if Fibonacci(0)
    i32 1, label %11                              ; If %4 == 1 jump to label 11 -> Base case if Fibonacci(1)
  ], !dbg !27

5:                                                ; preds = %2
  ; %5 = BB3
  %6 = add nsw i32 %4, -1, !dbg !28               ; %6 = %4 - 1 
  %7 = add nsw i32 %4, -2, !dbg !29               ; %7 = %4 - 2
  %8 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef %4, i32 noundef %6, i32 noundef %7), !dbg !30     ; %8 = printf(@.str2, %4, %6, %7) -> %8 = printf("f(%d) = f(%d) + f(%d)", %4, %6, %7)
  %9 = tail call i32 @Fibonacci(i32 noundef %6), !dbg !31       ; %9 = Fibonacci(%6) -> Fibonacci(%4) -> Fibonacci(n-1)
  %10 = add nsw i32 %9, %3, !dbg !32                            ; %10 = %9 + %3
  br label %2, !dbg !26                           ; unconditional jump to BB2

11:                                               ; preds = %2
  ; %11 = BB4
  br label %12, !dbg !33                          ; unconditional jump to BB12        

12:                                               ; preds = %2, %11
  ; %12 = BB5
  %13 = phi ptr [ @.str.1, %11 ], [ @.str, %2 ]   ; %13 = @.str1 if last BB was BB11, @.str if last BB was BB2
  %14 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) %13), !dbg !33    ; %14 = printf(%13) -> %14 = printf(@.str1) if last BB was BB11, printf(@.str) if last BB was BB2 -> %14 = printf("f(1) = 1") if last BB was BB11, printf("f(0) = 0") if last BB was BB2
  %15 = add nsw i32 %4, %3, !dbg !32              ; %15 = %4 + %3
  ret i32 %15, !dbg !34                           ; return %15
}

attributes #0 = { nofree nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { nofree nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.dbg.cu = !{!6}
!llvm.ident = !{!8}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 4]}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = distinct !DICompileUnit(language: DW_LANG_C99, file: !7, producer: "Apple clang version 15.0.0 (clang-1500.1.0.2.5)", isOptimized: true, runtimeVersion: 0, emissionKind: NoDebug, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk", sdk: "MacOSX.sdk")
!7 = !DIFile(filename: "TEST/Exercise1/Fibonacci.c", directory: "/Users/simone/LLVM_17")
!8 = !{!"Apple clang version 15.0.0 (clang-1500.1.0.2.5)"}
!9 = distinct !DISubprogram(name: "printf", scope: !10, file: !10, line: 4, type: !11, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6, retainedNodes: !12)
!10 = !DIFile(filename: "./TEST/Exercise1/Fibonacci.c", directory: "/Users/simone/LLVM_17")
!11 = !DISubroutineType(types: !12)
!12 = !{}
!13 = !DILocation(line: 6, column: 3, scope: !9)
!14 = !DILocation(line: 7, column: 3, scope: !9)
!15 = !DILocation(line: 8, column: 18, scope: !9)
!16 = !{!17, !17, i64 0}
!17 = !{!"any pointer", !18, i64 0}
!18 = !{!"omnipotent char", !19, i64 0}
!19 = !{!"Simple C/C++ TBAA"}
!20 = !DILocation(line: 8, column: 34, scope: !9)
!21 = !DILocation(line: 8, column: 9, scope: !9)
!22 = !DILocation(line: 9, column: 3, scope: !9)
!23 = !DILocation(line: 12, column: 1, scope: !9)
!24 = !DILocation(line: 11, column: 3, scope: !9)
!25 = distinct !DISubprogram(name: "Fibonacci", scope: !10, file: !10, line: 14, type: !11, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6, retainedNodes: !12)
!26 = !DILocation(line: 24, column: 29, scope: !25)
!27 = !DILocation(line: 15, column: 7, scope: !25)
!28 = !DILocation(line: 23, column: 40, scope: !25)
!29 = !DILocation(line: 23, column: 47, scope: !25)
!30 = !DILocation(line: 23, column: 3, scope: !25)
!31 = !DILocation(line: 24, column: 10, scope: !25)
!32 = !DILocation(line: 24, column: 27, scope: !25)
!33 = !DILocation(line: 0, scope: !25)
!34 = !DILocation(line: 25, column: 1, scope: !25)
