# Polymorphism
Polymorphism is an ability to appear in many forms. In OOPS, multiple routines sharing a common name is termed as Polymorphism
In SV (SystemVerilog), Polymorphism allows a parent class handler to hold sub class object and access the methods of those child classes from the parent class handler.
To achieve this, functions/tasks in SV are declared as virtual functions/tasks, which allow child classes to override the behaviour of the function/task.
Polymorphism : we are accessing the methods of child class using parent handle
In polymorphism parent acts as a child
# Rules:
1. write the same methods with same signatures with different functionalities in parent class as well as child classes

2. write 'virtual' keyword with function in top parent class - Recommended.

3. declare equal no. of handles for parent class and child classes.

4. cretae the child handle object and assign child handle into parent handle.

5. then if we access 'parent_name.method' then 'child_name.method' is accessed.

NOTE : we cannot write 'virtual' with 'new()' i.e. custom constructor.

NOTE: usually we assign child handle to parent handle...but we cannot assign parent handle to child handle

Ex : b = c ; // c - child , b - parent

c = b ; // we cannot assign directly

This can be done using casting.
## Ex1: without polymorphism
```
class A;
  
  function void display();
    $display("A");
  endfunction
  
endclass

class B extends A;
  
  function void display();
    $display("B");
  endfunction
  
endclass

class C extends B;
  
  function void display();
    $display("C");
  endfunction
  
endclass

module tb;
  A a;
  B b;
  C c;
  
  initial begin
    c = new();
    b = c;
    a = b;
    
    b.display();  // B since no polymorphism implemented using 'virtual' keyword
    a.display();  // A since no polymorphism implemented using 'virtual' keyword
    
  end
  
endmodule
```
# Ex2 : virtual keyword in only A
```
class A;
  
  virtual function void display();
    $display("A");
  endfunction
  
endclass

class B extends A;
  
  function void display();
    $display("B");
  endfunction
  
endclass

class C extends B;
  
  function void display();
    $display("C");
  endfunction
  
endclass

module tb;
  A a;
  B b;
  C c;
  
  initial begin
    c = new();
    b = c;       // B is pointing to C
    a = b;       // A is pointing to B
    
    b.display();  //  C 
    a.display();  //  C
    
  end
  
endmodule
```
# Ex3 : virtual keyword in only B and C
```
class A;
  
  function void display();
    $display("A");
  endfunction
  
endclass

class B extends A;
  
  virtual function void display();
    $display("B");
  endfunction
  
endclass

class C extends B;
  
  virtual function void display();
    $display("C");
  endfunction
  
endclass

module tb;
  A a;
  B b;
  C c;
  
  initial begin
    c = new();
    b = c;       // B is pointing to C
    a = b;       // No polymorphism since no 'veirtual' in A
    
    b.display();  // C 
    a.display();  // A
    
  end
  
endmodule
```
# Ex4 : virtual in A,B,C
```
class A;
  
  virtual function void display();
    $display("A");
  endfunction
  
endclass

class B extends A;
  
  virtual function void display();
    $display("B");
  endfunction
  
endclass

class C extends B;
  
  virtual function void display();
    $display("C");
  endfunction
  
endclass

module tb;
  A a;
  B b;
  C c;
  
  initial begin
    c = new();
    a = b;        // A is pointing to B , but B has null memory 
    b = c;        // B is pointing to C
   
    
    b.display();  // C 
    a.display();  // Error- Null object access
    
  end
  
endmodule
```
# Ex5 : virtual in A,B,C and c = new() , b = new()

```
class A;
  
  virtual function void display();
    $display("A");
  endfunction
  
endclass

class B extends A;
  
  virtual function void display();
    $display("B");
  endfunction
  
endclass

class C extends B;
  
  virtual function void display();
    $display("C");
  endfunction
  
endclass

module tb;
  A a;
  B b;
  C c;
  
  initial begin
    c = new();
    b = new();

    a = b;        // A is pointing to B
    b = c;        // B is pointing to C
   
    b.display();  // C 
    a.display();  // B
    
  end
  
endmodule
```
# Ex6 :
```
class A;
  
  virtual function void display();
    $display("A");
  endfunction
  
endclass

class B extends A;
  
  virtual function void display();
    $display("B");
  endfunction
  
endclass

class C extends B;
  
  virtual function void display();
    $display("C");
  endfunction
  
endclass

module tb;
  A a[2];
  B b;
  C c;
  
  initial begin
    c = new();
    b = new();

    a[0] = b;        // a[0] is pointing to B
    a[1] = c;        // a[1] is pointing to C
   
    a[0].display();  // B
    a[1].display();  // C
    
  end
  
endmodule
```
