# fork join_any
## fork join_any is comes out from the block any of child thread executed and then parent and child runs parallel
## The child thread in background parallel to the parent thread
## Parent thread execution over the child thread
# Example
## Ex1
```
module fork_join_any;
 
  initial begin
    
    $display("\t*BEFORE FORK..JOIN_ANY*");
    
    fork
        #15 $display($time,"\tThread A");
        #5  $display($time,"\tThread B");
        #10 $display($time,"\tThread C");
    join_any

    #2  $display($time,"\tThread D");
    #12 $display($time,"\tThread E");
 
    $display("*\tAFTER FORK..JOIN_ANY*");
    
    #30 $finish;
  end
  
endmodule
```
Output
```
*BEFORE FORK..JOIN_ANY*
                   5	Thread B
                   7	Thread D
                  10	Thread C
                  15	Thread A
                  19	Thread E
	*AFTER FORK..JOIN_ANY*
```
## Ex2
```
module fork_join_any;
 
  initial begin
    
    $display("\t*BEFORE FORK..JOIN_ANY*");
    
    fork
      begin
        #20 $display($time,"\tThread A");
        #25 $display($time,"\tThread B");
      end
      begin
        #10 $display($time,"\tThread C");
        #2  $display($time,"\tThread D");
      end
    join_any
       #4  $display($time,"\tThread E");
       #3  $display($time,"\tThread F");
 
    $display("\t*AFTER FORK..JOIN_ANY*");
    
    #30 $finish;
  end
  
endmodule
```
Output
```
*BEFORE FORK..JOIN_ANY*
                  10	Thread C
                  12	Thread D
                  16	Thread E
                  19	Thread F
	*AFTER FORK..JOIN_ANY*
                  20	Thread A
                  45	Thread B
```

