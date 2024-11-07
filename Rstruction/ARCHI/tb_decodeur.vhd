library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decodeur is
end tb_decodeur;

architecture test of tb_decodeur is
    -- Déclarations des signaux pour la simulation
    signal instr     : std_logic_vector(31 downto 0);  -- Instruction 32 bits
    signal aluOp     : std_logic_vector(3 downto 0);   -- Code opération ALU (sortie)
    signal WriteEnable, load, RI_sel : std_logic;      -- Signaux de contrôle
    signal loadAcc, wrMem : std_logic;                 -- Signaux pour le multiplexeur de dmem

begin
    -- Instancier le décodeur
    uut: entity work.decodeur
        port map(
            instr => instr,
            aluOp => aluOp,
            WriteEnable => WriteEnable,
            load => load,
            RI_sel => RI_sel,
            loadAcc => loadAcc,
            wrMem => wrMem
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
        
        -- Instructions supplémentaires de type R...

        -- -------------------
        -- Tests pour les instructions de type I
        -- -------------------

        -- Instruction ADDI (Type I)
        instr <= "00000000001000001000001010010011";  -- ADDI instruction
        wait for 10 ns;
        
        -- Instruction SLTI (Type I)
        instr <= "00000000001000001010001010010011";  -- SLTI instruction
        wait for 10 ns;

        -- Instructions supplémentaires de type I...

        -- -------------------
        -- Tests pour les instructions de type LOAD
        -- -------------------
        
        -- Instruction LB (Load Byte)
        instr <= "00000000001000000000000010000011";  -- LB instruction
        wait for 10 ns;
        
        -- Instruction LH (Load Halfword)
        instr <= "00000000001000000001000010000011";  -- LH instruction
        wait for 10 ns;
        
        -- Instruction LW (Load Word)
        instr <= "00000000001000000010000010000011";  -- LW instruction
        wait for 10 ns;
        
        -- Instruction LBU (Load Byte Unsigned)
        instr <= "00000000001000000100000010000011";  -- LBU instruction
        wait for 10 ns;
        
        -- Instruction LHU (Load Halfword Unsigned)
        instr <= "00000000001000000101000010000011";  -- LHU instruction
        wait for 10 ns;

        -- Fin de la simulation
        wait;
    end process;
end test;