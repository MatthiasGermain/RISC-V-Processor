library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DM is
    generic (
        DATA_WIDTH : natural := 32;   -- Largeur des données (32 bits)
        ADDR_WIDTH : natural := 8    -- Largeur de l'adresse (8 bits pour une mémoire de 256 octets)
    );
    port (
        addr    : in std_logic_vector(ADDR_WIDTH-1 downto 0); -- Adresse
        data    : in std_logic_vector(DATA_WIDTH-1 downto 0); -- Données à écrire
        wrMem   : in std_logic_vector(3 downto 0);            -- Signal de contrôle pour écriture
        q       : out std_logic_vector(DATA_WIDTH-1 downto 0) -- Données lues
    );
end DM;

architecture Behavioral of DM is
    -- Mémoire organisée en octets (8 bits par emplacement)
    type memory_array is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0);
    signal mem : memory_array := (others => (others => '0')); -- Mémoire initialisée à 0
begin
    process (addr, data, wrMem)
        variable addr_aligned : integer range 0 to 2**ADDR_WIDTH/4 - 1; -- Adresse alignée sur des mots de 4 octets
    begin
        -- Aligner l'adresse sur des mots de 4 octets (ADDR_WIDTH-1 downto 2)
        addr_aligned := to_integer(unsigned(addr(ADDR_WIDTH-1 downto 2)));

        -- Écriture dans la mémoire conditionnée par wrMem
        if wrMem(0) = '1' then
            mem(addr_aligned * 4) <= data(7 downto 0); -- Premier octet
        end if;
        if wrMem(1) = '1' then
            mem(addr_aligned * 4 + 1) <= data(15 downto 8); -- Deuxième octet
        end if;
        if wrMem(2) = '1' then
            mem(addr_aligned * 4 + 2) <= data(23 downto 16); -- Troisième octet
        end if;
        if wrMem(3) = '1' then
            mem(addr_aligned * 4 + 3) <= data(31 downto 24); -- Quatrième octet
        end if;

        -- Lecture : q reflète toujours la mémoire à l'adresse alignée
        q <= mem(addr_aligned * 4 + 3) & mem(addr_aligned * 4 + 2) &
             mem(addr_aligned * 4 + 1) & mem(addr_aligned * 4);
    end process;

end Behavioral;
