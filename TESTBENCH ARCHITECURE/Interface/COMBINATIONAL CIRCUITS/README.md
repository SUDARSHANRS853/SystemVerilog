# INTERFACE
```
Interface is used to encapsulate communication between design blocks, and between design and verification blocks.

Encapsulating communication between blocks facilitates design reuse.

Interfaces can be accessed through ports as a single item.

Signals can be added to and removed easily from an interface without modifying any port list.

Interface can contain the connectivity, synchronization, and optionally, the functionality of the communication between two or more blocks.
```
## 1.Half adder
```
interface intf;
  logic a;
  logic b;
  logic s;
  logic c;
  modport DUT(input a,b,output s,c);
  modport TB(input s,c,output a,b);
  endinterface

//DUT

module ha(intf.DUT inf);
  assign {inf.c,inf.s}=inf.a+inf.b;
  //assign {inf.a,inf.b}=inf.s+inf.c;
endmodule
//testbench

module test(intf.TB inf);
  initial begin
    repeat(5)
      begin
        {inf.a,inf.b}=$random;
        #10;
      end
  end

initial begin
  $monitor("a=%b,b=%b,s=%b,c=%b",inf.a,inf.b,inf.s,inf.c);
end
endmodule

//top module
module top;
  //instantiate interface
  intf inf();
  //instantiate tb
  ha dut(inf);
  //instantiate tb
  test tb(inf);
endmodule
```
Output
```
a=0,b=0,s=0,c=0
a=0,b=1,s=1,c=0
a=1,b=1,s=0,c=1
a=0,b=1,s=1,c=0
```
## 2.Half Substractor
```
interface intf;
  logic a,b,d,bo;
  modport DUT(input a,b,output d,bo);
  modport TB(input d,bo,output a,b);
endinterface
module hs(intf.DUT inf);
  assign {inf.d,inf.bo}=inf.a-inf.b;
endmodule
 
//test bench
module test(intf.TB inf);
  initial begin
    repeat(5)
    begin
      {inf.a,inf.b}=$random;
      #10;
    end
  end
  initial begin
    $monitor("a=%b,b=%b,d=%b,bo=%b",inf.a,inf.b,inf.d,inf.bo);
  end
endmodule
//top module
module top;
  //instantiate the interface
  intf inf();
  //instantiate the hs
  hs dut(inf);
  //instantiate the testbench
  test tb(inf);
endmodule
```
Output
```
a=0,b=0,d=0,bo=0
a=0,b=1,d=1,bo=1
a=1,b=1,d=0,bo=0
a=0,b=1,d=1,bo=1
```
