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
		  wrMem		  : out std_logic;							 -- Ecrire dans DMEM ou non
		  loadAcc	  : out std_logic		;						 -- Signal de lecture DMEM
		  lwtype 	  : out std_logic_vector(2 downto 0)	 -- Sortie pour le LM
    );
end entity decodeur;

architecture Behavioral of decodeur is
begin
    -- Processus combinatoire pour réagir immédiatement aux changements de "instr"
    process(instr)
	begin
		 -- Initialisation des signaux
		 WriteEnable <= '1';  -- Active l'écriture dans les registres
		 load <= '0';         -- Désactive le compteur (PC)
		 RI_sel <= '0';       -- Initialisation de RI_sel
		 aluOp <= "XXXX";     -- Valeur par défaut pour aluOp
		 wrMem <= '0';        -- Par défaut, écriture mémoire désactivée
		 loadAcc <= '0';      -- Par défaut, lecture d'accumulateur désactivée
		 lwtype <= instr(14 downto 12); -- funct3

		 -- Récupérer les champs funct3 et funct7
		 case instr(6 downto 0) is
			  -- Instructions de type R (opcode = "0110011")
			  when "0110011" =>
					RI_sel <= '0';  -- Instruction de type R
					loadAcc <= '0';  -- Désactive la lecture mémoire pour le bloc dmem
					wrMem <= '0';    -- Pas d'écriture dans la mémoire pour les instructions R
					case instr(14 downto 12) & instr(31 downto 25) is
						 when "000" & "0000000" => aluOp <= "0000";  -- ADD
						 when "000" & "0100000" => aluOp <= "0001";  -- SUB
						 when "001" & "0000000" => aluOp <= "0010";  -- SLL
						 when "010" & "0000000" => aluOp <= "0011";  -- SLT
						 when "011" & "0000000" => aluOp <= "0100";  -- SLTU
						 when "100" & "0000000" => aluOp <= "0101";  -- XOR
						 when "101" & "0000000" => aluOp <= "0110";  -- SRL
						 when "101" & "0100000" => aluOp <= "0111";  -- SRA
						 when "110" & "0000000" => aluOp <= "1000";  -- OR
						 when "111" & "0000000" => aluOp <= "1001";  -- AND
						 when others => aluOp <= "XXXX";  -- Instruction non reconnue
					end case;

			  -- Instructions de type I (opcode = "0010011")
			  when "0010011" =>
					RI_sel <= '1';  -- Instruction de type I
					loadAcc <= '0';  -- Désactive la lecture mémoire pour le bloc dmem
					wrMem <= '0';    -- Pas d'écriture dans la mémoire pour les instructions I
					case instr(14 downto 12) is
						 when "000" => aluOp <= "0000";  -- ADDI
						 when "001" => aluOp <= "0010";  -- SLLI
						 when "010" => aluOp <= "0011";  -- SLTI
						 when "011" => aluOp <= "0100";  -- SLTIU
						 when "100" => aluOp <= "0101";  -- XORI
						 when "101" =>
							  if instr(30) = '0' then
									aluOp <= "0110";  -- SRLI
							  else
									aluOp <= "0111";  -- SRAI
							  end if;
						 when "110" => aluOp <= "1000";  -- ORI
						 when "111" => aluOp <= "1001";  -- ANDI
						 when others => aluOp <= "XXXX";  -- Instruction non reconnue
					end case;

			  -- Instructions de type LOAD (opcode = "0000011")
			  when "0000011" =>
					RI_sel <= '1';   -- Instructions LOAD utilisent un type I pour les opérations
					loadAcc <= '1';  -- Activer la lecture pour le multiplexeur du bloc dmem
					wrMem <= '0';    -- Pas d'écriture dans la mémoire pour les instructions LOAD
					lwtype <= instr(14 downto 12); -- funct3
					aluOp <= "0000";

			  -- Instructions non reconnues
			  when others =>
					aluOp <= "XXXX";  -- Valeur par défaut si l'opcode n'est pas reconnu
					loadAcc <= '0';
					wrMem <= '1';
					
		 end case;
	end process;
end architecture Behavioral;
