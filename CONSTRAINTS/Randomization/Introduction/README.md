# System Functions
1. $random
2. $urandom 
3. $urandom_range();

## $urandom
$urandom is a SystemVerilog system function that generates random unsigned 32-bit integer values.Without a seed, produces different results each time simulation runs.With a seed, the same sequence of numbers is produced every run
```
int val;
val = $urandom;         // Random value
val = $urandom(seed);   // Seeded random value (optional)
```

# $urandom_range();
$urandom_range is a SystemVerilog system function used to generate a random unsigned 32-bit integer within a specified range.
### Syntax
```
$urandom_range(max, min)
$urandom_range(max)
```
### Example
```
module test;
  integer num1, num2, num3;

  initial
    repeat(20) begin
      #2 num1 = $urandom_range(35, 20);   // Random number between 20 and 35
         num2 = $urandom_range(9);       // Random number between 0 and 9
         num3 = $urandom_range(10, 15);  // Random number between 10 and 15

      $display("# num1=%0d num2=%0d num3=%0d", num1, num2, num3);
    end
endmodule
```
```
# num1=27 num2=8 num3=10
# num1=32 num2=0 num3=11
# num1=26 num2=0 num3=14
# num1=29 num2=0 num3=13
# num1=21 num2=6 num3=12
# num1=25 num2=4 num3=10
# num1=20 num2=7 num3=12
# num1=23 num2=2 num3=12
# num1=33 num2=2 num3=13
# num1=22 num2=1 num3=11
# num1=34 num2=8 num3=14
# num1=24 num2=2 num3=15
```




   
