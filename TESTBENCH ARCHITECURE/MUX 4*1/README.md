# 4*1 MUX TESTBENCH ARCHITECTURE

## 1.DUT
```
module mux(sel,I,Y);
  input [1:0] sel;
  input [3:0] I;
  output reg Y;
  
  always@(*) begin
    case(sel)
      2'b00 : Y = I[0];
      2'b01 : Y = I[1];
      2'b10 : Y = I[2];
      2'b11 : Y = I[3];
      default : Y = 1'b0;
    endcase
  end
  
endmodule
```
## 2.INTTERFACE
```
interface mux_intf;
  logic [1:0] sel;
  logic [3:0] I;
  logic Y;
endinterface
```
## 3.TRANSACTION
```
class transaction;
  rand bit [1:0] sel;
  rand bit [3:0] I;
  bit Y;
  
  function void display(string name);
    $display("[%s] : sel = %b | I = %b | Y = %b",name,sel,I,Y);
  endfunction
  
endclass
```
## 4.GENERATOR
```
class generator;
  
  rand transaction tr;
  mailbox gen2drv;
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
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
  transaction tr;
  mailbox gen2drv;
  virtual mux_intf vif;
  
  function new(mailbox gen2drv,virtual mux_intf vif);
    this.gen2drv = gen2drv;
    this.vif = vif;
  endfunction
  
  
  task main();
    
    repeat(10) begin
      gen2drv.get(tr);
      
      vif.I <= tr.I;
      vif.sel <= tr.sel;
      
      #2;
      $display("");
      tr.display("DRV");
    end
    
  endtask
  
endclass
```
## 6. MONITOR
```
class monitor;
  
  transaction tr;
  mailbox mon2scr;
  virtual mux_intf vif;
  
  function new(mailbox mon2scr,virtual mux_intf vif);
    this.mon2scr = mon2scr;
    this.vif = vif;
  endfunction
  
  task main();
    repeat(10) begin
      #2;
      tr = new();
      tr.I = vif.I;
      tr.sel = vif.sel;
      tr.Y = vif.Y;
      
      mon2scr.put(tr);
      
      tr.display("MON");
      
    end
  endtask
  
endclass
```
## 7.SCOREBOARD
```
class scoreboard;
  
  transaction tr;
  mailbox mon2scr;
  // bit expected_y;
  
  function new(mailbox mon2scr);
    this.mon2scr = mon2scr;
  endfunction
  
  task main();
    
    repeat(10) begin
      
      mon2scr.get(tr);

//       case(tr.sel)
//         2'b00 : expected_y = tr.I[0];
//         2'b00 : expected_y = tr.I[1];
//         2'b00 : expected_y = tr.I[2];
//         2'b00 : expected_y = tr.I[3];
//       endcase
      
//       if( expected_y === tr.Y)
//         $display("TEST PASSED");
//       else
//         $display("TEST FAILED");

      case(tr.sel)
        2'b00 : if(tr.I[0] == tr.Y)
                  $display("TEST PASSED");
                else
                  $display("TEST FAILED");
        
        2'b01 : if(tr.I[1] == tr.Y)
                  $display("TEST PASSED");
                else
                  $display("TEST FAILED");
        
        2'b10 : if(tr.I[2] == tr.Y)
                  $display("TEST PASSED");
                else
                  $display("TEST FAILED");
      
        2'b11 : if(tr.I[3] == tr.Y)
                  $display("TEST PASSED");
                else
                  $display("TEST FAILED");
      endcase
      
      tr.display("SCR");
      
    end
  endtask
  
endclass
```
## 8.ENVIRONMENT
```
class environment;
  
  //declare class handles
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scr;
  
  //declare mailbox handles
  mailbox gen2drv;
  mailbox mon2scr;
  
  //declare inteface handles
  virtual mux_intf vif;
  
  //custom constructor
  function new(virtual mux_intf vif);
    this.vif = vif;
    
    gen2drv = new();
    mon2scr = new();
    
    gen = new(gen2drv);
    drv = new(gen2drv,vif);
    mon = new(mon2scr,vif);
    scr = new(mon2scr);
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
module test(mux_intf inf);
  
  environment env;
  
  initial begin
    env = new(inf);
    env.run();
  end
  
endmodule
```
## 10.TOP
```
module top;
  
  mux_intf inf();
  
  //instantiate DUT
  mux dut(.sel(inf.sel), .I(inf.I), .Y(inf.Y));
  
  //instatiate test
  test tb(inf);
  
endmodule
```
OUTPUT
```
[GEN] : sel = 01 | I = 0010 | Y = 0
[GEN] : sel = 10 | I = 0100 | Y = 0
[GEN] : sel = 11 | I = 1011 | Y = 0
[GEN] : sel = 11 | I = 0101 | Y = 0
[GEN] : sel = 11 | I = 1111 | Y = 0
[GEN] : sel = 11 | I = 0110 | Y = 0
[GEN] : sel = 00 | I = 0011 | Y = 0
[GEN] : sel = 00 | I = 1111 | Y = 0
[GEN] : sel = 00 | I = 0110 | Y = 0
[GEN] : sel = 11 | I = 0101 | Y = 0

[DRV] : sel = 01 | I = 0010 | Y = 0
[MON] : sel = 01 | I = 0010 | Y = 1
TEST PASSED
[SCR] : sel = 01 | I = 0010 | Y = 1

[DRV] : sel = 10 | I = 0100 | Y = 0
[MON] : sel = 10 | I = 0100 | Y = 1
TEST PASSED
[SCR] : sel = 10 | I = 0100 | Y = 1

[DRV] : sel = 11 | I = 1011 | Y = 0
[MON] : sel = 11 | I = 1011 | Y = 1
TEST PASSED
[SCR] : sel = 11 | I = 1011 | Y = 1

[DRV] : sel = 11 | I = 0101 | Y = 0
[MON] : sel = 11 | I = 0101 | Y = 0
TEST PASSED
[SCR] : sel = 11 | I = 0101 | Y = 0

[DRV] : sel = 11 | I = 1111 | Y = 0
[MON] : sel = 11 | I = 1111 | Y = 1
TEST PASSED
[SCR] : sel = 11 | I = 1111 | Y = 1

[DRV] : sel = 11 | I = 0110 | Y = 0
[MON] : sel = 11 | I = 0110 | Y = 0
TEST PASSED
[SCR] : sel = 11 | I = 0110 | Y = 0

[DRV] : sel = 00 | I = 0011 | Y = 0
[MON] : sel = 00 | I = 0011 | Y = 1
TEST PASSED
[SCR] : sel = 00 | I = 0011 | Y = 1

[DRV] : sel = 00 | I = 1111 | Y = 0
[MON] : sel = 00 | I = 1111 | Y = 1
TEST PASSED
[SCR] : sel = 00 | I = 1111 | Y = 1

[DRV] : sel = 00 | I = 0110 | Y = 0
[MON] : sel = 00 | I = 0110 | Y = 0
TEST PASSED
[SCR] : sel = 00 | I = 0110 | Y = 0

[DRV] : sel = 11 | I = 0101 | Y = 0
[MON] : sel = 11 | I = 0101 | Y = 0
TEST PASSED
```
