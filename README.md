<h1>Zadání SQL projektu</h1>

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.


<h1>Popis tvorby primární a sekundární tabulky</h1>

<h2>Primární tabulka:</h2>
Primární tabulka je vytvořena ze zdrojů s daty o vývoji mezd (czechia_payroll) a cen jídla (czechia_price) v ČR. Součástí jsou také data o ČR z tabulky economies. Pro snadnější orientaci ve výsledcích byly dále připojeny pomocné tabulky czechia_payroll_industry_branch a czechia_price_category pomocí cizích klíčů. První z nich obsahuje názvy ekonomických odvětví NACE, druhá z nich názvy měřených položek spotřebního koše.

* Z tabulky czechia_price byly vybrány záznamy o roku měření, cenách jídla, kód měřené položky a datu měření. Vybrali jsme pouze měření agregovaná za celou ČR (region_code = NULL).

* Z tabulky czechia_payroll byly vybrány záznamy o mzdě a ekonomickém odvětví NACE. Jelikož tabulka obsahuje jednak záznamy o výši mzdy, jednak o počtu zaměstnanců, specifikovali jsme dotaz pouze na výběr záznamů o výši mzdy. Průměrná hrubá mzda na zaměstnance odpovídá value_type_code = 5958 a pracovali jsme s přepočteným počtem zaměstnanců (calculation_code = 200).

* Z tabulky economies byla vybrána data o HDP a počtu obyvatel. Z těchto dat jsme rovnou vypočetli hdp na obyvatele, tj. vhodný ukazatel pro řešení VO5.

**CTE:**

Údaje o mzdách i cenách potravin byly již při tvorbě primární tabulky agregovány na průměrné hodnoty. Hodnoty v primární tabulce jsou:
* průměrná cena položky jídla za daný rok za celou ČR
* průměrná přepočtená hrubá mzda v daném odvětví za určitý rok v ČR

**Analytická poznámka:**

Agregace cen jídla na roční průměry není zcela ideální pro výpočty u VO4/5. Takto totiž počítáme roční průměr cen jídla z již zprůměrovaných jednotlivých položek jídla a nikoli z jednotlivých primárních měření. Výpočet je tak mírně zkreslený, nicméně vychází velice podobně, jako bychom počítali průměr korektnějším způsobem.
 
**JOIN:**

Tabulky czechia_price a czechia_payroll byly spojeny na základě roku měření. V případě czechia_price k tomu byla využita extrakce roku měření ze sloupce date_from.

Obě tabulky se překrývají v období let 2006 a 2018, toto období bylo využito pro následující analýzu (VO 1-5). Pozn.: položka 212101 “Jakostní víno bílé” - zde je měření dostupné pouze pro období 2015 - 2018.

Tabulka economies byla připojena pomocí roku měření. Vyfiltrovány byly pouze záznamy pro ČR za roky 2006-2018.

<h2>Sekundární tabulka:</h2> 
Sekundární tabulka je vytvořena ze zdrojů s ekonomickými ukazateli (economies). Filtrace dat pouze na evropské země proběhla skrze klauzuli WHERE přes tabulku countries (continent = Europe). 

Do výsledného SELECT příkazu sekundární tabulky jsme vybrali název země, rok, velikost populace, HDP, gini koeficient a vypočtenou míru HDP na obyvatele pro snadnou srovnatelnost mezi evropskými státy. 

**JOIN:**

Spojení tabulek countries a economies přes sloupec country slouží pouze k filtraci dat.
Filtrace dat pouze na evropské země proběhla skrze klauzuli WHERE přes tabulku countries (continent = Europe). Samotná data z tabulky countries nicméně v sekundární tabulce nejsou obsažena (nejsou totiž relevantní).


<h2>Další zjištění o primárních datech:</h2>

**czechia_price:**
* četnost sběru dat o cenách jídla se po roce 2008 snižovala. V roce 2008 proběhlo měření 46x za rok, v roce 2009 pouze 24x, v roce 2010 celkem 22x; od roku 2011 probíhalo měření již pouze 1x měsíčně.
* Data pro kategorii “Jakostní víno bílé” jsou k dispozici pouze za období 2015 - 2018. Kvůli srovnatelnosti byla z analýzy v případě VO 3 tato položka vyřazena. 

**czechia_payroll:**
* hodnoty u value_type_code a unit_code jsou nesmyslně prohozené. Průměrný počet zaměstnaných osob (316) je přiřazen k řádkům s hodnotou v Kč (80403), naopak  Průměrná hrubá mzda na zaměstnance (5958) je přiřazena k řádkům tisíce osob (200).

**economies:**
* U některých zemí chybí záznamy o výši HDP a/nebo o gini koeficientu. V rámci Evropy se to týká především Albánie, Bosny a Hercegoviny, Lichtenštejnska, Monaka a San Marina a území, která jsou součástí jiných států (Faerské ostrovy, Gibraltar).  


<h1>Odpovědi na výzkumné otázky</h1>

<h2>Q1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?</h2>

>>Mzdy ve všech odvětvích mezi lety 2006 a 2018 **vzrostly**. V průměru se mzdy v ČR za 13 let zvýšily o 64 % z 19,5 tisíce na 32 tisíc.

V průběhu sledovaného období docházelo v některých odvětvích k meziroční stagnaci nebo i poklesu mezd. Meziroční pokles mezd se projevil především mezi lety 2012 a 2013 v 11 odvětvích z celkových 18. Jednoznačně největší relativní pokles (2012/2013: -8,8 %) zaznamenalo Peněžnictví a pojišťovnictví (K); hodnoty průměrné mzdy v tomto odvětví z roku 2012 byly překonány až v roce 2017. 

<h2>Q2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?</h2>

 **Předpoklady / poznámky:**

* Budeme vycházet z průměrné mzdy za celou ČR v daném roce za počátek a konec období, k němuž máme data pro mzdy i ceny zboží (tj. roky 2006 a 2018).
* (*) Sledují se průměrné hrubé mzdy. Hypoteticky uvažujeme, že celá hrubá mzda zůstane zaměstnanci. Reálnější by bylo korigovat výslednou hodnotu hrubé mzdy nějakým realistickým koeficientem (0,8).
* Počítáme s průměrnou cenou zboží za celý rok a celou ČR.

>>V roce **2006** si bylo možné za průměrnou mzdu (*) koupit **1212 kg chleba** nebo **1353 litrů mléka**. Průměrná kupní síla obyvatel (měřeno těmito položkami) byla v roce 2018 o 9 %, resp. bezmála o 20 % >>vyšší, kdy bylo možné za průměrnou mzdu nakoupit již **1322 kg chleba** nebo **1617 litrů mléka**.

<h2>Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?</h2>

Meziroční srovnání cen u většiny kategorií sledovaných potravin poměrně výrazně fluktuuje. Neexistuje meziroční lineární nárůst cen, ale období zdražování a zlevňování, případně cenové stagnace. Smysl tedy dává spíše srovnání z dlouhodobější perspektivy, tedy srovnání cen z počátku a konce sledovaného období.


>> Srovnáme-li takto ceny z let 2018 a 2006, můžeme konstatovat, že “nejpomaleji zdražuje” položka **Banány žluté** (v průměru o 7,4 % / rok). 

U dvou položek z celkových 27 došlo za sledované období dokonce ke zlevnění: Rajská jablka červená kulatá zlevnila v průměru o 23 % a Cukr krystalový o 27,5 %.
  

<h2>Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (více než 10 %)?</h2>

**Interpretace otázky:**
Když vezmeme průměr všech cen potravin za daný rok a rok následující, je nárůst u potravin o více než 10 % vyšší než nárůst všech mezd za daný YOY? Pokud ano, u kterých let to takto je?

>>Mezi lety 2006 - 2018 k této situaci **nedošlo**. 
Nejvíce se této situaci blížilo meziroční srovnání vývoje cen potravin a mezd 2012/2013, kdy mzdy stagnovaly a ceny jídla vzrostly o 5,1 % (rozdíl růst mezd - růst cen potravin = -5,2%). Opačná situace nastala v meziročním srovnání 2008/2009, kdy mzdy mírně vzrostly a potraviny zlevnily (rozdíl růst mezd - růst cen potravin = 9,8 %).


<h2>Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?</h2>

<h4>Shrnutí:</h4>

V případě ČR ve sledovaném období pozorujeme vztah mezi růstem HDP/obyvatele a růstem mezd. Většinou totiž platí, že pokud v jednom roce výrazněji vzroste HDP/obyv., v daném (a často i následujícím) roce vzrostou výrazněji také mzdy (2007-2008, 2017-2018). Nicméně meziroční nárůsty cen jídla jsou mnohem více rozkolísané. V některých letech rostou spolu s HDP/obyv. (2007-2008 a  2017), jindy jsou v protipohybu k HDP/obyv. (2012-2013 a 2015). 

>>
>> Hypotéza o vztahu mezi výrazným růstem HDP/obyv. a **růstem mezd sedí na data** o ČR 2006-2018. V případě **cen jídla** tento vztah spíše **neplatí**.

<h4>Diskuze:</h4>

Korektní odpověď na tuto otázku vyžaduje zpřesnění parametrů hypotézy. Především je důležité vyjasnit si, co znamená “výrazný růst”. K řešení této nejasnosti můžeme například přistoupit přes navázání definice “výrazného růstu” na hodnotu průměru meziročního růstu. Průměrný meziroční růst HDP/obyv. v ČR mezi lety 2006-2018 byl 1,8 %. Průměrný meziroční růst cen
jídla 2,9 %, mzdy rostly v průměru o 4,2 %. 

Pro účel úkolu definujeme **“výrazný růst”** jako meziroční nárůst hodnoty o minimálně 1,5 násobek průměru HDP/obyv., resp. mezd / cen jídla. Sledujeme tedy, zda v případě let s 3,2% růstem HDP/obyv. vzrostou ve stejném nebo následujícím roce mzdy o minimálně 6,4 %, resp. ceny jídla o minimálně 4,3 %. 

![q_5_table](https://github.com/user-attachments/assets/8f707671-0460-4c63-911d-4541482eea6f)

**Definovaný “výrazný růst” HDP/obyv. nastal v letech 2007, 2015, 2017 a 2018.**

<h4>Argumenty:</h4>

**Pro ponechání hypotézy:** 
* V roce 2007 a 2008 výrazně vzrostly jednak mzdy, jednak ceny jídla.
* V roce 2017 a 2018 výrazně vzrostly mzdy; ceny jídla výrazně vzrostly pouze v roce 2017 (avšak nikoli v roce 2018).

**Pro zamítnutí hypotézy:** 
* Růst HDP/obyv. v roce 2015 se neprojevil ani v růstu mezd ani v růstu cen jídla (a to ani v následujícím roce).
* V letech 2012 a 2013 HDP/obyv. stagnovalo / mírně klesalo, přesto jsme zaznamenali výrazný růst cen jídla v obou letech.


