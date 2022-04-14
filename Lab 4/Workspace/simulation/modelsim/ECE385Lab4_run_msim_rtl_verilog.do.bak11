transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/Synchronizers.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/HexDriver.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/9_bit_adder.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/ADDER9.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/Reg.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/Control.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/Multiplier.sv}

vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 4/Workspace/Files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 4/Workspace/Files/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 600 ns
