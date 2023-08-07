interface AHB_intf (input bit clock);

    logic Hresetn;    
    logic [31:0] Hwdata;
    logic [31:0] Hrdata;
    logic [31:0] Haddr;
    logic [2:0] Hsize;
    logic [2:0] Hburst;
    logic [1:0] Htrans;
    logic [1:0] Hresp; 
    logic Hwrite;
    logic Hreadyin;     
    logic Hreadyout;

    clocking ahb_drv_cb @(posedge clock);
        default input #1 output #1;    
            output Hresetn;    
            output Hwdata;
            output Haddr;
            output Hsize;
            output Hburst;
            output Htrans;
            output Hwrite;
            output Hreadyin;   
            input Hreadyout;
    endclocking

    clocking ahb_mon_cb @(posedge clock);
        default input #1 output #1;      
            input Hresetn;   // 
            input Hwdata;
            input Haddr;        
            input Hrdata;
            input Hsize;    // 
            input Htrans;   
            input Hburst;   
            input Hwrite;
            input Hreadyout;  
            input Hreadyin;   //
    endclocking
          
    modport DRV_MP (clocking ahb_drv_cb);
    modport MON_MP (clocking ahb_mon_cb);

endinterface
