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
<img width="1545" height="698" alt="top_level_schematic (2)" src="https://github.com/user-attachments/assets/6a3ab029-680a-49ee-9911-aa8fa2fba514" />

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

<img width="1006" height="283" alt="image" src="https://github.com/user-attachments/assets/4c44e500-0d43-4773-8843-4037859816a2" />

<br>

[![Debounce Test Bench](https://img.shields.io/badge/Debounce-Test-Bench-blue)](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/debounce_tb.vhd)

[Debounce Test Bench](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/debounce_tb.vhd)

### CONTROLLER <br>

Slúži ako riadiaca jednotka systému, ktorá na základe užívateľských vstupov generuje cieľové hodnoty pre jednotlivé farebné zložky RGB mood lampy. Blok spracováva požiadavky na zmenu módu, jasu a rýchlosti efektov. Simulačné priebehy zobrazujú schopnosť bloku prepínať medzi definovanými farbami (Red, Green, Blue, Yellow, Cyan, Magenta) a plynule prechádzať do automatického módu, pričom je zachovaná presná synchronizácia všetkých troch farebných kanálov.

<img width="1167" height="695" alt="controller-opravene " src="https://github.com/user-attachments/assets/608a3e7e-e924-402a-abb2-38a9f0d42b54" />

![Controller](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/controller_tb.vhd)

[Controller Test Bench](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/controller_tb.vhd)

###  SMOOTHING <br>

Tento modul plní funkciu vyhlazovacieho členu, ktorý zaišťuje plynulé prechody mezi farbami RGB mood lampy. Zabraňuje rušivým skokovým zmenám jasu tým, že postupne aproximuje aktuálnu hodnotu k hodnote cieľovej. Priebehy potvrdzujú, že blok dokáže paralelne a nezávisle spracovávať signály pre všetky tri farebné zložky súčasne, čím zaisťuje plynulé miešanie výsledného farebného spektra.

<img width="1159" height="697" alt="smoothing-opravene" src="https://github.com/user-attachments/assets/1e3246fe-6c09-4880-80e5-78ae4f1e4cef" />


[Smoothing Test Bench](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/smoothing_tb.vhd)

### PWM <br>

PWM modul slúži ako riadený generátor striedy, ktorý transformuje digitálnu hodnotu jasu na časovo modulovaný výstupný signál. Spravuje šírku impulzu na výstupe pwm_out v rámci každej periódy na základe porovnávania vnútorného čítača so vstupnou hodnotou duty_cycle. Z výsledkov simulácie vidíme, že modul stíha ovládať všetky tri farby (červenú, zelenú aj modrú) naraz a nezávisle od seba. Vďaka tomu, že toto prepínanie prebieha obrovskou rýchlosťou, oko nevidí žiadne blikanie, ale len namiešanú a stabilnú farbu.

<img width="1251" height="698" alt="pwm-opravene " src="https://github.com/user-attachments/assets/891e7a4b-9d13-4946-8f4b-9bc9734cea11" />

[PWM Test Bench](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/pwm_tb.vhd)

### RGB MOOD LAMP  <br>

Modul spája všetky časti RGM mood lampy do jedného fungujúceho celku. Simulácia nám ukázala, že tento modul úspešne koordinuje prácu všetkých vnútorných blokov naraz. Vďaka tomu lampa okamžite reaguje na stlačenie tlačidla a dokáže plynule meniť farby a jas.

<img width="1515" height="699" alt="top_level-opravene" src="https://github.com/user-attachments/assets/82640408-806b-4482-9ac5-f71486c0599b" />


[RGM MOOD LAMP Test Bench](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/rgb_mood_lamp_tb.vhd)

