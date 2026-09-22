# ====================================================================
# MACRO DI INIZIALIZZAZIONE
# ====================================================================

# Macro ORIGINALE per copiare le stringhe (usa l'offset manuale in byte)
.macro carica_stringa (%sorgente, %array_dest, %offset)
    la $a0, %sorgente            
    la $a1, %array_dest          
    addi $a1, $a1, %offset       
    jal copy_string              
.end_macro

# Macro ORIGINALE per copiare gli interi (usa l'offset manuale in byte)
.macro carica_intero (%sorgente, %array_dest, %offset)
    la $t0, %sorgente            
    lw $t1, 0($t0)               
    la $t2, %array_dest          
    addi $t2, $t2, %offset       
    sw $t1, 0($t2)               
.end_macro

# Macro per caricare gli esami (usa l'indice dello studente e dell'esame)
.macro carica_esame(%idx_stud, %idx_esame, %lbl_nome, %lbl_cred, %lbl_voto)
    li $t1, %idx_stud           
    li $t0, 20
    mul $t1, $t1, $t0           
    addi $t1, $t1, %idx_esame   
    sll $t2, $t1, 2             
    li $t0, 46
    mul $t3, $t1, $t0           
    la $t4, %lbl_cred
    lw $t5, 0($t4)
    la $t4, exam_credits
    add $t4, $t4, $t2
    sw $t5, 0($t4)
    la $t4, %lbl_voto
    lw $t5, 0($t4)
    la $t4, exam_grade
    add $t4, $t4, $t2
    sw $t5, 0($t4)
    la $a0, %lbl_nome
    la $a1, exam_name
    add $a1, $a1, $t3
    jal copy_string
.end_macro


.text
.globl init_db

# ================================================================================================================================
# FUNZIONE: init_db
# Popola gli array usando offset manuali per interi e stringhe
# ================================================================================================================================
init_db:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # ── STUDENTE 0 (Offset Int: 0 | Offset Str: 0) ──
    carica_intero(_db_id0, student_id, 0)
    carica_intero(_db_age0, student_age, 0)
    carica_intero(_db_year0, student_year, 0)
    carica_intero(_db_nexams0, student_nexams, 0)
    carica_intero(_db_active0, student_active, 0)
    carica_stringa(_db_name0, student_name, 0)
    carica_stringa(_db_surname0, student_surname, 0)
    carica_esame(0, 0, _db_e0_0_name, _db_e0_0_cred, _db_e0_0_grad)
    carica_esame(0, 1, _db_e0_1_name, _db_e0_1_cred, _db_e0_1_grad)
    carica_esame(0, 2, _db_e0_2_name, _db_e0_2_cred, _db_e0_2_grad)
    carica_esame(0, 3, _db_e0_3_name, _db_e0_3_cred, _db_e0_3_grad)
    carica_esame(0, 4, _db_e0_4_name, _db_e0_4_cred, _db_e0_4_grad)
    carica_esame(0, 5, _db_e0_5_name, _db_e0_5_cred, _db_e0_5_grad)
    carica_esame(0, 6, _db_e0_6_name, _db_e0_6_cred, _db_e0_6_grad)
    carica_esame(0, 7, _db_e0_7_name, _db_e0_7_cred, _db_e0_7_grad)
    carica_esame(0, 8, _db_e0_8_name, _db_e0_8_cred, _db_e0_8_grad)
    carica_esame(0, 9, _db_e0_9_name, _db_e0_9_cred, _db_e0_9_grad)
    carica_esame(0, 10, _db_e0_10_name, _db_e0_10_cred, _db_e0_10_grad)
    carica_esame(0, 11, _db_e0_11_name, _db_e0_11_cred, _db_e0_11_grad)
    carica_esame(0, 12, _db_e0_12_name, _db_e0_12_cred, _db_e0_12_grad)
    carica_esame(0, 13, _db_e0_13_name, _db_e0_13_cred, _db_e0_13_grad)
    carica_esame(0, 14, _db_e0_14_name, _db_e0_14_cred, _db_e0_14_grad)

    # ── STUDENTE 1 (Offset Int: 4 | Offset Str: 20) ──
    carica_intero(_db_id1, student_id, 4)
    carica_intero(_db_age1, student_age, 4)
    carica_intero(_db_year1, student_year, 4)
    carica_intero(_db_nexams1, student_nexams, 4)
    carica_intero(_db_active1, student_active, 4)
    carica_stringa(_db_name1, student_name, 20)
    carica_stringa(_db_surname1, student_surname, 20)
    carica_esame(1, 0, _db_e1_0_name, _db_e1_0_cred, _db_e1_0_grad)
    carica_esame(1, 1, _db_e1_1_name, _db_e1_1_cred, _db_e1_1_grad)
    carica_esame(1, 2, _db_e1_2_name, _db_e1_2_cred, _db_e1_2_grad)
    carica_esame(1, 3, _db_e1_3_name, _db_e1_3_cred, _db_e1_3_grad)
    carica_esame(1, 4, _db_e1_4_name, _db_e1_4_cred, _db_e1_4_grad)
    carica_esame(1, 5, _db_e1_5_name, _db_e1_5_cred, _db_e1_5_grad)
    carica_esame(1, 6, _db_e1_6_name, _db_e1_6_cred, _db_e1_6_grad)
    carica_esame(1, 7, _db_e1_7_name, _db_e1_7_cred, _db_e1_7_grad)
    carica_esame(1, 8, _db_e1_8_name, _db_e1_8_cred, _db_e1_8_grad)
    carica_esame(1, 9, _db_e1_9_name, _db_e1_9_cred, _db_e1_9_grad)
    carica_esame(1, 10, _db_e1_10_name, _db_e1_10_cred, _db_e1_10_grad)
    carica_esame(1, 11, _db_e1_11_name, _db_e1_11_cred, _db_e1_11_grad)
    carica_esame(1, 12, _db_e1_12_name, _db_e1_12_cred, _db_e1_12_grad)
    carica_esame(1, 13, _db_e1_13_name, _db_e1_13_cred, _db_e1_13_grad)
    carica_esame(1, 14, _db_e1_14_name, _db_e1_14_cred, _db_e1_14_grad)
    carica_esame(1, 15, _db_e1_15_name, _db_e1_15_cred, _db_e1_15_grad)
    carica_esame(1, 16, _db_e1_16_name, _db_e1_16_cred, _db_e1_16_grad)
    carica_esame(1, 17, _db_e1_17_name, _db_e1_17_cred, _db_e1_17_grad)
    carica_esame(1, 18, _db_e1_18_name, _db_e1_18_cred, _db_e1_18_grad)
    carica_esame(1, 19, _db_e1_19_name, _db_e1_19_cred, _db_e1_19_grad)

    # ── STUDENTE 2 (Offset Int: 8 | Offset Str: 40) ──
    carica_intero(_db_id2, student_id, 8)
    carica_intero(_db_age2, student_age, 8)
    carica_intero(_db_year2, student_year, 8)
    carica_intero(_db_nexams2, student_nexams, 8)
    carica_intero(_db_active2, student_active, 8)
    carica_stringa(_db_name2, student_name, 40)
    carica_stringa(_db_surname2, student_surname, 40)
    carica_esame(2, 0, _db_e2_0_name, _db_e2_0_cred, _db_e2_0_grad)
    carica_esame(2, 1, _db_e2_1_name, _db_e2_1_cred, _db_e2_1_grad)
    carica_esame(2, 2, _db_e2_2_name, _db_e2_2_cred, _db_e2_2_grad)
    carica_esame(2, 3, _db_e2_3_name, _db_e2_3_cred, _db_e2_3_grad)
    carica_esame(2, 4, _db_e2_4_name, _db_e2_4_cred, _db_e2_4_grad)
    carica_esame(2, 5, _db_e2_5_name, _db_e2_5_cred, _db_e2_5_grad)
    carica_esame(2, 6, _db_e2_6_name, _db_e2_6_cred, _db_e2_6_grad)
    carica_esame(2, 7, _db_e2_7_name, _db_e2_7_cred, _db_e2_7_grad)
    carica_esame(2, 8, _db_e2_8_name, _db_e2_8_cred, _db_e2_8_grad)
    carica_esame(2, 9, _db_e2_9_name, _db_e2_9_cred, _db_e2_9_grad)

    # ── STUDENTE 3 (Offset Int: 12 | Offset Str: 60) ──
    carica_intero(_db_id3, student_id, 12)
    carica_intero(_db_age3, student_age, 12)
    carica_intero(_db_year3, student_year, 12)
    carica_intero(_db_nexams3, student_nexams, 12)
    carica_intero(_db_active3, student_active, 12)
    carica_stringa(_db_name3, student_name, 60)
    carica_stringa(_db_surname3, student_surname, 60)
    carica_esame(3, 0, _db_e3_0_name, _db_e3_0_cred, _db_e3_0_grad)
    carica_esame(3, 1, _db_e3_1_name, _db_e3_1_cred, _db_e3_1_grad)
    carica_esame(3, 2, _db_e3_2_name, _db_e3_2_cred, _db_e3_2_grad)
    carica_esame(3, 3, _db_e3_3_name, _db_e3_3_cred, _db_e3_3_grad)
    carica_esame(3, 4, _db_e3_4_name, _db_e3_4_cred, _db_e3_4_grad)
    carica_esame(3, 5, _db_e3_5_name, _db_e3_5_cred, _db_e3_5_grad)

    # ── STUDENTE 4 (Offset Int: 16 | Offset Str: 80) ──
    carica_intero(_db_id4, student_id, 16)
    carica_intero(_db_age4, student_age, 16)
    carica_intero(_db_year4, student_year, 16)
    carica_intero(_db_nexams4, student_nexams, 16)
    carica_intero(_db_active4, student_active, 16)
    carica_stringa(_db_name4, student_name, 80)
    carica_stringa(_db_surname4, student_surname, 80)
    carica_esame(4, 0, _db_e4_0_name, _db_e4_0_cred, _db_e4_0_grad)
    carica_esame(4, 1, _db_e4_1_name, _db_e4_1_cred, _db_e4_1_grad)
    carica_esame(4, 2, _db_e4_2_name, _db_e4_2_cred, _db_e4_2_grad)
    carica_esame(4, 3, _db_e4_3_name, _db_e4_3_cred, _db_e4_3_grad)
    carica_esame(4, 4, _db_e4_4_name, _db_e4_4_cred, _db_e4_4_grad)
    carica_esame(4, 5, _db_e4_5_name, _db_e4_5_cred, _db_e4_5_grad)
    carica_esame(4, 6, _db_e4_6_name, _db_e4_6_cred, _db_e4_6_grad)
    carica_esame(4, 7, _db_e4_7_name, _db_e4_7_cred, _db_e4_7_grad)

    # ── STUDENTE 5 (Offset Int: 20 | Offset Str: 100) ──
    carica_intero(_db_id5, student_id, 20)
    carica_intero(_db_age5, student_age, 20)
    carica_intero(_db_year5, student_year, 20)
    carica_intero(_db_nexams5, student_nexams, 20)
    carica_intero(_db_active5, student_active, 20)
    carica_stringa(_db_name5, student_name, 100)
    carica_stringa(_db_surname5, student_surname, 100)
    carica_esame(5, 0, _db_e5_0_name, _db_e5_0_cred, _db_e5_0_grad)
    carica_esame(5, 1, _db_e5_1_name, _db_e5_1_cred, _db_e5_1_grad)
    carica_esame(5, 2, _db_e5_2_name, _db_e5_2_cred, _db_e5_2_grad)
    carica_esame(5, 3, _db_e5_3_name, _db_e5_3_cred, _db_e5_3_grad)
    carica_esame(5, 4, _db_e5_4_name, _db_e5_4_cred, _db_e5_4_grad)
    carica_esame(5, 5, _db_e5_5_name, _db_e5_5_cred, _db_e5_5_grad)
    carica_esame(5, 6, _db_e5_6_name, _db_e5_6_cred, _db_e5_6_grad)

    # ── STUDENTE 6 (Offset Int: 24 | Offset Str: 120) ──
    carica_intero(_db_id6, student_id, 24)
    carica_intero(_db_age6, student_age, 24)
    carica_intero(_db_year6, student_year, 24)
    carica_intero(_db_nexams6, student_nexams, 24)
    carica_intero(_db_active6, student_active, 24)
    carica_stringa(_db_name6, student_name, 120)
    carica_stringa(_db_surname6, student_surname, 120)
    carica_esame(6, 0, _db_e6_0_name, _db_e6_0_cred, _db_e6_0_grad)
    carica_esame(6, 1, _db_e6_1_name, _db_e6_1_cred, _db_e6_1_grad)
    carica_esame(6, 2, _db_e6_2_name, _db_e6_2_cred, _db_e6_2_grad)
    carica_esame(6, 3, _db_e6_3_name, _db_e6_3_cred, _db_e6_3_grad)
    carica_esame(6, 4, _db_e6_4_name, _db_e6_4_cred, _db_e6_4_grad)
    carica_esame(6, 5, _db_e6_5_name, _db_e6_5_cred, _db_e6_5_grad)

    # ── STUDENTE 7 (Offset Int: 28 | Offset Str: 140) ──
    carica_intero(_db_id7, student_id, 28)
    carica_intero(_db_age7, student_age, 28)
    carica_intero(_db_year7, student_year, 28)
    carica_intero(_db_nexams7, student_nexams, 28)
    carica_intero(_db_active7, student_active, 28)
    carica_stringa(_db_name7, student_name, 140)
    carica_stringa(_db_surname7, student_surname, 140)
    carica_esame(7, 0, _db_e7_0_name, _db_e7_0_cred, _db_e7_0_grad)
    carica_esame(7, 1, _db_e7_1_name, _db_e7_1_cred, _db_e7_1_grad)
    carica_esame(7, 2, _db_e7_2_name, _db_e7_2_cred, _db_e7_2_grad)
    carica_esame(7, 3, _db_e7_3_name, _db_e7_3_cred, _db_e7_3_grad)
    carica_esame(7, 4, _db_e7_4_name, _db_e7_4_cred, _db_e7_4_grad)
    carica_esame(7, 5, _db_e7_5_name, _db_e7_5_cred, _db_e7_5_grad)
    carica_esame(7, 6, _db_e7_6_name, _db_e7_6_cred, _db_e7_6_grad)

    # ── STUDENTE 8 (Offset Int: 32 | Offset Str: 160) ──
    carica_intero(_db_id8, student_id, 32)
    carica_intero(_db_age8, student_age, 32)
    carica_intero(_db_year8, student_year, 32)
    carica_intero(_db_nexams8, student_nexams, 32)
    carica_intero(_db_active8, student_active, 32)
    carica_stringa(_db_name8, student_name, 160)
    carica_stringa(_db_surname8, student_surname, 160)
    carica_esame(8, 0, _db_e8_0_name, _db_e8_0_cred, _db_e8_0_grad)
    carica_esame(8, 1, _db_e8_1_name, _db_e8_1_cred, _db_e8_1_grad)
    carica_esame(8, 2, _db_e8_2_name, _db_e8_2_cred, _db_e8_2_grad)
    carica_esame(8, 3, _db_e8_3_name, _db_e8_3_cred, _db_e8_3_grad)
    carica_esame(8, 4, _db_e8_4_name, _db_e8_4_cred, _db_e8_4_grad)
    carica_esame(8, 5, _db_e8_5_name, _db_e8_5_cred, _db_e8_5_grad)
    carica_esame(8, 6, _db_e8_6_name, _db_e8_6_cred, _db_e8_6_grad)
    carica_esame(8, 7, _db_e8_7_name, _db_e8_7_cred, _db_e8_7_grad)
    carica_esame(8, 8, _db_e8_8_name, _db_e8_8_cred, _db_e8_8_grad)

    # ── STUDENTE 9 (Offset Int: 36 | Offset Str: 180) ──
    carica_intero(_db_id9, student_id, 36)
    carica_intero(_db_age9, student_age, 36)
    carica_intero(_db_year9, student_year, 36)
    carica_intero(_db_nexams9, student_nexams, 36)
    carica_intero(_db_active9, student_active, 36)
    carica_stringa(_db_name9, student_name, 180)
    carica_stringa(_db_surname9, student_surname, 180)
    carica_esame(9, 0, _db_e9_0_name, _db_e9_0_cred, _db_e9_0_grad)
    carica_esame(9, 1, _db_e9_1_name, _db_e9_1_cred, _db_e9_1_grad)
    carica_esame(9, 2, _db_e9_2_name, _db_e9_2_cred, _db_e9_2_grad)
    carica_esame(9, 3, _db_e9_3_name, _db_e9_3_cred, _db_e9_3_grad)
    carica_esame(9, 4, _db_e9_4_name, _db_e9_4_cred, _db_e9_4_grad)
    carica_esame(9, 5, _db_e9_5_name, _db_e9_5_cred, _db_e9_5_grad)

    # ── STUDENTE 10 (Offset Int: 40 | Offset Str: 200) ──
    carica_intero(_db_id10, student_id, 40)
    carica_intero(_db_age10, student_age, 40)
    carica_intero(_db_year10, student_year, 40)
    carica_intero(_db_nexams10, student_nexams, 40)
    carica_intero(_db_active10, student_active, 40)
    carica_stringa(_db_name10, student_name, 200)
    carica_stringa(_db_surname10, student_surname, 200)
    carica_esame(10, 0, _db_e10_0_name, _db_e10_0_cred, _db_e10_0_grad)
    carica_esame(10, 1, _db_e10_1_name, _db_e10_1_cred, _db_e10_1_grad)

    # ── STUDENTE 11 (Offset Int: 44 | Offset Str: 220) ──
    carica_intero(_db_id11, student_id, 44)
    carica_intero(_db_age11, student_age, 44)
    carica_intero(_db_year11, student_year, 44)
    carica_intero(_db_nexams11, student_nexams, 44)
    carica_intero(_db_active11, student_active, 44)
    carica_stringa(_db_name11, student_name, 220)
    carica_stringa(_db_surname11, student_surname, 220)
    carica_esame(11, 0, _db_e11_0_name, _db_e11_0_cred, _db_e11_0_grad)
    carica_esame(11, 1, _db_e11_1_name, _db_e11_1_cred, _db_e11_1_grad)

    # ── STUDENTE 12 (Offset Int: 48 | Offset Str: 240) ──
    carica_intero(_db_id12, student_id, 48)
    carica_intero(_db_age12, student_age, 48)
    carica_intero(_db_year12, student_year, 48)
    carica_intero(_db_nexams12, student_nexams, 48)
    carica_intero(_db_active12, student_active, 48)
    carica_stringa(_db_name12, student_name, 240)
    carica_stringa(_db_surname12, student_surname, 240)
    carica_esame(12, 0, _db_e12_0_name, _db_e12_0_cred, _db_e12_0_grad)
    carica_esame(12, 1, _db_e12_1_name, _db_e12_1_cred, _db_e12_1_grad)
    carica_esame(12, 2, _db_e12_2_name, _db_e12_2_cred, _db_e12_2_grad)
    carica_esame(12, 3, _db_e12_3_name, _db_e12_3_cred, _db_e12_3_grad)

    # ── STUDENTE 13 (Offset Int: 52 | Offset Str: 260) ──
    carica_intero(_db_id13, student_id, 52)
    carica_intero(_db_age13, student_age, 52)
    carica_intero(_db_year13, student_year, 52)
    carica_intero(_db_nexams13, student_nexams, 52)
    carica_intero(_db_active13, student_active, 52)
    carica_stringa(_db_name13, student_name, 260)
    carica_stringa(_db_surname13, student_surname, 260)
    carica_esame(13, 0, _db_e13_0_name, _db_e13_0_cred, _db_e13_0_grad)
    carica_esame(13, 1, _db_e13_1_name, _db_e13_1_cred, _db_e13_1_grad)
    carica_esame(13, 2, _db_e13_2_name, _db_e13_2_cred, _db_e13_2_grad)

    # ── STUDENTE 14 (Offset Int: 56 | Offset Str: 280) ──
    carica_intero(_db_id14, student_id, 56)
    carica_intero(_db_age14, student_age, 56)
    carica_intero(_db_year14, student_year, 56)
    carica_intero(_db_nexams14, student_nexams, 56)
    carica_intero(_db_active14, student_active, 56)
    carica_stringa(_db_name14, student_name, 280)
    carica_stringa(_db_surname14, student_surname, 280)
    carica_esame(14, 0, _db_e14_0_name, _db_e14_0_cred, _db_e14_0_grad)
    carica_esame(14, 1, _db_e14_1_name, _db_e14_1_cred, _db_e14_1_grad)
    carica_esame(14, 2, _db_e14_2_name, _db_e14_2_cred, _db_e14_2_grad)

    # ── STUDENTE 15 (Offset Int: 60 | Offset Str: 300) ──
    carica_intero(_db_id15, student_id, 60)
    carica_intero(_db_age15, student_age, 60)
    carica_intero(_db_year15, student_year, 60)
    carica_intero(_db_nexams15, student_nexams, 60)
    carica_intero(_db_active15, student_active, 60)
    carica_stringa(_db_name15, student_name, 300)
    carica_stringa(_db_surname15, student_surname, 300)
    carica_esame(15, 0, _db_e15_0_name, _db_e15_0_cred, _db_e15_0_grad)
    carica_esame(15, 1, _db_e15_1_name, _db_e15_1_cred, _db_e15_1_grad)

    # ── STUDENTE 16 (Offset Int: 64 | Offset Str: 320) ──
    carica_intero(_db_id16, student_id, 64)
    carica_intero(_db_age16, student_age, 64)
    carica_intero(_db_year16, student_year, 64)
    carica_intero(_db_nexams16, student_nexams, 64)
    carica_intero(_db_active16, student_active, 64)
    carica_stringa(_db_name16, student_name, 320)
    carica_stringa(_db_surname16, student_surname, 320)
    carica_esame(16, 0, _db_e16_0_name, _db_e16_0_cred, _db_e16_0_grad)
    carica_esame(16, 1, _db_e16_1_name, _db_e16_1_cred, _db_e16_1_grad)
    carica_esame(16, 2, _db_e16_2_name, _db_e16_2_cred, _db_e16_2_grad)
    carica_esame(16, 3, _db_e16_3_name, _db_e16_3_cred, _db_e16_3_grad)

    # ── STUDENTE 17 (Offset Int: 68 | Offset Str: 340) ──
    carica_intero(_db_id17, student_id, 68)
    carica_intero(_db_age17, student_age, 68)
    carica_intero(_db_year17, student_year, 68)
    carica_intero(_db_nexams17, student_nexams, 68)
    carica_intero(_db_active17, student_active, 68)
    carica_stringa(_db_name17, student_name, 340)
    carica_stringa(_db_surname17, student_surname, 340)
    carica_esame(17, 0, _db_e17_0_name, _db_e17_0_cred, _db_e17_0_grad)

    # ── STUDENTE 18 (Offset Int: 72 | Offset Str: 360) ──
    carica_intero(_db_id18, student_id, 72)
    carica_intero(_db_age18, student_age, 72)
    carica_intero(_db_year18, student_year, 72)
    carica_intero(_db_nexams18, student_nexams, 72)
    carica_intero(_db_active18, student_active, 72)
    carica_stringa(_db_name18, student_name, 360)
    carica_stringa(_db_surname18, student_surname, 360)
    carica_esame(18, 0, _db_e18_0_name, _db_e18_0_cred, _db_e18_0_grad)
    carica_esame(18, 1, _db_e18_1_name, _db_e18_1_cred, _db_e18_1_grad)
    carica_esame(18, 2, _db_e18_2_name, _db_e18_2_cred, _db_e18_2_grad)
    carica_esame(18, 3, _db_e18_3_name, _db_e18_3_cred, _db_e18_3_grad)

    # ── STUDENTE 19 (Offset Int: 76 | Offset Str: 380) ──
    carica_intero(_db_id19, student_id, 76)
    carica_intero(_db_age19, student_age, 76)
    carica_intero(_db_year19, student_year, 76)
    carica_intero(_db_nexams19, student_nexams, 76)
    carica_intero(_db_active19, student_active, 76)
    carica_stringa(_db_name19, student_name, 380)
    carica_stringa(_db_surname19, student_surname, 380)
    carica_esame(19, 0, _db_e19_0_name, _db_e19_0_cred, _db_e19_0_grad)
    carica_esame(19, 1, _db_e19_1_name, _db_e19_1_cred, _db_e19_1_grad)
    carica_esame(19, 2, _db_e19_2_name, _db_e19_2_cred, _db_e19_2_grad)

    # ── STUDENTE 20 (Offset Int: 80 | Offset Str: 400) ──
    carica_intero(_db_id20, student_id, 80)
    carica_intero(_db_age20, student_age, 80)
    carica_intero(_db_year20, student_year, 80)
    carica_intero(_db_nexams20, student_nexams, 80)
    carica_intero(_db_active20, student_active, 80)
    carica_stringa(_db_name20, student_name, 400)
    carica_stringa(_db_surname20, student_surname, 400)
    carica_esame(20, 0, _db_e20_0_name, _db_e20_0_cred, _db_e20_0_grad)
    carica_esame(20, 1, _db_e20_1_name, _db_e20_1_cred, _db_e20_1_grad)

    # ── STUDENTE 21 (Offset Int: 84 | Offset Str: 420) ──
    carica_intero(_db_id21, student_id, 84)
    carica_intero(_db_age21, student_age, 84)
    carica_intero(_db_year21, student_year, 84)
    carica_intero(_db_nexams21, student_nexams, 84)
    carica_intero(_db_active21, student_active, 84)
    carica_stringa(_db_name21, student_name, 420)
    carica_stringa(_db_surname21, student_surname, 420)
    carica_esame(21, 0, _db_e21_0_name, _db_e21_0_cred, _db_e21_0_grad)
    carica_esame(21, 1, _db_e21_1_name, _db_e21_1_cred, _db_e21_1_grad)

    # ── STUDENTE 22 (Offset Int: 88 | Offset Str: 440) ──
    carica_intero(_db_id22, student_id, 88)
    carica_intero(_db_age22, student_age, 88)
    carica_intero(_db_year22, student_year, 88)
    carica_intero(_db_nexams22, student_nexams, 88)
    carica_intero(_db_active22, student_active, 88)
    carica_stringa(_db_name22, student_name, 440)
    carica_stringa(_db_surname22, student_surname, 440)
    carica_esame(22, 0, _db_e22_0_name, _db_e22_0_cred, _db_e22_0_grad)

    # ── STUDENTE 23 (Offset Int: 92 | Offset Str: 460) ──
    carica_intero(_db_id23, student_id, 92)
    carica_intero(_db_age23, student_age, 92)
    carica_intero(_db_year23, student_year, 92)
    carica_intero(_db_nexams23, student_nexams, 92)
    carica_intero(_db_active23, student_active, 92)
    carica_stringa(_db_name23, student_name, 460)
    carica_stringa(_db_surname23, student_surname, 460)
    carica_esame(23, 0, _db_e23_0_name, _db_e23_0_cred, _db_e23_0_grad)
    carica_esame(23, 1, _db_e23_1_name, _db_e23_1_cred, _db_e23_1_grad)

    # ── STUDENTE 24 (Offset Int: 96 | Offset Str: 480) ──
    carica_intero(_db_id24, student_id, 96)
    carica_intero(_db_age24, student_age, 96)
    carica_intero(_db_year24, student_year, 96)
    carica_intero(_db_nexams24, student_nexams, 96)
    carica_intero(_db_active24, student_active, 96)
    carica_stringa(_db_name24, student_name, 480)
    carica_stringa(_db_surname24, student_surname, 480)
    carica_esame(24, 0, _db_e24_0_name, _db_e24_0_cred, _db_e24_0_grad)
    carica_esame(24, 1, _db_e24_1_name, _db_e24_1_cred, _db_e24_1_grad)

    # ── STUDENTE 25 (Offset Int: 100 | Offset Str: 500) ──
    carica_intero(_db_id25, student_id, 100)
    carica_intero(_db_age25, student_age, 100)
    carica_intero(_db_year25, student_year, 100)
    carica_intero(_db_nexams25, student_nexams, 100)
    carica_intero(_db_active25, student_active, 100)
    carica_stringa(_db_name25, student_name, 500)
    carica_stringa(_db_surname25, student_surname, 500)
    carica_esame(25, 0, _db_e25_0_name, _db_e25_0_cred, _db_e25_0_grad)

    # ── STUDENTE 26 (Offset Int: 104 | Offset Str: 520) ──
    carica_intero(_db_id26, student_id, 104)
    carica_intero(_db_age26, student_age, 104)
    carica_intero(_db_year26, student_year, 104)
    carica_intero(_db_nexams26, student_nexams, 104)
    carica_intero(_db_active26, student_active, 104)
    carica_stringa(_db_name26, student_name, 520)
    carica_stringa(_db_surname26, student_surname, 520)
    carica_esame(26, 0, _db_e26_0_name, _db_e26_0_cred, _db_e26_0_grad)
    carica_esame(26, 1, _db_e26_1_name, _db_e26_1_cred, _db_e26_1_grad)
    carica_esame(26, 2, _db_e26_2_name, _db_e26_2_cred, _db_e26_2_grad)

    # ── STUDENTE 27 (Offset Int: 108 | Offset Str: 540) ──
    carica_intero(_db_id27, student_id, 108)
    carica_intero(_db_age27, student_age, 108)
    carica_intero(_db_year27, student_year, 108)
    carica_intero(_db_nexams27, student_nexams, 108)
    carica_intero(_db_active27, student_active, 108)
    carica_stringa(_db_name27, student_name, 540)
    carica_stringa(_db_surname27, student_surname, 540)
    carica_esame(27, 0, _db_e27_0_name, _db_e27_0_cred, _db_e27_0_grad)

    # ── STUDENTE 28 (Offset Int: 112 | Offset Str: 560) ──
    carica_intero(_db_id28, student_id, 112)
    carica_intero(_db_age28, student_age, 112)
    carica_intero(_db_year28, student_year, 112)
    carica_intero(_db_nexams28, student_nexams, 112)
    carica_intero(_db_active28, student_active, 112)
    carica_stringa(_db_name28, student_name, 560)
    carica_stringa(_db_surname28, student_surname, 560)
    carica_esame(28, 0, _db_e28_0_name, _db_e28_0_cred, _db_e28_0_grad)
    carica_esame(28, 1, _db_e28_1_name, _db_e28_1_cred, _db_e28_1_grad)

    # ── STUDENTE 29 (Offset Int: 116 | Offset Str: 580) ──
    carica_intero(_db_id29, student_id, 116)
    carica_intero(_db_age29, student_age, 116)
    carica_intero(_db_year29, student_year, 116)
    carica_intero(_db_nexams29, student_nexams, 116)
    carica_intero(_db_active29, student_active, 116)
    carica_stringa(_db_name29, student_name, 580)
    carica_stringa(_db_surname29, student_surname, 580)
    carica_esame(29, 0, _db_e29_0_name, _db_e29_0_cred, _db_e29_0_grad)
    carica_esame(29, 1, _db_e29_1_name, _db_e29_1_cred, _db_e29_1_grad)

    # ── STUDENTE 30 (Offset Int: 120 | Offset Str: 600) ──
    carica_intero(_db_id30, student_id, 120)
    carica_intero(_db_age30, student_age, 120)
    carica_intero(_db_year30, student_year, 120)
    carica_intero(_db_nexams30, student_nexams, 120)
    carica_intero(_db_active30, student_active, 120)
    carica_stringa(_db_name30, student_name, 600)
    carica_stringa(_db_surname30, student_surname, 600)
    carica_esame(30, 0, _db_e30_0_name, _db_e30_0_cred, _db_e30_0_grad)
    carica_esame(30, 1, _db_e30_1_name, _db_e30_1_cred, _db_e30_1_grad)

    # ── STUDENTE 31 (Offset Int: 124 | Offset Str: 620) ──
    carica_intero(_db_id31, student_id, 124)
    carica_intero(_db_age31, student_age, 124)
    carica_intero(_db_year31, student_year, 124)
    carica_intero(_db_nexams31, student_nexams, 124)
    carica_intero(_db_active31, student_active, 124)
    carica_stringa(_db_name31, student_name, 620)
    carica_stringa(_db_surname31, student_surname, 620)
    carica_esame(31, 0, _db_e31_0_name, _db_e31_0_cred, _db_e31_0_grad)

    # ── STUDENTE 32 (Offset Int: 128 | Offset Str: 640) ──
    carica_intero(_db_id32, student_id, 128)
    carica_intero(_db_age32, student_age, 128)
    carica_intero(_db_year32, student_year, 128)
    carica_intero(_db_nexams32, student_nexams, 128)
    carica_intero(_db_active32, student_active, 128)
    carica_stringa(_db_name32, student_name, 640)
    carica_stringa(_db_surname32, student_surname, 640)
    carica_esame(32, 0, _db_e32_0_name, _db_e32_0_cred, _db_e32_0_grad)
    carica_esame(32, 1, _db_e32_1_name, _db_e32_1_cred, _db_e32_1_grad)

    # ── STUDENTE 33 (Offset Int: 132 | Offset Str: 660) ──
    carica_intero(_db_id33, student_id, 132)
    carica_intero(_db_age33, student_age, 132)
    carica_intero(_db_year33, student_year, 132)
    carica_intero(_db_nexams33, student_nexams, 132)
    carica_intero(_db_active33, student_active, 132)
    carica_stringa(_db_name33, student_name, 660)
    carica_stringa(_db_surname33, student_surname, 660)
    carica_esame(33, 0, _db_e33_0_name, _db_e33_0_cred, _db_e33_0_grad)

    # ── STUDENTE 34 (Offset Int: 136 | Offset Str: 680) ──
    carica_intero(_db_id34, student_id, 136)
    carica_intero(_db_age34, student_age, 136)
    carica_intero(_db_year34, student_year, 136)
    carica_intero(_db_nexams34, student_nexams, 136)
    carica_intero(_db_active34, student_active, 136)
    carica_stringa(_db_name34, student_name, 680)
    carica_stringa(_db_surname34, student_surname, 680)
    carica_esame(34, 0, _db_e34_0_name, _db_e34_0_cred, _db_e34_0_grad)
    carica_esame(34, 1, _db_e34_1_name, _db_e34_1_cred, _db_e34_1_grad)

    # ── STUDENTE 35 (Offset Int: 140 | Offset Str: 700) ──
    carica_intero(_db_id35, student_id, 140)
    carica_intero(_db_age35, student_age, 140)
    carica_intero(_db_year35, student_year, 140)
    carica_intero(_db_nexams35, student_nexams, 140)
    carica_intero(_db_active35, student_active, 140)
    carica_stringa(_db_name35, student_name, 700)
    carica_stringa(_db_surname35, student_surname, 700)
    carica_esame(35, 0, _db_e35_0_name, _db_e35_0_cred, _db_e35_0_grad)
    carica_esame(35, 1, _db_e35_1_name, _db_e35_1_cred, _db_e35_1_grad)

    # ── STUDENTE 36 (Offset Int: 144 | Offset Str: 720) ──
    carica_intero(_db_id36, student_id, 144)
    carica_intero(_db_age36, student_age, 144)
    carica_intero(_db_year36, student_year, 144)
    carica_intero(_db_nexams36, student_nexams, 144)
    carica_intero(_db_active36, student_active, 144)
    carica_stringa(_db_name36, student_name, 720)
    carica_stringa(_db_surname36, student_surname, 720)
    carica_esame(36, 0, _db_e36_0_name, _db_e36_0_cred, _db_e36_0_grad)

    # ── STUDENTE 37 (Offset Int: 148 | Offset Str: 740) ──
    carica_intero(_db_id37, student_id, 148)
    carica_intero(_db_age37, student_age, 148)
    carica_intero(_db_year37, student_year, 148)
    carica_intero(_db_nexams37, student_nexams, 148)
    carica_intero(_db_active37, student_active, 148)
    carica_stringa(_db_name37, student_name, 740)
    carica_stringa(_db_surname37, student_surname, 740)
    carica_esame(37, 0, _db_e37_0_name, _db_e37_0_cred, _db_e37_0_grad)
    carica_esame(37, 1, _db_e37_1_name, _db_e37_1_cred, _db_e37_1_grad)

    # ── STUDENTE 38 (Offset Int: 152 | Offset Str: 760) ──
    carica_intero(_db_id38, student_id, 152)
    carica_intero(_db_age38, student_age, 152)
    carica_intero(_db_year38, student_year, 152)
    carica_intero(_db_nexams38, student_nexams, 152)
    carica_intero(_db_active38, student_active, 152)
    carica_stringa(_db_name38, student_name, 760)
    carica_stringa(_db_surname38, student_surname, 760)
    carica_esame(38, 0, _db_e38_0_name, _db_e38_0_cred, _db_e38_0_grad)

    # ── STUDENTE 39 (Offset Int: 156 | Offset Str: 780) ──
    carica_intero(_db_id39, student_id, 156)
    carica_intero(_db_age39, student_age, 156)
    carica_intero(_db_year39, student_year, 156)
    carica_intero(_db_nexams39, student_nexams, 156)
    carica_intero(_db_active39, student_active, 156)
    carica_stringa(_db_name39, student_name, 780)
    carica_stringa(_db_surname39, student_surname, 780)
    carica_esame(39, 0, _db_e39_0_name, _db_e39_0_cred, _db_e39_0_grad)
    carica_esame(39, 1, _db_e39_1_name, _db_e39_1_cred, _db_e39_1_grad)

    # ── STUDENTE 40 (Offset Int: 160 | Offset Str: 800) ──
    carica_intero(_db_id40, student_id, 160)
    carica_intero(_db_age40, student_age, 160)
    carica_intero(_db_year40, student_year, 160)
    carica_intero(_db_nexams40, student_nexams, 160)
    carica_intero(_db_active40, student_active, 160)
    carica_stringa(_db_name40, student_name, 800)
    carica_stringa(_db_surname40, student_surname, 800)
    carica_esame(40, 0, _db_e40_0_name, _db_e40_0_cred, _db_e40_0_grad)
    carica_esame(40, 1, _db_e40_1_name, _db_e40_1_cred, _db_e40_1_grad)

    # ── STUDENTE 41 (Offset Int: 164 | Offset Str: 820) ──
    carica_intero(_db_id41, student_id, 164)
    carica_intero(_db_age41, student_age, 164)
    carica_intero(_db_year41, student_year, 164)
    carica_intero(_db_nexams41, student_nexams, 164)
    carica_intero(_db_active41, student_active, 164)
    carica_stringa(_db_name41, student_name, 820)
    carica_stringa(_db_surname41, student_surname, 820)
    carica_esame(41, 0, _db_e41_0_name, _db_e41_0_cred, _db_e41_0_grad)

    # ── STUDENTE 42 (Offset Int: 168 | Offset Str: 840) ──
    carica_intero(_db_id42, student_id, 168)
    carica_intero(_db_age42, student_age, 168)
    carica_intero(_db_year42, student_year, 168)
    carica_intero(_db_nexams42, student_nexams, 168)
    carica_intero(_db_active42, student_active, 168)
    carica_stringa(_db_name42, student_name, 840)
    carica_stringa(_db_surname42, student_surname, 840)
    carica_esame(42, 0, _db_e42_0_name, _db_e42_0_cred, _db_e42_0_grad)
    carica_esame(42, 1, _db_e42_1_name, _db_e42_1_cred, _db_e42_1_grad)

    # ── STUDENTE 43 (Offset Int: 172 | Offset Str: 860) ──
    carica_intero(_db_id43, student_id, 172)
    carica_intero(_db_age43, student_age, 172)
    carica_intero(_db_year43, student_year, 172)
    carica_intero(_db_nexams43, student_nexams, 172)
    carica_intero(_db_active43, student_active, 172)
    carica_stringa(_db_name43, student_name, 860)
    carica_stringa(_db_surname43, student_surname, 860)
    carica_esame(43, 0, _db_e43_0_name, _db_e43_0_cred, _db_e43_0_grad)
    carica_esame(43, 1, _db_e43_1_name, _db_e43_1_cred, _db_e43_1_grad)

    # ── STUDENTE 44 (Offset Int: 176 | Offset Str: 880) ──
    carica_intero(_db_id44, student_id, 176)
    carica_intero(_db_age44, student_age, 176)
    carica_intero(_db_year44, student_year, 176)
    carica_intero(_db_nexams44, student_nexams, 176)
    carica_intero(_db_active44, student_active, 176)
    carica_stringa(_db_name44, student_name, 880)
    carica_stringa(_db_surname44, student_surname, 880)
    carica_esame(44, 0, _db_e44_0_name, _db_e44_0_cred, _db_e44_0_grad)

    # ── STUDENTE 45 (Offset Int: 180 | Offset Str: 900) ──
    carica_intero(_db_id45, student_id, 180)
    carica_intero(_db_age45, student_age, 180)
    carica_intero(_db_year45, student_year, 180)
    carica_intero(_db_nexams45, student_nexams, 180)
    carica_intero(_db_active45, student_active, 180)
    carica_stringa(_db_name45, student_name, 900)
    carica_stringa(_db_surname45, student_surname, 900)
    carica_esame(45, 0, _db_e45_0_name, _db_e45_0_cred, _db_e45_0_grad)
    carica_esame(45, 1, _db_e45_1_name, _db_e45_1_cred, _db_e45_1_grad)

    # ── STUDENTE 46 (Offset Int: 184 | Offset Str: 920) ──
    carica_intero(_db_id46, student_id, 184)
    carica_intero(_db_age46, student_age, 184)
    carica_intero(_db_year46, student_year, 184)
    carica_intero(_db_nexams46, student_nexams, 184)
    carica_intero(_db_active46, student_active, 184)
    carica_stringa(_db_name46, student_name, 920)
    carica_stringa(_db_surname46, student_surname, 920)
    carica_esame(46, 0, _db_e46_0_name, _db_e46_0_cred, _db_e46_0_grad)

    # ── STUDENTE 47 (Offset Int: 188 | Offset Str: 940) ──
    carica_intero(_db_id47, student_id, 188)
    carica_intero(_db_age47, student_age, 188)
    carica_intero(_db_year47, student_year, 188)
    carica_intero(_db_nexams47, student_nexams, 188)
    carica_intero(_db_active47, student_active, 188)
    carica_stringa(_db_name47, student_name, 940)
    carica_stringa(_db_surname47, student_surname, 940)
    carica_esame(47, 0, _db_e47_0_name, _db_e47_0_cred, _db_e47_0_grad)
    carica_esame(47, 1, _db_e47_1_name, _db_e47_1_cred, _db_e47_1_grad)
    carica_esame(47, 2, _db_e47_2_name, _db_e47_2_cred, _db_e47_2_grad)

    # ── STUDENTE 48 (Offset Int: 192 | Offset Str: 960) ──
    carica_intero(_db_id48, student_id, 192)
    carica_intero(_db_age48, student_age, 192)
    carica_intero(_db_year48, student_year, 192)
    carica_intero(_db_nexams48, student_nexams, 192)
    carica_intero(_db_active48, student_active, 192)
    carica_stringa(_db_name48, student_name, 960)
    carica_stringa(_db_surname48, student_surname, 960)
    carica_esame(48, 0, _db_e48_0_name, _db_e48_0_cred, _db_e48_0_grad)
    carica_esame(48, 1, _db_e48_1_name, _db_e48_1_cred, _db_e48_1_grad)

    # ── STUDENTE 49 (Offset Int: 196 | Offset Str: 980) ──
    carica_intero(_db_id49, student_id, 196)
    carica_intero(_db_age49, student_age, 196)
    carica_intero(_db_year49, student_year, 196)
    carica_intero(_db_nexams49, student_nexams, 196)
    carica_intero(_db_active49, student_active, 196)
    carica_stringa(_db_name49, student_name, 980)
    carica_stringa(_db_surname49, student_surname, 980)
    carica_esame(49, 0, _db_e49_0_name, _db_e49_0_cred, _db_e49_0_grad)
    carica_esame(49, 1, _db_e49_1_name, _db_e49_1_cred, _db_e49_1_grad)

    # ── INIZIALIZZAZIONE CONTATORE STUDENTI ──
    li $t0, 50                  # 50 studenti inseriti
    la $t1, student_count
    sw $t0, 0($t1)

    # Ripristino $ra e ritorno al main
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra