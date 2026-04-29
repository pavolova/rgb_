# RGB Mood Lamp 
## Členovia tímu
Miroslav Kaštier (272835) <br>
Viktória Pavolová (270987)
## Abstrakt
Pomocou RGB Mood Lamp dokážeme meniť farby, jas a rýchlosť prechodu medzi farbami. Projekt je realizovaný pomocou 8 módov (červená, zelená, modrá, žltá, cyan, fialová, autofade a OFF - možnosť vypnutia farby). Ďalším prvkom je resetovacie tlačítko. Kód je písaný v jazyku VHDL a implementovaný na dosku Nexys A7-50T.
### Hlavný cieľ
Navrhnúť a implementovať RGB Mood Lamp na FPGA (Nexys A7-50T), ktorá umožňuje:
- plynulé prechody medzi farbami
- manuálne nastavenie jasu a rýchlosti
- ovládanie pomocou tlačidiel

## Rozdelenie rolí
### - Miroslav Kaštier (272835) <br>
Inicializácia git + Vivado, Úprava README.md, editácia demo videa, programovanie častí: debounce, controller
### - Viktória Pavolová (270987) <br>
Úprava README.md, návrh architektúry, tvorba plagátu, programovanie častí: smoothing, PWM, rgb_mood_lamp_top, clk_en, controller

## Lab 1
<img width="1505" height="781" alt="top_level_schematic drawio (1)" src="https://github.com/user-attachments/assets/80f2e0b1-1e64-4d0d-ba08-1c9d4fd60c59" />

## Lab 2 & 3

### CLK_EN <br>

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| en | out | std_logic | One-clock-cycle enable pulse |

### DEBOUNCE <br>
Modul úspešne identifikuje a odstraňuje krátke zákmity napríklad v signáli btnc_in, pričom na výstup btnc_state prepúšťa len stabilné stlačenia bez šumu.
Priebehy potvrdzujú, že blok dokáže paralelne a nezávisle spracovávať signály z viacerých tlačidiel súčasne, čím zaisťuje stabilné ovládanie rôznych funkcií systému.
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

<img width="1252" height="700" alt="debounce-opravene" src="https://github.com/user-attachments/assets/0a643eaa-0bc1-4240-b58b-00dc867929b0" />


<br>

[![Debounce Test Bench](https://img.shields.io/badge/Debounce-TestBench-blue)](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/debounce_tb.vhd)


### CONTROLLER <br>

Slúži ako riadiaca jednotka systému, ktorá na základe užívateľských vstupov generuje cieľové hodnoty pre jednotlivé farebné zložky RGB mood lampy. Blok spracováva požiadavky na zmenu módu, jasu a rýchlosti efektov. Simulačné priebehy zobrazujú schopnosť bloku prepínať medzi definovanými farbami (Red, Green, Blue, Yellow, Cyan, Magenta) a plynule prechádzať do automatického módu, pričom je zachovaná presná synchronizácia všetkých troch farebných kanálov.

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

<img width="1167" height="695" alt="controller-opravene " src="https://github.com/user-attachments/assets/608a3e7e-e924-402a-abb2-38a9f0d42b54" />

<br>

[![Controller Test Bench](https://img.shields.io/badge/Controller-TestBench-blue)](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/controller_tb.vhd)

###  SMOOTHING <br>

Tento modul plní funkciu vyhlazovacieho členu, ktorý zaišťuje plynulé prechody mezi farbami RGB mood lampy. Zabraňuje rušivým skokovým zmenám jasu tým, že postupne aproximuje aktuálnu hodnotu k hodnote cieľovej. Priebehy potvrdzujú, že blok dokáže paralelne a nezávisle spracovávať signály pre všetky tri farebné zložky súčasne, čím zaisťuje plynulé miešanie výsledného farebného spektra.

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

<img width="1159" height="697" alt="smoothing-opravene" src="https://github.com/user-attachments/assets/1e3246fe-6c09-4880-80e5-78ae4f1e4cef" />

<br>

[![Smoothing Test Bench](https://img.shields.io/badge/Smoothing-TestBench-blue)](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/smoothing_tb.vhd)

### PWM <br>

PWM modul slúži ako riadený generátor striedy, ktorý transformuje digitálnu hodnotu jasu na časovo modulovaný výstupný signál. Spravuje šírku impulzu na výstupe pwm_out v rámci každej periódy na základe porovnávania vnútorného čítača so vstupnou hodnotou duty_cycle. Z výsledkov simulácie vidíme, že modul stíha ovládať všetky tri farby (červenú, zelenú aj modrú) naraz a nezávisle od seba. Vďaka tomu, že toto prepínanie prebieha obrovskou rýchlosťou, oko nevidí žiadne blikanie, ale len namiešanú a stabilnú farbu.

| Port name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| clk | in | std_logic | Main clock |
| rst | in | std_logic | High-active synchronous reset |
| duty_cycle | in | std_logic_vector(7 downto 0) | Input intensity (0 to 255) |
| pwm_out | out | std_logic | PWM output signal for LED |

<img width="1251" height="698" alt="pwm-opravene " src="https://github.com/user-attachments/assets/891e7a4b-9d13-4946-8f4b-9bc9734cea11" />

<br>

[![PWM Test Bench](https://img.shields.io/badge/PWM-TestBench-blue)](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/pwm_tb.vhd)

### RGB MOOD LAMP  <br>

Modul spája všetky časti RGM mood lampy do jedného fungujúceho celku. Simulácia nám ukázala, že tento modul úspešne koordinuje prácu všetkých vnútorných blokov naraz. Vďaka tomu lampa okamžite reaguje na stlačenie tlačidla a dokáže plynule meniť farby a jas.

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

<img width="1336" height="696" alt="top_level-opravene2" src="https://github.com/user-attachments/assets/02445429-69c3-4511-90b1-9693c963600a" />


<br>

[![RGB Test Bench](https://img.shields.io/badge/RGB-TestBench-blue)](https://github.com/pavolova/rgb_/blob/main/rgb_mood_lamp1/rgb_mood_lamp.srcs/sim_1/new/rgb_mood_lamp_tb.vhd)

## Lab 4

## Demo video

## Plagát

## Referencie



