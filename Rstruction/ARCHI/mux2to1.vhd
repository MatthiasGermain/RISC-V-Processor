library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
    generic (
        WIDTH : integer := 32  -- Taille des entrées et de la sortie (par défaut 32 bits)
    );
    port (
        sel : in  std_logic;                           -- Sélection du multiplexeur
        mux_in1   : in  std_logic_vector(WIDTH-1 downto 0);  -- Entrée 1
        mux_in2   : in  std_logic_vector(WIDTH-1 downto 0);  -- Entrée 2
        mux_out   : out std_logic_vector(WIDTH-1 downto 0)   -- Sortie
    );
end entity mux2to1;

architecture Behavioral of mux2to1 is
begin
    process(sel, mux_in1, mux_in2)
    begin
        if sel = '0' then
            mux_out <= mux_in1;  -- Si sel = '0', sortie prend la valeur de a
        else
            mux_out <= mux_in2;  -- Si sel = '1', sortie prend la valeur de b
        end if;
    end process;
end architecture Behavioral;
