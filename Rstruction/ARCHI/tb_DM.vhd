library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_DM is
end tb_DM;

architecture Behavioral of tb_DM is
    -- Composant sous test
    component DM
        generic (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 8
        );
        port (
            addr    : in std_logic_vector(ADDR_WIDTH-1 downto 0);
            data    : in std_logic_vector(DATA_WIDTH-1 downto 0);
            wrMem   : in std_logic_vector(3 downto 0);
            q       : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    -- Signaux pour le test
    signal addr : std_logic_vector(7 downto 0);
    signal data : std_logic_vector(31 downto 0);
    signal wrMem : std_logic_vector(3 downto 0);
    signal q : std_logic_vector(31 downto 0);

begin
    -- Instanciation du composant sous test
    uut: DM
        port map (
            addr  => addr,
            data  => data,
            wrMem => wrMem,
            q     => q
        );

    -- Processus de test
    process
    begin
        -- Cas 1: Écriture de 32 bits (sw)
        addr <= x"00";
        data <= x"12345678";
        wrMem <= "1111";
        wait for 10 ns;
		  
        -- Lecture
        addr <= x"00";
        wrMem <= "0000"; -- Lecture seulement
        wait for 10 ns;
        
        -- Cas 2: Écriture de 16 bits (sh)
        addr <= x"04";
        data <= x"AAAAABCD";
        wrMem <= "0011";
        wait for 10 ns;
		 
		  -- Lecture
        addr <= x"04";
        wrMem <= "0000"; -- Lecture seulement
        wait for 10 ns;

        -- Cas 3: Écriture d'un octet (sb)
        addr <= x"10";
        data <= x"0000EEEF";
        wrMem <= "0001";
        wait for 10 ns;
		  
        -- Lecture
        addr <= x"10";
        wrMem <= "0000"; -- Lecture seulement
        wait for 10 ns;

		 -- Cas 4: Écriture d'un octet (sb)
        addr <= x"08";
        data <= x"0000EEEF";
        wrMem <= "0010";
        wait for 10 ns;
		  
		 -- Lecture
        addr <= x"08";
        wrMem <= "0000"; -- Lecture seulement
        wait for 10 ns;

        -- Fin du test
        wait;
    end process;
end Behavioral;
