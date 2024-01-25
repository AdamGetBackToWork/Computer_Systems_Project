Projekt opracowali: Adam Szajgin, Maciej Gojski, Kacper Kesy

W ramach projektu stworzylismy system skladajacy sie z: 
- ALU
- APB master (bridge)
- UART (master)

Oto schemat systemu:

<p align="center">
  <img src="/jpg/1.png">
</p>

Nasza jednostka ALU wykonuje nastepujace operacje:
- A >> ~B
- A + B
- A/B
- ZM(A) => U2(A)
----------------
- A - 2*B
- A < B
- (A+B)[B] = 0
- U2(A) => ZM(A)
----------------
- ~A >> B
- ~A >= B
- A/B
- ABS(B)



Kontroler APB posiada następujące linie ze standardu:
1. PCLK – (wejście) zegar
2. PRESET – (wejście) reset synchroniczny
3. PADDR – (wyjście) 2 bitową magistralę adresową – pozwalającą w ten
sposób na ewentualne rozszerzenie projektu o dodatkowe moduły
komunikacyjne (pomimo, iż używać będzie na razie tylko jednego
peryferyjnego modułu komunikacji szeregowej)
4. PSELx – (wyjścia) pojedynczy bit dla każdego możliwego urządzenia
(2 bitowa magistrala adresowa, czyli maksymalnie 4 urządzenia)
5. PENABLE – (wyjście) sygnalizacja dla modułu podrzędnego, że może
przyjąć dane, sygnalizacja rozpoczęcia właściwej części transferu
6. PWRITE – (wyjście) Sygnalizacja kierunku obsługi magistrali PWDATA i
PRDATA, zgodnie z opisem APB
7. PWDATA – (wyjście) m-bitowa magistrala danych z kontrolera do urządzeń
podrzędnych
8. PREADY – (wejście) sygnalizacja z urządzenia podrzędnego
9. PRDATA – (wejście) 1-bitowa magistrala danych z urządzeń podrzędnych do
kontrolera, sygnalizacja poprawnie wykonanego transferu
