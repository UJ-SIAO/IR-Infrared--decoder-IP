transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/edge_detect.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/Lab3.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/init.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/select.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/switch.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/WR_Oper.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/Show.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/Lab3 {D:/QuartusCode/Lab3/IR.v}

