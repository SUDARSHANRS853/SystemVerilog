class prime;
  rand int a[];

  constraint c1 { a.size() == 10; }

  // Just randomize any values; we'll filter them in post_randomize()
  function void post_randomize();
    int i = 0;
    int n;
    for(int i=0; i<a.size ; i++) begin
      do begin
        n = $urandom_range(2, 100); // Random number between 2 and 100  ...it continuously generate the numbers until the prime number comes
      end while (!is_prime(n));
      a[i] = n;
    end
  endfunction

  // function to check prime 
  function bit is_prime(int N);
    if (N <= 1) return 0;
    for (int j = 2; j*j <= N; j++) begin
      if (N % j == 0)
        return 0;
    end
    return 1;
  endfunction

endclass


module tb;
  prime p;

  initial begin
    p = new();
    assert(p.randomize());
    $display("Prime numbers: %p", p.a);
  end

endmodule

//Output
Prime numbers: '{19, 61, 71, 53, 19, 7, 23, 23, 67, 37}
