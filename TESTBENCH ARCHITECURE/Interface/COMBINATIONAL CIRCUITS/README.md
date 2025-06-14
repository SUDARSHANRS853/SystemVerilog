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

//DUT
module hs(intf.DUT inf);
  assign {inf.bo,inf.d}=inf.a-inf.b;
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
## 3.Fulladder
```
interface intf;
  logic a,b,c,s,co;
  modport DUT(input a,b,c,output s,co);
  modport TB(input s,co,output a,b,c);
endinterface

//DUT
module fa(intf.DUT inf);
  assign {inf.co,inf.s}=inf.a+inf.b+inf.c;
endmodule

// testbench
module test(intf.TB inf);
  initial begin
    repeat(10)
    begin
    {inf.a,inf.b,inf.c}=$random;
    #10;
  end
  end
  initial begin
    $monitor("a=%b,b=%b,c=%b,s=%b,co=%b",inf.a,inf.b,inf.c,inf.s,inf.co);
  end
endmodule

//top
module top;
  //interface instantiation
  intf inf();
  //instantiation of dut
  fa dut(inf);
  //instantiation of tb
  test tb(inf);
endmodule
```
Output
```
a=1,b=0,c=0,s=1,co=0
a=0,b=0,c=1,s=1,co=0
a=0,b=1,c=1,s=0,co=1
a=1,b=0,c=1,s=0,co=1
a=0,b=1,c=0,s=1,co=0
a=0,b=0,c=1,s=1,co=0
a=1,b=0,c=1,s=0,co=1
```
## 4.Full Substractor
```
interface intf;
  logic a,b,c,d,bo;
  modport DUT(input a,b,c,output d,bo);
  modport TB(input d,bo,output a,b,c);
endinterface

//DUT
module fs(intf.DUT inf);
  assign {inf.bo,inf.d}=inf.a-inf.b-inf.c;
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.a,inf.b,inf.c}=$random;
        #10;
      end
  end
  initial begin
    $monitor("a=%b,b=%b,c=%b,d=%b,bo=%b",inf.a,inf.b,inf.c,inf.d,inf.bo);
  end
    
endmodule

//TOP
module top;
  intf inf();
  fs dut(inf);
  test tb(inf);
endmodule
```
Output
```
a=1,b=0,c=0,d=1,bo=0
a=0,b=0,c=1,d=1,bo=1
a=0,b=1,c=1,d=0,bo=1
a=1,b=0,c=1,d=0,bo=0
a=0,b=1,c=0,d=1,bo=1
a=0,b=0,c=1,d=1,bo=1
a=1,b=0,c=1,d=0,bo=0
```
## 5.MUX21
```
   interface intf;
     logic [1:0]i;
     logic s,y;
     modport DUT(input i,s,output y);
     modport TB(input y,output i,s);
   endinterface

//DUT
module mux21(intf.DUT inf);
  assign inf.y=(~(inf.s)&(inf.i[0]))|((inf.s)&(inf.i[1]));
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.i,inf.s}=$random;
        #10;
      end
  end
  initial begin
    $monitor("i=%b,s=%b,y=%b",inf.i,inf.s,inf.y);
  end
endmodule

//TOP
module top;
  //instantiation of interface
  intf inf();
  //instantiation of DUT
  mux21 dut(inf);
  //instantiation of TEST
  test tb(inf);
endmodule
```
Output
```
i=10,s=0,y=0
i=00,s=1,y=0
i=01,s=1,y=0
i=10,s=1,y=1
i=01,s=0,y=1
i=00,s=1,y=0
i=10,s=1,y=1
```
## 6.MUX41
```
interface intf;
  logic [3:0]i;
  logic [1:0]s;
  logic y;
  modport DUT(input i,s,output y);
  modport TB(input y,output i,s);
endinterface
//DUT
module mux41(intf.DUT inf);
  assign inf.y=(inf.i[0]&(~inf.s[1])&(~inf.s[0]))|
                (inf.i[1]&(~inf.s[1])&(inf.s[0]))|
                 (inf.i[3]&(inf.s[1])&(~inf.s[0]))|
                  (inf.i[0]&(inf.s[1])&(inf.s[0]));
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.i,inf.s}=$random;
        #10;
      end
  end
  initial begin
    $monitor("i=%b,s=%b,y=%b",inf.i,inf.s,inf.y);
  end
endmodule

//Top
module top;
  intf inf();
  mux41 dut(inf);
  test tb(inf);
endmodule
```
Output
```
i=1001,s=00,y=1
i=0000,s=01,y=0
i=0010,s=01,y=1
i=1000,s=11,y=0
i=0011,s=01,y=1
i=1001,s=01,y=0
i=0100,s=10,y=0
i=0000,s=01,y=0
i=0011,s=01,y=1
```
## 7. 3*1 MUX USING TURNARY OPERATOR
```
interface intf;
  logic [2:0]i;
  logic [1:0]s;
  logic y;
  modport DUT(input i,s,output y);
  modport TB(input y,output i,s);
endinterface

//DUT
module mux41(intf.DUT inf);
  assign inf.y=(inf.s[1])?((inf.s[0])?1'bx:inf.i[2]):((inf.s[0])?inf.i[1]:inf.i[0]);
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.i,inf.s}=$random;
        #10;
      end
  end
  initial begin
    $monitor("i=%b,s=%b,y=%b",inf.i,inf.s,inf.y);
  end
endmodule

//Top
module top;
  intf inf();
  mux41 dut(inf);
  test tb(inf);
endmodule
```
Output
```
i=001,s=00,y=1
i=000,s=01,y=0
i=010,s=01,y=1
i=000,s=11,y=x
i=011,s=01,y=1
i=001,s=01,y=0
i=100,s=10,y=1
i=000,s=01,y=0
i=011,s=01,y=1
```
## 8. 5*1MUX using turnary operator
```interface intf;
  logic [4:0]i;
  logic [2:0]s;
  logic y;
  modport DUT(input i,s,output y);
  modport TB(input y,output i,s);
endinterface
//DUT
module mux41(intf.DUT inf);
  assign inf.y=(inf.s[2])?((inf.s[1])?((inf.s[0])?1'bx:1'bx):((inf.s[0])?1'bx:inf.i[4])):
    ((inf.s[1])?((inf.s[0])?inf.i[3]:inf.i[2]):(inf.s[0])?inf.i[1]:inf.i[0]);
 
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.i,inf.s}=$random;
        #10;
      end
  end
  initial begin
    $monitor("i=%b,s=%b,y=%b",inf.i,inf.s,inf.y);
  end
endmodule

//Top
module top;
  intf inf();
  mux41 dut(inf);
  test tb(inf);
endmodule
```
Output
```
i=00100,s=100,y=0
i=10000,s=001,y=0
i=00001,s=001,y=0
i=01100,s=011,y=1
i=00001,s=101,y=x
i=10001,s=101,y=x
i=01100,s=101,y=x
i=00010,s=010,y=0
i=00000,s=001,y=0
i=00001,s=101,y=x
```
## 9. 8*1 MUX using Turnary operator
```
interface intf;
  logic [7:0]i;
  logic [2:0]s;
  logic y;
  modport DUT(input i,s,output y);
  modport TB(input y,output i,s);
endinterface
//DUT
module mux41(intf.DUT inf);
  assign inf.y=(inf.s[2])?((inf.s[1])?((inf.s[0])?inf.i[7]:inf.i[6]):((inf.s[0])?inf.i[5]:inf.i[4])):((inf.s[1])?((inf.s[0])?inf.i[3]:inf.i[2]):(inf.s[0])?inf.i[1]:inf.i[0]);
 
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.i,inf.s}=$random;
        #10;
      end
  end
  initial begin
    $monitor("i=%b,s=%b,y=%b",inf.i,inf.s,inf.y);
  end
endmodule

//Top
module top;
  intf inf();
  mux41 dut(inf);
  test tb(inf);
endmodule
```
Output
```
i=10100100,s=100,y=0
i=11010000,s=001,y=0
i=11000001,s=001,y=0
i=11001100,s=011,y=1
i=01100001,s=101,y=1
i=00110001,s=101,y=1
i=10001100,s=101,y=0
i=01000010,s=010,y=0
i=01100000,s=001,y=0
i=10100001,s=101,y=1
```
## 10. 2*4 Decoder
```
interface intf;
  logic [1:0]i;
  logic [3:0]d;
  modport DUT(input i,output d);
  modport TB(input d,output i);
endinterface
//DUT
module Decoder24(intf.DUT inf);
  assign inf.d[0]=(~inf.i[0])&(~inf.i[1]);
  assign inf.d[1]=(inf.i[0])&(~inf.i[1]);
  assign inf.d[2]=(~inf.i[0])&(inf.i[1]);
  assign inf.d[3]=(inf.i[0])&(inf.i[1]);
 
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.i}=$random;
        #10;
      end
  end
  initial begin
    $monitor("i=%b,d=%b",inf.i,inf.d);
  end
endmodule

//Top
module top;
  intf inf();
  Decoder24 dut(inf);
  test tb(inf);
endmodule
```
Output
```
i=00,d=0001
i=01,d=0010
i=11,d=1000
i=01,d=0010
i=10,d=0100
i=01,d=0010
```
## 3*8 decoder
```
interface intf;
  logic [2:0]i;
  logic [7:0]d;
  modport DUT(input i,output d);
  modport TB(input d,output i);
endinterface
//DUT
module Decoder38(intf.DUT inf);
  assign inf.d[0]=(~inf.i[0])&(~inf.i[1])&(~inf.i[2]);
  assign inf.d[1]=(inf.i[0])&(~inf.i[1])&(~inf.i[2]);
  assign inf.d[2]=(~inf.i[0])&(inf.i[1])&(~inf.i[2]);
  assign inf.d[3]=(inf.i[0])&(inf.i[1])&(~inf.i[2]);
  assign inf.d[4]=(~inf.i[0])&(~inf.i[1])&(inf.i[2]);
  assign inf.d[5]=(inf.i[0])&(~inf.i[1])&(inf.i[2]);
  assign inf.d[6]=(~inf.i[0])&(inf.i[1])&(inf.i[2]);
  assign inf.d[7]=(inf.i[0])&(inf.i[1])&(inf.i[2]);
  
 
endmodule

//TESTBENCH
module test(intf.TB inf);
  initial begin
    repeat(10)
      begin
        {inf.i}=$random;
        #10;
      end
  end
  initial begin
    $monitor("i=%b,d=%b",inf.i,inf.d);
  end
endmodule

//Top
module top;
  intf inf();
  Decoder38 dut(inf);
  test tb(inf);
endmodule
```
Output
```
i=100,d=00010000
i=001,d=00000010
i=011,d=00001000
i=101,d=00100000
i=010,d=00000100
i=001,d=00000010
i=101,d=00100000
```

