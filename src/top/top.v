/*
 * Copyright (C) 2019-2020 Yizhou Shan. All rights reserved.
 */

`timescale 1 ps / 1 ps

module top (
	input sysclk_125_clk_n,
	input sysclk_125_clk_p
);

	wire sys_clk;

	clock clock (
		.clk_out1_0(sys_clk),
		.sysclk_125_clk_n(sysclk_125_clk_n),
		.sysclk_125_clk_p(sysclk_125_clk_p)
	);
    
	reg [31:0] local_counter;
	always @(posedge sys_clk) begin
		local_counter <= local_counter + 1;
	end

	wire lp_0;
	pr_loopback inst_rp_0 (
		.clock (sys_clk),
		.in (lp_0),
		.out (lp_0)
	);

	wire lp_1;
	pr_loopback inst_rp_1 (
		.clock (sys_clk),
		.in (lp_1),
		.out (lp_1)
	);

	wire lp_2;
	pr_loopback inst_rp_2 (
		.clock (sys_clk),
		.in (lp_2),
		.out (lp_2)
	);

	wire lp_3;
	pr_loopback inst_rp_3 (
		.clock (sys_clk),
		.in (lp_3),
		.out (lp_3)
	);

endmodule

/*
 * Black-box definition
 */
module pr_loopback(
	input clock,
	input [31:0] in,
	output reg [31:0] out
);
endmodule
