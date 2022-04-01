`timescale 1ns / 1ps
module mips(
    input clk,                       // 闁哄啫鐖奸幐鎾寸┍閳ュ啿濞�
    input reset,                     // 闁告艾鏈鐐村緞瀹ュ嫮绉村ǎ鍥ｂ偓鍐插▏
    input interrupt,                 // 濠㈣埖鐗犻崕瀛樼▔椤撶喐鐒藉ǎ鍥ｂ偓鍐插▏
    output [31:0] macroscopic_pc,    // 閻庣懓绻楅～锟� PC闁挎稑鐗愰～鍡樼▔鐎ｎ偅鐎柨鐕傛嫹

    output [31:0] i_inst_addr,       // 闁告瑦鐗楃€碉拷 PC
    input  [31:0] i_inst_rdata,      // i_inst_addr 閻庣數鎳撶花鏌ユ晸閿燂拷32 濞达絽绉电€垫岸鏁撻敓锟�

    output [31:0] m_data_addr,       // 闁轰胶澧楀畵浣衡偓娑櫭崑宥夊闯閵娿儳绐￠柛鎰懃閸欏棝宕烽弶鎸庣祷
    input  [31:0] m_data_rdata,      // m_data_addr 閻庣數鎳撶花鏌ユ晸閿燂拷32 濞达絽绉甸弳鐔兼晸閿燂拷
    output [31:0] m_data_wdata,      // 闁轰胶澧楀畵浣衡偓娑櫭崑宥夊闯閵娿儳绐￠柛鎰懃閸欏棝寮悧鍫濈ウ
    output [3 :0] m_data_byteen,     // 閻庢稒顨夋俊顓熸媴閼愁垰鍘村ǎ鍥ｂ偓鍐插▏

    output [31:0] m_inst_addr,       // M 缂佺虎婀扖
    output w_grf_we,                 // grf 闁告劖鐟ゆ繛鍥嚄閹存帊绻嗛柨鐕傛嫹
    output [4 :0] w_grf_addr,        // grf 鐎垫澘鎳庨崯鎾诲礂閵夈儳妲戦悗娑櫭▍鎺旂磽閺嵮冨▏
    output [31:0] w_grf_wdata,       // grf 鐎垫澘鎳庨崯鎾诲礂閵夛附娈堕柨鐕傛嫹

    output [31:0] w_inst_addr        // W 闁跨喓绁癈
);
    wire [5:0] HWINT;
    wire [31:0] DataFromT0,DataFromT1,DataFromBToT0,DataFromBToT1,DataToCPU;
    wire [31:0] InstAddrFromCPU,MEMADDR,MEMDATA,PCINM,GRFDATA,PCINW,MACROPC,AddrToDM,AddrToT0,AddrToT1,DataFromBToDM;
    wire [3:0] DMByteen;
    wire GRFWEINW,DMWEFROMB,T0WEFORMB,T1WEFROMB;
    wire [4:0] GRFADDR;
    wire IRQT0,IRQT1;



    assign i_inst_addr = InstAddrFromCPU;
    assign macroscopic_pc = MACROPC;
    assign m_data_addr = AddrToDM;
    assign m_data_wdata = DataFromBToDM;
    assign m_data_byteen = DMByteen;
    assign m_inst_addr = PCINM;
    assign w_grf_we = GRFWEINW;
    assign w_grf_addr = GRFADDR;
    assign w_grf_wdata = GRFDATA;
    assign w_inst_addr = PCINW;

    assign HWINT = {3'b0,interrupt,IRQT1,IRQT0};

    CPU MIPSCPU(.clk(clk),
                .reset(reset),
                .HWINT(HWINT),
                .i_inst_rdata(i_inst_rdata), 
                .m_data_rdata(DataToCPU), 
                .i_inst_addr(InstAddrFromCPU), 
                .m_data_addr(MEMADDR), 
                .m_data_wdata(MEMDATA), 
                .m_data_byteen(DMByteen), 
                .m_inst_addr(PCINM), 
                .w_grf_we(GRFWEINW), 
                .w_grf_addr(GRFADDR),
                .w_grf_wdata(GRFDATA),
                .w_inst_addr(PCINW),
                .macroscopic_pc(MACROPC)
    );

    

    Bridge MIPSBridge(.AddrFromCPU(MEMADDR),
                      .WEFromCPU(|DMByteen),
                      .DataFromCPU(MEMDATA),
                      .DataToCPUFromDM(m_data_rdata),
                      .DataToCPUFromTime0(DataFromT0),
                      .DataToCPUFromTime1(DataFromT1),
                      .DMWE(DMWEFROMB),
                      .Time0WE(T0WEFORMB),
                      .Time1WE(T1WEFROMB),
                      .AddrToDM(AddrToDM),
                      .AddrToTime0(AddrToT0),
                      .AddrToTime1(AddrToT1),
                      .DataToDM(DataFromBToDM),
                      .DataToTime0(DataFromBToT0),
                      .DataToTime1(DataFromBToT1), 
                      .DataToCPU(DataToCPU)
    );




    TC MIPSTC0(.clk(clk),
               .reset(reset),
               .Addr(AddrToT0[31:2]),
               .WE(T0WEFORMB),
               .Din(DataFromBToT0),
               .Dout(DataFromT0),
               .IRQ(IRQT0)

    );



    TC MIPSTC1(.clk(clk),
               .reset(reset),
               .Addr(AddrToT1[31:2]),
               .WE(T1WEFROMB),
               .Din(DataFromBToT1),
               .Dout(DataFromT1),
               .IRQ(IRQT1)

    );



endmodule
