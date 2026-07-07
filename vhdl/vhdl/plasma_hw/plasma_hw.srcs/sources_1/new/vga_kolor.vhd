----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2023 20:23:41
-- Design Name: 
-- Module Name: vga_kolor - Behavioral
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

entity vga_kolor is
    Port(vidon : in STD_LOGIC;
         GPIO0 : in std_logic_vector(11 downto 0);
         vgaRed : out std_logic_vector(3 downto 0);
         vgaGreen : out std_logic_vector(3 downto 0);
         vgaBlue : out std_logic_vector(3 downto 0));
end vga_kolor;

architecture Behavioral of vga_kolor is

begin

process(vidon)
begin
    vgaRed <=(others =>'0');
    vgaGreen <=(others =>'0');
    vgaBlue <=(others =>'0');
    
        if vidon = '1' then
            vgaRed <= gpio0(11 downto 8);
            vgaGreen <= gpio0(7 downto 4);
            vgaBlue <= gpio0(3 downto 0);

         end if;
    
   end process;
 


end Behavioral;
