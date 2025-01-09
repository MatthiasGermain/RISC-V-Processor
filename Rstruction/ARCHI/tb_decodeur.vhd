library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decodeur is
end tb_decodeur;

architecture test of tb_decodeur is
    -- Déclarations des signaux pour la simulation
    signal instr         : std_logic_vector(31 downto 0);  -- Instruction 32 bits
    signal aluOp         : std_logic_vector(3 downto 0);   -- Code opération ALU (sortie)
    signal WriteEnable   : std_logic;                     -- Signal d'écriture dans les registres
    signal load, RI_sel  : std_logic;                     -- Signaux de contrôle
    signal loadAcc       : std_logic;                     -- Signal pour la lecture dans DMEM
    signal wrMem         : std_logic_vector(3 downto 0);  -- Signal d'écriture dans DMEM
    signal res_low       : std_logic_vector(1 downto 0);  -- Bits de poids faibles de l'adresse

begin
    -- Instancier le décodeur
    uut: entity work.decodeur
        port map(
            instr       => instr,
            aluOp       => aluOp,
            WriteEnable => WriteEnable,
            load        => load,
            RI_sel      => RI_sel,
            loadAcc     => loadAcc,
            wrMem       => wrMem,
            res_low     => res_low
        );

    -- Stimulus pour tester différentes instructions
    process
    begin
        -- -------------------
        -- Tests pour les instructions de type STORE
        -- -------------------
        
        -- Instruction SW (Store Word)
        instr <= "00000000001000000010001010100011";  -- SW instruction
        res_low <= "00";
        wait for 10 ns;

        -- Instruction SH (Store Halfword, écrit data[15:0])
        instr <= "00000000001000000001001010100011";  -- SH instruction
        res_low <= "00";  -- Écrit dans les deux premiers octets
        wait for 10 ns;
        res_low <= "10";  -- Écrit dans les deux derniers octets
        wait for 10 ns;

        -- Instruction SB (Store Byte, écrit un seul octet)
        instr <= "00000000001000000000001010100011";  -- SB instruction
        res_low <= "00";  -- Écrit dans l'octet le plus faible
        wait for 10 ns;
        res_low <= "01";  -- Écrit dans le deuxième octet
        wait for 10 ns;
        res_low <= "10";  -- Écrit dans le troisième octet
        wait for 10 ns;
        res_low <= "11";  -- Écrit dans le quatrième octet
        wait for 10 ns;

        -- -------------------
        -- Tests pour les instructions de type LOAD (pour validation croisee)
        -- -------------------

        -- Instruction LW (Load Word)
        instr <= "00000000001000000010000010000011";  -- LW instruction
        wait for 10 ns;

        -- Instruction LB (Load Byte)
        instr <= "00000000001000000000000010000011";  -- LB instruction
        wait for 10 ns;

        -- Instruction LH (Load Halfword)
        instr <= "00000000001000000001000010000011";  -- LH instruction
        wait for 10 ns;

        -- -------------------
        -- Fin de la simulation
        -- -------------------
        wait;
    end process;
end test;