.macro stampa_linea_separatrice
# --- Stampa Linea Separatrice ---
    li $v0, 4
    la $a0, separator_msg
    syscall
.end_macro

#-------------------------------------------------------------------------
# MACRO: cerca_studente_per_id
# Pezzo ripetitivo estratto: acquisisce l'ID, invoca la funzione di backend
# e salta automaticamente all'etichetta di errore se il record non esiste.
# Se esiste, restituisce l'indice in $v0.
#-------------------------------------------------------------------------
.macro cerca_studente_per_id(%id_reg, %not_found_label)
    move $a0, %id_reg           # Copia l'ID registrato in $a0 per la funzione
    jal find_index_by_id        # Chiama l'algoritmo di ricerca per ID
    li $t0, -1
    beq $v0, $t0, %not_found_label # Se ritorna -1 (non trovato), salta all'errore
.end_macro

#-----------------------------------------------
# --- MACRO PER STAMPARE UN SINGOLO STUDENTE ---
#-----------------------------------------------
.macro print_student (%indice)
    # Calcolo degli offset
    sll $t0, %indice, 2             # $t0 = offset per interi (i * 4)
    li $t1, 20
    mul $t1, %indice, $t1           # $t1 = offset per le stringhe (i * 20)

    # --- Stampa ID ---
    stampa_linea_separatrice
    li $v0, 4
    la $a0, id_label
    syscall
    la $t2, student_id
    add $t2, $t2, $t0
    lw $a0, 0($t2)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # --- Stampa Nome ---
    li $v0, 4
    la $a0, name_label
    syscall
    la $t2, student_name
    add $a0, $t2, $t1
    li $v0, 4
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # --- Stampa Cognome ---
    li $v0, 4
    la $a0, surname_label
    syscall
    la $t2, student_surname
    add $a0, $t2, $t1
    li $v0, 4
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # --- Stampa Età ---
    li $v0, 4
    la $a0, age_label
    syscall
    la $t2, student_age
    add $t2, $t2, $t0
    lw $a0, 0($t2)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # --- Stampa Anno Iscrizione ---
    li $v0, 4
    la $a0, year_label
    syscall
    la $t2, student_year
    add $t2, $t2, $t0
    lw $a0, 0($t2)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # --- Stampa Numero Esami ---
    li $v0, 4
    la $a0, nexams_label
    syscall
    la $t2, student_nexams
    add $t2, $t2, $t0
    lw $a0, 0($t2)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # --- Stampa Stato (Active / Inactive) ---
    la $t2, student_active
    add $t2, $t2, $t0
    lw $t3, 0($t2)              # Legge 1 (attivo) o 0 (inattivo/eliminato)
    
    beq $t3, $zero, print_inactive# Se è 0, salta a Inactive
    la $a0, active_label        # Se è 1, carica l'etichetta "Status: Active\n"
    j print_status_end      
    
print_inactive:
    la $a0, inactive_label      # Carica l'etichetta "Status: Inactive\n"

print_status_end:
    li $v0, 4                   # Syscall per stampare la stringa di stato decisa
    syscall                     

    # --- Stampa Linea Separatrice ---
    stampa_linea_separatrice
.end_macro

#-----------------------------------------
# Macro per chiedere un intero all'utente
#------------------------------------------
.macro chiedi_intero(%msg_label, %reg_dest)
    li $v0, 4               # Syscall per stampare stringa
    la $a0, %msg_label      # Carica il messaggio
    syscall
    li $v0, 5               # Syscall per leggere intero
    syscall
    move %reg_dest, $v0     # Salva il risultato nel registro scelto
.end_macro

#-----------------------------------------
# Macro per chiedere una stringa all'utente
#-----------------------------------------
.macro chiedi_stringa(%msg_label, %indirizzo_dest, %lunghezza_max)
    li $v0, 4
    la $a0, %msg_label
    syscall
    li $v0, 8               # Syscall per leggere stringa
    move $a0, %indirizzo_dest
    li $a1, %lunghezza_max
    syscall
.end_macro


# ========================================================================================================================================
# MACRO LOCALE PER LO SWAP DI MEMORIA
# ========================================================================================================================================
.macro scambia_array(%array, %off1, %off2, %size)
    la $a0, %array
    add $a0, $a0, %off1
    la $a1, %array
    add $a1, $a1, %off2
    li $a2, %size
    jal swap_bytes_memory
.end_macro


