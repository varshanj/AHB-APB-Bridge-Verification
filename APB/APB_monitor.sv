class APB_monitor extends uvm_monitor;

    `uvm_component_utils (APB_monitor)

    virtual APB_intf.MON_MP intf;
    APB_agent_config cfg;
    APB_xtn data;
    uvm_analysis_port #(APB_xtn) monitor_port;

    extern function new(string name="APB_monitor",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_data();

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function APB_monitor::new(string name="APB_monitor",uvm_component parent);
	    super.new(name,parent);
	    monitor_port = new("Monitor_port",this);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void APB_monitor::build_phase(uvm_phase phase);
	    if(!uvm_config_db #(APB_agent_config)::get(this,"","APB_agent_config",cfg))
		    `uvm_fatal("CONFIG","cannot get config data");
        data = APB_xtn::type_id::create("data");
	    super.build_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void APB_monitor::connect_phase(uvm_phase phase);
        intf = cfg.vif;
        super.connect_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task APB_monitor::run_phase(uvm_phase phase);
        forever 
            collect_data();
    endtask
  
    /////////////////////////////////////////////////////////////////////////////////////

    task APB_monitor::collect_data();
        data = APB_xtn::type_id::create("data");

        wait(intf.apb_mon_cb.Penable)
            data.Paddr = intf.apb_mon_cb.Paddr;
            data.Pwrite = intf.apb_mon_cb.Pwrite;
            data.Pselx = intf.apb_mon_cb.Pselx;
//
        if(data.Pwrite == 1)
			data.Pwdata = intf.apb_mon_cb.Pwdata; 
        else
            data.Prdata = intf.apb_mon_cb.Prdata;

        @(intf.apb_mon_cb); //
        //data.print();
        monitor_port.write(data);
    endtask

///****************************************************************************************************///
