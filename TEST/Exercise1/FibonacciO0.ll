; ModuleID = 'Fibonacci.c'
source_filename = "Fibonacci.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

; Print global declariation
@__stdoutp = external global ptr, align 8
@.str = private unnamed_addr constant [9 x i8] c"f(0) = 0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"f(1) = 1\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"f(%d) = f(%d) + f(%d)\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @printf(ptr noundef %0, ...) #0 !dbg !9 {      ; int printf(ptr %0, ...) = int printf(*format, ...)
  ; %1 = BB1
  %2 = alloca ptr, align 8                        ; ptr %2
  %3 = alloca i32, align 4                        ; int %3 -> int ret
  %4 = alloca ptr, align 8                        ; ptr %4 -> va_list args
  store ptr %0, ptr %2, align 8                   ; %2 = %0 -> %2 = format
  call void @llvm.va_start(ptr %4), !dbg !12          ; va_start(%4)
  %5 = load ptr, ptr @__stdoutp, align 8, !dbg !13    ; %5 = @__stdoutp -> %5 = stdout
  %6 = load ptr, ptr %2, align 8, !dbg !14        ; %6 = %2 -> %6 = format
  %7 = load ptr, ptr %4, align 8, !dbg !15        ; %7 = %4 -> %7 = args
  %8 = call i32 @vfprintf(ptr noundef %5, ptr noundef %6, ptr noundef %7), !dbg !16     ; %8 = vfprintf(%5, %6, %7) -> %8 = vfprintf(stdout, format, args)
  store i32 %8, ptr %3, align 4, !dbg !17         ; %3 = %8 -> %3 = ret
  call void @llvm.va_end(ptr %4), !dbg !18        ; va_end(%4)
  %9 = load i32, ptr %3, align 4, !dbg !19        ; %9 = %3 -> %9 = ret
  ret i32 %9, !dbg !20                         ; return %9 -> return ret
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start(ptr) #1

declare i32 @vfprintf(ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end(ptr) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @Fibonacci(i32 noundef %0) #0 !dbg !21 {     ; int Fibonacci(int %0) -> int Fibonacci(int n)
  ; %1 = BB1
  %2 = alloca i32, align 4                        ; int %2
  %3 = alloca i32, align 4                        ; int %3
  store i32 %0, ptr %3, align 4                   ; %3 = %0 -> %3 = n
  %4 = load i32, ptr %3, align 4, !dbg !22        ; %4 = %3 -> %4 = n
  %5 = icmp eq i32 %4, 0, !dbg !23                ; %5 = true if n == 0 else false
  br i1 %5, label %6, label %8, !dbg !22          ; jump based on %5 to label 6 or label 8

6:                                                ; preds = %1
  ; %6 = BB2
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str), !dbg !24     ;%7 = printf(.str) -> %7 = printf("f(0) = 0")
  store i32 0, ptr %2, align 4, !dbg !25          ; %2 = 0      
  br label %27, !dbg !25                          ; unconditional jump to label 27

8:                                                ; preds = %1
  ; %8 = BB3
  %9 = load i32, ptr %3, align 4, !dbg !26        ; %9 = %3 -> %9 = n
  %10 = icmp eq i32 %9, 1, !dbg !27               ; %10 = true if n == 1 else false
  br i1 %10, label %11, label %13, !dbg !26       ; jump based on %10 to label 11 or label 13

11:                                               ; preds = %8
  ; %11 = BB4
  %12 = call i32 (ptr, ...) @printf(ptr noundef @.str.1), !dbg !28    ; %12 = printf(.str.1) -> %12 = printf("f(1) = 1")
  store i32 1, ptr %2, align 4, !dbg !29          ; %2 = 1
  br label %27, !dbg !29                          ; unconditional jump to label 27

13:                                               ; preds = %8
  ; %13 = BB5
  %14 = load i32, ptr %3, align 4, !dbg !30       ; %14 = %3 -> %14 = n
  %15 = load i32, ptr %3, align 4, !dbg !31       ; %15 = %3 -> %15 = n
  %16 = sub nsw i32 %15, 1, !dbg !32              ; %16 = %15 - 1 -> %16 = n - 1
  %17 = load i32, ptr %3, align 4, !dbg !33       ; %17 = %3 -> %17 = n
  %18 = sub nsw i32 %17, 2, !dbg !34              ; %18 = %17 - 2 -> %18 = n - 2
  %19 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %14, i32 noundef %16, i32 noundef %18), !dbg !35   ; %19 = printf(.str.2, %14, %16, %18) -> %19 = printf("f(%d) = f(%d) + f(%d)", %14, %16, %18)
  %20 = load i32, ptr %3, align 4, !dbg !36       ; %20 = %3 -> %20 = n
  %21 = sub nsw i32 %20, 1, !dbg !37              ; %21 = %20 - 1 -> %21 = n - 1
  %22 = call i32 @Fibonacci(i32 noundef %21), !dbg !38      ; %22 = Fibonacci(%21) -> %22 = Fibonacci(n - 1)
  %23 = load i32, ptr %3, align 4, !dbg !39       ; %23 = %3 -> %23 = n
  %24 = sub nsw i32 %23, 2, !dbg !40              ; %24 = %23 - 2 -> %24 = n - 2
  %25 = call i32 @Fibonacci(i32 noundef %24), !dbg !41      ; %25 = Fibonacci(%24) -> %25 = Fibonacci(n - 2)
  %26 = add nsw i32 %22, %25, !dbg !42            ; %26 = %22 + %25 -> %26 = Fibonacci(n - 1) + Fibonacci(n - 2)
  store i32 %26, ptr %2, align 4, !dbg !43        ; %2 = %26
  br label %27, !dbg !43                          ; unconditional jump to label 27

27:                                               ; preds = %13, %11, %6
  ; %27 = BB6
  %28 = load i32, ptr %2, align 4, !dbg !44       ; %28 = %2
  ret i32 %28, !dbg !44                           ; return %28
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.dbg.cu = !{!6}
!llvm.ident = !{!8}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 2]}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = distinct !DICompileUnit(language: DW_LANG_C99, file: !7, producer: "Apple clang version 15.0.0 (clang-1500.1.0.2.5)", isOptimized: false, runtimeVersion: 0, emissionKind: NoDebug, splitDebugInlining: false, nameTableKind: None, sysroot: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk", sdk: "MacOSX.sdk")
!7 = !DIFile(filename: "Fibonacci.c", directory: "/Users/simone/LLVM_17/TEST")
!8 = !{!"Apple clang version 15.0.0 (clang-1500.1.0.2.5)"}
!9 = distinct !DISubprogram(name: "printf", scope: !7, file: !7, line: 4, type: !10, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !11)
!10 = !DISubroutineType(types: !11)
!11 = !{}
!12 = !DILocation(line: 7, column: 3, scope: !9)
!13 = !DILocation(line: 8, column: 18, scope: !9)
!14 = !DILocation(line: 8, column: 26, scope: !9)
!15 = !DILocation(line: 8, column: 34, scope: !9)
!16 = !DILocation(line: 8, column: 9, scope: !9)
!17 = !DILocation(line: 8, column: 7, scope: !9)
!18 = !DILocation(line: 9, column: 3, scope: !9)
!19 = !DILocation(line: 11, column: 10, scope: !9)
!20 = !DILocation(line: 11, column: 3, scope: !9)
!21 = distinct !DISubprogram(name: "Fibonacci", scope: !7, file: !7, line: 14, type: !10, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !11)
!22 = !DILocation(line: 15, column: 7, scope: !21)
!23 = !DILocation(line: 15, column: 9, scope: !21)
!24 = !DILocation(line: 16, column: 5, scope: !21)
!25 = !DILocation(line: 17, column: 5, scope: !21)
!26 = !DILocation(line: 19, column: 7, scope: !21)
!27 = !DILocation(line: 19, column: 9, scope: !21)
!28 = !DILocation(line: 20, column: 5, scope: !21)
!29 = !DILocation(line: 21, column: 5, scope: !21)
!30 = !DILocation(line: 23, column: 35, scope: !21)
!31 = !DILocation(line: 23, column: 38, scope: !21)
!32 = !DILocation(line: 23, column: 40, scope: !21)
!33 = !DILocation(line: 23, column: 45, scope: !21)
!34 = !DILocation(line: 23, column: 47, scope: !21)
!35 = !DILocation(line: 23, column: 3, scope: !21)
!36 = !DILocation(line: 24, column: 20, scope: !21)
!37 = !DILocation(line: 24, column: 22, scope: !21)
!38 = !DILocation(line: 24, column: 10, scope: !21)
!39 = !DILocation(line: 24, column: 39, scope: !21)
!40 = !DILocation(line: 24, column: 41, scope: !21)
!41 = !DILocation(line: 24, column: 29, scope: !21)
!42 = !DILocation(line: 24, column: 27, scope: !21)
!43 = !DILocation(line: 24, column: 3, scope: !21)
!44 = !DILocation(line: 25, column: 1, scope: !21)
