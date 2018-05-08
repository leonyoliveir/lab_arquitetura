module maindec(input logic [5:0] op,
                input zero, clk, reset,
                output logic memtoreg, memwrite,
                output logic branch, alusrcA,
                output logic [1:0] alusrcB,
                output logic regdst, regwrite, iord,
                output logic jump, pcwrite, irwrite,
                output logic [1:0] aluop, pcsrc);

  logic [15:0] controls;
  assign {regwrite, regdst, alusrcA, alusrcB, branch, memwrite, memtoreg, iord, jump, pcwrite, irwrite, aluop, pcsrc} = controls;

  typedef enum logic [3:0] {FETCH, DECODE, MEMADR, MEMREAD, MEMWRITEBACK, MEMWRITE, EXECUTE, ALUWRITEBACK, BRANCH, ADDIEX, ADDIWB, JUMP} statetype;
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
			6'b000010: nextstate <= JUMP;
            default: nextstate <= FETCH;
        endcase
            
      MEMADR: 
        if (op === 6'b100011) nextstate <= MEMREAD;
        else if (op === 6'b101011) nextstate <= MEMWRITE;
      MEMREAD: nextstate <= MEMWRITEBACK;
      MEMWRITE: nextstate <= FETCH;
      MEMWRITEBACK: nextstate <= FETCH;
      EXECUTE: nextstate <= ALUWRITEBACK;
      ALUWRITEBACK: nextstate <= FETCH;
      BRANCH: nextstate <= FETCH;
	  ADDIEX: nextstate <= ADDIWB;
	  ADDIWB: nextstate <= FETCH;
	  JUMP: nextstate <= FETCH;
      default: nextstate <= FETCH;
    endcase
    
    always_comb
      case(state)
        FETCH:          controls <= 16'b0000100000110000;
        DECODE:         controls <= 16'b0001100000000000;
        MEMADR:         controls <= 16'b0011000000000000;
        MEMREAD:        controls <= 16'b0000000010000000;
        MEMWRITE:       controls <= 16'b0000001010000000;
        MEMWRITEBACK:   controls <= 16'b1000000100000000;
        EXECUTE:        controls <= 16'b0010000000001000;
        ALUWRITEBACK:   controls <= 16'b1100000000000000;
        BRANCH:         controls <= 16'b0010010000000001;
        ADDIEX:         controls <= 16'b0011000000000000;
		ADDIWB:			controls <= 16'b1000000000000000;
		JUMP: 			controls <= 16'b0000000000100010;
      endcase
      
endmodule
