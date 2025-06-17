# Fulladder verification

## 1.DUT
```
module FA (input a,b,cin, output s,cout);
  assign {cout,s} = a+b+cin;
endmodule
```
## 2.INTERFACE
```
interface FA_intf;
  
  logic a;
  logic b;
  logic cin;
  logic s;
  logic cout;
  
endinterface
```

## 3.TRANSACTION
```
class transaction;
  
  rand bit a,b,cin;
  bit s,cout;
  
  function void display(string name);
    $display("[%s] : A = %b | B = %b | Cin = %b | Sum = %b | Carry = %b ",name,a,b,cin,s,cout);
    
  endfunction
endclass
```
## GENERATOR
```
class generator;
  
  //declaring the handlers
  rand transaction tr;
  mailbox gen2drv;
  
  // write custom constructor
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  // write the main task (generate the packet, randomize  and put this packet into mailbox
  task main();
    
    repeat(10) begin
      tr = new();
      assert(tr.randomize());
      gen2drv.put(tr);
      tr.display("GEN");
    end
    
  endtask
  
endclass
```
## 5.DRIVER
```
class driver;
  
  //declaring the handlers
  transaction tr;
  mailbox gen2drv;
  virtual FA_intf vif;
  
  // write custom constructor
  function new(mailbox gen2drv,virtual FA_intf vif);
    this.gen2drv = gen2drv;
    this.vif = vif;
  endfunction
  
  // write the main task
  task main();
    
    repeat(10) begin
      gen2drv.get(tr);
      
      // driving the inputs from the transaction packet to interface using NBA 
      vif.a <= tr.a;
      vif.b <= tr.b;
      vif.cin <= tr.cin;
      
      //printing the inputs before driving them
      
      #1;   // giving delay to avoid race condition
      $display("");
      tr.display("DRV");
    end
    
  endtask
  
endclass
```
## 6.MONITOR
```
class monitor;
  
  //declaring the handlers
  transaction tr;
  mailbox mon2scr;
  virtual FA_intf vif;
  
  //write the custom constructor
  function new(mailbox mon2scr , virtual FA_intf vif);
    this.mon2scr = mon2scr;
    this.vif = vif;
  endfunction

  // write the main task
  task main();
    
    repeat(10) begin
      #1;   // same delay as driver
      tr = new();
      // monitoring the IO's
      tr.a = vif.a;
      tr.b = vif.b;
      tr.cin = vif.cin;
      tr.s = vif.s;
      tr.cout = vif.cout;
      
      mon2scr.put(tr);  // putting the all data loaded transaction packet to mailbox
      
      tr.display("MON");
      
    end
    
  endtask
  
endclass
```
## 7.SCOREBOARD
```
class scoreboard;
  
  // declaring the handlers
  transaction tr;
  mailbox mon2scr;
  
  //custom constructor
  function new(mailbox mon2scr);
    this.mon2scr = mon2scr;
  endfunction
  
  // write the main task
  task main();
    
    repeat(10) begin
      mon2scr.get(tr);
      
      //checking with golden data
      if({tr.cout, tr.s} == tr.a + tr.b + tr.cin)
          $display("TEST PASSED");
      
      else
        $error("TEST FAILED");
     
      tr.display("SCR");
      
      end
    
  endtask
  
endclass
```
## 8.ENVIRENMENT
```
class environment;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scr;
         
         
  mailbox gen2drv;
  mailbox mon2scr;
  
  virtual FA_intf vif;
  
  function new(virtual FA_intf vif);
    this.vif = vif;
    
    gen2drv = new();
    mon2scr = new();
    
    gen=new(gen2drv);
    drv=new(gen2drv,vif);
    mon=new(mon2scr,vif);
    scr=new(mon2scr);
    
  endfunction
  
  task run();
    fork
      gen.main();
      drv.main();
      mon.main();
      scr.main();
    join_any
  endtask
  
endclass
```
## 9.TEST
```
module test(FA_intf inf);
  
  environment env;
  
  initial begin
    env = new(inf);
    env.run();
  end
  
endmodule
```
## 10.TOP
```
module test(FA_intf inf);
  
  environment env;
  
  initial begin
    env = new(inf);
    env.run();
  end
  
endmodule
```
OUTPUT
```
[GEN] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 0
[GEN] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0
[GEN] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[GEN] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[GEN] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[GEN] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 0
[GEN] : A = 0 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[GEN] : A = 0 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[GEN] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0
[GEN] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0

[DRV] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 0
[MON] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 1
TEST PASSED
[SCR] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 1

[DRV] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0
TEST PASSED
[SCR] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0

[DRV] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1
TEST PASSED
[SCR] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1

[DRV] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1
TEST PASSED
[SCR] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1

[DRV] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1
TEST PASSED
[SCR] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1

[DRV] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 0
[MON] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 1
TEST PASSED
[SCR] : A = 1 | B = 0 | Cin = 1 | Sum = 0 | Carry = 1

[DRV] : A = 0 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 0 | B = 1 | Cin = 0 | Sum = 1 | Carry = 0
TEST PASSED
[SCR] : A = 0 | B = 1 | Cin = 0 | Sum = 1 | Carry = 0

[DRV] : A = 0 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 0 | B = 1 | Cin = 0 | Sum = 1 | Carry = 0
TEST PASSED
[SCR] : A = 0 | B = 1 | Cin = 0 | Sum = 1 | Carry = 0

[DRV] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0
TEST PASSED
[SCR] : A = 0 | B = 0 | Cin = 0 | Sum = 0 | Carry = 0

[DRV] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 0
[MON] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1
TEST PASSED
[SCR] : A = 1 | B = 1 | Cin = 0 | Sum = 0 | Carry = 1
```



