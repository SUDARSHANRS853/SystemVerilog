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
a = 745498069 | b = 965135662 | c = 22
/ a = 1839063467 | b = -2026068732 | c = -25
/ a = 867541970 | b = 1687939045 | c = -115
/ a = -1341242060 | b = -1756719925 | c = 37
/ a = -1792175997 | b = -1427011644 | c = 13
```

