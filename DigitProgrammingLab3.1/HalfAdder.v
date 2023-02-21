module HalfAdder(A,B,Sum,Cout);

	input A, B;
	output Sum, Cout;
	and and1(Cout,A,B);
	xor xor1(Sum,A,B);
	
endmodule