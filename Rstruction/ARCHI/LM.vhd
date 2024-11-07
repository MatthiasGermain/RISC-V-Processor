library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Déclaration de l'entité LM
entity LM is
    port (
        funct3  : in  std_logic_vector(2 downto 0);  -- Type de chargement
        res : in  std_logic_vector(1 downto 0);  -- Les deux bits de poids faibles de l'adresse
        data : in  std_logic_vector(31 downto 0); -- Données lues de la mémoire
        dataOut: out std_logic_vector(31 downto 0)  -- Données ajustées à charger
    );
end LM;

-- Architecture du module LM
architecture Behavioral of LM is
 

begin
process(funct3, res, data)
    variable res_h : std_logic_vector(15 downto 0);
    variable res_b : std_logic_vector(7 downto 0);
begin
    case funct3(1 downto 0) is
        when "00" =>  -- Byte access
            -- Sélection de la moitié de mot (Halfword)
            case res(1) is
                when '0' =>
                    res_h := data(15 downto 0);
                when '1' =>
                    res_h := data(31 downto 16);
                when others =>
                    res_h := (others => '0');
            end case;

            -- Sélection de l'octet
            case res(0) is
                when '0' =>
                    res_b := res_h(7 downto 0);
                when '1' =>
                    res_b := res_h(15 downto 8);
                when others =>
                    res_b := (others => '0');
            end case;

            -- Extension de signe ou zéro
            case res_b(7) is
                when '1' => 
                    case funct3(2) is
                        when '0' => -- Case res_b(7) and not funct3(2)
                            dataOut <= "111111111111111111111111" & res_b;
                        when '1' =>
                            dataOut <= "000000000000000000000000" & res_b;
                        when others =>
                            dataOut <= (others => '0'); -- Ajout de when others
                    end case;
                when others =>
                    dataOut <= "000000000000000000000000" & res_b;
            end case;

        when "01" =>  -- Halfword access
            -- Sélection de la moitié de mot
            case res(1) is
                when '0' =>
                    res_h := data(15 downto 0);
                when '1' =>
                    res_h := data(31 downto 16);
                when others =>
                    res_h := (others => '0');
            end case;

            -- Extension de signe ou zéro
            case res_h(15) is
                when '1' => 
                    case funct3(2) is
                        when '0' => -- Case res_h(15) and not funct3(2)
                            dataOut <= "1111111111111111" & res_h;
                        when '1' =>
                            dataOut <= "0000000000000000" & res_h;
                        when others =>
                            dataOut <= (others => '0'); -- Ajout de when others
                    end case;
                when others =>
                    dataOut <= "0000000000000000" & res_h;
            end case;

        when "10" =>  -- Word access
            dataOut <= data;

        when others =>
            dataOut <= (others => '0'); -- Par défaut
    end case;
end process;


end Behavioral;
