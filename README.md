# RGB Mood Lamp 
## Členovia tímu
Miroslav Kaštier (272835) <br>
Viktória Pavolová (270987)
### Hlavný cieľ
Navrhnúť a implementovať RGB Mood Lamp na FPGA (Nexys A7-50T), ktorá umožňuje:
- plynulé prechody medzi farbami
- manuálne nastavenie jasu a rýchlosti
- ovládanie pomocou tlačidiel

## Rozdelenie rolí
### - Miroslav Kaštier (272835) <br>
Inicializácia git + Vivado, Úprava README.md, programovanie častí: debounce, controller
### - Viktória Pavolová (270987) <br>
Úprava README.md, návrh architektúry, programovanie častí: smoothing, PWM, rgb_mood_lamp_top, clk_en

## Lab 1
<img width="1307" height="597" alt="top_level_schematic" src="https://github.com/user-attachments/assets/f296e955-0ce6-4d35-b63b-75a03cbffa5d" />



### RGB Mood Lamp <br>

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| btnc | in | std_logic | Mode button |
| btnu | in | std_logic | Brightness control button |
| btnd | in | std_logic | Speed control button |
| LED16_r | out | std_logic | Red LED output |
| LED16_g | out | std_logic | Green LED output |
| LED16_b | out | std_logic | Blue LED output |


### debounce <br>

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| btnc_in | in | std_logic | Raw input from center button |
| btnu_in | in | std_logic | Raw input from up button |
| btnd_in | in | std_logic | Raw input from down button |
| btnc_state | out | std_logic | Debounced state of center button |
| btnu_state | out | std_logic | Debounced state of up button |
| btnd_state | out | std_logic | Debounced state of down button |

### clk_en <br>

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| en | out | std_logic | One-clock-cycle enable pulse |

### controller <br>

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| ce | in | std_logic | Clock enable signal |
| mode | in | std_logic | Mode control (from btnc_state) |
| bright | in | std_logic | Bright control (from btnu_state) |
| speed | in | std_logic | Speed control (from btnd_state) |
| target_r | out | std_logic_vector(7 downto 0) | Target value for red component |
| target_g | out | std_logic_vector(7 downto 0) | Target value for green component |
| target_b | out | std_logic_vector(7 downto 0) | Target value for blue component |

### smoothing <br>

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| ce | in | std_logic | Clock enable signal |
| target_r | in | std_logic_vector(7 downto 0) | Input target red value |
| target_g | in | std_logic_vector(7 downto 0) | Input target green value |
| target_b | in | std_logic_vector(7 downto 0) | Input target blue value |
| current_r | out | std_logic_vector(7 downto 0) | Current smoothed red value |
| current_g | out | std_logic_vector(7 downto 0) | Current smoothed green value |
| current_b | out | std_logic_vector(7 downto 0) | Current smoothed blue value |

### PWM <br>

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| duty_cycle | in | std_logic_vector(7 downto 0) | Input intensity (0 to 255) |
| pwm_out | out | std_logic | PWM output signal for LED |

## Lab 2

### DEBOUNCE <br>

Modul úspešne identifikuje a odstraňuje krátke zákmity napríklad v signáli btnc_in, pričom na výstup btnc_state prepúšťa len stabilné stlačenia bez šumu.
Priebehy potvrdzujú, že blok dokáže paralelne a nezávisle spracovávať signály z viacerých tlačidiel súčasne, čím zaisťuje stabilné ovládanie rôznych funkcií systému.

<img width="1000" height="450" alt="debounce" src="https://github.com/user-attachments/assets/bbbc1424-7847-4a83-a9ad-2ae9bbd1a1e7" />

### CLOCK ENABLE <br>

Zabezpečuje, aby nadväzujúce bloky nepracovali na plnej rýchlosti hlavných hodín, ale v dlhších, presne definovaných intervaloch. Modul čaká na uvoľnenie resetu, a potom v pravidelných intervaloch "prepúšťa" jeden hodinový impulz do signálu enable, čím efektívne spomaľuje činnosť nadväzujúcej logiky.

<img width="1000" height="550" alt="clk_en" src="https://github.com/user-attachments/assets/a6d04ff4-d67c-433b-a6a2-8938de2f46af" />


### CONTROLLER <br>

Slúži ako riadiaca jednotka systému, ktorá na základe užívateľských vstupov generuje cieľové hodnoty pre jednotlivé farebné zložky RGB mood lampy. Blok spracováva požiadavky na zmenu módu, jasu a rýchlosti efektov. Simulačné priebehy zobrazujú schopnosť bloku prepínať medzi definovanými farbami (Red, Green, Blue, Yellow, Cyan, Magenta) a plynule prechádzať do automatického módu, pričom je zachovaná presná synchronizácia všetkých troch farebných kanálov.

<img width="1000" height="550" alt="controller" src="https://github.com/user-attachments/assets/55c97bd9-98d5-4caf-b76f-87370df22e1f" />


###  SMOOTHING <br>

Tento modul plní funkciu vyhlazovacieho členu, ktorý zaišťuje plynulé prechody mezi farbami RGB mood lampy. Zabraňuje rušivým skokovým zmenám jasu tým, že postupne aproximuje aktuálnu hodnotu k hodnote cieľovej. Priebehy potvrdzujú, že blok dokáže paralelne a nezávisle spracovávať signály pre všetky tri farebné zložky súčasne, čím zaisťuje plynulé miešanie výsledného farebného spektra.

<img width="1000" height="550" alt="smoothing" src="https://github.com/user-attachments/assets/66c98408-0b2b-40e0-a797-1715cbbfb513" />

### PWM <br>

PWM modul slúži ako riadený generátor striedy, ktorý transformuje digitálnu hodnotu jasu na časovo modulovaný výstupný signál. Spravuje šírku impulzu na výstupe pwm_out v rámci každej periódy na základe porovnávania vnútorného čítača so vstupnou hodnotou duty_cycle. Z výsledkov simulácie vidíme, že modul stíha ovládať všetky tri farby (červenú, zelenú aj modrú) naraz a nezávisle od seba. Vďaka tomu, že toto prepínanie prebieha obrovskou rýchlosťou, oko nevidí žiadne blikanie, ale len namiešanú a stabilnú farbu.

<img width="1000" height="550" alt="pwm2" src="https://github.com/user-attachments/assets/53dd987c-4ab6-4c6f-b533-790072845f61" />

### RGB MOOD LAMP  <br>

Modul spája všetky časti RGM mood lampy do jedného fungujúceho celku. Simulácia nám ukázala, že tento modul úspešne koordinuje prácu všetkých vnútorných blokov naraz. Vďaka tomu lampa okamžite reaguje na stlačenie tlačidla a dokáže plynule meniť farby a jas.

<img width="1000" height="550" alt="top_level" src="https://github.com/user-attachments/assets/4705b20f-2895-47dd-b08b-278fa5f2971b" />
