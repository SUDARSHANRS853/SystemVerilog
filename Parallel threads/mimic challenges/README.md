# mimic the functionality for fork join  using fork join_any
```
module fork_join;
 
  initial begin
    
    $display("\tBEFORE FORK..JOIN");                                     
    
    fork
      #15 $display($time,"\tThread A");
      #5  $display($time,"\tThread B");
      #10 $display($time,"\tThread C");
      #2  $display($time,"\tThread D");
    join_any
	wait fork;
      #7  $display($time,"\tThread E");
 
      $display("\tAFTER FORK..JOIN");
    
    $finish;
  end
endmodule
```
Output
```
BEFORE FORK..JOIN
                   2	Thread D
                   5	Thread B
                  10	Thread C
                  15	Thread A
                  22	Thread E
AFTER FORK..JOIN
```
# mimic the functionality for fork join  using fork join_none
```
 module fork_join;
 
  initial begin
    
    $display("\tBEFORE FORK..JOIN");                                     
    
    fork
      #15 $display($time,"\tThread A");
      #5  $display($time,"\tThread B");
      #10 $display($time,"\tThread C");
      #2  $display($time,"\tThread D");
    join_none
	wait fork;
      #7  $display($time,"\tThread E");
 
      $display("\tAFTER FORK..JOIN");
    
    $finish;
  end
endmodule
```
Output
```
BEFORE FORK..JOIN
                   2	Thread D
                   5	Thread B
                  10	Thread C
                  15	Thread A
                  22	Thread E
	AFTER FORK..JOIN
```
# mimic the functionality for fork join_any  using fork join_none
```
 module fork_join;
  event done;
 
  initial begin
    
    $display("BEFORE FORK..JOIN");                                     
    
    fork
      begin
      #15 $display($time,"\tThread A");
      ->done;
      end
      begin
      #5  $display($time,"\tThread B");
        ->done;
      end
      begin
      #10 $display($time,"\tThread C");
        ->done;
      end
      begin
      #2  $display($time,"\tThread D");
        ->done;
      end
          join_none
    @(done)
	//wait fork;
      #7  $display($time,"\tThread E");
 
    $display("AFTER FORK..JOIN");
    
    $finish;
  end
endmodule
```
Output
```
BEFORE FORK..JOIN
                   2	Thread D
                   5	Thread B
                   9	Thread E
	AFTER FORK..JOIN
```
# mimic the functionality for fork join_none  using fork join_any
```
module fork_join;
  event done;
 
  initial begin
    
    $display("BEFORE FORK..JOIN");                                     
    
    fork
      begin
      end
      begin
      #15 $display($time,"\tThread A");
      
      end
      begin
      #5  $display($time,"\tThread B");
       
      end
      begin
      #10 $display($time,"\tThread C");
       
      end
      begin
      #2  $display($time,"\tThread D");
       
      end
 join_any
   
	//wait fork;
      #7  $display($time,"\tThread E");
 
    $display("AFTER FORK..JOIN");
    
    $finish;
  end
endmodule
