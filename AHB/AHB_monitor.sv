class AHB_monitor extends uvm_monitor;

    `uvm_component_utils (AHB_monitor)

    virtual AHB_intf.MON_MP vif;
    AHB_agent_config cfg;
    AHB_xtn data;
    uvm_analysis_port #(AHB_xtn) monitor_port;

    extern function new(string name="AHB_monitor",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_data();

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function AHB_monitor::new(string name="AHB_monitor",uvm_component parent);
	    super.new(name,parent);
	    monitor_port = new("Monitor_port",this);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void AHB_monitor::build_phase(uvm_phase phase);
	    if(!uvm_config_db #(AHB_agent_config)::get(this,"","AHB_agent_config",cfg))
		    `uvm_fatal("CONFIG","cannot get config data");
        data = AHB_xtn::type_id::create("data");
	    super.build_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void AHB_monitor::connect_phase(uvm_phase phase);
        vif = cfg.vif;
        super.connect_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task AHB_monitor::run_phase(uvm_phase phase);
        forever 
            collect_data();
    endtask
  
    /////////////////////////////////////////////////////////////////////////////////////

    task AHB_monitor::collect_data();

        wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11))
             data.Htrans = vif.ahb_mon_cb.Htrans;
             data.Hburst = vif.ahb_mon_cb.Hburst;
             data.Hwrite = vif.ahb_mon_cb.Hwrite;
             data.Hsize  = vif.ahb_mon_cb.Hsize;
             data.Haddr  = vif.ahb_mon_cb.Haddr;

        @(vif.ahb_mon_cb);
        wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11))
        if (data.Hwrite) 
            data.Hwdata = vif.ahb_mon_cb.Hwdata;
        else if (!data.Hwrite)
            data.Hrdata = vif.ahb_mon_cb.Hrdata;

            //data.print();
            $display("from AHB mon @ %0t", $time);
            monitor_port.write(data); 
    endtask

///****************************************************************************************************///
