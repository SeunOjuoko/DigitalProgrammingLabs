module Lab5(clock, wA, rA, rW, BS, WrA, WrB, ALUop, out, A_out, B_out, Multiplexer_out, Register_out);
	input clock;
	input [2:0] wA; //write address of the register file
	input [2:0] rA; //read address of the register file
	input [2:0] BS; //select signal of the multiplexer
	input [2:0] ALUop; //signal that indicates the function of the ALU
	input rW; //rW=0 read the register file while rW=1 write into the register file
	input WrA; //when WrA=1, write to buffer A
	input	WrB; // when WrB=1, write value to B buffer
	
	output [7:0] out; //the output of the ALU that is an input to the multiplexer
	output [7:0] A_out; //buffer A output
	output [7:0] B_out; //buffer B output
	output [7:0] Multiplexer_out; //the multiplexer's output that is an input to the register file and the two buffers
	output [7:0] Register_out; //the register file's output which is also an input to the multiplexer
	
	/*Using wires to transfer the information between the modules*/
	wire [7:0] ALU_Out; 
	wire [7:0] Areg;
	wire [7:0] Breg;
	wire [7:0] Mult_Out; 
	wire [7:0] Reg_Out; 
	
	/*Assigning the wires to the outputs declared before*/
	assign out = ALU_Out;
	assign A_out = Areg;
	assign B_out = Breg;
	assign Multiplexer_out = Mult_Out;
	assign Register_out = Reg_Out;
	
	/*instantiate the modules using ordered connection so that each parenthesis must have the variables (inputs and wires of this module) in order to match the module declaration*/
	Alu Alu1(clock, Mult_Out, WrA, WrB, ALUop, Areg, Breg, ALU_Out);
	Reg Reg1(clock, rA, wA, rW, Mult_Out, Reg_Out);	
	Mux Mux1(clock, Reg_Out, ALU_Out, Mult_Out, BS);
endmodule

module Alu(clock, BusIn, wrA, wrB, F, Abuf,Bbuf,AluOut);
input clock, wrA, wrB;
input [7:0] BusIn;
input [2:0] F;  // function control
// 0	nop
// 1	A+B
// 2	A-B
// 3	A+1
// 4	A-1  not implemented
// 5	A & B  ditto
// 6	A* B   ditto
output[7:0] AluOut, Abuf, Bbuf;
reg[7:0] A, B,AO;

assign AluOut = AO;
assign Abuf = A;
assign Bbuf = B;

always @ ( posedge clock)
begin
  case (F)
         0:   begin
              if (wrA ==0) A <= BusIn;
              else if (wrB == 0) B <= BusIn;
              AO <= 8'h0;
              end 
         1:   AO = A + B;
         2:   AO = A - B;
         3 :  AO = A + 8'h1;
         4 :  AO = A - 8'h1;
         5:   AO = A & B;
         6 :  AO = A * B;
        default : AO = 8'h0;

 endcase
end 
endmodule


module Reg(clock, RA, WA, RNW, DataIn, DataOut);
input clock, RNW;   // RNW = 1 bit 1 = read  0 = write
input [2:0] RA, WA;    // read address and write address
input [7:0] DataIn;
output[7:0] DataOut;

reg [7:0] R[0:7];    // register file is not reset to zero but filled accordingly
reg [7:0] DataOut;

always @( posedge clock)
   begin          
     if (RNW)
       DataOut <= R[RA];
          else
           R[WA] <= DataIn;
   end

endmodule

module Mux(clock, RegIn, AluIn, muxOut, sel);
  input clock;
  input [ 7:0] RegIn, AluIn;
  output [7:0] muxOut;
  input [2:0]  sel;    // select line
  reg [7:0] muxOut;

  always @ ( posedge clock)
      begin
       case (sel)
               0:  muxOut = 8'd0;
               1:  muxOut = 8'd1;
               2:  muxOut = 8'd2;
               3:  muxOut = 8'd4;
               4:  muxOut = RegIn;
               5:  muxOut = AluIn;
             default : muxOut = 7'd0;

     endcase
      end
endmodule
