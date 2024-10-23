library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decodeur is
end tb_decodeur;

architecture test of tb_decodeur is
    -- Déclarations des signaux pour la simulation
    signal instr : std_logic_vector(31 downto 0);  -- Instruction 32 bits
    signal aluOp : std_logic_vector(3 downto 0);   -- Code opération ALU (sortie)
    signal WriteEnable, load, RI_sel : std_logic;  -- Signaux de contrôle

begin
    -- Instancier le décodeur
    uut: entity work.decodeur
        port map(
            instr => instr,
            aluOp => aluOp,
            WriteEnable => WriteEnable,
            load => load,
            RI_sel => RI_sel
        );
    
    -- Stimulus pour tester différentes instructions
    process
    begin
        -- -------------------
        -- Tests pour les instructions de type R
        -- -------------------
        
        -- Instruction ADD (Type R)
        instr <= "00000000001000001000000010110011";  -- ADD instruction
        wait for 10 ns;
        
        -- Instruction SUB (Type R)
        instr <= "01000000001000001000000010110011";  -- SUB instruction
        wait for 10 ns;
        
        -- Instruction SLL (Type R)
        instr <= "00000000001000001001000010110011";  -- SLL instruction
        wait for 10 ns;
        
        -- Instruction SLT (Type R)
        instr <= "00000000001000001010000010110011";  -- SLT instruction
        wait for 10 ns;
        
        -- Instruction SLTU (Type R)
        instr <= "00000000001000001011000010110011";  -- SLTU instruction
        wait for 10 ns;
        
        -- Instruction XOR (Type R)
        instr <= "00000000001000001100000010110011";  -- XOR instruction
        wait for 10 ns;
        
        -- Instruction SRL (Type R)
        instr <= "00000000001000001101000010110011";  -- SRL instruction
        wait for 10 ns;
        
        -- Instruction SRA (Type R)
        instr <= "01000000001000001101000010110011";  -- SRA instruction
        wait for 10 ns;
        
        -- Instruction OR (Type R)
        instr <= "00000000001000001110000010110011";  -- OR instruction
        wait for 10 ns;
        
        -- Instruction AND (Type R)
        instr <= "00000000001000001111000010110011";  -- AND instruction
        wait for 10 ns;
        
        -- -------------------
        -- Tests pour les instructions de type I
        -- -------------------
        
        -- Instruction ADDI (Type I)
        -- funct7 est inutile dans ce cas, seulement funct3 et immediate
        instr <= "00000000001000001000001010010011";  -- ADDI instruction
        wait for 10 ns;
        
        -- Instruction SLTI (Type I)
        instr <= "00000000001000001010001010010011";  -- SLTI instruction
        wait for 10 ns;
        
        -- Instruction SLTIU (Type I)
        instr <= "00000000001000001011001010010011";  -- SLTIU instruction
        wait for 10 ns;
        
        -- Instruction XORI (Type I)
        instr <= "00000000001000001100001010010011";  -- XORI instruction
        wait for 10 ns;
        
        -- Instruction ORI (Type I)
        instr <= "00000000001000001110001010010011";  -- ORI instruction
        wait for 10 ns;
        
        -- Instruction ANDI (Type I)
        instr <= "00000000001000001111001010010011";  -- ANDI instruction
        wait for 10 ns;
        
        -- Instruction SLLI (Type I)
        instr <= "00000000001000001001001010010011";  -- SLLI instruction
        wait for 10 ns;
        
        -- Instruction SRLI (Type I)
        instr <= "00000000001000001101001010010011";  -- SRLI instruction
        wait for 10 ns;
        
        -- Instruction SRAI (Type I)
        instr <= "01000000001000001101001010010011";  -- SRAI instruction
        wait for 10 ns;

        -- Fin de la simulation
        wait;
    end process;
end test;
