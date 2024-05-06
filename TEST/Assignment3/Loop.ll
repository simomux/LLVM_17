; ModuleID = 'Loop.c'
source_filename = "Loop.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@g = common global i32 0, align 4                ; int g

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @g_incr(i32 noundef %0) #0 {          ; int g_incr(int c)
  ; %1 = BB1
  %2 = alloca i32, align 4                       ; int %2
  store i32 %0, ptr %2, align 4                  ; %2 = c
  %3 = load i32, ptr %2, align 4                 ; %3 = %2
  %4 = load i32, ptr @g, align 4                 ; %4 = g
  %5 = add nsw i32 %4, %3                        ; %5 = %4 + %3 -> %5 = g + c
  store i32 %5, ptr @g, align 4                  ; g = %5
  %6 = load i32, ptr @g, align 4                 ; %6 = g
  ret i32 %6                                     ; return %6 -> return g
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @loop(i32 noundef %0, i32 noundef %1, i32 noundef %2) #0 { ; int loop(int a, int b, int c)
  ; %3 = BB2
  %4 = alloca i32, align 4                   ; int %4
  %5 = alloca i32, align 4                   ; int %5 
  %6 = alloca i32, align 4                   ; int %6 
  %7 = alloca i32, align 4                   ; int %7 -> int i
  %8 = alloca i32, align 4                   ; int %8 
  store i32 %0, ptr %4, align 4              ; %4 = a  
  store i32 %1, ptr %5, align 4              ; %5 = b               
  store i32 %2, ptr %6, align 4              ; %6 = c              
  store i32 0, ptr %8, align 4               ; %8 = 0 -> ret = 0
  %9 = load i32, ptr %4, align 4             ; %9 = %4 -> %9 = a
  store i32 %9, ptr %7, align 4              ; %7 = %9 -> i = a
  br label %10                               ; unconditional jump to label 10        

10:                                               ; preds = %17, %3
  ; %10 = BB3
  %11 = load i32, ptr %7, align 4            ; %11 = %7 -> %11 = i
  %12 = load i32, ptr %5, align 4            ; %12 = %5 -> %12 = b
  %13 = icmp slt i32 %11, %12                ; %13 = %11 < %12 -> %13 = i < b
  br i1 %13, label %14, label %20            ; jump based on %13 jump to label 14 or 20

14:                                               ; preds = %10
  ;%14 = BB4
  %15 = load i32, ptr %6, align 4            ; %15 = %6 -> %15 = c
  %16 = call i32 @g_incr(i32 noundef %15)    ; %16 = g_incr(%15) -> %16 = g_incr(c)
  br label %17                               ; unconditional jump to label 17 (fallthrough)    

17:                                               ; preds = %14
  ; %17 = BB5
  %18 = load i32, ptr %7, align 4            ; %18 = %7 -> %18 = i
  %19 = add nsw i32 %18, 1                   ; %19 = %18 + 1 -> %19 = i + 1
  store i32 %19, ptr %7, align 4             ; %7 = %19 -> i = i + 1
  br label %10, !llvm.loop !6                ; unconditional jump to label 10

20:                                               ; preds = %10
  ; %20 = BB6
  %21 = load i32, ptr %8, align 4           ; %21 = %8 -> %21 = ret
  %22 = load i32, ptr @g, align 4           ; %22 = g
  %23 = add nsw i32 %21, %22                ; %23 = %21 + %22 -> %23 = ret + g
  ret i32 %23                               ; return %23     
}

;attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 2]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Apple clang version 15.0.0 (clang-1500.1.0.2.5)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
