# Examples related fork join
## Ex1
```
module wait_fork;
 
  initial begin
    $display("\t*BEFORE_WAIT_FORK*");
 
 
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
    
    wait fork; //waiting for all active fork threads to be finished
 
      $display("\t*AFTER_WAIT_FORK*");

    $finish;
  
  end
endmodule
```
Output
```
*BEFORE_WAIT_FORK*
                   0	Thread A
                   0	Thread C
                  15	Thread B
                  30	Thread D
	*AFTER_WAIT_FORK*
```
## Ex2
```
module fork_join;
 
  initial begin
    
    $display("\t *BEFORE FORK..JOIN*");
    
    fork
      begin
        #15 $display($time,"\tThread A");
        #5  $display($time,"\tThread B");
      end
      begin
        #10 $display($time,"\tThread C");
        #2  $display($time,"\tThread D");
      end
    join
    
      #7  $display($time,"\tThread E");
 
    $display("\t *AFTER FORK..JOIN*");
    
    $finish;
  end
  
endmodule
```
Output
```
*BEFORE FORK..JOIN*
                  10	Thread C
                  12	Thread D
                  15	Thread A
                  20	Thread B
                  27	Thread E
	 *AFTER FORK..JOIN*
```
## Ex3
```
module fork_join;
 
  initial begin
    
    $display("\t *BEFORE FORK..JOIN*");                                     
    
    fork
      #15 $display($time,"\tThread A");
      #5  $display($time,"\tThread B");
      #10 $display($time,"\tThread C");
      #2  $display($time,"\tThread D");
    join
	disable fork;
      #7  $display($time,"\tThread E");
 
      $display("\t *AFTER FORK..JOIN*");
    
    $finish;
  end
endmodule
```
Output
```
*BEFORE FORK..JOIN*
                   2	Thread D
                   5	Thread B
                  10	Thread C
                  15	Thread A
                  22	Thread E
	 *AFTER FORK..JOIN*
```
## EX3
### Event example
```
module test;
  event done_a;
  event done_b;
  
  initial begin
    fork 
      begin                          //10
        #5 $display($time," Th A");  //5
      -> done_a;                     //5
      end
      
      begin                          //0
        #10 $display($time," Th B"); //10
        -> done_b;                   //10
      end
      
    join_none                       //0
    
    fork                            //0
      begin                         //0
        @(done_a);                  //5
        $display($time," Th C");    //5
      end
      
      begin                         //0
        @(done_b);                  //10
        $display($time," Th D");    //10
      end
      
    join                            //10
  end
  
endmodule
```
 Output
 ```

                   5 Th A
                   5 Th C
                  10 Th B
                  10 Th D
```

