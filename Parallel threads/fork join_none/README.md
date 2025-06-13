# fork join_none
## fork join_none is basically ,runs all its child thread in background parallel to parent thread
# Examples
## Ex1
```
 module fork_join_none;
 
  initial begin
    
    $display("*BEFORE FORK..JOIN_ANY*");
    
    fork
        #15 $display($time,"\tThread A");
        #5   $display($time,"\tThread B");
        #10 $display($time,"\tThread C");
    join_none
      
        #2  $display($time,"\tThread D");
      #12  $display($time,"\tThread E");
 
    $display("*AFTER FORK..JOIN_NONE*");
    
    #30 $finish;
  end
  
endmodule
```
Output
```
*BEFORE FORK..JOIN_ANY*
                   2	Thread D
                   5	Thread B
                  10	Thread C
                  14	Thread E
	*AFTER FORK..JOIN_NONE*
                  15	Thread A
```
## Ex2
```
module disable_fork;
 
  initial begin
    $display("*BEFORE_DISABLE_FORK*");
 
 
    fork
      begin
        $display($time,"\tThread A");
        #15;
        $display($time,"\tThread B");
      end
 
      begin
        $display($time,"\tThread C");
        #30;
        $display($time,"\tThread D");
      end
    join_any
    
    fork
      begin
        $display($time,"\tThread A1");
        #15;
        $display($time,"\tThread B1");
      end
begin
        $display($time,"\tThread C1");
        #30;
        $display($time,"\tThread D1");
      end
    join_none
    
    disable fork;
 
    $display("*AFTER_DISABLE_FORK*");

    $finish;
  
  end
endmodule
```
Output
```
  *BEFORE_DISABLE_FORK*
                   0	Thread A
                   0	Thread C
                  15	Thread B
	*AFTER_DISABLE_FORK*
```
## Ex3
//Disable a particular thread
```
module disable_specific_thread;

  initial begin
    $display("\t*BEFORE_DISABLE_SPECIFIC_THREAD*");

    fork
      begin : A1
        $display("%0t\tThread A", $time);
        #30;
        $display("%0t\tThread B", $time);
      end

      begin : B1
        $display("%0t\tThread C", $time);
        #15;
        $display("%0t\tThread D", $time);
      end
    join_any

    disable A1;

    $display("\t*AFTER_DISABLE_SPECIFIC_THREAD*");

    #50 $finish;
  end

endmodule
```
Output
```
	*BEFORE_DISABLE_SPECIFIC_THREAD*
0	Thread A
0	Thread C
15	Thread D
	*AFTER_DISABLE_SPECIFIC_THREAD*
 ```



