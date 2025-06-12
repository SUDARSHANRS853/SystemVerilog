# counts how many objects of a class are created
```
class packet;
  static int count;
  
  function new();
    count++;
  endfunction
  
endclass

module tb;
  packet p;
  
  initial begin
    repeat(10)
      p = new();
    $display("%0d",p.count);  // 10
  end
  
endmodule
```
