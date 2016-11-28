transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/virtualgod/Altera/RISC2/dataHazard.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/finalComponents.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/regRead.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/execute.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/memPackage.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/datapathComponents.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/regWrite.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/memAccess.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/fetch.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/decode.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/controlHazard.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/flipFlop.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/dataRegister.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/instrMemory.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/alu.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/PE.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/dataMemory.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/Comparator.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/DataPath_RISC2.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/regFile.vhd}
vcom -93 -work work {/home/virtualgod/Altera/RISC2/RISC2.vhd}

vcom -93 -work work {/home/virtualgod/Altera/RISC2/testbench_full.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  Testbench_full

add wave *
view structure
view signals
run -all
