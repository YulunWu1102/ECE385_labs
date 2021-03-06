transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/router.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/ripple_adder.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/reg_17.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/HexDriver.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/control.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/basic_CPA.sv}
vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/adder2.sv}

vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 500 ns
