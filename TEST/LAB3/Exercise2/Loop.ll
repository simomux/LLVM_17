define void @test(i32 %n) {
entry:
  br label %for.header

for.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %body, label %exit

body:
  ; Loop body
  br label %latch

latch:
  %i.next = add nsw i32 %i, 1
  br label %for.header

exit:
  ret void
}