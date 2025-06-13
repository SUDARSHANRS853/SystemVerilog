# Scope Randomization
Syntax
```
randomize(signal names);
```
# Object Randomization
Syntax
```
handle.randomize();
```
# Example for Scope Randomize
```
class packet;
  rand int a;
  rand int b;
  rand byte c;  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    repeat(5) begin
      if (randomize(p.a, p.b, p.c)) begin
        $display("a = %0d | b = %0d | c = %0d", p.a, p.b, p.c);
      end else begin
        $display("Randomization failed");
      end
    end
  end
  
endmodule
```
```
a = 745498069 | b = 965135662 | c = 22
a = 1839063467 | b = -2026068732 | c = -25
a = 867541970 | b = 1687939045 | c = -115
a = -1341242060 | b = -1756719925 | c = 37
a = -1792175997 | b = -1427011644 | c = 13
```
# Examples for Object Randomization
## Ex1
```class packet;
  rand int a;
  int b;
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      p.randomize();
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = -384116807 | b = 0
a = 1637914715 | b = 0
a = 397247290 | b = 0
a = -407577593 | b = 0
a = -1298805792 | b = 0
```
Ex2
```
class packet;
  rand bit [7:0] a;
  rand bit [7:0] b;
  
  function void display();
    $display("a = %0d | b = %0d",a,b);
  endfunction
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      if(p.randomize())
       $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = 185 | b = 108
a = 91 | b = 128
a = 58 | b = 86
a = 7 | b = 82
a = 224 | b = 76
```


