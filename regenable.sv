module reg1 #(parameter WIDTH = 8)
              (input logic clk, reset, en, 
                input logic [WIDTH-1:0] data,
                output logic[WIDTH-1:0] y);
                
  always_ff @(posedge clk)
    if (reset) y <= 0;
    else if(en) y <= data;
      
endmodule

module reg2 #(parameter WIDTH = 8)
              (input logic clk, reset, 
                input logic [WIDTH-1:0] data,
                output logic[WIDTH-1:0] y);
                
  always_ff @(posedge clk)
    if (reset) y <= 0;
    else y <= data;
      
endmodule 