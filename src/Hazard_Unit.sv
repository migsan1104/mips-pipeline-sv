module Hazard_Unit(input logic branch_taken, jump,mem_read, input logic [4:0] IF_ID_rs,IF_ID_rt,ID_EX_rt,output logic [1:0] pc_source, output logic IF_ID_write,stall,pc_write,flush);
always_comb begin
//initialize outputs to avoid latches
	pc_write = 1'b1;
	IF_ID_write = 1'b1; 
	stall = 1'b0;
	flush = 1'b0;
	pc_source = 2'b0;
	if((ID_EX_rt == IF_ID_rt || ID_EX_rt == IF_ID_rs) && mem_read == 1'b1 ) begin
		pc_write = 1'b0;
		IF_ID_write = 1'b0;
		//setting stall to one sets all control signals to zero, the alu does nothing
		stall = 1'b1;
	end
	else begin
	//flush
		if(branch_taken) begin
			flush = 1'b1;
			pc_source = 2'b1;
			end
	end	
	
end
endmodule