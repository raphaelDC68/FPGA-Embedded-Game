----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.03.2023 00:15:23
-- Design Name: 
-- Module Name: VGA_PROM__2 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_PROM is
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
           Rom_addr16_4 : out STD_LOGIC_VECTOR (10 downto 0);   
           Rom_addr16_5 : out STD_LOGIC_VECTOR (14 downto 0);  
           Rom_addr16_6 : out STD_LOGIC_VECTOR (14 downto 0);  
           Rom_addr16_7 : out STD_LOGIC_VECTOR (14 downto 0);  
           
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

end VGA_PROM;


architecture Behavioral of VGA_PROM is

    constant hbp : std_logic_vector(9 downto 0) := "0010010000"; -- back porch horizontal (144)
    constant vbp : std_logic_vector(9 downto 0) := "0000011111"; -- back porch vertical (31)
    
    constant w_sprite : std_logic_vector(9 downto 0) := "0000110010"; -- largeur du sprite (50)
    constant h_sprite : std_logic_vector(9 downto 0) := "0000110010"; -- hauteur du sprite (50)   
    
    constant w_sprite_2 : std_logic_vector(9 downto 0) := "0000110010"; -- largeur du sprite (50)
    constant h_sprite_2 : std_logic_vector(9 downto 0) := "0000110010"; -- hauteur du sprite (50)    

    constant w_sprite_3 : std_logic_vector(9 downto 0) := "0010100000"; -- largeur du sprite (160) *2
    constant h_sprite_3 : std_logic_vector(9 downto 0) := "0001111000"; -- hauteur du sprite (120) *2 pour le terrain       
    
    constant w_sprite_4 : std_logic_vector(9 downto 0) := "0000100011"; -- largeur du sprite (40)
    constant h_sprite_4 : std_logic_vector(9 downto 0) := "0000100011"; -- hauteur du sprite (40)       
    
    
    constant w_sprite_5 : std_logic_vector(9 downto 0) := "0010010101"; -- largeur du sprite (149)
    constant h_sprite_5 : std_logic_vector(9 downto 0) := "0010010101"; -- hauteur du sprite (149)       
    
    constant w_sprite_6 : std_logic_vector(9 downto 0) := "0011001000"; -- largeur du sprite (200)
    constant h_sprite_6 : std_logic_vector(9 downto 0) := "0010010101"; -- hauteur du sprite (149)       
 
 
    constant w_sprite_7 : std_logic_vector(9 downto 0) := "0011001000"; -- largeur du sprite (200)
    constant h_sprite_7 : std_logic_vector(9 downto 0) := "0010010101"; -- hauteur du sprite (149)    
    
    signal rom_addr,rom_addr_2,rom_addr_3,rom_addr_4,rom_addr_5,rom_addr_6,rom_addr_7 : std_logic_vector(9 downto 0); -- Calcul de l'adresse de ligne et du numéro de colonne du pixel
    signal spriteon,spriteon_2,spriteon_3,spriteon_4,spriteon_5,spriteon_6,spriteon_7 : std_logic; -- zone d'affichage du sprite ou non
    signal R,G,B : std_logic; -- 0 ou 1 selon la valeur de la data dans la PROM
    signal offset_h,offset_h_2,offset_h_3,offset_h_4,offset_h_5,offset_h_6,offset_h_7:  std_logic_vector(9 downto 0);
    signal offset_v,offset_v_2,offset_v_3,offset_v_4,offset_v_5,offset_v_6,offset_v_7:  std_logic_vector(9 downto 0);
    signal  ypix, xpix, ypix_2,xpix_2,ypix_3,xpix_3,ypix_4,xpix_4,ypix_5,xpix_5,ypix_6,xpix_6,ypix_7,xpix_7 : std_logic_vector (9 downto 0);
    signal  y3,x3: std_logic_vector (9 downto 0);   
    --signal rom_addr1_2 : std_logic_vector(19 downto 0);
    
begin

-- x en poids faible, y en pds fort
-- Switches
    offset_v <= gpio_1(19 downto 10); -- la gpio1 gere laffichage en x et y de l'image 1
    offset_h <= gpio_1(9 downto 0);

    offset_v_2 <= gpio_2(19 downto 10); -- la gpio2 gere laffichage en x et y de l'image 2
    offset_h_2 <= gpio_2(9 downto 0);

    offset_v_3 <= gpio_3(19 downto 10); -- la gpio2 gere laffichage en x et y de l'image 3
    offset_h_3 <= gpio_3(9 downto 0);

    offset_v_4 <= gpio_4(19 downto 10); -- la gpio2 gere laffichage en x et y de l'image 3
    offset_h_4 <= gpio_4(9 downto 0);

    offset_v_5 <= gpio_5(19 downto 10); -- la gpio2 gere laffichage en x et y de l'image 3
    offset_h_5 <= gpio_5(9 downto 0);

    offset_v_6 <= gpio_6(19 downto 10); -- la gpio2 gere laffichage en x et y de l'image 3
    offset_h_6 <= gpio_6(9 downto 0);


    offset_v_7 <= gpio_7(19 downto 10); -- la gpio2 gere laffichage en x et y de l'image 3
    offset_h_7 <= gpio_7(9 downto 0);





-- Position sprite 1
    ypix <= VC - vbp - offset_v;
    xpix <= HC - hbp - offset_h;
    
-- Position sprite 2
    ypix_2 <= (VC - vbp - offset_v_2); 
    xpix_2 <= (HC - hbp - offset_h_2); 
    
-- Position sprite 3
    y3 <= (VC - vbp - offset_v_3);-- /"10";
    ypix_3 <= "00" & y3(9 downto 2); -- division par 4 car decalage 2  car on a divisé le nb de pixel initial de limage par 4(120*160) et on veut l'afficher sur du 480*640
    --et on affiche un pixel 4 fois car decalage arrondit par dfaut (le pixel en (0,1) sera considéré comme le (0,0) de mon nvx affichage donc o multiplie par 4 l'image 
    
    x3<= (HC - hbp - offset_h_3);
    xpix_3<= "00" & x3(9 downto 2); --/"10";
    
-- Position sprite 4
    ypix_4 <= (VC - vbp - offset_v_4); 
    xpix_4 <= (HC - hbp - offset_h_4); 
  
-- Position sprite 5
    ypix_5 <= (VC - vbp - offset_v_5); 
    xpix_5 <= (HC - hbp - offset_h_5); 
      
-- Position sprite 6
    ypix_6 <= (VC - vbp - offset_v_6); 
    xpix_6 <= (HC - hbp - offset_h_6); 
      
-- Position sprite 7
    ypix_7 <= (VC - vbp - offset_v_7); 
    xpix_7 <= (HC - hbp - offset_h_7); 
        
   
-- flag si dans la zone du sprite
    spriteon <= '1' when (HC >= hbp + 1 + offset_h and 
                          HC <= hbp + offset_h + w_sprite and 
                          VC >= vbp + 1 + offset_v and 
                          VC <= vbp + offset_v + h_sprite) 
                          else '0';
                         
                         
    spriteon_2 <= '1' when (HC >= hbp + 1 + offset_h_2 and 
                          HC <= hbp + offset_h_2 + w_sprite_2  and 
                          VC >= vbp + 1 + offset_v_2 and 
                          VC <= vbp + offset_v_2 + h_sprite_2 ) 
                          else '0';
                          
    spriteon_3 <= '1' when (HC >= hbp + 1 + offset_h_3 and 
                          HC <= hbp + offset_h_3 + w_sprite_3* "100" and 
                          VC >= vbp + 1 + offset_v_3 and 
                          VC <= vbp + offset_v_3 + h_sprite_3* "100") 
                          else '0';
                          
    spriteon_4 <= '1' when (HC >= hbp + 1 + offset_h_4 and 
                          HC <= hbp + offset_h_4 + w_sprite_4  and 
                          VC >= vbp + 1 + offset_v_4 and 
                          VC <= vbp + offset_v_4 + h_sprite_4 ) 
                          else '0';
                          
                          
    spriteon_5 <= '1' when (HC >= hbp + 1 + offset_h_5 and 
                          HC <= hbp + offset_h_5 + w_sprite_5  and 
                          VC >= vbp + 1 + offset_v_5 and 
                          VC <= vbp + offset_v_5 + h_sprite_5 ) 
                          else '0';

    spriteon_6 <= '1' when (HC >= hbp + 1 + offset_h_6 and 
                          HC <= hbp + offset_h_6 + w_sprite_6  and 
                          VC >= vbp + 1 + offset_v_6 and 
                          VC <= vbp + offset_v_6 + h_sprite_6 ) 
                          else '0';

    spriteon_7 <= '1' when (HC >= hbp + 1 + offset_h_7 and 
                          HC <= hbp + offset_h_7 + w_sprite_7  and 
                          VC >= vbp + 1 + offset_v_7 and 
                          VC <= vbp + offset_v_7 + h_sprite_7 ) 
                          else '0';



-- Choix du pixel à afficher
--    process(xpix, ypix)
--        variable rom_addr1, rom_addr2 : std_logic_vector(16 downto 0);
--    begin         --      *128                  *64                     *32                         *16
--        rom_addr1 := (ypix & "0000000") + ("0" & ypix & "000000") + ("00" & ypix & "00000") + ("000" & ypix & "0000");
--        rom_addr2 := rom_addr1 + ("0000000" & xpix);
--        Rom_addr16 <= rom_addr2(11 downto 0);
--    end process;


    process(xpix, ypix)
        variable rom_addr1 : std_logic_vector(19 downto 0);
        --variable rom_addr2_2 : std_logic_vector(15 downto 0);
    begin         --      *128                  *64                     *32                         *16
        rom_addr1 := (ypix* w_sprite) + xpix;--(ypix_2 & "0000000") + ("0" & ypix_2 & "000000") + ("00" & ypix_2 & "00000") + ("000" & ypix_2 & "0000");
        --rom_addr2_2 := rom_addr1_2 + ("0000000" & xpix_2);
        Rom_addr16<= rom_addr1(11 downto 0);
    end process;

    process(xpix_2, ypix_2)
        variable rom_addr1_2 : std_logic_vector(19 downto 0);
        --variable rom_addr2_2 : std_logic_vector(15 downto 0);
    begin         --      *128                  *64                     *32                         *16
        rom_addr1_2 := (ypix_2 * w_sprite_2) + xpix_2;--(ypix_2 & "0000000") + ("0" & ypix_2 & "000000") + ("00" & ypix_2 & "00000") + ("000" & ypix_2 & "0000");
        --rom_addr2_2 := rom_addr1_2 + ("0000000" & xpix_2);
        Rom_addr16_2 <= rom_addr1_2(11 downto 0);
    end process;


    process(xpix_3, ypix_3)
        variable rom_addr1_3 : std_logic_vector(19 downto 0);
        --variable rom_addr2_2 : std_logic_vector(15 downto 0);
    begin         --      *128                  *64                     *32                         *16
        rom_addr1_3 := (ypix_3 * w_sprite_3) + xpix_3;--(ypix_2 & "0000000") + ("0" & ypix_2 & "000000") + ("00" & ypix_2 & "00000") + ("000" & ypix_2 & "0000");
        --rom_addr2_2 := rom_addr1_2 + ("0000000" & xpix_2);
        Rom_addr16_3 <= rom_addr1_3(14 downto 0);
    end process;

    process(xpix_4, ypix_4)
        variable rom_addr1_4 : std_logic_vector(19 downto 0);
        --variable rom_addr2_2 : std_logic_vector(15 downto 0);
    begin         --      *128                  *64                     *32                         *16
        rom_addr1_4 := (ypix_4 * w_sprite_4) + xpix_4;--(ypix_2 & "0000000") + ("0" & ypix_2 & "000000") + ("00" & ypix_2 & "00000") + ("000" & ypix_2 & "0000");
        --rom_addr2_2 := rom_addr1_2 + ("0000000" & xpix_2);
        Rom_addr16_4 <= rom_addr1_4(10 downto 0);
    end process;


    process(xpix_5, ypix_5)
        variable rom_addr1_5 : std_logic_vector(19 downto 0);
        --variable rom_addr2_2 : std_logic_vector(15 downto 0);
    begin         --      *128                  *64                     *32                         *16
        rom_addr1_5 := (ypix_5 * w_sprite_5) + xpix_5;--(ypix_2 & "0000000") + ("0" & ypix_2 & "000000") + ("00" & ypix_2 & "00000") + ("000" & ypix_2 & "0000");
        --rom_addr2_2 := rom_addr1_2 + ("0000000" & xpix_2);
        Rom_addr16_5 <= rom_addr1_5(14 downto 0);
    end process;





    process(xpix_6, ypix_6)
        variable rom_addr1_6 : std_logic_vector(19 downto 0);
        --variable rom_addr2_2 : std_logic_vector(15 downto 0);
    begin         --      *128                  *64                     *32                         *16
        rom_addr1_6 := (ypix_6 * w_sprite_6) + xpix_6;--(ypix_2 & "0000000") + ("0" & ypix_2 & "000000") + ("00" & ypix_2 & "00000") + ("000" & ypix_2 & "0000");
        --rom_addr2_2 := rom_addr1_2 + ("0000000" & xpix_2);
        Rom_addr16_6 <= rom_addr1_6(14 downto 0);
    end process;





    process(xpix_7, ypix_7)
        variable rom_addr1_7 : std_logic_vector(19 downto 0);
        --variable rom_addr2_2 : std_logic_vector(15 downto 0);
    begin         --      *128                  *64                     *32                         *16
        rom_addr1_7 := (ypix_7 * w_sprite_7) + xpix_7;--(ypix_2 & "0000000") + ("0" & ypix_2 & "000000") + ("00" & ypix_2 & "00000") + ("000" & ypix_2 & "0000");
        --rom_addr2_2 := rom_addr1_2 + ("0000000" & xpix_2);
        Rom_addr16_7 <= rom_addr1_7(14 downto 0);
    end process;




-- Affectation des sorties
    process(M,M_2,M_3,M_4,M_5,M_6,M_7, VIDON, spriteon,spriteon_2,spriteon_3,spriteon_4,spriteon_5,spriteon_6,spriteon_7)
    begin
        if  VIDON = '1' then 
            if spriteon = '1' and M /="111111111111"  then    
                RED <= M(11 downto 8);
                GREEN <= M(7 downto 4);
                BLUE <= M(3 downto 0); --- on affiche l'image contenue dans le M
--                if M="111100000000" then
--                RED <= gpio_3(31 downto 28);
--                GREEN <= gpio_3(27 downto 24);
--                BLUE <= gpio_3(23 downto 20);
--                end if;
--            else 
--            RED <= gpio_1(31 downto 28);
--            GREEN <= gpio1(27 downto 24);
--            BLUE <= gpio1(23 downto 20); -- on affiche le fond qui est dans la gpio0
--            end if;
            
            elsif (spriteon_2 = '1' and M_2 /="111111111111")  then    
                RED <= M_2(11 downto 8);
                GREEN <= M_2(7 downto 4);
                BLUE <= M_2(3 downto 0);
           
            elsif (spriteon_4 = '1' and M_4 /="000000000000")  then    
                RED <= M_4(11 downto 8);
                GREEN <= M_4(7 downto 4);
                BLUE <= M_4(3 downto 0);
 
 
             elsif (spriteon_5 = '1')  then    
                RED <= M_5(11 downto 8);
                GREEN <= M_5(7 downto 4);
                BLUE <= M_5(3 downto 0);
                      
             elsif (spriteon_6 = '1')  then    
                RED <= M_6(11 downto 8);
                GREEN <= M_6(7 downto 4);
                BLUE <= M_6(3 downto 0);
                      
                      
            elsif (spriteon_7 = '1')  then    
                RED <= M_7(11 downto 8);
                GREEN <= M_7(7 downto 4);
                BLUE <= M_7(3 downto 0);
                                            
                                           
--                if M_2="111100000000" then
--                RED <= gpio_1(31 downto 28);
--                GREEN <= gpio_1(27 downto 24);
--                BLUE <= gpio_1(23 downto 20);    --- on affiche l'image contenue dans le M_2
--                end if;
            
            elsif (spriteon_3 = '1')  then    
                RED <= M_3(11 downto 8);
                GREEN <= M_3(7 downto 4);
                BLUE <= M_3(3 downto 0);
            end if;

--        else     
--            RED <= M_3(11 downto 8);
--            GREEN <= M_3(7 downto 4);
--            BLUE <= M_3(3 downto 0); --- on affiche l'image contenue dans le M_3
--        end if;

        else
   
            RED <= "0000";
            GREEN <= "0000";
            BLUE <= "0000";
        end if;

    end process;


end Behavioral;







