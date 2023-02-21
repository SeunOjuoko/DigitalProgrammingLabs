module lab1a (A,X,Y,Z);
	input A;
	output X,Y,Z;
	
	reg X,Y,Z;
	
	always @ (A)
	begin //start of always block

		if (A==0)
		begin
			X=0;
			Y=1;
			Z=0;
		end
		
		else
		begin

			X=1;
			Y=0;
			Z=1;
		end
	end
endmodule