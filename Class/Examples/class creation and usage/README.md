# Examples
## Ex1
```
class packet;
  bit [7:0] addr;
  bit [7:0] data;
  
  function void display();
    $display(" addr : %0d | data : %0d ",addr ,data);
  endfunction
  
endclass

module tb;
  packet p1; // handler
  
  initial begin
    p1 = new();  // object creation
    p1.display(); // displays default values of addr and data
    
    p1.addr = 10;
    p1.data = 20;
    
    p1.display(); // displays updated values of addr and data
    
    p1.addr = 100;
    p1.data = 200;
    
    p1.display(); // displays updated values of addr and data
    
  end
  
endmodule
```
```
// Output
addr : 0 | data : 0
addr : 10 | data : 100
addr : 100 | data : 200
```
# Ex2
```
class packet;
  bit [7:0] addr;
  bit [7:0] data;
  
  function void display();
    $display(" addr : %0d | data : %0d ",addr ,data);
  endfunction
  
endclass

module tb;
  packet p1,p2; // handler
  
  initial begin
    p1 = new();  // object creation
    p2 = new();
    
    p1.display(); // displays default values of addr and data of p1
    p2.display(); // displays default values of addr and data of p2
    
    p1.addr = 10;
    p1.data = 20;
    
    p1.display(); // displays updated values of addr and data
    p2.display();
    
    p2.addr = 100;
    p2.data = 200;
    
    p1.display(); // displays updated values of addr and data
    p2.display(); // displays updated values of addr and data
    
  end
  
endmodule
```
```
// Output
 addr : 0 | data : 0 
 addr : 0 | data : 0 
 addr : 10 | data : 20 
 addr : 0 | data : 0 
 addr : 10 | data : 20 
 addr : 100 | data : 200
```
