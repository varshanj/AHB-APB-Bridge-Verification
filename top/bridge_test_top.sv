module top;

    import uvm_pkg::*;
    import bridge_pkg::*;

    bit clock;
    always #10 clock = ~clock;

    AHB_intf master(clock);
    APB_intf slave(clock);

    rtl_top DUT (.Hresetn(master.Hresetn), .Hwdata(master.Hwdata), 
                 .Haddr(master.Haddr), .Hwrite(master.Hwrite), .Hclk(clock),
                 .Hrdata(master.Hrdata), .Hsize(master.Hsize), 
                 .Hresp(master.Hresp), .Htrans(master.Htrans),
                 .Hreadyout(master.Hreadyout), .Hreadyin(master.Hreadyin), 

                 .Prdata(slave.Prdata), .Pwdata(slave.Pwdata), 
                 .Paddr(slave.Paddr), .Pselx(slave.Pselx), 
                 .Penable(slave.Penable), .Pwrite(slave.Pwrite));       

    initial begin
        uvm_config_db #(virtual AHB_intf):: set(null, "*", "AHB_intf", master);
        uvm_config_db #(virtual APB_intf):: set(null, "*", "APB_intf", slave);
        run_test();
    end

endmodule
