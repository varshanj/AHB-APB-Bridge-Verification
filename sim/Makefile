
RTL= ../rtl/*
work= work #library name
SVTB1= ../top/bridge_test_top.sv
INC = +incdir+../test +incdir+../top +incdir+../AHB +incdir+../APB +define+WRAPPING_INCR
SVTB2 = ../top/bridge_pkg.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH= -c -do  " log -r /* ;coverage save -onexit mem_cov;run -all; exit"
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"
VSIMBATCH5= -c -do  " log -r /* ;coverage save -onexit mem_cov5;run -all; exit"
VSIMBATCH6= -c -do  " log -r /* ;coverage save -onexit mem_cov6;run -all; exit"


help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                                                          "                       										
	@echo "! clean      =>  clean the earlier log and intermediate files.       							 "
	@echo "! sv_cmp     =>  Create library and compile the code.            "
	@echo "! run_test   =>  compile & run the simulation for bridge_test in batch mode.		 "
	@echo "! run_test1  =>  compile & run the simulation for bridge_ext1_test in batch mode."		
	@echo "! run_test2  =>  compile & run the simulation for bridge_ext2_test in batch mode.	"		
	@echo "! run_test3  =>  compile & run the simulation for bridge_ext3_test in batch mode."
	@echo "! run**      =>  clean, compile & run the simulation."
	@echo "! view_wave1 =>  To view the waveform of bridge_ext1_test	    								 "
	@echo "! view_wave2 =>  To view the waveform of bridge_ext2_test	    								"
	@echo "! view_wave3 =>  To view the waveform of bridge_ext3_test	  	  							"		
	@echo "! view_wave4 =>  To view the waveform of bridge_ext4_test	    								"
	@echo "! regress    =>  clean, compile and run all testcases in batch mode.		    		"			
	@echo "! report     =>  To merge coverage reports for all testcases and  convert to html format.			"
	@echo "! cov        =>  To open merged coverage report in html format.										"
	@echo ====================================================================================================================

sv_cmp: 
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1)
  
run: clean sv_cmp run_test

run1: clean sv_cmp run_test1

run2: clean sv_cmp run_test2

run3: clean sv_cmp run_test3

run4: clean sv_cmp run_test4

run_test: 
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH)  -wlf wave_file1.wlf -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=bridge_test +UVM_VERBOSITY=UVM_HIGH
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

run_test1: 
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave_file2.wlf -l test2.log  -sv_seed random  work.top +UVM_TESTNAME=extended_test1 +UVM_VERBOSITY=UVM_HIGH
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1
 
run_test2: 
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave_file3.wlf -l test3.log  -sv_seed 2772598444  work.top +UVM_TESTNAME=extended_test2 +UVM_VERBOSITY=UVM_HIGH
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2
 
run_test3: 
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)  -wlf wave_file4.wlf -l test4.log  -sv_seed random  work.top +UVM_TESTNAME=extended_test3 +UVM_VERBOSITY=UVM_HIGH
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov3
 
run_test4: 
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4) -solvefaildebug=2 -wlf wave_file5.wlf -l test5.log  -sv_seed random  work.top +UVM_TESTNAME=extended_test4 +UVM_VERBOSITY=UVM_HIGH
	vcover report  -cvg  -details  -nocompactcrossbins -codeAll -assert -directive -html mem_cov4
   
view_wave1:
	vsim -view wave_file1.wlf
	
view_wave2:
	vsim -view wave_file2.wlf
	
view_wave3:
	vsim -view wave_file3.wlf


report:
	vcover merge mem_cov mem_cov1 mem_cov2 mem_cov3 mem_cov4
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

regress: clean sv_cmp run_test1 run_test2 run_test3 run_test4 report 

cov:
	firefox covhtmlreport/index.html&
	
clean:
	rm -rf transcript* *log*  vsim.wlf fcover* covhtml* mem_cov* *.wlf modelsim.ini work
	clear



