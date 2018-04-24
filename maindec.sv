module maindec(input logic [5:0] op,
                input zero, clk, reset,
                output logic memtoreg, memwrite,
                output logic branch, alusrcA,
                output logic [1:0] alusrcB,
                output logic regdst, regwrite, iord,
                output logic jump, pcwrite, irwrite,
                output logic [1:0] aluop,
                output logic pcsrc);

  logic [14:0] controls;
  assign {regwrite, regdst, alusrcA, alusrcB, branch, memwrite, memtoreg, iord, jump, pcwrite, irwrite, aluop, pcsrc} = controls;

  typedef enum logic [3:0] {FETCH, DECODE, MEMADR, MEMREAD, MEMWRITEBACK, MEMWRITE, EXECUTE, ALUWRITEBACK, BRANCH, ADDIEX} statetype;
  statetype [3:0] state, nextstate;
  
  always_ff @ (posedge clk, posedge reset)
    if(reset) state <= FETCH;
    else state <= nextstate;
  
  always_comb
    case(state)
      FETCH: nextstate <= DECODE;
      DECODE:
          case(op)
            6'b100011: nextstate <= MEMADR;
            6'b101011: nextstate <= MEMADR;
            6'b000000: nextstate <= EXECUTE;
            6'b000100: nextstate <= BRANCH;
            6'b001000: nextstate <= ADDIEX;
            default: nextstate <= FETCH;
        endcase
            
        //if(op === 6'b100011 || op === 6'b101011) nextstate <= MEMADR;
       // else if (op === 6'b000000) nextstate <= EXECUTE;
       // else if (op === 6'b000100) nextstate <= BRANCH;
       // else begin
        //  nextstate <= FETCH;
        //  $display("Here");
       // end
      MEMADR: 
        if (op === 6'b100011) nextstate <= MEMREAD;
        else if (op === 6'b101011) nextstate <= MEMWRITE;
      MEMREAD: nextstate <= MEMWRITEBACK;
      MEMWRITE: nextstate <= FETCH;
      MEMWRITEBACK: nextstate <= FETCH;
      EXECUTE: nextstate <= ALUWRITEBACK;
      ALUWRITEBACK: nextstate <= FETCH;
      BRANCH: nextstate <= FETCH;
      default: nextstate <= FETCH;
    endcase
    
    always_comb
      case(state)
        FETCH:          controls <= 15'b000010000011000;
        DECODE:         controls <= 15'b000110000000000;
        MEMADR:         controls <= 15'b001100000000000;
        MEMREAD:        controls <= 15'b000000001000000;
        MEMWRITE:       controls <= 15'b000000101000000;
        MEMWRITEBACK:   controls <= 15'b100000010000000;
        EXECUTE:        controls <= 15'b001000000000100;
        ALUWRITEBACK:   controls <= 15'b110000000000000;
        BRANCH:         controls <= 15'b001001000000001;
        ADDIEX:         controls <= 15'b001100000000000;
      endcase
  
  /*always_comb
    case(op)
      6'b000000: controls <= 14'b110000010; // RTYPE
      6'b100011: controls <= 14'b101001000; // LW
      6'b101011: controls <= 14'b001010000; // SW
      6'b000100: controls <= 14'b000100001; // BEQ
      6'b001000: controls <= 14'b101000000; // ADDI
      6'b000010: controls <= 14'b000000100; // J
      default: controls <= 14'bxxxxxxxxx; // illegal op
    endcase
      */
      
endmodule
