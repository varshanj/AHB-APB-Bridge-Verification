class bridge_scoreboard extends uvm_scoreboard;

    `uvm_component_utils (bridge_scoreboard)

    bridge_env_config s_cfg;
    AHB_xtn m_xtn, ahb_xtn;
    APB_xtn s_xtn;
    AHB_xtn AHB_que[$];
    //APB_xtn APB_que[$];
    uvm_tlm_analysis_fifo #(AHB_xtn) AHB_fifo[];
    uvm_tlm_analysis_fifo #(APB_xtn) APB_fifo[];


    extern function new(string name = "Scoreboard",  uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern function void check_data(APB_xtn apb_xtn);
    extern function void compare_data(logic [31:0] Hdata, Pdata, Haddr, Paddr);

endclass


/////////////////////////////////////////////////////////////////////////////////////

function bridge_scoreboard::new(string name = "Scoreboard",  uvm_component parent);
    super.new(name, parent);        
endfunction: new

/////////////////////////////////////////////////////////////////////////////////////

function void bridge_scoreboard::build_phase(uvm_phase phase);
    if (!uvm_config_db #(bridge_env_config)::get(this, "", "bridge_env_config",s_cfg))
        `uvm_fatal("CONFIG","Getting config database failed")

    super.build_phase(phase); 

    AHB_fifo = new[s_cfg.AHB_Agents];
    APB_fifo = new[s_cfg.APB_Agents];

    foreach(AHB_fifo[i]) begin
        AHB_fifo[i] = new($sformatf("AHB_fifo[%0d]",i),this);
    end

    foreach(APB_fifo[i]) begin
        APB_fifo[i] = new($sformatf("APB_fifo[%0d]",i),this);
    end
endfunction

/////////////////////////////////////////////////////////////////////////////////////
 
    task bridge_scoreboard::run_phase(uvm_phase phase);
        fork
            begin
                forever begin
                AHB_fifo[0].get(m_xtn);
                AHB_que.push_front(m_xtn);
                m_xtn.print();
                $display("from scoreboard @ %0t", $time);
                $display("Size of the Queue = %d", AHB_que.size);
                end
            end
            begin
                forever begin
                APB_fifo[0].get(s_xtn);
                check_data(s_xtn);
                //s_xtn.print();
                end
            end
        join
    endtask

/////////////////////////////////////////////////////////////////////////////////////

    function void bridge_scoreboard::check_data(APB_xtn apb_xtn);
        ahb_xtn = AHB_que.pop_back();
        $display("AHB= %p @ %0t",ahb_xtn,$time);

        if (ahb_xtn.Hwrite) begin
            case(ahb_xtn.Hsize)
                2'b00: begin
                    if(ahb_xtn.Haddr[1:0] == 2'b00)
                        compare_data(ahb_xtn.Hwdata[7:0], s_xtn.Pwdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                    if(ahb_xtn.Haddr[1:0] == 2'b01)
                        compare_data(ahb_xtn.Hwdata[15:8], s_xtn.Pwdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                    if(ahb_xtn.Haddr[1:0] == 2'b10)
                        compare_data(ahb_xtn.Hwdata[23:16], s_xtn.Pwdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                    if(ahb_xtn.Haddr[1:0] == 2'b11)
                        compare_data(ahb_xtn.Hwdata[31:24], s_xtn.Pwdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                end

				2'b01: begin
                    if(ahb_xtn.Haddr[1:0] == 2'b00)
                        compare_data(ahb_xtn.Hwdata[15:0], s_xtn.Pwdata[15:0], ahb_xtn.Haddr, s_xtn.Paddr);
                    if(ahb_xtn.Haddr[1:0] == 2'b10)
                        compare_data(ahb_xtn.Hwdata[31:16], s_xtn.Pwdata[15:0], ahb_xtn.Haddr, s_xtn.Paddr);
                end

                2'b10: begin
                        compare_data(ahb_xtn.Hwdata, s_xtn.Pwdata, ahb_xtn.Haddr, s_xtn.Paddr);
                end
            endcase
        end

        else begin
            case(ahb_xtn.Hsize)
                2'b00: begin
                    if(ahb_xtn.Haddr[1:0] == 2'b00)
                        compare_data(ahb_xtn.Hrdata[7:0], s_xtn.Prdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                    if(ahb_xtn.Haddr[1:0] == 2'b01)
                        compare_data(ahb_xtn.Hrdata[15:8], s_xtn.Prdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                    if(ahb_xtn.Haddr[1:0] == 2'b10)
                        compare_data(ahb_xtn.Hrdata[31:16], s_xtn.Prdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                    if(ahb_xtn.Haddr[1:0] == 2'b11)
                        compare_data(ahb_xtn.Hrdata[31:16], s_xtn.Prdata[7:0], ahb_xtn.Haddr, s_xtn.Paddr);
                end

                2'b01: begin
					if(ahb_xtn.Haddr[1:0] == 2'b00)
                        compare_data(ahb_xtn.Hrdata[15:0], s_xtn.Prdata[15:0], ahb_xtn.Haddr, s_xtn.Paddr);
					if(ahb_xtn.Haddr[1:0] == 2'b10)
                        compare_data(ahb_xtn.Hrdata[31:16], s_xtn.Prdata[15:0], ahb_xtn.Haddr, s_xtn.Paddr);
                end

                2'b10: begin
                        compare_data(ahb_xtn.Hrdata, s_xtn.Prdata, ahb_xtn.Haddr, s_xtn.Paddr);
                end

            endcase
        end         
               
    endfunction

/////////////////////////////////////////////////////////////////////////////////////

    function void bridge_scoreboard::compare_data(logic [31:0] Hdata, Pdata, Haddr, Paddr);
        if(Haddr == Paddr)
                $display("Address compared Successfully");
        else
        begin
                $display("Address not compared Successfully");
                $display(" Haddr = %0h, Paddr = %0h",Haddr, Paddr);
                //$finish;
        end

        if(Hdata == Pdata)
                $display("Address compared Successfully");
        else
        begin
                $display("Data not compared Successfully");                
                $display(" Hdata = %0h, Pdata = %0h",Hdata, Pdata);
                //$finish;
        end
    endfunction

    
///****************************************************************************************************///
