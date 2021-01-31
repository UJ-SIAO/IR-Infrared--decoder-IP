module WR_Oper(
	enable,
	rst_n,
	CLK_50M,
	LCD_RS_IN,
	LCD_RW_IN,
	LCD_DATA_IN,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_DATA,
	flag_busy
);
input enable;
input rst_n;
input CLK_50M;
input [7:0]LCD_DATA_IN;
input LCD_RS_IN;
input LCD_RW_IN;
output [7:0]LCD_DATA;
output LCD_RS;
output LCD_RW;
output LCD_EN;
output flag_busy;

reg [7:0]LCD_DATA=8'b0;
reg LCD_RS=1'b0;
reg LCD_RW=1'b0;
reg LCD_EN=1'b0;
//reg [31:0]counter_600ns=32'b1;
reg [31:0]counter_2ms=32'b1;
//reg [31:0]counter_1ms=32'b1;
reg flag_RS_RW=1'b0;
reg flag_EN=1'b0;
reg flag_DATA=1'b0;
reg [1:0]state=1'd0;
reg [1:0]next_state;
reg flag_busy=1'b0;

parameter S100=0;
parameter S010=1;
parameter S001=2;


always@(*)
begin
	if(!rst_n)
	begin
		next_state<=S010;
		flag_DATA<=1'b0;
		flag_EN<=1'b0;
		flag_RS_RW<=1'b0;
	end
	else
	begin
	if(enable)
		case(state)
			S100:	begin
						next_state<=S010;
						flag_RS_RW<=1'b1;
						flag_EN<=1'b0;
						flag_DATA<=1'b0;
					end
			S010: begin
						next_state<=S001;
						flag_RS_RW<=1'b0;
						flag_EN<=1'b1;
						flag_DATA<=1'b0;
					end
			S001:	begin
						next_state<=S100;
						flag_RS_RW<=1'b0;
						flag_EN<=1'b0;
						flag_DATA<=1'b1;
					end
			default:	begin
							next_state<=S100;
							flag_RS_RW<=1'b1;
							flag_EN<=1'b0;
							flag_DATA<=1'b0;								
						end
		endcase
	end
end

/*always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		counter_600ns<=32'd1;
	else
	begin
		if(counter_600ns==32'd30)
		begin
			counter_600ns<=32'b0;
		end
		else
			counter_600ns<=counter_600ns+1'd1;
	end
end*/

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		counter_2ms<=32'd1;
	else
	begin
		if(enable)
		begin
			if(counter_2ms==32'd200000)
			begin
				counter_2ms<=32'b0;
			end
			else
				counter_2ms<=counter_2ms+1'd1;
		end
	end
end

/*always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		counter_1ms<=32'd1;
	else
	begin
		if(flag_EN)
			if(counter_1ms==32'd50000)
			begin
				counter_1ms<=32'b0;
			end
			else
				counter_1ms<=counter_1ms+1'd1;
		else
			counter_1ms<=1'd1;
	end
end*/

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		state<=S100;
	else
	if(enable)
		if(counter_2ms==32'd200000)
			state<=next_state;
end

always@(posedge CLK_50M or negedge rst_n )
begin
	if(!rst_n)
	begin	
		LCD_RS<=1'b0;
		LCD_RW<=1'b0;
	end
	else
	begin
		if(enable)
		begin
			if(flag_RS_RW)
			begin
				LCD_RS<=LCD_RS_IN;
				LCD_RW<=LCD_RW_IN;
			end
			else
			begin
				LCD_RS<=LCD_RS;
				LCD_RW<=LCD_RW;
			end
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		LCD_EN<=1'b0;
	else
	begin
		if(enable)
		begin
			if(flag_EN)
			begin
				if(LCD_DATA!=0)begin
					if(counter_2ms<32'd80000 && counter_2ms>32'd6)
						LCD_EN<=1'b1;
					else
						LCD_EN<=1'b0;
				end
				else
					LCD_EN<=1'b0;
			end
			else
				LCD_EN<=1'b0;
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		LCD_DATA<=8'b0;
	else
	begin
		if(enable)
		begin
			if(flag_EN)
			begin
				if(32'd5<counter_2ms)
					LCD_DATA<=LCD_DATA_IN;
				else
					LCD_DATA<=LCD_DATA;
			end
			else
				LCD_DATA<=LCD_DATA;
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		flag_busy<=1'b0;
	else
	begin
		if(enable)
		begin
			if(flag_EN)
				if(counter_2ms==32'd200000)
					flag_busy<=1'b0;
				else
					flag_busy<=flag_busy;
			else if(flag_RS_RW)
				flag_busy<=1'b1;
			else
				flag_busy<=flag_busy;
		end
		else
			flag_busy<=1'b1;
	end
	
end
endmodule
