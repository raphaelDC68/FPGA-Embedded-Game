----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.01.2023 15:11:53
-- Design Name: 
-- Module Name: VGA_640x480 - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_640x480 is
    Port( rst: in std_logic;
          clk25: in std_logic;
          HSYNC: out std_logic;
          VSYNC: out std_logic;
          HC: out std_logic_vector(9 downto 0);
          VC: out std_logic_vector(9 downto 0);
          vidon: out std_logic);

end VGA_640x480;

architecture Behavioral of VGA_640x480 is

constant hbp: std_logic_vector(9 downto 0):="0010010000";
constant hfp: std_logic_vector(9 downto 0):="1100010000";
constant hpixels: std_logic_vector(9 downto 0):="1100100000";
constant vbp: std_logic_vector(9 downto 0):="0000011111";
constant vfp: std_logic_vector(9 downto 0):="0111111111";
constant vlines: std_logic_vector(9 downto 0):="1000001001";



    
signal counterH : std_logic_vector( 9 downto 0);
signal counterV : std_logic_vector(9 downto 0);
signal vsenable : std_logic;

begin 

hpixels_p: process(clk25,rst)
begin
        if rst='1' then counterH <= (others=>'0');
      elsif rising_edge(clk25) then
        if counterH = hpixels-1 then
         counterH <=(others=>'0');
      else
            counterH<= counterH+1;
       end if;
end if;
end process;


enable: process(counterH)
begin
        if counterH =hpixels-1 then vsenable<='1';
        else
            vsenable<= '0';
        end if;
 end process;


c_vertical: process(clk25,rst)
begin

   if rst='1' then counterV <= (others=>'0');
   elsif clk25'event and clk25='1' then 
   if  vsenable ='1' then
    if counterV = vlines-1 then counterV<=(others=>'0');
    else
       counterV<=counterV+1;
    end if;
    end if;
    end if;
end process;


HSYNC<='0' when counterH <96 else '1';
VSYNC<='0' when counterV <2 else '1';

VIDON <= '1' when ((counterH >= hbp) and (counterH<hfp) and (counterV >= vbp) and (counterV <vfp)) else '0';



hc<= counterH; 
vc<= counterV;

end Behavioral;

