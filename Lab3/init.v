module init(
	CLK_50M,
	LCD_DATA,
	LCD_EN,
	LCD_RW,
	LCD_RS,
	rst_n,
	Enable,
	flag_complete
);

input rst_n;
input CLK_50M;
input Enable;
output LCD_EN;
output LCD_RS;
output LCD_RW;
output [7:0]LCD_DATA;
output flag_complete;

reg [31:0]counter=32'd0;
reg [31:0]counter_busy=32'd0;
reg thirty_ms;
reg [7:0]Ins;
reg flag_complete;
reg LCD_RS_IN;
reg LCD_RW_IN;
reg [7:0]LCD_DATA_IN;


reg [3:0]state;
reg [3:0]next_state;
reg RS=0;
reg RW=0;
//parameter Ins5=8'b00110000;
parameter Ins0=8'b00111000;
parameter Ins1=8'b00001000;
parameter Ins2=8'b00000001;
parameter Ins3=8'b00000110;
parameter Ins4=8'b00001110;
parameter S0=0;
parameter S1=1;
parameter S2=2;
parameter S3=3;
parameter S4=4;
parameter S5=5;
parameter S6=6;
parameter S7=7;
parameter S8=8;
parameter S9=9;




always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		counter<=31'd1;
	else	
	begin
		if(Enable)
		begin
				if(counter==32'd1500000)
					counter<=32'b0;
				else
					counter<=counter+1'd1;
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		thirty_ms<=1'b0;
	else	
	begin
		if(Enable)
		begin
			if(counter==31'd1500000)
				thirty_ms<=1'b1;
		end
	end	
end

WR_Oper	WR_Oper1(
	.enable(thirty_ms),
	.rst_n(rst_n),
	.CLK_50M(CLK_50M),
	.LCD_RS_IN(LCD_RS_IN),
	.LCD_RW_IN(LCD_RW_IN),
	.LCD_DATA_IN(LCD_DATA_IN),
	.LCD_RS(LCD_RS),
	.LCD_RW(LCD_RW),
	.LCD_EN(LCD_EN),
	.LCD_DATA(LCD_DATA),
	.flag_busy(flag_busy)
	);

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		counter_busy<=32'd0;
	else
	begin
		if(Enable)
		begin
			if(!flag_busy)
				counter_busy<=counter_busy+1;
			else
				counter_busy<=31'd0;
		end
	end	
end

always@(*)
begin
	if(!rst_n)
	begin
		next_state<=S4;
		Ins<=Ins0;
		RS<=0;
		RW<=0;
		flag_complete<=1'b0;
	end
	else
	begin
		if(Enable)
		begin
			case(state)
				/*S0:begin
						next_state<=S1;
						Ins<=Ins5;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;
					end				
				S1:begin
						next_state<=S2;
						Ins<=Ins5;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;
					end
				S2:begin	
						next_state<=S3;
						Ins<=Ins5;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;	
					end*/
				S3:begin
						next_state<=S4;
						Ins<=8'b00111000;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;
					end
				S4:begin
						next_state<=S5;
						Ins<=8'b00001000;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;
					end
				S5:begin
						next_state<=S6;
						Ins<=8'b00000001;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;
					end
				S6:begin
						next_state<=S7;
						Ins<=8'b00000110;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;
					end
				S7:begin
						next_state<=S8;
						Ins<=8'b00001110;
						RS<=0;
						RW<=0;
						flag_complete<=1'b0;
					end
				S8:begin
						next_state<=S9;
						Ins<=0;
						RS<=0;
						RW<=0;
						flag_complete=(counter==32'd1329438)?1:0;
					end
					
					
				default:	begin
								next_state<=S8;
								Ins<=0;
							end
			endcase
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		state<=S3;
	else
	begin
		if(Enable)
		begin
			if(counter_busy==32'd50200)
			begin
				state<=next_state;
			end
		end
	end
end

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		LCD_RS_IN<=1'b0;
		LCD_RW_IN<=1'b0;
		LCD_DATA_IN<=8'b0;
	end
	else
	begin
		if(Enable)
		begin
			if(!flag_busy)
			begin
				if(counter_busy==32'd50000)
				begin
					LCD_RS_IN<=RS;
					LCD_RW_IN<=RW;
					LCD_DATA_IN<=Ins;
				end
				else
				begin
					LCD_RS_IN<=LCD_RS_IN;
					LCD_RW_IN<=LCD_RW_IN;
					LCD_DATA_IN<=LCD_DATA_IN;				
				end
			end
			else
			begin
				LCD_RS_IN<=LCD_RS_IN;
				LCD_RW_IN<=LCD_RW_IN;
				LCD_DATA_IN<=LCD_DATA_IN;
			end
		end
	end	
end
endmodule


		
