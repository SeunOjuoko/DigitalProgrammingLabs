module LabB (A,B,W,X,Y,Z);
	input A,B;
	output W,X,Y,Z;
	
	reg W,X,Y,Z;
	
	always @ (A,B)
	begin
	
		if((A==0)&(B==0))
		begin
			W=0;
			X=0;
			Y=0;
			Z=0;	
		end
	
		else if((A==0)&(B==1))
		begin
			W=0;
			X=0;
			Y=1;
			Z=1;	
		end
		
		else if((A==1)&(B==0))
		begin
			W=1;
			X=1;
			Y=0;
			Z=0;	
		end
		
		else if((A==1)&(B==1))
		begin
			W=1;
			X=0;
			Y=0;
			Z=1;	
		end
	end
endmodule
