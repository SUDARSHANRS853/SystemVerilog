## Encapsulation : used to protect the data members of one class from being accessed by another class
#### 1.Public - can be accessed by other classes
#### 2.Private - limited to local class only cannot be accessed by other classes
#### 3.Protected - can be accessed within same class and one child class
#### NOTE : 'new()' function is global, it is used for accessing local and protected members of class outside of it.

## Ex :
```
class A;
  local int x;
  local int y;
  
  local function void display();
    $display("x = %0d | y = %0d ", x,y);
  endfunction
  
  function new(int x, int y);
    this.x = x;
    this.y = y;
    display();
  endfunction
  
endclass


module tb;
  A a;
  
  initial begin
    a = new(100,200);  // x = 100 | y = 200
  end
  
endmodule
```
## Ex2 : write parent class with one protected prop. extend this class with another class which is having one local prop. write a TB to update values to these prop and print them
```
class packet;
  protected int x;
  
endclass

class superpacket extends packet;
  local int y;
  
  function new(int x, int y);
    super.x = x;
    this.y = y;
    $display(" x = %0d | y = %0d",super.x, y);
  endfunction
  
endclass


module tb;
  superpacket sp;
  
  initial begin
    sp = new(10,20);  // x = 10 | y = 20
  end
  
endmodule
```
## Ex3 : write parent class with one local prop. extend this class with another class which is having one local prop. write a TB to update values to these prop and print them.
```
class packet;
  local int x;
  
  function new(int x);
    this.x = x;
   // $display(" x = %0d",x);
  endfunction
  
  // getter method for returning x in child class
  function int get_x();
    return x;
  endfunction
  
endclass

class superpacket extends packet;
  local int y;
  
  function new(int x, int y);
    super.new(x);
    this.y = y;
    $display(" x = %0d | y = %0d", get_x(), y);
  endfunction
  
endclass


module tb;
  superpacket sp;
  
  initial begin
    sp = new(10,20);  // x = 10 | y = 20
  end
  
endmodule
```

