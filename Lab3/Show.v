module Show(
	CLK_50M,
	rst_n,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_DATA,
	DATA,
	Enable	
);


input CLK_50M;
input rst_n;
input Enable;
input [31:0]DATA;
output LCD_RS;
output LCD_RW;
output LCD_EN;
output [7:0]LCD_DATA;


reg LCD_RS_IN;
reg LCD_RW_IN;
reg LCD_EN_IN;
reg [7:0]LCD_DATA_IN;

wire flag_busy;
reg [31:0]counter_busy;
reg RS;
reg RW;
reg [7:0]Ins;


reg [4:0]state=0;
reg [4:0]next_state=1;

wire [7:0]Ins8;
wire [7:0]Ins7;
wire [7:0]Ins6;
wire [7:0]Ins5;
wire [7:0]Ins4;
wire [7:0]Ins3;
wire [7:0]Ins2;
wire [7:0]Ins1;

parameter	LCD_H = 8'b01001000;
parameter	LCD_z = 8'b01111010;
parameter	LCD_E = 8'b01000101;
parameter	S0_adr=0;
parameter	S0=1;
parameter	S1=2;
parameter	S2=3;
parameter	S3=4;
parameter	S4=5;
parameter	S5=6;
parameter	S6=7;
parameter	S7=8;
parameter	S8=9;
parameter	S9=10;
parameter	S10_adr=11;
parameter	S10=12;
parameter	S11=13;
parameter	S12=14;
parameter	S13=15;
parameter	S14=16;
parameter	S15=17;
parameter	S16=18;
parameter	S17=19;
parameter	S18=20;
parameter	S19=21;
parameter	S20=22;

always@(*)
begin
	if(!rst_n)
		next_state<=S0_adr;
	else
	begin
		if(Enable)
		begin
			case(state)
				S0_adr:begin
							next_state<=S0;
							RS<=0;
							RW<=0;
							Ins<=8'b10000000;
						end
				S0:begin
						next_state<=S1;
						RS<=1;
						RW<=0;
						Ins<=8'h49;
					end
				S1:begin
						next_state<=S2;
						RS<=1;
						RW<=0;
						Ins<=8'h52;
					end
				S2:begin
						next_state<=S3;
						RS<=1;
						RW<=0;
						Ins<=8'h20;
					end
				S3:begin
						next_state<=S4;
						RS<=1;
						RW<=0;
						Ins<=8'h44;
					end
				S4:begin
						next_state<=S5;
						RS<=1;
						RW<=0;
						Ins<=8'h45;
					end
				S5:begin
						next_state<=S6;
						RS<=1;
						RW<=0;
						Ins<=8'h43;
					end
				S6:begin
						next_state<=S7;
						RS<=1;
						RW<=0;
						Ins<=8'h4F;
					end
				S7:begin
						next_state<=S8;
						RS<=1;
						RW<=0;
						Ins<=8'h44;
					end
				S8:begin
						next_state<=S9;
						RS<=1;
						RW<=0;
						Ins<=8'h45;
					end
				S9:begin
						next_state<=S10_adr;
						RS<=1;
						RW<=0;
						Ins<=8'h52;
					end
				S10_adr:begin
						next_state<=S10;
						RS<=0;
						RW<=0;
						Ins<=8'b11000000;
					end
				S10:begin
						next_state<=S11;
						RS<=1;
						RW<=0;
						Ins<=Ins8;
					end
				S11:begin
						next_state<=S12;
						RS<=1;
						RW<=0;
						Ins<=Ins7;
					end
				S12:begin
						next_state<=S13;
						RS<=1;
						RW<=0;
						Ins<=8'h2d;
					end
				S13:begin
						next_state<=S14;
						RS<=1;
						RW<=0;
						Ins<=Ins6;
					end
				S14:begin
						next_state<=S15;
						RS<=1;
						RW<=0;
						Ins<=Ins5;
					end
				S15:begin
						next_state<=S16;
						RS<=1;
						RW<=0;
						Ins<=8'h2d;
					end
				S16:begin
						next_state<=S17;
						RS<=1;
						RW<=0;
						Ins<=Ins4;
					end
				S17:begin
						next_state<=S18;
						RS<=1;
						RW<=0;
						Ins<=Ins3;
					end
				S18:begin
						next_state<=S19;
						RS<=1;
						RW<=0;
						Ins<=8'h2d;
					end
				S19:begin
						next_state<=S20;
						RS<=1;
						RW<=0;
						Ins<=Ins2;
					end
				S20:begin
						next_state<=S10_adr;
						RS<=1;
						RW<=0;
						Ins<=Ins1;
					end
				default:begin
								next_state<=S10_adr;
								RS<=1;
								RW<=0;
								Ins<=8'h30;
							end
			endcase
		end
	end
end


always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
		state<=S0_adr;
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

select slect_8(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[31:28]),
	.select_out(Ins8)	
);
select slect_7(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[27:24]),
	.select_out(Ins7)	
);
select slect_6(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[23:20]),
	.select_out(Ins6)	
);
select slect_5(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[19:16]),
	.select_out(Ins5)	
);
select slect_4(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[15:12]),
	.select_out(Ins4)	
);
select slect_3(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[11:8]),
	.select_out(Ins3)	
);
select slect_2(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[7:4]),
	.select_out(Ins2)	
);
select slect_1(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.select_in(DATA[3:0]),
	.select_out(Ins1)	
);


WR_Oper	WR_Oper2(
	.enable(Enable),
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