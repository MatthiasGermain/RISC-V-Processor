transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/decodeur.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/ALU.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/DMEM.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/PC.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/REG.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/IMEM_FILE.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/RISC_V_Processor.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/Imm_ext.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/mux2to1.vhd}
vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/LM.vhd}

vcom -93 -work work {C:/Users/germa/OneDrive/Documents/Documents/TELECOM NANCY/3A/CDSP/TP/RISC-V-Processor/Rstruction/ARCHI/RISC_V_Processor_simplified_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L cyclonev_hssi -L rtl_work -L work -voptargs="+acc"  RISC_V_Processor_simplified_tb

add wave *
view structure
view signals
run 500 ns
