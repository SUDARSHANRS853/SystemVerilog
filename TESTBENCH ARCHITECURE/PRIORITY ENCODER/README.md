# PRIORITY ENCODER VERIFICATION
## DUT
```
module dff(dff_intf inf);
  always @(posedge inf.clk) begin
    if (inf.rst)
      inf.dout <= 1'b0;
    else
      inf.dout <= inf.din;
  end
endmodule
```
## INTERFACE
```
interface dff_intf;
  logic clk, rst, din, dout;
endinterface
```
## TRANSACTION
```
class transaction;
  rand bit din;
  bit dout;

  function transaction copy();
    transaction t = new();
    t.din = this.din;
    t.dout = this.dout;
    return t;
  endfunction

  function void display(string name);
    $display("[%s] : DIN = %b DOUT = %b", name, din, dout);
  endfunction
endclass
```
## GENERATOR
```
class generator;
  transaction tr;
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2scr;

  event done;
  event sconext;

  function new(mailbox #(transaction) gen2drv, mailbox #(transaction) gen2scr);
    this.gen2drv = gen2drv;
    this.gen2scr = gen2scr;
  endfunction

  task main();
    repeat (10) begin
      tr = new();
      assert(tr.randomize()) else $error("[GEN] : RANDOMIZATION FAILED");
      gen2drv.put(tr);
      gen2scr.put(tr.copy());
      #1;
      tr.display("GEN");
      @(sconext);
    end
    ->done;
  endtask
endclass
```
## DRIVER
```
class driver;
  transaction tr;
  mailbox #(transaction) gen2drv;
  virtual dff_intf vif;

  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task reset();
    vif.rst <= 1'b1;
    repeat(5) @(posedge vif.clk);
    vif.rst <= 1'b0;
    @(posedge vif.clk);
    $display("[DRV] : RESET DONE");
  endtask

  task main();
    forever begin
      gen2drv.get(tr);
      vif.din <= tr.din;
      @(posedge vif.clk);
      tr.display("DRV");
    end
  endtask
endclass
```
## MONITOR
```
class monitor;
  transaction tr;
  mailbox #(transaction) mon2scr;
  virtual dff_intf vif;

  function new(mailbox #(transaction) mon2scr);
    this.mon2scr = mon2scr;
  endfunction

  task main();
    forever begin
      repeat (2) @(posedge vif.clk);
      tr = new();
      tr.din = vif.din;
      tr.dout = vif.dout;
      mon2scr.put(tr);
      tr.display("MON");
    end
  endtask
endclass
```
## SCOREBOARD
```
class scoreboard;
  transaction tr;
  transaction trref;
  mailbox #(transaction) mon2scr;
  mailbox #(transaction) gen2scr;
  event sconext;

  function new(mailbox #(transaction) mon2scr, mailbox #(transaction) gen2scr);
    this.mon2scr = mon2scr;
    this.gen2scr = gen2scr;
  endfunction

  task main();
    forever begin
      mon2scr.get(tr);
      gen2scr.get(trref);
      tr.display("SCR");
      trref.display("REF");

      if (tr.dout == trref.din)
        $display("TEST PASSED");
      else
        $display("TEST FAILED");

      $display("");
      ->sconext;
    end
  endtask
endclass
```
## ENVIRONMENT
```
class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scr;

  event next;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scr;
  mailbox #(transaction) gen2scr;

  virtual dff_intf vif;

  function new(virtual dff_intf vif);
    this.vif = vif;

    gen2drv = new();
    mon2scr = new();
    gen2scr = new();

    gen = new(gen2drv, gen2scr);
    drv = new(gen2drv);
    mon = new(mon2scr);
    scr = new(mon2scr, gen2scr);

    drv.vif = this.vif;
    mon.vif = this.vif;

    gen.sconext = next;
    scr.sconext = next;
  endfunction

  task pre_test();
    drv.reset();
  endtask

  task test();
    fork
      gen.main();
      drv.main();
      mon.main();
      scr.main();
    join_any
  endtask

  task post_test();
    wait(gen.done.triggered);
    $finish;
  endtask

  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass
```

## TOP LEVEL TESTBENCH\
```
module tb;

  dff_intf inf();
  dff dut(inf);

  environment env;

  initial begin
    inf.clk <= 0;
    //inf.rst <= 0;
  end

  always #10 inf.clk <= ~inf.clk;

  initial begin
    env = new(inf);
    env.run();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule
```
## OUTPUT 
```
[DRV] : RESET DONE
[GEN] : DIN = 0 DOUT = 0
[DRV] : DIN = 0 DOUT = 0
[MON] : DIN = 0 DOUT = 0
[SCR] : DIN = 0 DOUT = 0
[REF] : DIN = 0 DOUT = 0
TEST PASSED

[GEN] : DIN = 0 DOUT = 0
[DRV] : DIN = 0 DOUT = 0
[MON] : DIN = 0 DOUT = 0
[SCR] : DIN = 0 DOUT = 0
[REF] : DIN = 0 DOUT = 0
TEST PASSED

[GEN] : DIN = 1 DOUT = 0
[DRV] : DIN = 1 DOUT = 0
[MON] : DIN = 1 DOUT = 1
[SCR] : DIN = 1 DOUT = 1
[REF] : DIN = 1 DOUT = 0
TEST PASSED

[GEN] : DIN = 1 DOUT = 0
[DRV] : DIN = 1 DOUT = 0
[MON] : DIN = 1 DOUT = 1
[SCR] : DIN = 1 DOUT = 1
[REF] : DIN = 1 DOUT = 0
TEST PASSED

[GEN] : DIN = 1 DOUT = 0
[DRV] : DIN = 1 DOUT = 0
[MON] : DIN = 1 DOUT = 1
[SCR] : DIN = 1 DOUT = 1
[REF] : DIN = 1 DOUT = 0
TEST PASSED

[GEN] : DIN = 0 DOUT = 0
[DRV] : DIN = 0 DOUT = 0
[MON] : DIN = 0 DOUT = 0
[SCR] : DIN = 0 DOUT = 0
[REF] : DIN = 0 DOUT = 0
TEST PASSED

[GEN] : DIN = 1 DOUT = 0
[DRV] : DIN = 1 DOUT = 0
[MON] : DIN = 1 DOUT = 1
[SCR] : DIN = 1 DOUT = 1
[REF] : DIN = 1 DOUT = 0
TEST PASSED

[GEN] : DIN = 0 DOUT = 0
[DRV] : DIN = 0 DOUT = 0
[MON] : DIN = 0 DOUT = 0
[SCR] : DIN = 0 DOUT = 0
[REF] : DIN = 0 DOUT = 0
TEST PASSED

[GEN] : DIN = 1 DOUT = 0
[DRV] : DIN = 1 DOUT = 0
[MON] : DIN = 1 DOUT = 1
[SCR] : DIN = 1 DOUT = 1
[REF] : DIN = 1 DOUT = 0
TEST PASSED

[GEN] : DIN = 1 DOUT = 0
[DRV] : DIN = 1 DOUT = 0
[MON] : DIN = 1 DOUT = 1
[SCR] : DIN = 1 DOUT = 1
[REF] : DIN = 1 DOUT = 0
TEST PASSED
```

