module IR(
	CLK_50M,
	rst_n,
	IRDA_RX,
	DATA
);

input CLK_50M;
input rst_n;
input IRDA_RX;
output [31:0]DATA;

reg [31:0]DATA;

reg [1:0]state;
reg [1:0]next_state;

wire pos_IR;
wire neg_IR;
reg [31:0]counter;
reg [31:0]counter_temp;
reg [31:0]data_temp;
reg in_range;
reg [4:0]data_count;
wire logic1;
wire logic0;


parameter idle=0;
parameter leader_check=1;
parameter receive_data=2;
parameter data_latch=3;
parameter leader_down=540000;
parameter leader_up=810000; 
parameter logic1_down=90000;//112500-22500
parameter logic1_up=135000;
parameter logic0_down=44800;//56000-11200
parameter logic0_up=67200;

assign leader_in_range = leader_down < counter_temp && counter_temp < leader_up;
assign logic1 = logic1_down < counter_temp && counter_temp <logic1_up;
assign logic0 = logic0_down < counter_temp && counter_temp <logic0_up;
assign logic_in_range  = logic1 || logic0 ;
always@(*)
begin
	if(!rst_n)
		next_state<=leader_check;
	else
	begin
		case(state)
			idle:begin
					next_state <= (!IRDA_RX) ? leader_check : idle;
					end
			leader_check:begin
								next_state <= (leader_in_range) ? receive_data : idle;
								end
			receive_data:begin
								/*next_state <= (data_count==31) ? data_latch : 
												  (!logic_in_range) ? idle :
												  (!IRDA_RX) ? receive_data :
												  receive_data;*/
								if(data_count==31)
									next_state<=data_latch;
								else if(!logic_in_range)
									next_state<=idle;
								else
									next_state<=receive_data;
								end
			data_latch:begin
								next_state <= idle;
							end
		endcase
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		state<=idle;
	end
	else
	begin
		if(state == data_latch)
		begin
			state<=next_state;
		end
		else if(state == idle)
		begin
			state<=next_state;
		end
		else if (state == leader_check)
		begin
			if(!neg_IR)
				state<=next_state;
			else
				state<=state;
		end
		else if(state == receive_data)
		begin
			if(!neg_IR)
				state<=next_state;
			else
				state<=state;
		end
	end
end

edge_detect edge1(
   .clk(CLK_50M),
   .rst(rst_n),
   .data_in(IRDA_RX),
   .pos_edge(neg_IR),
   .neg_edge(pos_IR)	
);

always@(posedge CLK_50M or negedge rst_n)
begin	
	if(!rst_n)
	begin
		counter<=31'b0;
		counter_temp<=0;
	end
	else
	begin
		if(state != idle && neg_IR)
		begin
			counter<=counter+1;
			counter_temp<=counter;
		end
		else
		begin
			counter<=0;
			counter_temp<=counter_temp;
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		data_count<=0;
	else
	begin
		if(state==receive_data)
		begin
			if(!neg_IR)
				data_count<=data_count+1;
			else
				data_count<=data_count;
		end
		else
			data_count<=0;
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		data_temp<=0;
	end
	else
	begin
		if(state == receive_data)
		begin
			if(!neg_IR)
			begin
				if(0<=data_count && data_count<=7)
				begin
					if(logic1)
						data_temp[24+data_count]<=1'b1;
					else if (logic0)
						data_temp[24+data_count]<=1'b0;
					else
						data_temp<=0;
				end
				else if(8<=data_count && data_count<=15)
				begin
					if(logic1)
						data_temp[8+data_count]<=1'b1;
					else if (logic0)
						data_temp[8+data_count]<=1'b0;
					else
						data_temp<=0;
				end
				else if(16<=data_count && data_count<=23)
				begin
					if(logic1)
						data_temp[data_count-8]<=1'b1;
					else if (logic0)
						data_temp[data_count-8]<=1'b0;
					else
						data_temp<=0;
				end
				else if(24<=data_count && data_count<=31)
				begin
					if(logic1)
						data_temp[data_count-24]<=1'b1;
					else if (logic0)
						data_temp[data_count-24]<=1'b0;
					else
						data_temp<=0;
				end
			end
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		DATA<=0;
	else
	begin
		if(state == data_latch)
			DATA<=data_temp;
		else
			DATA<=DATA;
	end
end

endmodule
