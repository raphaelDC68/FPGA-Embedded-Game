----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 15:33:04
-- Design Name: 
-- Module Name: clkdiv_tb - Behavioral
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

entity clkdiv_tb is
--  Port ( );
end clkdiv_tb;

architecture Behavioral of clkdiv_tb is
component clock_div is
    Port( clk: in std_logic;
          rst: in std_logic;
          clk25: out std_logic);
end component;

signal clK25,CLK,RST: std_logic;


begin
uut: clock_div port map(clk=>CLK, rst=> RST, clk25=> clK25);

    clock:process
        begin
            CLK <='0';
            wait for 10 ns;
            loop
                CLK<=not(CLK);
                wait for 10 ns;
            end loop;
        end process;
        
    remise_a_zero:process
        begin
            RST<='1';
            wait for 5 ns;
            RST<='0';
            wait;
        end process;
            
end Behavioral;
