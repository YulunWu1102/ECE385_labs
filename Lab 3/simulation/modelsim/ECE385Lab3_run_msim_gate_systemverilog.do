transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {ECE385Lab3.svo}

vlog -sv -work work +incdir+D:/UIUC/2022\ Spring/ECE\ 385/Labs/Lab\ 3/Lab\ 3\ files {D:/UIUC/2022 Spring/ECE 385/Labs/Lab 3/Lab 3 files/testbench.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 200 ns
