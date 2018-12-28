###########################
# Simple modelsim do file #
###########################

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library
vlib work

# Compile all the Verilog sources in current folder into working library
vlog  FPGAMIPS.v MIPS.v FPGAMIPS_tb.v ALU.v ALUControl.v barrel.v GDataMemory.v InstructionMemory.v MainControl.v MUX.v NextPC.v PC.v RegisterFile.v SignExtender.v  RegisterF.v RegisterD.v RegisterM.v RegisterE.v HazardUnit.v GPIO.v DynamicPredictors.v EPC_Cause.v

# Open testbench module for simulation
vsim -novopt work.FPGAMIPS_tb 

# Add all testbench signals to waveform diagram
add wave sim:/FPGAMIPS_tb/*

# Run simulation
run -all
