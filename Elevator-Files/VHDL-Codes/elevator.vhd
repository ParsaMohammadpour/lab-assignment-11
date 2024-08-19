library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity elevator is
port (
		clk, rst    : in std_logic;
	    in_elev_key    :  in  std_logic_vector(4 downto 1);
        out_elev_key    :  in  std_logic_vector(4 downto 1);
        AC 				: out std_logic_vector(1 downto 0);
		DISP			: out std_logic_vector(2 downto 0);
		is_open			: out std_logic);
end entity elevator;

architecture behavioral of elevator is

begin

process(clk)
type int_array is array (4 downto 1) of integer;
variable next_floor : int_array;

type t_State is (floor1, floor2, floor3, floor4, floor12, floor23, floor34);
variable state : t_State;
variable direction : INTEGER := 0;
variable is_openVar : std_logic := '1';
variable displayVar : integer := 1;
variable reserved_floors : std_logic_vector(4 downto 1) := "0000";
begin
	if rising_edge(Clk) then
		if rst = '1' then
			state := floor1;
			is_openVar := '1';
			displayVar := 1;
		end if;
		if rst = '0' then
			reserved_floors(1) := in_elev_key(1) or out_elev_key(1) or reserved_floors(1);
			reserved_floors(2) := in_elev_key(2) or out_elev_key(2) or reserved_floors(2);
			reserved_floors(3) := in_elev_key(3) or out_elev_key(3) or reserved_floors(3);
			reserved_floors(4) := in_elev_key(4) or out_elev_key(4) or reserved_floors(4);
			case state is
                when floor1 =>
					displayVar := 1;
					is_openVar := reserved_floors(1);
                    if reserved_floors(2) = '1' or reserved_floors(3) = '1' or reserved_floors(4) = '1' then
						direction := 1;
						state := floor12;
					else
						direction := 0;
					end if;
					reserved_floors(1) := '0';
				when floor2 =>
					displayVar := 2;
					is_openVar := reserved_floors(2);
					if direction = 1 then
						if reserved_floors(3) = '1' or reserved_floors(4) = '1' then
							direction := 1;
							state := floor23;
						elsif reserved_floors(1) = '1' then
							direction := 2;
							state := floor12;
						else 
							direction := 0;
						end if;
					else 
						if reserved_floors(1) = '1' then 
							direction := 2;
							state := floor12;
						elsif reserved_floors(3) = '1' or reserved_floors(4) = '1' then
							direction := 1;
							state := floor23;
						else 
							direction := 0;
						end if;
					end if;
					reserved_floors(2) := '0';
				when floor3 =>
					displayVar := 3;
					is_openVar := reserved_floors(3);
					if direction = 1 then
						if reserved_floors(4) = '1' then
							direction := 1;
							state := floor34;
						elsif reserved_floors(1) = '1' or reserved_floors(2) = '1' then
							direction := 2;
							state := floor23;
						else 
							direction := 0;
						end if;
					else 
						if reserved_floors(1) = '1' or reserved_floors(2) = '1' then
							direction := 2;
							state := floor23;
						elsif reserved_floors(4) = '1' then
							direction := 1;
							state := floor34;
						else 
							direction := 0;
						end if;
					end if;
					reserved_floors(3) := '0';
				when floor4 =>
					displayVar := 4;
					is_openVar := reserved_floors(4);
					if reserved_floors(1) = '1' or reserved_floors(2) = '1' or reserved_floors(3) = '1' then
						direction := 2;
						state := floor34;
					else 
						direction := 0;
					end if;
					reserved_floors(4) := '0';
				when floor12 =>
					is_openVar := '0';
					if direction = 1 then
						displayVar := 1;
						state := floor2;
					else
						displayVar := 2;
						state := floor1;
					end if;
				when floor23 =>
					is_openVar := '0';
					if direction = 1 then
						displayVar := 2;
						state := floor3;
					else
						displayVar := 3;
						state := floor2;
					end if;
				when floor34 => 
					is_openVar := '0';
					if direction = 1 then
						displayVar := 3;
						state := floor4;
					else
						displayVar := 4;
						state := floor3;
					end if;
                end case;
		end if;
		is_open <= is_openVar;
		AC <= std_logic_vector(to_unsigned(direction, AC'length));
		DISP <= std_logic_vector(to_unsigned(displayVar, DISP'length));
	end if;
end process;
end behavioral;