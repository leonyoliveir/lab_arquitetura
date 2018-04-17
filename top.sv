module top(input logic clk, reset,
            output logic [31:0] writedata, dataadr,
            output logic memwrite);
  logic [31:0] pc, readdata;
  // instantiate processor and memories
  mips mips(clk, reset, pc, memwrite, dataadr, writedata, readdata);
  dmem dmem(clk, memwrite, dataadr, writedata, readdata);
endmodule
