.text
# ==============================================================================
# NOME: copy_string
# UTILIZZO: Utility di Base (Inizializzazione DB, Modifica dati)
# DESCRIZIONE: Copia una stringa di caratteri dalla sorgente alla destinazione,
#              arrestandosi automaticamente quando incontra il terminatore '\0'.
# NOTE: Include un blocco di sicurezza hardware per fermarsi a 19 caratteri.
# ==============================================================================

copy_string:
    li $t1, 0                   # Contatore caratteri copiati

copy_string_loop:
    lb $t0, 0($a0)              # Leggo 1 byte 
    sb $t0, 0($a1)              # Lo scrivo
    
    beq $t0, $zero, copy_end    # Se è '\0' (zero logico), la parola è finita!
    
    addi $a0, $a0, 1            # Avanzo puntatore sorgente
    addi $a1, $a1, 1            # Avanzo puntatore destinazione
    
    addi $t1, $t1, 1            # Incremento contatore
    li $t2, 19
    beq $t1, $t2, copy_end      # Limite di sicurezza: max 19 caratteri
    
    j copy_string_loop

copy_end:
    jr $ra                      # Torna al chiamante
    

# ==============================================================================
# NOME: strip_newline
# UTILIZZO: Utility di Base (Usata dopo ogni acquisizione di stringa)
# DESCRIZIONE: Sanatizza le stringhe inserite dall'utente, sostituendo il carattere 
#              'Invio' (\n) con un terminatore di stringa standard (\0).
# ==============================================================================
strip_newline:
strip_nl_loop:
    lb $t0, 0($a0)
    beq $t0, 10, found_nl       # ASCII 10 = \n
    beq $t0, 0, done_nl         # ASCII 0 = \0 (fine stringa)
    addi $a0, $a0, 1
    j strip_nl_loop
found_nl:
    sb $zero, 0($a0)            # Sostituzione \n con un terminatore pulito \0
done_nl:
    jr $ra
    
# ==============================================================================
# NOME: find_index_by_id
# UTILIZZO: Utility di Backend (Usata nei Case 3, 5, 6, 7, 8, 17)
# DESCRIZIONE: Motore di ricerca lineare per ID all'interno del database.
# NOTE: Ritorna l'indice fisico se trovato e attivo, altrimenti ritorna -1.
# ==============================================================================
find_index_by_id:
    la $t0, student_count
    lw $t1, 0($t0)              # Totale record
    li $t2, 0                   # Indice ciclo i = 0

find_id_loop:
    beq $t2, $t1, find_id_not_found 

    # --- CONTROLLO INTEGRITÀ ELIMINAZIONE LOGICA ---
    sll $t3, $t2, 2
    la $t4, student_active
    add $t4, $t4, $t3
    lw $t5, 0($t4)
    beq $t5, $zero, find_id_next # Se active == 0, ignora e prosegui oltre

    # Controllo ID Effettivo
    la $t4, student_id
    add $t4, $t4, $t3
    lw $t5, 0($t4)
    beq $t5, $a0, find_id_success 

find_id_next:
    addi $t2, $t2, 1            # i++
    j find_id_loop

find_id_success:
    move $v0, $t2               
    jr $ra

find_id_not_found:
    li $v0, -1                  
    jr $ra    
    
# ========================================================================================================================================
# BACK-END CORE UTILITY 4: find_index_by_surname
# Algoritmo di confronto stringa per trovare la prima occorrenza di un cognome
# ========================================================================================================================================
find_index_by_surname:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)

    move $s0, $a0               # Indirizzo stringa ricercata
    la $t0, student_count
    lw $s1, 0($t0)              
    li $s2, 0                   

find_surname_loop:
    beq $s2, $s1, find_surname_not_found

    # Salta se inattivo
    sll $t3, $s2, 2
    la $t4, student_active
    add $t4, $t4, $t3
    lw $t5, 0($t4)
    beq $t5, $zero, find_surname_next 

    li $t4, 20
    mul $t5, $s2, $t4
    la $s3, student_surname
    add $s3, $s3, $t5

    move $a0, $s0               
    move $a1, $s3               
strcmp_loop:
    lb $t7, 0($a0)
    lb $t8, 0($a1)
    bne $t7, $t8, find_surname_next      
    beq $t7, $zero, find_surname_success 
    addi $a0, $a0, 1            
    addi $a1, $a1, 1            
    j strcmp_loop

find_surname_next:
    addi $s2, $s2, 1            
    j find_surname_loop

find_surname_success:
    move $v0, $s2               
    j find_surname_end

find_surname_not_found:
    li $v0, -1                  

find_surname_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

# ----------------------------------------------------------------------------------------------------------------------------------------
# UTILITY EXTRA 1: copy_student_record
# (Conservata per usi futuri come l'ordinamento avanzato del DB)
# ----------------------------------------------------------------------------------------------------------------------------------------
copy_student_record:
    addi $sp, $sp, -28
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)

    move $s0, $a0               # Destinazione
    move $s1, $a1               # Sorgente

    sll $t0, $s0, 2             
    sll $t1, $s1, 2             
    lw $t2, student_id($t1)
    sw $t2, student_id($t0)
    lw $t2, student_age($t1)
    sw $t2, student_age($t0)
    lw $t2, student_year($t1)
    sw $t2, student_year($t0)
    lw $t2, student_nexams($t1)
    sw $t2, student_nexams($t0)
    lw $t2, student_active($t1)
    sw $t2, student_active($t0)

    li $t2, 20
    mul $s2, $s0, $t2           
    mul $s3, $s1, $t2           

    la $a1, student_name
    add $a1, $a1, $s2           
    la $a0, student_name
    add $a0, $a0, $s3           
    jal copy_string

    la $a1, student_surname
    add $a1, $a1, $s2
    la $a0, student_surname
    add $a0, $a0, $s3
    jal copy_string

    li $s4, 0                   
csr_exams_loop:
    li $t0, 20
    beq $s4, $t0, csr_end

    mul $t1, $s0, $t0
    add $t1, $t1, $s4           
    mul $t2, $s1, $t0
    add $t2, $t2, $s4           

    sll $t3, $t1, 2             
    sll $t4, $t2, 2             

    lw $t5, exam_credits($t4)
    sw $t5, exam_credits($t3)
    lw $t5, exam_grade($t4)
    sw $t5, exam_grade($t3)

    li $t5, 46
    mul $t6, $t1, $t5           
    mul $t7, $t2, $t5           

    la $a1, exam_name
    add $a1, $a1, $t6
    la $a0, exam_name
    add $a0, $a0, $t7
    jal copy_string

    addi $s4, $s4, 1
    j csr_exams_loop

csr_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    addi $sp, $sp, 28
    jr $ra

# ----------------------------------------------------------------------------------------------------------------------------------------
# UTILITY EXTRA 2: clear_student_record
# (Conservata per svuotare blocchi di memoria fisici se necessario)
# ----------------------------------------------------------------------------------------------------------------------------------------
clear_student_record:
    move $t0, $a0               
    
    sll $t1, $t0, 2             
    sw $zero, student_id($t1)
    sw $zero, student_age($t1)
    sw $zero, student_year($t1)
    sw $zero, student_nexams($t1)
    sw $zero, student_active($t1)

    li $t2, 20
    mul $t3, $t0, $t2
    la $t4, student_name
    add $t4, $t4, $t3
    sb $zero, 0($t4)            
    la $t4, student_surname
    add $t4, $t4, $t3
    sb $zero, 0($t4)            

    li $t5, 0                   
clr_exams_loop:
    li $t2, 20
    beq $t5, $t2, clr_end

    mul $t6, $t0, $t2
    add $t6, $t6, $t5
    sll $t7, $t6, 2

    sw $zero, exam_credits($t7)
    sw $zero, exam_grade($t7)

    li $t8, 46
    mul $t9, $t6, $t8
    la $t4, exam_name
    add $t4, $t4, $t9
    sb $zero, 0($t4)            

    addi $t5, $t5, 1
    j clr_exams_loop

clr_end:
    jr $ra
    
# ==============================================================================
# NOME: get_student_gpa
# UTILIZZO: Utility di Backend (Usata nei Case 8, 9, 14, 16)
# DESCRIZIONE: Calcola matematicamente in background la media ponderata di uno studente.
# NOTE: Previene le eccezioni di divisione per zero e restituisce un flag di stato.
# ==============================================================================
get_student_gpa:
    # --- Salvataggio Registri ---
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Indice studente
    sw $s1, 8($sp)              # Accumulatore: Somma ponderata (Voto * Crediti)
    sw $s2, 12($sp)             # Numero esami sostenuti
    sw $s3, 16($sp)             # Accumulatore: Somma totale dei crediti

    move $s0, $a0               # Trasferisce l'indice in $s0
    sll $t0, $s0, 2             # Offset word

    # --- Controllo Numero Esami ---
    la $t1, student_nexams
    add $t1, $t1, $t0
    lw $s2, 0($t1)              # Carica numero esami

    beq $s2, $zero, get_gpa_no_exams # Se ha 0 esami, salta (evita divisione per zero)

    # --- Inizializzazione Accumulatori ---
    li $s1, 0                   # Azzera Somma Ponderata
    li $s3, 0                   # Azzera Somma Crediti
    li $t9, 0                   # Contatore ciclo (k)

get_gpa_loop:
    beq $t9, $s2, get_gpa_calc  # Fine ciclo esami

    li $t0, 20
    mul $t1, $s0, $t0           
    add $t1, $t1, $t9           
    sll $t2, $t1, 2             # $t2 = Offset dell'esame esatto

    la $t0, exam_credits
    add $t0, $t0, $t2
    lw $t3, 0($t0)              # $t3 = Crediti esame
    add $s3, $s3, $t3           # Somma i crediti all'accumulatore totale

    la $t0, exam_grade
    add $t0, $t0, $t2
    lw $t4, 0($t0)              # $t4 = Voto esame

    mul $t5, $t3, $t4           # Ponderazione (Voto * Crediti)
    add $s1, $s1, $t5           # Aggiunge alla Somma Ponderata

    addi $t9, $t9, 1
    j get_gpa_loop

get_gpa_calc:
    # Conversione in virgola mobile e calcolo finale
    mtc1 $s1, $f0               
    cvt.s.w $f0, $f0            # Converte Somma Ponderata in float
    mtc1 $s3, $f1               
    cvt.s.w $f1, $f1            # Converte Somma Crediti in float
    
    div.s $f0, $f0, $f1         # $f0 = (Somma Ponderata) / (Somma Crediti)
    
    li $v1, 1                   # Imposta flag di successo ($v1 = 1)
    j get_gpa_exit

get_gpa_no_exams:
    li $v1, 0                   # Imposta flag di errore ($v1 = 0)

get_gpa_exit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra                      # Ritorna il risultato al chiamante
    
# ========================================================================================================================================
# UTILITY: get_student_credits
# Calcola i crediti totali acquisiti da uno studente in modo "silenzioso", riutilizzabile da altre funzioni.
# INPUT:  $a0 = Indice dello studente
# OUTPUT: $v0 = Crediti totali (Intero)
# ========================================================================================================================================
get_student_credits:
    # --- Salvataggio Registri nello Stack ---
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Indice dello studente
    sw $s1, 8($sp)              # Accumulatore dei crediti totali
    sw $s2, 12($sp)             # Numero totale di esami sostenuti dallo studente

    move $s0, $a0               # Copia l'indice in $s0
    sll $t0, $s0, 2             # Calcola l'offset word (i * 4) per gli array degli studenti

    # Carica il numero di esami dello studente
    la $t1, student_nexams
    add $t1, $t1, $t0
    lw $s2, 0($t1)              # $s2 = numero di esami del record

    # Inizializzazione cicli e accumulatori
    li $s1, 0                   # Somma crediti = 0
    li $t9, 0                   # Indice del ciclo esami (k = 0)

get_credits_loop:
    beq $t9, $s2, get_credits_exit # Se k == numero_esami, esce dal ciclo

    # Calcolo dell'offset esatto dell'esame nella matrice lineare:
    # Offset in byte = ((studente_index * 20) + k) * 4
    li $t0, 20
    mul $t1, $s0, $t0           # index * 20
    add $t1, $t1, $t9           # + k
    sll $t2, $t1, 2             # * 4 (trasforma in offset byte)

    # Accedi all'array dei crediti d'esame
    la $t0, exam_credits
    add $t0, $t0, $t2
    lw $t3, 0($t0)              # $t3 = Crediti dell'esame corrente

    add $s1, $s1, $t3           # Accumula i crediti: somma += crediti

    addi $t9, $t9, 1            # Avanza all'esame successivo (k++)
    j get_credits_loop

get_credits_exit:
    move $v0, $s1               # Posiziona il risultato finale nel registro di output $v0
    
    # Ripristino dello Stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra                      # Ritorna al codice chiamante
    
