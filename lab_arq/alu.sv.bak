module alu #(parameter X = 32)(input logic [2:0] func, logic [X-1:0] A, B, 
           output logic [X-1:0] S, logic Z, N, O, EG, LT, GT);
       
  always_comb
    case(func)
      3'b000: S = A;
      3'b001: S = A + B;
      3'b010: S = A - B;
      3'b011: S = A & B;
      3'b100: S = A + 1;
      3'b101: S = ~A;
      3'b110: S = A ^ B;
      3'b111: S = (A === B);
    endcase

  assign Z = (S === 0);
  assign N = (S < 0);
  assign O = 1'b0;
  assign EG = (A >= B);
  assign GT = (A > B);
  assign LT = (A < B); 
  
endmodule

module testbench_wwith_test_vector ();
  logic clk, reset;
  logic[3:0] a, b;
  logic[2:0] func;
  logic[3:0] sexpected, s;
  logic z, n, o, eg, lt, gt, zexpected, nexpected, oexpected, egexpected, ltexpected, gtexpected;
  logic[31:0] vectornum, errors;
  logic[20:0] testvectors [10000:0];
  
  // instantiate device under test
  alu #(4) dut (func, a, b, s, z, n, o, eg, lt, gt);
  
  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb ("alutest.tv", testvectors);
      vectornum = 0; errors = 0;
      reset = 1; #20; reset = 0;
    end
  
  // apply test vectors on rising edge of clk
  always @ (posedge clk)
  begin
    #1; {func, a, b, sexpected, zexpected, nexpected, oexpected, egexpected, ltexpected, gtexpected} = testvectors[vectornum];
  end

  // check results on falling edge of clk
  always @ (negedge clk)
    if (~reset) begin // skip during reset
      if (s !== sexpected || z !== zexpected || n !== nexpected
      || o !== oexpected || eg !== egexpected || lt !== ltexpected
      || gt !== gtexpected) begin
        $display ("Error: inputs = %b %b %b", func, a, b);
        $display ("outputs = %b (%b expected)", s, sexpected);
        $display ("flags  = %b, %b, %b, %b, %b, %b (%b, %b, %b, %b, %b, %b expected)", z, n, o, eg, lt, gt,
                  zexpected, nexpected, oexpected, egexpected, ltexpected, gtexpected);
        errors = errors + 1;
      end
      
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 21'bx) begin
        $display ("%d tests completed with %d errors", vectornum, errors);
        $finish;
      end
    end
endmodule