# ================================================================================================================================
# database_studenti.asm  -  Dati statici iniziali (50 studenti)
# Includere nel .data del file principale con:
#     .include "database_studenti.asm"
#
# Capienza Massima Database: 100 studenti
# Offset esami: studente i -> slot base = i*20 (max 20 esami)
#   exam_name:    base * 46 byte  (ogni nome = 45 char + \0)
#   exam_credits: base * 4 byte
#   exam_grade:   base * 4 byte

#N.B. per testare il case 4 ho messo 2 volte il cognome Rossi (studente 0 e 1)
# ================================================================================================================================1
 .data

# ── STUDENTE 0 ──
_db_name0:      .asciiz "Marco"
_db_surname0:   .asciiz "Rossi"
_db_id0:        .word 1001
_db_age0:       .word 20
_db_year0:      .word 2022
_db_nexams0:    .word 15
_db_active0:    .word 1
_db_e0_0_name:  .asciiz "Analisi Matematica I"
_db_e0_0_cred:  .word 9
_db_e0_0_grad:  .word 28
_db_e0_1_name:  .asciiz "Geometria e Algebra"
_db_e0_1_cred:  .word 6
_db_e0_1_grad:  .word 24
_db_e0_2_name:  .asciiz "Fisica I"
_db_e0_2_cred:  .word 6
_db_e0_2_grad:  .word 30
_db_e0_3_name:  .asciiz "Informatica (programmazione)"
_db_e0_3_cred:  .word 6
_db_e0_3_grad:  .word 27
_db_e0_4_name:  .asciiz "Chimica per l'ingegneria elettronica"
_db_e0_4_cred:  .word 6
_db_e0_4_grad:  .word 25
_db_e0_5_name:  .asciiz "Informatica (calcolatori elettronici)"
_db_e0_5_cred:  .word 6
_db_e0_5_grad:  .word 28
_db_e0_6_name:  .asciiz "Economia e Organizzazione Aziendale"
_db_e0_6_cred:  .word 6
_db_e0_6_grad:  .word 22
_db_e0_7_name:  .asciiz "Analisi dei dati"
_db_e0_7_cred:  .word 6
_db_e0_7_grad:  .word 26
_db_e0_8_name:  .asciiz "Fisica II"
_db_e0_8_cred:  .word 6
_db_e0_8_grad:  .word 29
_db_e0_9_name:  .asciiz "Elettronica Analogica e Digitale"
_db_e0_9_cred:  .word 8
_db_e0_9_grad:  .word 24
_db_e0_10_name: .asciiz "Automazione industriale"
_db_e0_10_cred: .word 6
_db_e0_10_grad: .word 27
_db_e0_11_name: .asciiz "Tecnologie dei sistemi di controllo"
_db_e0_11_cred: .word 6
_db_e0_11_grad: .word 28
_db_e0_12_name: .asciiz "Optoelettronica"
_db_e0_12_cred: .word 6
_db_e0_12_grad: .word 30
_db_e0_13_name: .asciiz "Misure elettroniche"
_db_e0_13_cred: .word 6
_db_e0_13_grad: .word 25
_db_e0_14_name: .asciiz "Dispositivi Elettronici"
_db_e0_14_cred: .word 6
_db_e0_14_grad: .word 26

# ── STUDENTE 1 ──
_db_name1:      .asciiz "Giulia"
_db_surname1:   .asciiz "Rossi"
_db_id1:        .word 1002
_db_age1:       .word 21
_db_year1:      .word 2021
_db_nexams1:    .word 20
_db_active1:    .word 1
_db_e1_0_name:  .asciiz "Analisi Matematica I"
_db_e1_0_cred:  .word 9
_db_e1_0_grad:  .word 30
_db_e1_1_name:  .asciiz "Fisica I"
_db_e1_1_cred:  .word 6
_db_e1_1_grad:  .word 27
_db_e1_2_name:  .asciiz "Chimica per l'ingegneria elettronica"
_db_e1_2_cred:  .word 6
_db_e1_2_grad:  .word 25
_db_e1_3_name:  .asciiz "Informatica (programmazione)"
_db_e1_3_cred:  .word 6
_db_e1_3_grad:  .word 30
_db_e1_4_name:  .asciiz "Geometria e Algebra"
_db_e1_4_cred:  .word 6
_db_e1_4_grad:  .word 28
_db_e1_5_name:  .asciiz "Economia e Organizzazione Aziendale"
_db_e1_5_cred:  .word 6
_db_e1_5_grad:  .word 26
_db_e1_6_name:  .asciiz "Informatica (calcolatori elettronici)"
_db_e1_6_cred:  .word 6
_db_e1_6_grad:  .word 29
_db_e1_7_name:  .asciiz "Analisi dei dati"
_db_e1_7_cred:  .word 6
_db_e1_7_grad:  .word 30
_db_e1_8_name:  .asciiz "Fisica II"
_db_e1_8_cred:  .word 6
_db_e1_8_grad:  .word 28
_db_e1_9_name:  .asciiz "Elettronica Analogica e Digitale"
_db_e1_9_cred:  .word 8
_db_e1_9_grad:  .word 27
_db_e1_10_name: .asciiz "Automazione industriale"
_db_e1_10_cred: .word 6
_db_e1_10_grad: .word 30
_db_e1_11_name: .asciiz "Tecnologie dei sistemi di controllo"
_db_e1_11_cred: .word 6
_db_e1_11_grad: .word 29
_db_e1_12_name: .asciiz "Optoelettronica"
_db_e1_12_cred: .word 6
_db_e1_12_grad: .word 28
_db_e1_13_name: .asciiz "Progettazione dei sistemi elettronici"
_db_e1_13_cred: .word 6
_db_e1_13_grad: .word 26
_db_e1_14_name: .asciiz "Misure elettroniche"
_db_e1_14_cred: .word 6
_db_e1_14_grad: .word 30
_db_e1_15_name: .asciiz "Elettronica industriale"
_db_e1_15_cred: .word 6
_db_e1_15_grad: .word 27
_db_e1_16_name: .asciiz "Dispositivi Elettronici"
_db_e1_16_cred: .word 6
_db_e1_16_grad: .word 28
_db_e1_17_name: .asciiz "Analisi Matematica II"
_db_e1_17_cred: .word 9
_db_e1_17_grad: .word 24
_db_e1_18_name: .asciiz "Elettrotecnica"
_db_e1_18_cred: .word 9
_db_e1_18_grad: .word 25
_db_e1_19_name: .asciiz "Controlli Automatici"
_db_e1_19_cred: .word 9
_db_e1_19_grad: .word 29

# ── STUDENTE 2 ──
_db_name2:      .asciiz "Luca"
_db_surname2:   .asciiz "Ferrari"
_db_id2:        .word 1003
_db_age2:       .word 22
_db_year2:      .word 2020
_db_nexams2:    .word 10
_db_active2:    .word 1
_db_e2_0_name:  .asciiz "Analisi Matematica I"
_db_e2_0_cred:  .word 9
_db_e2_0_grad:  .word 19
_db_e2_1_name:  .asciiz "Economia e Organizzazione Aziendale"
_db_e2_1_cred:  .word 6
_db_e2_1_grad:  .word 24
_db_e2_2_name:  .asciiz "Fisica I"
_db_e2_2_cred:  .word 6
_db_e2_2_grad:  .word 22
_db_e2_3_name:  .asciiz "Geometria e Algebra"
_db_e2_3_cred:  .word 6
_db_e2_3_grad:  .word 20
_db_e2_4_name:  .asciiz "Informatica (programmazione)"
_db_e2_4_cred:  .word 6
_db_e2_4_grad:  .word 26
_db_e2_5_name:  .asciiz "Chimica per l'ingegneria elettronica"
_db_e2_5_cred:  .word 6
_db_e2_5_grad:  .word 18
_db_e2_6_name:  .asciiz "Informatica (calcolatori elettronici)"
_db_e2_6_cred:  .word 6
_db_e2_6_grad:  .word 25
_db_e2_7_name:  .asciiz "Analisi dei dati"
_db_e2_7_cred:  .word 6
_db_e2_7_grad:  .word 21
_db_e2_8_name:  .asciiz "Fisica II"
_db_e2_8_cred:  .word 6
_db_e2_8_grad:  .word 24
_db_e2_9_name:  .asciiz "Automazione industriale"
_db_e2_9_cred:  .word 6
_db_e2_9_grad:  .word 23

# ── STUDENTE 3 ──
_db_name3:      .asciiz "Sofia"
_db_surname3:   .asciiz "Esposito"
_db_id3:        .word 1004
_db_age3:       .word 19
_db_year3:      .word 2023
_db_nexams3:    .word 6
_db_active3:    .word 1
_db_e3_0_name:  .asciiz "Analisi Matematica I"
_db_e3_0_cred:  .word 9
_db_e3_0_grad:  .word 26
_db_e3_1_name:  .asciiz "Geometria e Algebra"
_db_e3_1_cred:  .word 6
_db_e3_1_grad:  .word 30
_db_e3_2_name:  .asciiz "Informatica (calcolatori elettronici)"
_db_e3_2_cred:  .word 6
_db_e3_2_grad:  .word 28
_db_e3_3_name:  .asciiz "Fisica I"
_db_e3_3_cred:  .word 6
_db_e3_3_grad:  .word 25
_db_e3_4_name:  .asciiz "Informatica (programmazione)"
_db_e3_4_cred:  .word 6
_db_e3_4_grad:  .word 27
_db_e3_5_name:  .asciiz "Economia e Organizzazione Aziendale"
_db_e3_5_cred:  .word 6
_db_e3_5_grad:  .word 29

# ── STUDENTE 4 ──
_db_name4:      .asciiz "Alessandro"
_db_surname4:   .asciiz "Ricci"
_db_id4:        .word 1005
_db_age4:       .word 23
_db_year4:      .word 2019
_db_nexams4:    .word 8
_db_active4:    .word 1
_db_e4_0_name:  .asciiz "Analisi Matematica I"
_db_e4_0_cred:  .word 9
_db_e4_0_grad:  .word 21
_db_e4_1_name:  .asciiz "Fisica I"
_db_e4_1_cred:  .word 6
_db_e4_1_grad:  .word 30
_db_e4_2_name:  .asciiz "Informatica (calcolatori elettronici)"
_db_e4_2_cred:  .word 6
_db_e4_2_grad:  .word 27
_db_e4_3_name:  .asciiz "Elettronica Analogica e Digitale"
_db_e4_3_cred:  .word 8
_db_e4_3_grad:  .word 24
_db_e4_4_name:  .asciiz "Analisi dei dati"
_db_e4_4_cred:  .word 6
_db_e4_4_grad:  .word 23
_db_e4_5_name:  .asciiz "Geometria e Algebra"
_db_e4_5_cred:  .word 6
_db_e4_5_grad:  .word 26
_db_e4_6_name:  .asciiz "Fisica II"
_db_e4_6_cred:  .word 6
_db_e4_6_grad:  .word 22
_db_e4_7_name:  .asciiz "Automazione industriale"
_db_e4_7_cred:  .word 6
_db_e4_7_grad:  .word 28

# ── STUDENTE 5 ──
_db_name5:      .asciiz "Chiara"
_db_surname5:   .asciiz "Marino"
_db_id5:        .word 1006
_db_age5:       .word 20
_db_year5:      .word 2022
_db_nexams5:    .word 7
_db_active5:    .word 1
_db_e5_0_name:  .asciiz "Analisi Matematica I"
_db_e5_0_cred:  .word 9
_db_e5_0_grad:  .word 29
_db_e5_1_name:  .asciiz "Fisica I"
_db_e5_1_cred:  .word 6
_db_e5_1_grad:  .word 18
_db_e5_2_name:  .asciiz "Geometria e Algebra"
_db_e5_2_cred:  .word 6
_db_e5_2_grad:  .word 24
_db_e5_3_name:  .asciiz "Informatica (programmazione)"
_db_e5_3_cred:  .word 6
_db_e5_3_grad:  .word 28
_db_e5_4_name:  .asciiz "Chimica per l'ingegneria elettronica"
_db_e5_4_cred:  .word 6
_db_e5_4_grad:  .word 25
_db_e5_5_name:  .asciiz "Informatica (calcolatori elettronici)"
_db_e5_5_cred:  .word 6
_db_e5_5_grad:  .word 27
_db_e5_6_name:  .asciiz "Economia e Organizzazione Aziendale"
_db_e5_6_cred:  .word 6
_db_e5_6_grad:  .word 30

# ── STUDENTE 6 ──
_db_name6:      .asciiz "Matteo"
_db_surname6:   .asciiz "Greco"
_db_id6:        .word 1007
_db_age6:       .word 21
_db_year6:      .word 2021
_db_nexams6:    .word 6
_db_active6:    .word 1
_db_e6_0_name:  .asciiz "Analisi Matematica I"
_db_e6_0_cred:  .word 9
_db_e6_0_grad:  .word 22
_db_e6_1_name:  .asciiz "Fisica I"
_db_e6_1_cred:  .word 6
_db_e6_1_grad:  .word 30
_db_e6_2_name:  .asciiz "Fisica II"
_db_e6_2_cred:  .word 6
_db_e6_2_grad:  .word 25
_db_e6_3_name:  .asciiz "Automazione industriale"
_db_e6_3_cred:  .word 6
_db_e6_3_grad:  .word 28
_db_e6_4_name:  .asciiz "Informatica (programmazione)"
_db_e6_4_cred:  .word 6
_db_e6_4_grad:  .word 24
_db_e6_5_name:  .asciiz "Chimica per l'ingegneria elettronica"
_db_e6_5_cred:  .word 6
_db_e6_5_grad:  .word 21

# ── STUDENTE 7 ──
_db_name7:      .asciiz "Valentina"
_db_surname7:   .asciiz "Conti"
_db_id7:        .word 1008
_db_age7:       .word 22
_db_year7:      .word 2020
_db_nexams7:    .word 7
_db_active7:    .word 1
_db_e7_0_name:  .asciiz "Analisi Matematica I"
_db_e7_0_cred:  .word 9
_db_e7_0_grad:  .word 21
_db_e7_1_name:  .asciiz "Geometria e Algebra"
_db_e7_1_cred:  .word 6
_db_e7_1_grad:  .word 24
_db_e7_2_name:  .asciiz "Fisica I"
_db_e7_2_cred:  .word 6
_db_e7_2_grad:  .word 28
_db_e7_3_name:  .asciiz "Economia e Organizzazione Aziendale"
_db_e7_3_cred:  .word 6
_db_e7_3_grad:  .word 26
_db_e7_4_name:  .asciiz "Informatica (programmazione)"
_db_e7_4_cred:  .word 6
_db_e7_4_grad:  .word 27
_db_e7_5_name:  .asciiz "Fisica II"
_db_e7_5_cred:  .word 6
_db_e7_5_grad:  .word 25
_db_e7_6_name:  .asciiz "Automazione industriale"
_db_e7_6_cred:  .word 6
_db_e7_6_grad:  .word 30

# ── STUDENTE 8 ──
_db_name8:      .asciiz "Federico"
_db_surname8:   .asciiz "Lombardi"
_db_id8:        .word 1009
_db_age8:       .word 24
_db_year8:      .word 2018
_db_nexams8:    .word 9
_db_active8:    .word 1
_db_e8_0_name:  .asciiz "Analisi Matematica I"
_db_e8_0_cred:  .word 9
_db_e8_0_grad:  .word 30
_db_e8_1_name:  .asciiz "Geometria e Algebra"
_db_e8_1_cred:  .word 6
_db_e8_1_grad:  .word 28
_db_e8_2_name:  .asciiz "Informatica (programmazione)"
_db_e8_2_cred:  .word 6
_db_e8_2_grad:  .word 29
_db_e8_3_name:  .asciiz "Fisica II"
_db_e8_3_cred:  .word 6
_db_e8_3_grad:  .word 18
_db_e8_4_name:  .asciiz "Tecnologie dei sistemi di controllo"
_db_e8_4_cred:  .word 6
_db_e8_4_grad:  .word 27
_db_e8_5_name:  .asciiz "Fisica I"
_db_e8_5_cred:  .word 6
_db_e8_5_grad:  .word 26
_db_e8_6_name:  .asciiz "Analisi dei dati"
_db_e8_6_cred:  .word 6
_db_e8_6_grad:  .word 24
_db_e8_7_name:  .asciiz "Automazione industriale"
_db_e8_7_cred:  .word 6
_db_e8_7_grad:  .word 25
_db_e8_8_name:  .asciiz "Elettronica Analogica e Digitale"
_db_e8_8_cred:  .word 8
_db_e8_8_grad:  .word 22

# ── STUDENTE 9 ──
_db_name9:      .asciiz "Elisa"
_db_surname9:   .asciiz "Moretti"
_db_id9:        .word 1010
_db_age9:       .word 20
_db_year9:      .word 2022
_db_nexams9:    .word 6
_db_active9:    .word 1
_db_e9_0_name:  .asciiz "Analisi Matematica I"
_db_e9_0_cred:  .word 9
_db_e9_0_grad:  .word 23
_db_e9_1_name:  .asciiz "Fisica I"
_db_e9_1_cred:  .word 6
_db_e9_1_grad:  .word 19
_db_e9_2_name:  .asciiz "Informatica (programmazione)"
_db_e9_2_cred:  .word 6
_db_e9_2_grad:  .word 28
_db_e9_3_name:  .asciiz "Geometria e Algebra"
_db_e9_3_cred:  .word 6
_db_e9_3_grad:  .word 24
_db_e9_4_name:  .asciiz "Economia e Organizzazione Aziendale"
_db_e9_4_cred:  .word 6
_db_e9_4_grad:  .word 27
_db_e9_5_name:  .asciiz "Chimica per l'ingegneria elettronica"
_db_e9_5_cred:  .word 6
_db_e9_5_grad:  .word 26

# ── STUDENTE 10 ──
_db_name10:     .asciiz "Davide"
_db_surname10:  .asciiz "Fontana"
_db_id10:       .word 1011
_db_age10:      .word 21
_db_year10:     .word 2021
_db_nexams10:   .word 2
_db_active10:   .word 1
_db_e10_0_name: .asciiz "Analisi Matematica I"
_db_e10_0_cred: .word 9
_db_e10_0_grad: .word 25
_db_e10_1_name: .asciiz "Fisica I"
_db_e10_1_cred: .word 6
_db_e10_1_grad: .word 27

# ── STUDENTE 11 ──
_db_name11:     .asciiz "Martina"
_db_surname11:  .asciiz "De Luca"
_db_id11:       .word 1012
_db_age11:      .word 19
_db_year11:     .word 2023
_db_nexams11:   .word 2
_db_active11:   .word 1
_db_e11_0_name: .asciiz "Analisi Matematica I"
_db_e11_0_cred: .word 9
_db_e11_0_grad: .word 20
_db_e11_1_name: .asciiz "Fisica I"
_db_e11_1_cred: .word 6
_db_e11_1_grad: .word 26

# ── STUDENTE 12 ── (Cancellato logicamente)
_db_name12:     .asciiz "Simone"
_db_surname12:  .asciiz "Barbieri"
_db_id12:       .word 1013
_db_age12:      .word 23
_db_year12:     .word 2019
_db_nexams12:   .word 4
_db_active12:   .word 0
_db_e12_0_name: .asciiz "Analisi Matematica I"
_db_e12_0_cred: .word 9
_db_e12_0_grad: .word 18
_db_e12_1_name: .asciiz "Geometria e Algebra"
_db_e12_1_cred: .word 6
_db_e12_1_grad: .word 21
_db_e12_2_name: .asciiz "Fisica I"
_db_e12_2_cred: .word 6
_db_e12_2_grad: .word 29
_db_e12_3_name: .asciiz "Elettronica Analogica e Digitale"
_db_e12_3_cred: .word 8
_db_e12_3_grad: .word 22

# ── STUDENTE 13 ──
_db_name13:     .asciiz "Aurora"
_db_surname13:  .asciiz "Santoro"
_db_id13:       .word 1014
_db_age13:      .word 20
_db_year13:     .word 2022
_db_nexams13:   .word 3
_db_active13:   .word 1
_db_e13_0_name: .asciiz "Analisi Matematica I"
_db_e13_0_cred: .word 9
_db_e13_0_grad: .word 27
_db_e13_1_name: .asciiz "Fisica I"
_db_e13_1_cred: .word 6
_db_e13_1_grad: .word 30
_db_e13_2_name: .asciiz "Chimica per l'ingegneria elettronica"
_db_e13_2_cred: .word 6
_db_e13_2_grad: .word 19

# ── STUDENTE 14 ──
_db_name14:     .asciiz "Riccardo"
_db_surname14:  .asciiz "Ferraro"
_db_id14:       .word 1015
_db_age14:      .word 22
_db_year14:     .word 2020
_db_nexams14:   .word 3
_db_active14:   .word 1
_db_e14_0_name: .asciiz "Analisi Matematica I"
_db_e14_0_cred: .word 9
_db_e14_0_grad: .word 26
_db_e14_1_name: .asciiz "Informatica (programmazione)"
_db_e14_1_cred: .word 6
_db_e14_1_grad: .word 29
_db_e14_2_name: .asciiz "Fisica II"
_db_e14_2_cred: .word 6
_db_e14_2_grad: .word 30

# ── STUDENTE 15 ──
_db_name15:     .asciiz "Francesca"
_db_surname15:  .asciiz "Mancini"
_db_id15:       .word 1016
_db_age15:      .word 21
_db_year15:     .word 2021
_db_nexams15:   .word 2
_db_active15:   .word 1
_db_e15_0_name: .asciiz "Analisi Matematica I"
_db_e15_0_cred: .word 9
_db_e15_0_grad: .word 22
_db_e15_1_name: .asciiz "Fisica I"
_db_e15_1_cred: .word 6
_db_e15_1_grad: .word 28

# ── STUDENTE 16 ──
_db_name16:     .asciiz "Andrea"
_db_surname16:  .asciiz "Pellegrini"
_db_id16:       .word 1017
_db_age16:      .word 20
_db_year16:     .word 2022
_db_nexams16:   .word 4
_db_active16:   .word 1
_db_e16_0_name: .asciiz "Analisi Matematica I"
_db_e16_0_cred: .word 9
_db_e16_0_grad: .word 30
_db_e16_1_name: .asciiz "Geometria e Algebra"
_db_e16_1_cred: .word 6
_db_e16_1_grad: .word 27
_db_e16_2_name: .asciiz "Fisica I"
_db_e16_2_cred: .word 6
_db_e16_2_grad: .word 23
_db_e16_3_name: .asciiz "Informatica (programmazione)"
_db_e16_3_cred: .word 6
_db_e16_3_grad: .word 25

# ── STUDENTE 17 ──
_db_name17:     .asciiz "Giorgia"
_db_surname17:  .asciiz "Caruso"
_db_id17:       .word 1018
_db_age17:      .word 19
_db_year17:     .word 2023
_db_nexams17:   .word 1
_db_active17:   .word 1
_db_e17_0_name: .asciiz "Analisi Matematica I"
_db_e17_0_cred: .word 9
_db_e17_0_grad: .word 26

# ── STUDENTE 18 ──
_db_name18:     .asciiz "Lorenzo"
_db_surname18:  .asciiz "Gallo"
_db_id18:       .word 1019
_db_age18:      .word 24
_db_year18:     .word 2018
_db_nexams18:   .word 4
_db_active18:   .word 1
_db_e18_0_name: .asciiz "Analisi Matematica I"
_db_e18_0_cred: .word 9
_db_e18_0_grad: .word 28
_db_e18_1_name: .asciiz "Informatica (programmazione)"
_db_e18_1_cred: .word 6
_db_e18_1_grad: .word 22
_db_e18_2_name: .asciiz "Elettronica Analogica e Digitale"
_db_e18_2_cred: .word 8
_db_e18_2_grad: .word 18
_db_e18_3_name: .asciiz "Automazione industriale"
_db_e18_3_cred: .word 6
_db_e18_3_grad: .word 27

# ── STUDENTE 19 ──
_db_name19:     .asciiz "Beatrice"
_db_surname19:  .asciiz "Russo"
_db_id19:       .word 1020
_db_age19:      .word 22
_db_year19:     .word 2020
_db_nexams19:   .word 3
_db_active19:   .word 1
_db_e19_0_name: .asciiz "Analisi Matematica I"
_db_e19_0_cred: .word 9
_db_e19_0_grad: .word 24
_db_e19_1_name: .asciiz "Fisica I"
_db_e19_1_cred: .word 6
_db_e19_1_grad: .word 19
_db_e19_2_name: .asciiz "Informatica (programmazione)"
_db_e19_2_cred: .word 6
_db_e19_2_grad: .word 28

# ── STUDENTE 20 ──
_db_name20:     .asciiz "Matteo"
_db_surname20:  .asciiz "Bianchi"
_db_id20:       .word 1021
_db_age20:      .word 20
_db_year20:     .word 2022
_db_nexams20:   .word 2
_db_active20:   .word 1
_db_e20_0_name: .asciiz "Analisi Matematica I"
_db_e20_0_cred: .word 9
_db_e20_0_grad: .word 24
_db_e20_1_name: .asciiz "Fisica I"
_db_e20_1_cred: .word 6
_db_e20_1_grad: .word 21

# ── STUDENTE 21 ──
_db_name21:     .asciiz "Sara"
_db_surname21:  .asciiz "Romano"
_db_id21:       .word 1022
_db_age21:      .word 21
_db_year21:     .word 2021
_db_nexams21:   .word 2
_db_active21:   .word 1
_db_e21_0_name: .asciiz "Informatica (programmazione)"
_db_e21_0_cred: .word 6
_db_e21_0_grad: .word 30
_db_e21_1_name: .asciiz "Geometria e Algebra"
_db_e21_1_cred: .word 6
_db_e21_1_grad: .word 28

# ── STUDENTE 22 ──
_db_name22:     .asciiz "Andrea"
_db_surname22:  .asciiz "Colombo"
_db_id22:       .word 1023
_db_age22:      .word 23
_db_year22:     .word 2019
_db_nexams22:   .word 1
_db_active22:   .word 1
_db_e22_0_name: .asciiz "Analisi Matematica I"
_db_e22_0_cred: .word 9
_db_e22_0_grad: .word 18

# ── STUDENTE 23 ──
_db_name23:     .asciiz "Martina"
_db_surname23:  .asciiz "Ricci"
_db_id23:       .word 1024
_db_age23:      .word 22
_db_year23:     .word 2020
_db_nexams23:   .word 2
_db_active23:   .word 1
_db_e23_0_name: .asciiz "Fisica II"
_db_e23_0_cred: .word 6
_db_e23_0_grad: .word 27
_db_e23_1_name: .asciiz "Misure elettroniche"
_db_e23_1_cred: .word 6
_db_e23_1_grad: .word 26

# ── STUDENTE 24 ──
_db_name24:     .asciiz "Marco"
_db_surname24:  .asciiz "Bruno"
_db_id24:       .word 1025
_db_age24:      .word 19
_db_year24:     .word 2023
_db_nexams24:   .word 2
_db_active24:   .word 1
_db_e24_0_name: .asciiz "Analisi Matematica I"
_db_e24_0_cred: .word 9
_db_e24_0_grad: .word 29
_db_e24_1_name: .asciiz "Chimica per l'ingegneria elettronica"
_db_e24_1_cred: .word 6
_db_e24_1_grad: .word 25

# ── STUDENTE 25 ──
_db_name25:     .asciiz "Elena"
_db_surname25:  .asciiz "Gallo"
_db_id25:       .word 1026
_db_age25:      .word 20
_db_year25:     .word 2022
_db_nexams25:   .word 1
_db_active25:   .word 1
_db_e25_0_name: .asciiz "Geometria e Algebra"
_db_e25_0_cred: .word 6
_db_e25_0_grad: .word 24

# ── STUDENTE 26 ──
_db_name26:     .asciiz "Davide"
_db_surname26:  .asciiz "Conti"
_db_id26:       .word 1027
_db_age26:      .word 21
_db_year26:     .word 2021
_db_nexams26:   .word 3
_db_active26:   .word 1
_db_e26_0_name: .asciiz "Fisica I"
_db_e26_0_cred: .word 6
_db_e26_0_grad: .word 22
_db_e26_1_name: .asciiz "Informatica (programmazione)"
_db_e26_1_cred: .word 6
_db_e26_1_grad: .word 30
_db_e26_2_name: .asciiz "Economia e Organizzazione Aziendale"
_db_e26_2_cred: .word 6
_db_e26_2_grad: .word 28

# ── STUDENTE 27 ──
_db_name27:     .asciiz "Anna"
_db_surname27:  .asciiz "De Luca"
_db_id27:       .word 1028
_db_age27:      .word 22
_db_year27:     .word 2020
_db_nexams27:   .word 1
_db_active27:   .word 1
_db_e27_0_name: .asciiz "Analisi Matematica I"
_db_e27_0_cred: .word 9
_db_e27_0_grad: .word 18

# ── STUDENTE 28 ──
_db_name28:     .asciiz "Simone"
_db_surname28:  .asciiz "Costa"
_db_id28:       .word 1029
_db_age28:      .word 20
_db_year28:     .word 2022
_db_nexams28:   .word 2
_db_active28:   .word 1
_db_e28_0_name: .asciiz "Fisica I"
_db_e28_0_cred: .word 6
_db_e28_0_grad: .word 26
_db_e28_1_name: .asciiz "Geometria e Algebra"
_db_e28_1_cred: .word 6
_db_e28_1_grad: .word 23

# ── STUDENTE 29 ──
_db_name29:     .asciiz "Laura"
_db_surname29:  .asciiz "Giordano"
_db_id29:       .word 1030
_db_age29:      .word 21
_db_year29:     .word 2021
_db_nexams29:   .word 2
_db_active29:   .word 1
_db_e29_0_name: .asciiz "Informatica (programmazione)"
_db_e29_0_cred: .word 6
_db_e29_0_grad: .word 28
_db_e29_1_name: .asciiz "Analisi dei dati"
_db_e29_1_cred: .word 6
_db_e29_1_grad: .word 29

# ── STUDENTE 30 ──
_db_name30:     .asciiz "Alessandro"
_db_surname30:  .asciiz "Rizzo"
_db_id30:       .word 1031
_db_age30:      .word 23
_db_year30:     .word 2019
_db_nexams30:   .word 2
_db_active30:   .word 1
_db_e30_0_name: .asciiz "Analisi Matematica I"
_db_e30_0_cred: .word 9
_db_e30_0_grad: .word 21
_db_e30_1_name: .asciiz "Fisica I"
_db_e30_1_cred: .word 6
_db_e30_1_grad: .word 24

# ── STUDENTE 31 ──
_db_name31:     .asciiz "Chiara"
_db_surname31:  .asciiz "Lombardi"
_db_id31:       .word 1032
_db_age31:      .word 19
_db_year31:     .word 2023
_db_nexams31:   .word 1
_db_active31:   .word 1
_db_e31_0_name: .asciiz "Chimica per l'ingegneria elettronica"
_db_e31_0_cred: .word 6
_db_e31_0_grad: .word 30

# ── STUDENTE 32 ──
_db_name32:     .asciiz "Federico"
_db_surname32:  .asciiz "Moretti"
_db_id32:       .word 1033
_db_age32:      .word 20
_db_year32:     .word 2022
_db_nexams32:   .word 2
_db_active32:   .word 1
_db_e32_0_name: .asciiz "Geometria e Algebra"
_db_e32_0_cred: .word 6
_db_e32_0_grad: .word 25
_db_e32_1_name: .asciiz "Informatica (calcolatori elettronici)"
_db_e32_1_cred: .word 6
_db_e32_1_grad: .word 27

# ── STUDENTE 33 ──
_db_name33:     .asciiz "Sofia"
_db_surname33:  .asciiz "Barbieri"
_db_id33:       .word 1034
_db_age33:      .word 22
_db_year33:     .word 2020
_db_nexams33:   .word 1
_db_active33:   .word 1
_db_e33_0_name: .asciiz "Analisi Matematica I"
_db_e33_0_cred: .word 9
_db_e33_0_grad: .word 20

# ── STUDENTE 34 ──
_db_name34:     .asciiz "Lorenzo"
_db_surname34:  .asciiz "Fontana"
_db_id34:       .word 1035
_db_age34:      .word 21
_db_year34:     .word 2021
_db_nexams34:   .word 2
_db_active34:   .word 1
_db_e34_0_name: .asciiz "Fisica I"
_db_e34_0_cred: .word 6
_db_e34_0_grad: .word 28
_db_e34_1_name: .asciiz "Automazione industriale"
_db_e34_1_cred: .word 6
_db_e34_1_grad: .word 26

# ── STUDENTE 35 ──
_db_name35:     .asciiz "Francesca"
_db_surname35:  .asciiz "Santoro"
_db_id35:       .word 1036
_db_age35:      .word 20
_db_year35:     .word 2022
_db_nexams35:   .word 2
_db_active35:   .word 1
_db_e35_0_name: .asciiz "Analisi Matematica I"
_db_e35_0_cred: .word 9
_db_e35_0_grad: .word 29
_db_e35_1_name: .asciiz "Chimica per l'ingegneria elettronica"
_db_e35_1_cred: .word 6
_db_e35_1_grad: .word 23

# ── STUDENTE 36 ──
_db_name36:     .asciiz "Gabriele"
_db_surname36:  .asciiz "Mariani"
_db_id36:       .word 1037
_db_age36:      .word 22
_db_year36:     .word 2020
_db_nexams36:   .word 1
_db_active36:   .word 1
_db_e36_0_name: .asciiz "Elettronica Analogica e Digitale"
_db_e36_0_cred: .word 8
_db_e36_0_grad: .word 21

# ── STUDENTE 37 ──
_db_name37:     .asciiz "Silvia"
_db_surname37:  .asciiz "Rinaldi"
_db_id37:       .word 1038
_db_age37:      .word 19
_db_year37:     .word 2023
_db_nexams37:   .word 2
_db_active37:   .word 1
_db_e37_0_name: .asciiz "Informatica (programmazione)"
_db_e37_0_cred: .word 6
_db_e37_0_grad: .word 24
_db_e37_1_name: .asciiz "Geometria e Algebra"
_db_e37_1_cred: .word 6
_db_e37_1_grad: .word 28

# ── STUDENTE 38 ──
_db_name38:     .asciiz "Riccardo"
_db_surname38:  .asciiz "Caruso"
_db_id38:       .word 1039
_db_age38:      .word 21
_db_year38:     .word 2021
_db_nexams38:   .word 1
_db_active38:   .word 1
_db_e38_0_name: .asciiz "Analisi Matematica I"
_db_e38_0_cred: .word 9
_db_e38_0_grad: .word 22

# ── STUDENTE 39 ──
_db_name39:     .asciiz "Valentina"
_db_surname39:  .asciiz "Ferrara"
_db_id39:       .word 1040
_db_age39:      .word 20
_db_year39:     .word 2022
_db_nexams39:   .word 2
_db_active39:   .word 1
_db_e39_0_name: .asciiz "Fisica I"
_db_e39_0_cred: .word 6
_db_e39_0_grad: .word 26
_db_e39_1_name: .asciiz "Analisi dei dati"
_db_e39_1_cred: .word 6
_db_e39_1_grad: .word 30

# ── STUDENTE 40 ──
_db_name40:     .asciiz "Tommaso"
_db_surname40:  .asciiz "Galli"
_db_id40:       .word 1041
_db_age40:      .word 23
_db_year40:     .word 2019
_db_nexams40:   .word 2
_db_active40:   .word 1
_db_e40_0_name: .asciiz "Automazione industriale"
_db_e40_0_cred: .word 6
_db_e40_0_grad: .word 25
_db_e40_1_name: .asciiz "Misure elettroniche"
_db_e40_1_cred: .word 6
_db_e40_1_grad: .word 27

# ── STUDENTE 41 ──
_db_name41:     .asciiz "Alice"
_db_surname41:  .asciiz "Martini"
_db_id41:       .word 1042
_db_age41:      .word 21
_db_year41:     .word 2021
_db_nexams41:   .word 1
_db_active41:   .word 1
_db_e41_0_name: .asciiz "Analisi Matematica I"
_db_e41_0_cred: .word 9
_db_e41_0_grad: .word 19

# ── STUDENTE 42 ──
_db_name42:     .asciiz "Nicola"
_db_surname42:  .asciiz "Leone"
_db_id42:       .word 1043
_db_age42:      .word 20
_db_year42:     .word 2022
_db_nexams42:   .word 2
_db_active42:   .word 1
_db_e42_0_name: .asciiz "Informatica (programmazione)"
_db_e42_0_cred: .word 6
_db_e42_0_grad: .word 28
_db_e42_1_name: .asciiz "Geometria e Algebra"
_db_e42_1_cred: .word 6
_db_e42_1_grad: .word 22

# ── STUDENTE 43 ──
_db_name43:     .asciiz "Beatrice"
_db_surname43:  .asciiz "Longo"
_db_id43:       .word 1044
_db_age43:      .word 19
_db_year43:     .word 2023
_db_nexams43:   .word 2
_db_active43:   .word 1
_db_e43_0_name: .asciiz "Analisi Matematica I"
_db_e43_0_cred: .word 9
_db_e43_0_grad: .word 24
_db_e43_1_name: .asciiz "Chimica per l'ingegneria elettronica"
_db_e43_1_cred: .word 6
_db_e43_1_grad: .word 30

# ── STUDENTE 44 ──
_db_name44:     .asciiz "Filippo"
_db_surname44:  .asciiz "Gentile"
_db_id44:       .word 1045
_db_age44:      .word 22
_db_year44:     .word 2020
_db_nexams44:   .word 1
_db_active44:   .word 1
_db_e44_0_name: .asciiz "Fisica I"
_db_e44_0_cred: .word 6
_db_e44_0_grad: .word 18

# ── STUDENTE 45 ──
_db_name45:     .asciiz "Camilla"
_db_surname45:  .asciiz "Martinelli"
_db_id45:       .word 1046
_db_age45:      .word 20
_db_year45:     .word 2022
_db_nexams45:   .word 2
_db_active45:   .word 1
_db_e45_0_name: .asciiz "Geometria e Algebra"
_db_e45_0_cred: .word 6
_db_e45_0_grad: .word 25
_db_e45_1_name: .asciiz "Informatica (calcolatori elettronici)"
_db_e45_1_cred: .word 6
_db_e45_1_grad: .word 26

# ── STUDENTE 46 ──
_db_name46:     .asciiz "Giovanni"
_db_surname46:  .asciiz "Vitale"
_db_id46:       .word 1047
_db_age46:      .word 21
_db_year46:     .word 2021
_db_nexams46:   .word 1
_db_active46:   .word 1
_db_e46_0_name: .asciiz "Analisi Matematica I"
_db_e46_0_cred: .word 9
_db_e46_0_grad: .word 21

# ── STUDENTE 47 ──
_db_name47:     .asciiz "Vittoria"
_db_surname47:  .asciiz "Lombardo"
_db_id47:       .word 1048
_db_age47:      .word 23
_db_year47:     .word 2019
_db_nexams47:   .word 3
_db_active47:   .word 1
_db_e47_0_name: .asciiz "Fisica I"
_db_e47_0_cred: .word 6
_db_e47_0_grad: .word 30
_db_e47_1_name: .asciiz "Informatica (programmazione)"
_db_e47_1_cred: .word 6
_db_e47_1_grad: .word 29
_db_e47_2_name: .asciiz "Economia e Organizzazione Aziendale"
_db_e47_2_cred: .word 6
_db_e47_2_grad: .word 28

# ── STUDENTE 48 ──
_db_name48:     .asciiz "Giulio"
_db_surname48:  .asciiz "Coppola"
_db_id48:       .word 1049
_db_age48:      .word 20
_db_year48:     .word 2022
_db_nexams48:   .word 2
_db_active48:   .word 1
_db_e48_0_name: .asciiz "Analisi Matematica I"
_db_e48_0_cred: .word 9
_db_e48_0_grad: .word 23
_db_e48_1_name: .asciiz "Fisica II"
_db_e48_1_cred: .word 6
_db_e48_1_grad: .word 24

# ── STUDENTE 49 ──
_db_name49:     .asciiz "Eleonora"
_db_surname49:  .asciiz "D'Amico"
_db_id49:       .word 1050
_db_age49:      .word 22
_db_year49:     .word 2020
_db_nexams49:   .word 2
_db_active49:   .word 1
_db_e49_0_name: .asciiz "Geometria e Algebra"
_db_e49_0_cred: .word 6
_db_e49_0_grad: .word 26
_db_e49_1_name: .asciiz "Chimica per l'ingegneria elettronica"
_db_e49_1_cred: .word 6
_db_e49_1_grad: .word 27
