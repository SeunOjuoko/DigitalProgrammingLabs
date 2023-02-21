module Lab2 (clock,A,B,Select,Numout,add_result, sub_result, mul_result, div_result,min_result, max_result,
ave_result, all_on_result); // lab2.txt on vision
	input [3:0] A;
	input [3:0] B; //A and B are the two 4-bit inputs
	input [2:0] Select; //Select is a 3-bit input, used to select one of 8 functions
	input clock;
	
	output [7:0] Numout; //Numout is the 8-bit result that is sent to the output pins
	output [7:0] add_result, sub_result, mul_result, div_result;
	output [7:0] min_result, max_result, ave_result, all_on_result;
	
	reg [7:0] Numout; //Numout defined in an always block, so needs declared as register
	
	reg [7:0] add_result, sub_result, mul_result, div_result;
	reg [7:0] min_result, max_result, ave_result, all_on_result;
					//these variables are internal circuit nodes
	always @ (A,B)
	begin //beginning of always block, where signals depend on values of A and B
		add_result = A + B;
		sub_result = A - B;
		mul_result = A * B;
		div_result = A / B;
		min_result = (A < B) ? A:B;
		max_result = (A > B) ? A:B;
		ave_result = (A+B)/2;
		all_on_result = 255;
		
							// Simple calculation of all internal variables
							// all internal variables calculated simulatneously
		//*******************************************************************
		//ADD EXTRA CODE HERE TO CALCULATE:
		// min_result, max_result, ave_result, all_on_result
		//*******************************************************************
	end
	
	always @ (Select, add_result, sub_result, mul_result, div_result, min_result, max_result, ave_result,all_on_result)
	
	begin
		case (Select)
			3'b000: Numout = add_result;
			3'b001: Numout = sub_result;
			3'b010: Numout = mul_result;
			3'b011: Numout = div_result;
			3'b100: Numout = min_result;
			3'b101: Numout = max_result;
			3'b110: Numout = ave_result;
			3'b111: Numout = all_on_result;
			//******************************************************************
			//ADD EXTRA CODE TO PASS min_result, max_result, ave_result, all_on_result
			//TO NUMOUT BASED ON THE OTHER POSSIBLE VALUES OF 'Select'
			//******************************************************************
		endcase
					//case statement based on value of 'Select' input
					//if (select==0) numout=add_result, etc
	end
endmodule
