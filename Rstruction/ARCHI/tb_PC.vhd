library ieee;
use ieee.std_logic_1164.all;

entity tb_PC is
end entity tb_PC;

architecture test of tb_PC is

    -- Déclaration des signaux de test
    signal clk_t         : std_logic := '0';
    signal reset_t       : std_logic := '0';
    signal load_t        : std_logic := '0';
    signal Write_Enable_t: std_logic := '0';
    signal Data_In_t     : std_logic_vector(31 downto 0) := (others => '0');
    signal Data_Out_t    : std_logic_vector(31 downto 0);

    -- Instantiation du composant PC
    component PC is
        generic (
            N : integer := 32
        );
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            load        : in  std_logic;
            Write_Enable: in  std_logic;
            Data_In     : in  std_logic_vector(N-1 downto 0);
            Data_Out    : out std_logic_vector(N-1 downto 0)
        );
    end component;

begin
    -- Instantiation du PC (compteur de programme)
    UUT : PC
        generic map (N => 32)  -- On fixe la taille à 32 bits
        port map (
            clk         => clk_t,
            reset       => reset_t,
            load        => load_t,
            Write_Enable=> Write_Enable_t,
            Data_In     => Data_In_t,
            Data_Out    => Data_Out_t
        );

    -- Processus de génération de l'horloge (période de 20 ns)
    clk_process : process
    begin
        clk_t <= not clk_t after 10 ns;
        wait for 10 ns;
    end process;

    -- Processus de test
    test_process : process
    begin
        -- 1. Reset le registre
        reset_t <= '1';
        wait for 20 ns;
        reset_t <= '0';

        -- 2. Chargement direct avec le signal load
        load_t <= '1';  -- Activer le chargement direct
        Data_In_t <= x"12345678";  -- Valeur arbitraire à charger
        wait for 20 ns;
        load_t <= '0';  -- Désactiver le signal load

        -- 3. Tester l'incrémentation du PC (Write_Enable = 1)
        Write_Enable_t <= '1';  -- Autoriser l'incrémentation
        wait for 40 ns;  -- Attendre deux cycles d'horloge pour vérifier l'incrémentation (PC <- PC + 4)
        Write_Enable_t <= '0';  -- Désactiver l'incrémentation

        -- 4. Charger une nouvelle valeur avec load
        load_t <= '1';  -- Activer le chargement direct à nouveau
        Data_In_t <= x"87654321";  -- Nouvelle valeur à charger
        wait for 20 ns;
        load_t <= '0';

        -- 5. Vérifier que la valeur chargée est conservée
        wait for 40 ns;

        -- Fin de simulation
        wait;
    end process;

end architecture test;
