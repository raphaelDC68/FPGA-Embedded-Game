----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2023 15:18:52
-- Design Name: 
-- Module Name: plasma_basys3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity plasma_basys3 is
    Port ( clk : in STD_LOGIC;
           RsRx : in STD_LOGIC;
           RsTx : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           btnR : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnC : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           
           vgaRed: out STD_LOGIC_VECTOR(3 downto 0);
           vgaBlue: out STD_LOGIC_VECTOR(3 downto 0);
           vgaGreen: out STD_LOGIC_VECTOR(3 downto 0);
           Hsync: out STD_LOGIC; 
           Vsync: out STD_LOGIC;
           seg: out std_logic_vector(6 downto 0);
           an: out std_logic_vector(3 downto 0);
           dp: out std_logic);
end plasma_basys3;

architecture Behavioral of plasma_basys3 is

component plasma 
    Port (

        clk          : in std_logic;
        reset        : in std_logic;

        uart_write   : out std_logic;
        uart_read    : in std_logic;

        address      : out std_logic_vector(31 downto 2);
        byte_we      : out std_logic_vector(3 downto 0); 
        data_write   : out std_logic_vector(31 downto 0);
        data_read    : in std_logic_vector(31 downto 0);
        mem_pause_in : in std_logic;
        no_ddr_start : out std_logic;
        no_ddr_stop  : out std_logic;
        
        gpio0_out    : out std_logic_vector(31 downto 0);
        gpio1_out    : out std_logic_vector(31 downto 0);        
        gpio2_out    : out std_logic_vector(31 downto 0);    
        gpio3_out    : out std_logic_vector(31 downto 0);    
        gpio4_out    : out std_logic_vector(31 downto 0);
        gpio5_out    : out std_logic_vector(31 downto 0);        
        gpio6_out    : out std_logic_vector(31 downto 0);        
        gpio7_out    : out std_logic_vector(31 downto 0);                
        gpioA_in     : in std_logic_vector(31 downto 0));
    
end component;

component clock_div
    Port (
        clk : in std_logic;
        rst:  in std_logic;
        clk25: out std_logic);
end component;


component RAM_PROGRAM
    Port(
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
        
end component;



component VGA_640x480
    Port( rst: in std_logic;
          clk25: in std_logic;
          HSYNC: out std_logic;
          VSYNC: out std_logic;
          HC: out std_logic_vector(9 downto 0);
          VC: out std_logic_vector(9 downto 0);
          vidon: out std_logic);

end component;



--component vga_kolor
--    Port(vidon : in STD_LOGIC;
--         GPIO0 : in std_logic_vector(11 downto 0);
--         vgaRed : out std_logic_vector(3 downto 0);
--         vgaGreen : out std_logic_vector(3 downto 0);
--         vgaBlue : out std_logic_vector(3 downto 0));
--end component;



component VGA_PROM 
   Port ( HC : in STD_LOGIC_VECTOR (9 downto 0);
          VC : in STD_LOGIC_VECTOR (9 downto 0);
           
           VIDON : in STD_LOGIC;
           
           M : in STD_LOGIC_VECTOR (11 downto 0);
           M_2 : in STD_LOGIC_VECTOR (11 downto 0);          
           M_3 : in STD_LOGIC_VECTOR (11 downto 0);          
           M_4 : in STD_LOGIC_VECTOR (11 downto 0);    
           M_5 : in STD_LOGIC_VECTOR (11 downto 0);    
           M_6 : in STD_LOGIC_VECTOR (11 downto 0);         
           M_7 : in STD_LOGIC_VECTOR (11 downto 0);    
                                     
           Rom_addr16 : out STD_LOGIC_VECTOR (11 downto 0);
           Rom_addr16_2 : out STD_LOGIC_VECTOR (11 downto 0); 
           Rom_addr16_3 : out STD_LOGIC_VECTOR (14 downto 0); 
           Rom_addr16_4: out STD_LOGIC_VECTOR (10 downto 0);     
           Rom_addr16_5: out STD_LOGIC_VECTOR (14 downto 0);     
           Rom_addr16_6: out STD_LOGIC_VECTOR (14 downto 0);     
           Rom_addr16_7: out STD_LOGIC_VECTOR (14 downto 0);           
                                                                          
           RED : out STD_LOGIC_VECTOR (3 downto 0);
           GREEN : out STD_LOGIC_VECTOR (3 downto 0);
           BLUE : out STD_LOGIC_VECTOR (3 downto 0);
           
           gpio_1: in std_logic_vector(31 downto 0);
           gpio_2: in std_logic_vector(31 downto 0);
           gpio_3: in std_logic_vector(31 downto 0);
           gpio_4: in std_logic_vector(31 downto 0);
           gpio_5: in std_logic_vector(31 downto 0);
           gpio_6: in std_logic_vector(31 downto 0);
           gpio_7: in std_logic_vector(31 downto 0));
end component;





component top_7seg
 Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           e1 : in STD_LOGIC_VECTOR (3 downto 0);
           e2 : in STD_LOGIC_VECTOR (3 downto 0);
           e3 : in STD_LOGIC_VECTOR (3 downto 0);
           e4 : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC);
end component;



---zone image 


component blk_mem_gen_0
PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
end component;



component blk_mem_gen_1 
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;


component blk_mem_gen_2 
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;


component blk_mem_gen_3 
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;



component blk_mem_gen_4 
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;




component blk_mem_gen_5 
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;





component blk_mem_gen_6 
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;

--------zone signaux


signal clock25,mem_pause_in  :std_logic;
signal no_ddr_start,no_ddr_stop: std_logic;
signal address: std_logic_vector(31 downto 2);
signal byte_we: std_logic_vector(3 downto 0);
signal data_write: std_logic_vector(31 downto 0);
signal data_read: std_logic_vector(31 downto 0);
signal gpio0_out: std_logic_vector(31 downto 0);
signal addrA: std_logic_vector(13 downto 2);
signal addrB: std_logic_vector(13 downto 2); 
signal hc,vc: std_logic_vector(9 downto 0);
signal vidon: std_logic; 
signal gpioA_in: std_logic_vector(31 downto 0);
signal addr,addr_2: std_logic_vector(11 downto 0);
signal addr_3: std_logic_vector(14 downto 0);
signal addr_4: std_logic_vector(10 downto 0);
signal addr_5: std_logic_vector(14 downto 0);
signal addr_6: std_logic_vector(14 downto 0);
signal addr_7: std_logic_vector(14 downto 0);

signal s_M,s_M_2,s_M_3,s_M_4,s_M_5,s_M_6,s_M_7: std_logic_vector(11 downto 0);
signal s_gpio1_out: std_logic_vector(31 downto 0);
signal s_gpio2_out: std_logic_vector(31 downto 0);
signal s_gpio3_out: std_logic_vector(31 downto 0);
signal s_gpio4_out: std_logic_vector(31 downto 0);
signal s_gpio5_out: std_logic_vector(31 downto 0);
signal s_gpio6_out: std_logic_vector(31 downto 0);
signal s_gpio7_out: std_logic_vector(31 downto 0);
---zone port mapping

begin 

addrA(13 downto 2)<= address(13 downto 2);
addrB(13 downto 2)<= address(13 downto 2);

instance_clock_div : clock_div Port map(clk =>clk,
                                        rst=>btnC,
                                        clk25=>clock25);
                                        
instance_plasma : plasma Port map(clk=>clock25,
                                  reset=> btnC,
                                  uart_write=>RsTx,
                                  uart_read=>RsRx,
                                  address=>address,
                                  byte_we=>byte_we,
                                  data_write=>data_write,
                                  data_read=>data_read,
                                  mem_pause_in=>mem_pause_in,
                                  no_ddr_start=>no_ddr_start,
                                  no_ddr_stop=>no_ddr_stop,
                                  gpio0_out(31 downto 16)=>gpio0_out(31 downto 16),
                                  gpio0_out(15 downto 0)=>led,  
                                  gpio1_out(31 downto 0)=>s_gpio1_out,   
                                  gpio2_out(31 downto 0)=>s_gpio2_out,
                                  gpio3_out(31 downto 0)=>s_gpio3_out,
                                  gpio4_out(31 downto 0)=>s_gpio4_out,       
                                  gpio5_out(31 downto 0)=>s_gpio5_out, 
                                  gpio6_out(31 downto 0)=>s_gpio6_out,
                                  gpio7_out(31 downto 0)=>s_gpio7_out,                                                                                                                                                                                                                                                             
                                  gpioA_in(15 downto 0)=>sw,
                                  gpioA_in(19)=>btnR,
                                  gpioA_in(18)=>btnL,
                                  gpioA_in(17)=>btnU,
                                  gpioA_in(16)=>btnD,
                                  gpioA_in(31 downto 20)=>(others=>'0'));


instance_RAM_PROGRAM: RAM_PROGRAM Port map(
                                  clka=>clk,
                                  wea=>byte_we,
                                  addra=>addrA,
                                  dina=>data_write,
                                  clkb=>clk,
                                  addrb=>addrB,
                                  doutb=>data_read);

instance_VGA_640x480: VGA_640x480 Port map(
                                  rst=>btnC,
                                  clk25=>clock25,
                                  HSYNC=>Hsync,
                                  VSYNC=>Vsync,
                                  HC=>hc,
                                  VC=>vc,
                                  vidon=>vidon);
                                  
--instance_vga_kolor: vga_kolor Port map(
--                              gpio0=>gpio_out(27 downto 16),
--                              vidon=>vidon,
--                              vgaRed=>vgaRed,
--                              vgaGreen=>vgaGreen,
--                              vgaBlue=>vgaBlue);

instance_VGA_PROM: VGA_PROM Port map(
                               HC=>hc ,
                               VC=>vc,
                               
                               VIDON=>vidon,
                               
                               
                               M=>s_M,
                               M_2=>s_M_2,                               
                               M_3=>s_M_3, 
                               M_4=>s_M_4, 
                               M_5=>s_M_5, 
                               M_6=>s_M_6,                                
                               M_7=>s_M_7,                                
                               
                               
                               
                                                                                             
                               Rom_addr16=>addr ,
                               Rom_addr16_2=>addr_2 ,                               
                               Rom_addr16_3=>addr_3,
                               Rom_addr16_4=>addr_4,
                               Rom_addr16_5=>addr_5,                              
                               Rom_addr16_6=>addr_6,
                               Rom_addr16_7=>addr_7,                                
                                
                                
                                                                                             
                               RED=>vgaRed,
                               GREEN=>vgaGreen,
                               BLUE=>vgaBlue,
                               
                               
                               gpio_1=>s_gpio1_out(31 downto 0),
                               gpio_2=>s_gpio2_out(31 downto 0),
                               gpio_3=>s_gpio3_out(31 downto 0),
                               gpio_4=>s_gpio4_out(31 downto 0),
                               gpio_5=>s_gpio5_out(31 downto 0),                            
                               gpio_6=>s_gpio6_out(31 downto 0),    
                               gpio_7=>s_gpio7_out(31 downto 0));                               
                               
instance_7_seg_top: top_7seg Port map(
                               rst=>btnC,
                               clk=>clk,
                               e1=>gpio0_out(31 downto 28),
                               e2=>gpio0_out(27 downto 24),
                               e3=>gpio0_out(23 downto 20),
                               e4=>gpio0_out(19 downto 16),
                               seg=>seg,
                               an=>an,
                               dp=>dp);

instance_blk_mem_gen_0: blk_mem_gen_0 Port map( 
                                      clka=>clk,
                                      addra=>addr,
                                      douta=>s_M);
                                    
instance_blk_mem_gen_1:  blk_mem_gen_1 Port map(
    clka => clk,
    addra =>addr_2,
    douta =>s_M_2);
                                   


instance_blk_mem_gen_2: blk_mem_gen_2 Port map(
    clka => clk,
    addra => addr_3,
    douta => s_M_3);

instance_blk_mem_gen_3: blk_mem_gen_3 Port map(
    clka => clk,
    addra => addr_4,
    douta => s_M_4);


instance_blk_mem_gen_4: blk_mem_gen_4 Port map(
    clka => clk,
    addra => addr_5,
    douta => s_M_5);
    

instance_blk_mem_gen_5: blk_mem_gen_5 Port map(
    clka => clk,
    addra => addr_6,
    douta => s_M_6);
 
 
instance_blk_mem_gen_6: blk_mem_gen_6 Port map(
    clka => clk,
    addra => addr_7,
    douta => s_M_7);                                   
end Behavioral;
