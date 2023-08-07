interface APB_intf (input bit clock);

    logic [31:0] Prdata;    
    logic [31:0] Pwdata;    
    logic [31:0] Paddr;
    logic [3:0] Pselx;
    logic Penable;    
    logic Pwrite;

    clocking apb_drv_cb @(posedge clock);
        default input #1 output #1;
            output Prdata;    
            input Pwdata;    
            input Paddr;
            input Pselx;
            input Penable;    
            input Pwrite;
    endclocking

    clocking apb_mon_cb @(posedge clock);
        default input #1 output #1;
            input Prdata;    
            input Pwdata;    
            input Paddr;
            input Pselx;
            input Penable;    
            input Pwrite;
    endclocking

    modport APB_DRV_MP (clocking apb_drv_cb);
    modport APB_MON_MP (clocking apb_mon_cb);

endinterface
