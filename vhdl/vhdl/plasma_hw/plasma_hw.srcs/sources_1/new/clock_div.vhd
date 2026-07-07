----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.01.2023 14:49:20
-- Design Name: 
-- Module Name: pixel clock - Behavioral
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

entity clock_div is
--  Port ( );
Port( clk: in std_logic;
      rst: in std_logic;
      clk25: out std_logic);
end clock_div;


architecture Behavioral of clock_div is

signal compteur: std_logic_vector(1 downto 0);

begin

compteur_process : process(clk, rst)
begin
    if rst='1' then compteur <= (others=>'0');
     elsif clk'event and clk= '1'  
        then compteur <= compteur +1;
     end if;
end process;

clk25 <= compteur(1);
end Behavioral;

