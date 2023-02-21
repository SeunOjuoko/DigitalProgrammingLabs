module Lab6(clock, reg_add, RNW, BS, WrA, WrB, ALUop, ALUout, A_out, B_out, Multiplexer_out, Register_out, disp_drv);
	input clock;
	input [2:0] reg_add; //address of the register file
	input [2:0] BS; //select signal of the multiplexer
	input [2:0] ALUop; //signal that indicates the function of the ALU
	input RNW; //rW=1 read the register file while rW=0 write into the register file
	input WrA; //when WrA=1, write to buffer A
	input WrB; // when WrB=1, write value to B buffer
	

	output [7:0] ALUout; //the output of the ALU
	output [7:0] A_out; //buffer A output
	output [7:0] B_out; //buffer B output
	output [7:0] Multiplexer_out; //the multiplexer's output
	output [7:0] Register_out; //register's output
	output [13:0] disp_drv;
	

	Alu Alu1(clock, Multiplexer_out, WrA, WrB, ALUop, A_out, B_out, AlUout);
	Reg Reg1(clock, reg_add, RNW, Multiplexer_out, Register_out);	
	Mux Mux1(clock, Register_out, ALUout, Multiplexer_out, BS);
	bcd bcd1(clock, ALUout, disp_drive);
	display_drv(clk,number,display);
	
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
              if (wrA == 1) A <= BusIn;
              else if (wrB == 1) B <= BusIn;
              AO <= 8'h0;
              end 
         1 :  AO = A + B;
         2 :  AO = A - B;
         3 :  AO = A + 8'h1;
         4 :  AO = A - 8'h1;
         5 :  AO = A & B;
         6 :  AO = A * B;
        default : AO = 8'h0;

 endcase
end 
endmodule

module Reg(clock, mem, RNW, DataIn, DataOut);
input clock, RNW;   // RNW = 1 bit 1 = read  0 = write
input [2:0] mem;    // read address and write address
input [7:0] DataIn;
output[7:0] DataOut;

reg [7:0] R[0:7];    // register file is not reset to zero but filled accordingly
reg [7:0] DataOut;

always @( posedge clock)
   begin          
     if (RNW)
       DataOut <= R[mem];
          else
           R[mem] <= DataIn; 
   end

endmodule

module Mux(clock, RegIn, AluIn, muxOut, sel);
  input clock;
  input [7:0] RegIn, AluIn;
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

module bcd(clk, result, disp_drive);
	input clk;
	input [7:0] result;
	output [13:0] disp_drive;
	
	
	reg [3:0] numb_bcd0,numb_bcd1;
	wire [3:0] n1,n2;
	assign n1 = numb_bcd0;
	assign n2 = numb_bcd1;
	

	display_drv dd1(clk,n1,disp_drive[6:0]);
	display_drv dd2(clk,n2,disp_drive[13:7]);

	always @(posedge clk)
		begin
			numb_bcd0 = result % 4'd10; //units
			numb_bcd1 = (result / 4'd10) % 4'd10; //tens
		end
endmodule

module display_drv(clk,number,display);
	input clk;
	input [3:0] number;
	output [6:0] display;
	reg [6:0] d;
	assign display = ~d; // active low
	// on clock edge update display
	always @(posedge clk )
		begin
	if (number < 10)
			begin
				case (number)
					4'd0 : d <= 7'b0111111; // segments lit
					4'd1 : d <= 7'b0000110;
					4'd2 : d <= 7'b1011011;
					4'd3 : d <= 7'b1001111;
					4'd4 : d <= 7'b1100110;
					4'd5 : d <= 7'b1101101;
					4'd6 : d <= 7'b1111100;
					4'd7 : d <= 7'b0000111;
					4'd8 : d <= 7'b1111111;
					4'd9 : d <= 7'b1100111;
					default : d <= 7'b0000000; // off
				endcase
			end
		else d <= 7'b1110001; // 'F
		end
endmodule
