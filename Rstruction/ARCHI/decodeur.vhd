library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decodeur is
    port (
        instr       : in  std_logic_vector(31 downto 0);  -- Instruction de 32 bits
        aluOp       : out std_logic_vector(3 downto 0);   -- Code opératoire ALU
        WriteEnable : out std_logic;                      -- Signal d'écriture dans le registre
        load        : out std_logic;                      -- Signal pour le compteur
        RI_sel      : out std_logic;                      -- Sélection d'instructions R ou I
        wrMem       : out std_logic_vector(3 downto 0);   -- Signal d'écriture dans DMEM
        loadAcc     : out std_logic;                      -- Signal de lecture DMEM
        lwtype      : out std_logic_vector(2 downto 0);   -- Sortie pour le LM
        res_low     : in  std_logic_vector(1 downto 0)    -- Bits de poids faibles de l'adresse
    );
end entity decodeur;

architecture Behavioral of decodeur is
begin
    -- Processus combinatoire pour réagir immédiatement aux changements de "instr"
    process(instr, res_low)
    begin
        -- Initialisation des signaux
        WriteEnable <= '1';  -- Active l'écriture dans les registres
        load <= '0';         -- Désactive le compteur (PC)
        RI_sel <= '0';       -- Initialisation de RI_sel
        aluOp <= "XXXX";     -- Valeur par défaut pour aluOp
        wrMem <= "0000";     -- Par défaut, pas d'écriture en mémoire
        loadAcc <= '0';      -- Par défaut, lecture d'accumulateur désactivée
        lwtype <= instr(14 downto 12); -- funct3

        -- Récupérer les champs funct3 et funct7
        case instr(6 downto 0) is
            -- Instructions STORE (opcode = "0100011")
            when "0100011" =>
                RI_sel <= '1';   -- Type I (base pour calcul d'adresse)
                loadAcc <= '0';  -- Pas de lecture pour LOAD
                aluOp <= "0000"; -- ALU effectue un ADD pour calculer l'adresse
                case instr(14 downto 12) is
                    -- sw : écriture d'un mot complet (4 octets)
                    when "010" => wrMem <= "1111";

                    -- sh : écriture de 16 bits (2 octets)
                    when "001" =>
                        if res_low = "00" then
                            wrMem <= "0011"; -- Écrit data[15:0]
                        elsif res_low = "10" then
                            wrMem <= "1100"; -- Écrit data[31:16]
                        else
                            wrMem <= "0000"; -- Cas non valide pour sh
                        end if;

                    -- sb : écriture d'un octet
                    when "000" =>
                        case res_low is
                            when "00" => wrMem <= "0001"; -- Écrit data[7:0]
                            when "01" => wrMem <= "0010"; -- Écrit data[15:8]
                            when "10" => wrMem <= "0100"; -- Écrit data[23:16]
                            when "11" => wrMem <= "1000"; -- Écrit data[31:24]
                            when others => wrMem <= "0000"; -- Pas d'écriture
                        end case;

                    -- Instruction non reconnue
                    when others => wrMem <= "0000";
                end case;

            -- Autres instructions
            when others =>
                WriteEnable <= '1';
                loadAcc <= '0';
                wrMem <= "0000";
        end case;
    end process;
end architecture Behavioral;
