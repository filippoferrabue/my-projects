.text     


# ============================================================================================================================================================
# NOME: insert_student
# UTILIZZO: Case 1
# DESCRIZIONE: Inserisce un nuovo studente nel database chiedendo i dati all'utente.
#              Gestisce i controlli di errore per database pieno (Max 100) e
#              la validazione dell'età (range 18-100).
# NOTE: Preserva il registro $ra nello Stack.
# ============================================================================================================================================================

insert_student:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # 1. Controlla spazio disponibile (Max 100)
    la $t0, student_count
    lw $t1, 0($t0)              # $t1 = numero corrente di studenti
    li $t2, 100
    beq $t1, $t2, db_full_error

    # 2. Calcola offset base per il nuovo slot
    sll $t3, $t1, 2             # Offset tipi interi ($t1 * 4)
    li $t4, 20
    mul $t5, $t1, $t4           # Offset tipi stringa ($t1 * 20)

    # --- INSERIMENTO DATI ANAGRAFICI ---
    chiedi_intero(insert_id_msg, $t6)
    la $t7, student_id
    add $t7, $t7, $t3
    sw $t6, 0($t7)

ask_age:
    chiedi_intero(insert_age_msg, $t6)
    bgt $t6, 100, invalid_age   # Controllo validità età max
    blt $t6, 18, invalid_age    # Controllo validità età min
    la $t7, student_age
    add $t7, $t7, $t3
    sw $t6, 0($t7)
    j ask_year

invalid_age:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j ask_age                   

ask_year:
    chiedi_intero(insert_year_msg, $t6)
    li $t2, 2027
    bge $t6, $t2, invalid_year  # Controllo anno futuro
    blt $t6, 1950, invalid_year # Controllo anno obsoleto
    la $t7, student_year
    add $t7, $t7, $t3
    sw $t6, 0($t7)
    j strings_insert

invalid_year:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j ask_year                  

strings_insert:
    # Imposta lo stato a 1 (Attivo) di default
    la $t7, student_active
    add $t7, $t7, $t3
    li $t6, 1
    sw $t6, 0($t7)

    # --- INSERIMENTO STRINGHE NOME/COGNOME ---
    la $t7, student_name
    add $t8, $t7, $t5           
    chiedi_stringa(insert_name_msg, $t8, 20)
    move $a0, $t8
    jal strip_newline           

    la $t7, student_surname
    add $t8, $t7, $t5
    chiedi_stringa(insert_surname_msg, $t8, 20)
    move $a0, $t8
    jal strip_newline           

    # --- CICLO INSERIMENTO ESAMI CONTESTUALE ---
    li $s0, 0                   # $s0 = contatore esami per lo studente corrente
insert_exam_loop:
    li $t2, 20
    beq $s0, $t2, end_exam_loop # Controllo limite max esami per studente (20)

    chiedi_intero(add_exam_choice_msg, $t6)
    beq $t6, $zero, end_exam_loop # Se l'utente digita 0, termina l'inserimento esami

    # Calcolo offset per lo slot esame specifico
    li $t2, 20
    mul $t9, $t1, $t2           # (studente * 20)
    add $t9, $t9, $s0           # indice totale esame nel DB esami

    sll $t4, $t9, 2             # Offset word esami ($t9 * 4)
    li $t2, 46
    mul $t8, $t9, $t2           # Offset stringa esami ($t9 * 46)

    la $t7, exam_name
    add $t7, $t7, $t8           
    chiedi_stringa(exam_name_msg, $t7, 46)
    move $a0, $t7
    jal strip_newline

ask_credits:
    chiedi_intero(exam_credits_msg, $t6)
    bgt $t6, 12, invalid_credits
    blt $t6, 1, invalid_credits
    la $t7, exam_credits
    add $t7, $t7, $t4
    sw $t6, 0($t7)
    j ask_grade

invalid_credits:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j ask_credits               

ask_grade:
    chiedi_intero(exam_grade_msg, $t6)
    bgt $t6, 31, invalid_grade
    blt $t6, 18, invalid_grade
    la $t7, exam_grade
    add $t7, $t7, $t4
    sw $t6, 0($t7)
    
    addi $s0, $s0, 1            # Incrementa contatore esami superati
    j insert_exam_loop          

invalid_grade:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j ask_grade                 

end_exam_loop:
    # Memorizza il conteggio esami effettivo nell'array anagrafico dello studente
    la $t7, student_nexams
    add $t7, $t7, $t3
    sw $s0, 0($t7)

    # Incrementa il contatore del database globale (+1 record)
    la $t0, student_count
    addi $t1, $t1, 1
    sw $t1, 0($t0)

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

db_full_error:
    li $v0, 4
    la $a0, error_msg
    syscall
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------


# ============================================================================================================================================================
# NOME: print_all_students
# UTILIZZO: Case 2
# DESCRIZIONE: Scorre l'intero database e stampa a schermo i dati anagrafici completi
#              dei soli studenti ATTIVI. Calcola e mostra il conteggio reale finale.
# NOTE: Salva e ripristina $ra, $s0 (indice), $s1 (limite), $s2 (contatore attivi).
# ============================================================================================================================================================
print_all_students:
    # --- Salvataggio Registri nello Stack ---
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Indice del ciclo (i)
    sw $s1, 8($sp)              # Numero totale di record nel DB (student_count)
    sw $s2, 12($sp)             # CONTEGGIO REALE degli studenti attivi stampati

    # Stampa l'intestazione
    li $v0, 4
    la $a0, print_all_title
    syscall

    # Inizializzazione variabili del ciclo
    la $t0, student_count
    lw $s1, 0($t0)              # $s1 = limite massimo dei record inseriti
    li $s0, 0                   # i = 0
    li $s2, 0                   # Contatore studenti attivi = 0

print_all_loop:
    beq $s0, $s1, print_all_end # Se i == student_count, esci dal ciclo

    # --- CONTROLLO SE LO STUDENTE E' ATTIVO ---
    sll $t1, $s0, 2             # Offset = i * 4
    la $t0, student_active
    add $t0, $t0, $t1
    lw $t2, 0($t0)              # Carica lo stato (1 = attivo, 0 = eliminato)
    
    beq $t2, $zero, print_all_next # SE E' INATTIVO (0): Salta al prossimo senza stampare e senza contare!

    # --- STUDENTE ATTIVO TROVATO ---
    addi $s2, $s2, 1            # Incrementa il conteggio reale (+1 studente visibile)

    # Stampa lo studente passando l'indice fisico ($s0) alla tua macro
    move $a0, $s0
    print_student($a0)

print_all_next:
    addi $s0, $s0, 1            # i++ (Avanza al prossimo record nell'array)
    j print_all_loop

print_all_end:
    # --- AGGIUSTAMENTO E VERIFICA DEL CONTEGGIO ---
    bne $s2, $zero, print_total_footer # Se il contatore reali è > 0, salta al riepilogo finale

    # Se siamo qui, il contatore è rimasto a 0 (nessuno studente era attivo o il DB è vuoto)
    li $v0, 4
    la $a0, no_active_students_msg
    syscall
    j print_all_exit

print_total_footer:
    # Stampa il riepilogo con il conteggio corretto degli studenti effettivamente stampati
    li $v0, 4
    la $a0, total_displayed_msg
    syscall
    
    move $a0, $s2               # Passa il valore del contatore reale degli attivi
    li $v0, 1                   # Syscall 1: Stampa Intero
    syscall
    
    li $v0, 4
    la $a0, newline_msg         # Va a capo per pulizia grafica
    syscall

print_all_exit:
    # --- Ripristino dello Stack ---
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra                      # Ritorna al menu principale
    
    
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------


# ==============================================================================
# NOME: search_by_id
# UTILIZZO: Case 3
# DESCRIZIONE: Chiede un ID all'utente, invoca la funzione di ricerca e, se trovato,
#              stampa la scheda anagrafica completa dello studente.
# NOTE: Sfrutta la macro cerca_studente_per_id e preserva lo Stack.
# ==============================================================================

search_by_id:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    chiedi_intero(search_id_msg, $t0)
    
    # Utilizzo della Macro Centralizzata per eliminare duplicati di codice!
    cerca_studente_per_id($t0, print_id_not_found)

    # Se arriviamo qui, lo studente esiste e l'indice è salvato in $v0
    move $s0, $v0               
    li $v0, 4
    la $a0, found_msg
    syscall

    move $a0, $s0               
    print_student($a0)          
    j search_id_end             

print_id_not_found:
    li $v0, 4
    la $a0, not_found_msg
    syscall

search_id_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
 
 
 
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------

# ==============================================================================
# NOME: search_by_surname
# UTILIZZO: Case 4
# DESCRIZIONE: Esegue una ricerca per cognome. Scorre i record attivi e stampa 
#              la scheda di tutti gli studenti il cui cognome coincide esattamente.
# NOTE: Utilizza una logica di confronto stringa carattere per carattere (byte per byte).
# ==============================================================================
search_by_surname:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    la $t0, search_buffer
    chiedi_stringa(search_surname_msg, $t0, 20)

    la $a0, search_buffer
    jal strip_newline

    la $t0, student_count
    lw $s1, 0($t0)              
    li $s2, 0                   
    li $s4, 0                   # Registro accumulatore dei record trovati

search_surname_loop:
    beq $s2, $s1, search_surname_end_loop 

    sll $t3, $s2, 2
    la $t4, student_active
    add $t4, $t4, $t3
    lw $t5, 0($t4)
    beq $t5, $zero, search_surname_next   

    li $t4, 20
    mul $t5, $s2, $t4
    la $s3, student_surname
    add $s3, $s3, $t5

    la $a0, search_buffer       
    move $a1, $s3               
strcmp_loop_multi:
    lb $t7, 0($a0)
    lb $t8, 0($a1)
    bne $t7, $t8, search_surname_next        
    beq $t7, $zero, search_surname_match     
    addi $a0, $a0, 1            
    addi $a1, $a1, 1            
    j strcmp_loop_multi

search_surname_match:
    li $v0, 4
    la $a0, found_msg
    syscall

    move $a0, $s2
    print_student($a0)          

    addi $s4, $s4, 1            # Incrementa contatore riscontri positivi

search_surname_next:
    addi $s2, $s2, 1            
    j search_surname_loop       

search_surname_end_loop:
    bgt $s4, $zero, search_surname_exit 

    li $v0, 4
    la $a0, not_found_msg
    syscall

search_surname_exit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------

# ==============================================================================
# NOME: add_exam
# UTILIZZO: Case 5
# DESCRIZIONE: Registra un nuovo esame superato per uno studente identificato da ID.
#              Controlla che lo studente non abbia già raggiunto il limite di 20 esami.
# NOTE: Calcola l'offset bidimensionale linearizzato: ((index * 20) + k) * size.
# ==============================================================================

add_exam:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    chiedi_intero(search_id_msg, $t0)
    
    # Utilizzo della Macro Centralizzata!
    cerca_studente_per_id($t0, add_exam_not_found)

    move $s0, $v0               # Salva l'indice valido trovato

    sll $t1, $s0, 2             
    la $t2, student_nexams
    add $t2, $t2, $t1
    lw $s1, 0($t2)              # $s1 = numero esami inseriti in precedenza

    li $t3, 20
    beq $s1, $t3, add_exam_full 

    li $t3, 20
    mul $t4, $s0, $t3
    add $t4, $t4, $s1           

    sll $t5, $t4, 2             
    li $t3, 46
    mul $t6, $t4, $t3           

    la $s2, exam_name
    add $s2, $s2, $t6           
    chiedi_stringa(exam_name_msg, $s2, 46)
    
    move $a0, $s2
    jal strip_newline

    # --- SOTTOCICLO DI SICUREZZA INTERNO: ANTI-DUPLICATI ---
    li $t9, 0                   
check_duplicate_loop:
    beq $t9, $s1, add_exam_credits 

    li $t3, 20
    mul $t4, $s0, $t3           
    add $t4, $t4, $t9           
    li $t3, 46
    mul $t8, $t4, $t3           

    la $a1, exam_name
    add $a1, $a1, $t8           

    move $a0, $s2               
strcmp_dup_loop:
    lb $t7, 0($a0)
    lb $t8, 0($a1)
    bne $t7, $t8, check_duplicate_next  
    beq $t7, $zero, duplicate_found     
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    j strcmp_dup_loop

check_duplicate_next:
    addi $t9, $t9, 1            
    j check_duplicate_loop      

duplicate_found:
    li $v0, 4
    la $a0, duplicate_exam_msg
    syscall
    j add_exam_exit             

add_exam_credits:
    chiedi_intero(exam_credits_msg, $t8)
    bgt $t8, 12, add_exam_inv_cred
    blt $t8, 1, add_exam_inv_cred
    la $t7, exam_credits
    add $t7, $t7, $t5
    sw $t8, 0($t7)
    j add_exam_grade

add_exam_inv_cred:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j add_exam_credits

add_exam_grade:
    chiedi_intero(exam_grade_msg, $t8)
    bgt $t8, 31, add_exam_inv_grade
    blt $t8, 18, add_exam_inv_grade
    la $t7, exam_grade
    add $t7, $t7, $t5
    sw $t8, 0($t7)
    j add_exam_finish

add_exam_inv_grade:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j add_exam_grade

add_exam_finish:
    addi $s1, $s1, 1
    sll $t1, $s0, 2
    la $t2, student_nexams
    add $t2, $t2, $t1
    sw $s1, 0($t2)

    li $v0, 4
    la $a0, exam_success_msg
    syscall
    j add_exam_exit

add_exam_not_found:
    li $v0, 4
    la $a0, not_found_msg
    syscall
    j add_exam_exit

add_exam_full:
    li $v0, 4
    la $a0, error_msg           
    syscall

add_exam_exit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
  
# ==============================================================================
# NOME: edit_student
# UTILIZZO: Case 6
# DESCRIZIONE: Permette la sovrascrittura dei dati anagrafici (Nome, Cognome, Età, 
#              Anno) di uno studente attivo cercato tramite il suo ID.
# ==============================================================================

edit_student:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Indice dello studente trovato
    sw $s1, 8($sp)              # Offset per tipi word (indice * 4)
    sw $s2, 12($sp)             # Offset per stringhe anagrafiche (indice * 20)

    chiedi_intero(search_id_msg, $t0)
    
    # Utilizzo della Macro Centralizzata!
    cerca_studente_per_id($t0, edit_not_found)

    move $s0, $v0               
    sll $s1, $s0, 2             
    li $t0, 20
    mul $s2, $s0, $t0           

edit_submenu_loop:
    chiedi_intero(edit_menu_msg, $t0)
    
    beq $t0, $zero, edit_success 
    li $t1, 1
    beq $t0, $t1, edit_name     
    li $t1, 2
    beq $t0, $t1, edit_surname  
    li $t1, 3
    beq $t0, $t1, edit_age      
    li $t1, 4
    beq $t0, $t1, edit_year     
    
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j edit_submenu_loop

edit_name:
    la $t0, student_name
    add $t1, $t0, $s2           
    chiedi_stringa(insert_name_msg, $t1, 20)
    move $a0, $t1
    jal strip_newline           
    j show_updated_student      

edit_surname:
    la $t0, student_surname
    add $t1, $t0, $s2           
    chiedi_stringa(insert_surname_msg, $t1, 20)
    move $a0, $t1
    jal strip_newline           
    j show_updated_student      

edit_age:
    chiedi_intero(insert_age_msg, $t6)
    bgt $t6, 100, edit_invalid_age
    blt $t6, 18, edit_invalid_age
    la $t7, student_age
    add $t7, $t7, $s1
    sw $t6, 0($t7)
    j show_updated_student

edit_invalid_age:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j edit_age

edit_year:
    chiedi_intero(insert_year_msg, $t6)
    li $t2, 2027
    bge $t6, $t2, edit_invalid_year
    blt $t6, 1950, edit_invalid_year
    la $t7, student_year
    add $t7, $t7, $s1
    sw $t6, 0($t7)
    j show_updated_student

edit_invalid_year:
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j edit_year

show_updated_student:
    move $a0, $s0               
    print_student($a0)          
    j edit_submenu_loop         

edit_success:
    li $v0, 4
    la $a0, edit_success_msg    
    syscall
    j edit_exit

edit_not_found:
    li $v0, 4
    la $a0, not_found_msg       
    syscall

edit_exit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra                      

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
  
# ==============================================================================
# NOME: delete_student
# UTILIZZO: Case 7
# DESCRIZIONE: Esegue la cancellazione logica di uno studente tramite ID.
#              Imposta il flag student_active a 0 senza alterare fisicamente i dati.
# ==============================================================================
delete_student:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Conterrà l'indice dello studente trovato
    sw $s1, 8($sp)              # Conterrà l'offset di tipo word (indice * 4)

    chiedi_intero(search_id_msg, $t0)
    
    # Utilizzo della Macro Centralizzata!
    cerca_studente_per_id($t0, delete_not_found)

    # Record individuato con successo
    move $s0, $v0               
    sll $s1, $s0, 2             

    li $v0, 4
    la $a0, found_msg           
    syscall

    move $a0, $s0
    print_student($a0)          # Mostra i dati anagrafici attuali prima della revoca dello stato

ask_confirm_delete:
    chiedi_intero(delete_confirm_msg, $t0)
    beq $t0, $zero, delete_cancelled # Scelta 0: Interrompe l'azione
    li $t1, 1
    beq $t0, $t1, delete_execute     # Scelta 1: Procedi con l'eliminazione logica

    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j ask_confirm_delete        

delete_execute:
    # --- ESECUZIONE CORRETTA SOFT DELETE (Cancellazione logica come da specifica) ---
    la $t2, student_active
    add $t2, $t2, $s1
    sw $zero, 0($t2)            # Sovrascrive lo stato portandolo da 1 (Attivo) a 0 (Inattivo)

    li $v0, 4
    la $a0, deleted_msg         
    syscall
    j delete_exit

delete_cancelled:
    li $v0, 4
    la $a0, delete_cancel_msg   
    syscall
    j delete_exit

delete_not_found:
    li $v0, 4
    la $a0, not_found_msg       
    syscall

delete_exit:
    lw $ra, 0($sp)              
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12           
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------

# ==============================================================================
# NOME: calculate_gpa
# UTILIZZO: Case 8
# DESCRIZIONE: Richiede l'ID di uno studente e ne mostra a video la media ponderata 
#              calcolata richiamando la funzione matematica di backend.
# ==============================================================================

calculate_gpa:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Salverà l'indice dello studente

    # 1. Ricerca Studente tramite Macro
    chiedi_intero(search_id_msg, $t0)
    cerca_studente_per_id($t0, print_gpa_not_found)

    # 2. Studente Trovato: Stampa riepilogo
    move $s0, $v0               
    li $v0, 4
    la $a0, found_msg
    syscall
    
    move $a0, $s0
    print_student($a0)

    # 3. Invoca il motore di calcolo riutilizzabile
    move $a0, $s0               # Passa l'indice come argomento
    jal get_student_gpa         # Chiama la utility! Ritornerà $f0 (Media) e $v1 (Stato)

    # 4. Verifica lo stato (Ha fatto esami?)
    beq $v1, $zero, print_gpa_no_exams

    # 5. Stampa risultato
    li $v0, 4
    la $a0, weight_avg_msg      # Stampa "Media Ponderata: "
    syscall
    
    mov.s $f12, $f0             # Sposta il float da $f0 a $f12 per poterlo stampare
    li $v0, 2                   # Syscall MIPS per stampare float
    syscall
    
    li $v0, 4
    la $a0, newline_msg
    syscall
    syscall                     # Doppio invio per spazio extra
    j gpa_end

    # --- Gestione Errori Visivi ---
print_gpa_no_exams:
    li $v0, 4
    la $a0, no_exams_msg
    syscall
    j gpa_end

print_gpa_not_found:
    li $v0, 4
    la $a0, not_found_msg
    syscall

gpa_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
   
# ==============================================================================
# NOME: compute_best_student
# UTILIZZO: Case 9
# DESCRIZIONE: Scorre tutti gli studenti attivi, ne calcola la media e determina 
#              chi possiede la media ponderata più alta (Max-Search).
# NOTE: Gestisce il confronto tra registri del Coprocessore matematico 1 ($f0, $f1).
# ==============================================================================

compute_best_student:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Contatore indice (i)
    sw $s1, 8($sp)              # Numero totale studenti
    sw $s2, 12($sp)             # Indice del MIGLIOR studente trovato finora

    # Inizializzazione variabili
    la $t0, student_count
    lw $s1, 0($t0)              # Carica il numero totale di studenti inseriti nel database
    li $s0, 0                   # Indice ciclo (i = 0)
    li $s2, -1                  # Imposta best index a -1 (nessuno trovato all'inizio)
    
    mtc1 $zero, $f2             # Inizializza il Max GPA ($f2) a 0.0
    
find_best_loop:
    beq $s0, $s1, find_best_end # Se i == student_count, abbiamo finito di scorrere

    # 1. Controllo se lo studente è attivo
    la $t0, student_active
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $t2, 0($t0)
    beq $t2, $zero, find_best_next # Se inattivo (0), salta al prossimo

    # 2. Richiamo la nostra Utility per fargli calcolare la media in background!
    move $a0, $s0               # Passa l'indice attuale
    jal get_student_gpa         # Ritorna la media in $f0 e lo stato (ha esami?) in $v1

    # 3. Controllo se lo studente ha almeno 1 esame
    beq $v1, $zero, find_best_next # Se non ha esami, saltalo

    # 4. Confronto: Il suo voto ($f0) è <= al record attuale ($f2)?
    c.le.s $f0, $f2             # Compara: $f0 <= $f2
    bc1t find_best_next         # Se vero (non ha battuto il record), salta al prossimo

    # 5. ABBIAMO UN NUOVO RECORD! Salviamo i suoi dati
    mov.s $f2, $f0              # Aggiorna il Max GPA con la sua media
    move $s2, $s0               # Salva il suo indice come nuovo miglior studente

find_best_next:
    addi $s0, $s0, 1            # Incrementa i++
    j find_best_loop            # Torna su

find_best_end:
    # Fine del ciclo. Controlliamo se abbiamo trovato almeno UN vincitore
    li $t0, -1
    beq $s2, $t0, print_no_best # Se l'indice è rimasto -1, nessuno aveva esami

    # --- STAMPA DEL VINCITORE ---
    li $v0, 4
    la $a0, best_student_msg
    syscall

    move $a0, $s2
    print_student($a0)          # Usa la tua macro per stampare l'anagrafica completa!

    li $v0, 4
    la $a0, weight_avg_msg      # Stampa la stringa "Media Ponderata: "
    syscall

    mov.s $f12, $f2             # Sposta il record vincente in $f12 per stamparlo
    li $v0, 2                   # Syscall per stampare Float
    syscall

    li $v0, 4
    la $a0, newline_msg
    syscall
    syscall                     # Doppio spazio
    j end_compute_best

print_no_best:
    li $v0, 4
    la $a0, no_best_msg
    syscall

end_compute_best:
    # Ripristino stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra
    

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
   
# ==============================================================================
# NOME: compute_total_credits
# UTILIZZO: Case 10
# DESCRIZIONE: Somma e visualizza il numero complessivo di crediti formativi (CFU)
#              ottenuti da tutti gli studenti attivi presenti nel sistema.
# ==============================================================================
compute_total_credits:
    # Salvataggio registri minimi
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Salverà l'indice dello studente trovato

    # 1. Ricerca dello studente tramite l'ottima Macro già esistente
    chiedi_intero(search_id_msg, $t0)
    cerca_studente_per_id($t0, credits_not_found)

    # 2. Studente trovato! Mostra l'anagrafica
    move $s0, $v0               # Salva l'indice restituito in $s0
    li $v0, 4
    la $a0, found_msg
    syscall
    
    move $a0, $s0
    print_student($a0)          # Stampa la scheda ordinata dello studente

    # 3. Invoca il motore di calcolo silenzioso che abbiamo scritto sopra
    move $a0, $s0               # Passa l'indice come parametro
    jal get_student_credits     # Esegue il calcolo, il risultato torna in $v0

    move $t0, $v0               # Sposta temporaneamente il totale crediti in $t0

    # 4. Stampe finali coordinate a schermo
    li $v0, 4
    la $a0, total_credits_msg   # Stampa la stringa "Crediti Totali Acquisiti: "
    syscall
    
    move $a0, $t0               # Passa il totale intero da stampare
    li $v0, 1                   # Syscall per stampare un intero
    syscall
    
    li $v0, 4
    la $a0, newline_msg
    syscall
    syscall                     # Doppio a capo per pulizia grafica
    j credits_end

    # Gestione errore se l'ID cercato non esiste
    credits_not_found:
    li $v0, 4
    la $a0, not_found_msg
    syscall

credits_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra                      # Ritorna al menu principale (main_loop)
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
   
# ========================================================================================================================================
# FUNZIONE 11: print_students_above_threshold (Case 11)
# ========================================================================================================================================
print_students_above_threshold:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)              
    sw $s1, 8($sp)              
    sw $s2, 12($sp)             
    swc1 $f20, 16($sp)          

    # 1. Chiedi la soglia float all'utente (Sostituisci 'threshold_msg' con l'etichetta che hai già tu se preferisci!)
    li $v0, 4
    la $a0, threshold_msg       # <--- Usa la tua etichetta qui!
    syscall
    
    li $v0, 6                   # Syscall 6: Legge FLOAT
    syscall
    mov.s $f20, $f0             

    li $v0, 4
    la $a0, above_threshold_title # (Metti l'etichetta del tuo titolo se l'avevi già)
    syscall

    la $t0, student_count
    lw $s1, 0($t0)              
    li $s0, 0                   
    li $s2, 0                   

above_thresh_loop:
    beq $s0, $s1, above_thresh_end 

    la $t0, student_active
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $t2, 0($t0)
    beq $t2, $zero, above_thresh_next 

    move $a0, $s0               
    jal get_student_gpa         

    beq $v1, $zero, above_thresh_next 

    c.le.s $f0, $f20            
    bc1t above_thresh_next      

    addi $s2, $s2, 1            

    move $a0, $s0
    print_student($a0)

    # --- ECCO IL MESSAGGIO RICICLATO! ---
    li $v0, 4
    la $a0, weight_avg_msg      # Usiamo quello che avevamo già per il Case 8 e 9!
    syscall
    
    mov.s $f12, $f0             
    li $v0, 2                   
    syscall
    
    li $v0, 4
    la $a0, newline_msg
    syscall
    syscall                     

above_thresh_next:
    addi $s0, $s0, 1            
    j above_thresh_loop

above_thresh_end:
    bne $s2, $zero, above_thresh_exit 
    li $v0, 4
    la $a0, no_students_above_msg     
    syscall

above_thresh_exit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lwc1 $f20, 16($sp)          
    addi $sp, $sp, 20
    jr $ra

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------  
         
# ========================================================================================================================================
# FUNZIONE 12: print_students_min_exams (Case 12)
# Chiede un intero N all'utente e stampa tutti gli studenti che hanno un numero di esami (student_nexams) >= N.
# ========================================================================================================================================
print_students_min_exams:
    # --- Salvataggio Registri nello Stack ---
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # Indice ciclo (i)
    sw $s1, 8($sp)              # Numero totale studenti nel database
    sw $s2, 12($sp)             # Contatore di quanti studenti soddisfano il requisito
    sw $s3, 16($sp)             # La soglia N (numero minimo di esami)

    # 1. Chiedi la soglia intera (N) all'utente
    li $v0, 4
    la $a0, min_exams_msg       
    syscall
    
    li $v0, 5                   # Syscall 5: Legge un INTERO da tastiera
    syscall
    move $s3, $v0               # Salva la soglia N nel registro $s3

    # Stampa l'intestazione del report
    li $v0, 4
    la $a0, min_exams_title
    syscall

    # Inizializzazione variabili ciclo
    la $t0, student_count
    lw $s1, 0($t0)              # $s1 = numero totale di studenti inseriti
    li $s0, 0                   # i = 0
    li $s2, 0                   # Contatore studenti trovati = 0

min_exams_loop:
    beq $s0, $s1, min_exams_end # Se i == student_count, esci dal ciclo

    # 2. Controllo se lo studente è attivo
    la $t0, student_active
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $t2, 0($t0)
    beq $t2, $zero, min_exams_next # Se eliminato (0), passa al prossimo

    # 3. Controlla il numero di esami
    la $t0, student_nexams
    add $t0, $t0, $t1           # Usa lo stesso offset ($t1) già calcolato per active
    lw $t3, 0($t0)              # $t3 = numero di esami dello studente corrente

    # 4. Confronto Intero: Esami < Soglia (N)?
    blt $t3, $s3, min_exams_next # Se $t3 < $s3, non va bene, salta al prossimo

    # 5. Se siamo qui, Esami >= N. Stampa lo studente!
    addi $s2, $s2, 1            # Incrementa il contatore dei trovati
    move $a0, $s0
    print_student($a0)          # Usa la solita macro che stampa tutta l'anagrafica

min_exams_next:
    addi $s0, $s0, 1            # i++
    j min_exams_loop

min_exams_end:
    # 6. Controllo finale: abbiamo trovato qualcuno?
    bne $s2, $zero, min_exams_exit # Se contatore != 0, salta all'uscita
    
    # Altrimenti stampa messaggio di errore
    li $v0, 4
    la $a0, no_min_exams_msg     
    syscall

min_exams_exit:
    # --- Ripristino dello Stack ---
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra                      # Ritorna al menu principale

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------

# ========================================================================================================================================
# FUNZIONE 13: sort_students_by_id (Case 13)
# Ordina l'intero database in base all'ID usando l'algoritmo Bubble Sort.
# Se uno studente è inattivo, viene considerato con ID "999999" per essere spinto in fondo al database.
# ========================================================================================================================================
sort_students_by_id:
    # Salvataggio registri
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # i (Outer loop counter)
    sw $s1, 8($sp)              # j (Inner loop counter)
    sw $s2, 12($sp)             # Numero totale di studenti
    sw $s3, 16($sp)             # Limite per il loop interno (count - i - 1)
    sw $s4, 20($sp)             # Flag "swapped" per ottimizzare il Bubble Sort

    la $t0, student_count
    lw $s2, 0($t0)              # Carica numero studenti

    li $t0, 2
    blt $s2, $t0, sort_end      # Se c'è 0 o 1 studente, è già ordinato

    li $s0, 0                   # i = 0
sort_outer_loop:
    # Calcola limite j: limite = count - i - 1
    sub $s3, $s2, $s0
    addi $s3, $s3, -1
    ble $s3, $zero, sort_end    # Se abbiamo finito i passaggi, esci

    li $s1, 0                   # j = 0
    li $s4, 0                   # swapped = 0 (Falso)

sort_inner_loop:
    bge $s1, $s3, sort_inner_end # Se j >= limite, fine passata interna

    # --- Leggi active[j] e id[j] ---
    sll $t0, $s1, 2
    la $t1, student_active
    add $t1, $t1, $t0
    lw $t2, 0($t1)              # active[j]
    la $t1, student_id
    add $t1, $t1, $t0
    lw $t3, 0($t1)              # id[j]
    bne $t2, $zero, active_j_ok # Se è attivo salta
    li $t3, 999999              # Se inattivo, assegna ID fittizio altissimo
active_j_ok:

    # --- Leggi active[j+1] e id[j+1] ---
    addi $t4, $s1, 1            # $t4 = j + 1
    sll $t0, $t4, 2
    la $t1, student_active
    add $t1, $t1, $t0
    lw $t5, 0($t1)              # active[j+1]
    la $t1, student_id
    add $t1, $t1, $t0
    lw $t6, 0($t1)              # id[j+1]
    bne $t5, $zero, active_j1_ok
    li $t6, 999999              # Se inattivo, ID fittizio altissimo
active_j1_ok:

    # --- Confronto: id[j] > id[j+1]? ---
    ble $t3, $t6, no_swap       # Se id[j] <= id[j+1], l'ordine è corretto, non fare nulla

    # SCAMBIO DEI RECORD (id[j] > id[j+1])
    move $a0, $s1               # Passa indice j
    move $a1, $t4               # Passa indice j+1
    jal swap_all_student_data   # Invoca lo scambiatore di array
    li $s4, 1                   # Imposta flag swapped = 1 (Vero)

no_swap:
    addi $s1, $s1, 1            # j++
    j sort_inner_loop

sort_inner_end:
    # Se dopo un'intera passata non abbiamo fatto scambi, l'array è completamente ordinato!
    beq $s4, $zero, sort_end    
    addi $s0, $s0, 1            # i++
    j sort_outer_loop

sort_end:
    li $v0, 4
    la $a0, sort_success_msg
    syscall

    # Ripristino stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------


# ========================================================================================================================================
# HELPER 1: swap_all_student_data
# Scambia FISICAMENTE tutti i campi tra due studenti (compresi tutti i loro esami).
# INPUT: $a0 = Indice Studente A, $a1 = Indice Studente B
# ========================================================================================================================================
swap_all_student_data:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0
    move $s1, $a1

    # 1. Scambio Vettori di Interi (Offset = i * 4, Dimensione = 4 byte)
    sll $t0, $s0, 2
    sll $t1, $s1, 2
    scambia_array(student_id, $t0, $t1, 4)
    scambia_array(student_age, $t0, $t1, 4)
    scambia_array(student_year, $t0, $t1, 4)
    scambia_array(student_nexams, $t0, $t1, 4)
    scambia_array(student_active, $t0, $t1, 4)

    # 2. Scambio Vettori di Stringhe Anagrafiche (Offset = i * 20, Dimensione = 20 byte)
    li $t2, 20
    mul $t0, $s0, $t2
    mul $t1, $s1, $t2
    scambia_array(student_name, $t0, $t1, 20)
    scambia_array(student_surname, $t0, $t1, 20)

    # 3. Scambio Voti e Crediti degli Esami (Offset = i * 80, Dimensione = 80 byte)
    # (Ogni studente ha max 20 esami. 20 * 4 = 80 byte)
    li $t2, 80
    mul $t0, $s0, $t2
    mul $t1, $s1, $t2
    scambia_array(exam_credits, $t0, $t1, 80)
    scambia_array(exam_grade, $t0, $t1, 80)

    # 4. Scambio Nomi degli Esami (Offset = i * 920, Dimensione = 920 byte)
    # (Ogni studente ha max 20 esami da 46 byte l'uno. 20 * 46 = 920 byte)
    li $t2, 920
    mul $t0, $s0, $t2
    mul $t1, $s1, $t2
    scambia_array(exam_name, $t0, $t1, 920)

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------

# ========================================================================================================================================
# HELPER 2: swap_bytes_memory
# Scambia byte per byte un blocco di memoria tra due indirizzi. (Funziona per qualsiasi dimensione!)
# INPUT: $a0 = Indirizzo 1, $a1 = Indirizzo 2, $a2 = Numero di byte da scambiare
# ========================================================================================================================================
swap_bytes_memory:
    li $t8, 0                   # Contatore byte copiati (k = 0)
swap_bytes_loop:
    beq $t8, $a2, swap_bytes_end # Se k == dimensione, fine
    
    lb $t9, 0($a0)              # Leggi 1 byte dall'Indirizzo 1
    lb $t7, 0($a1)              # Leggi 1 byte dall'Indirizzo 2
    sb $t7, 0($a0)              # Scrivi il byte 2 nell'Indirizzo 1
    sb $t9, 0($a1)              # Scrivi il byte 1 nell'Indirizzo 2
    
    addi $a0, $a0, 1            # Avanza puntatore 1
    addi $a1, $a1, 1            # Avanza puntatore 2
    addi $t8, $t8, 1            # k++
    j swap_bytes_loop
    
swap_bytes_end:
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
   
# ========================================================================================================================================
# FUNZIONE 14: sort_students_by_gpa (Case 14)
# Ordina l'intero database in base alla media ponderata (Ordine Decrescente).
# Assegna 0.0 a chi non ha esami e -1.0 ai record inattivi per spingerli in fondo.
# ========================================================================================================================================
sort_students_by_gpa:
    # Salvataggio registri (Inclusi i registri float $f20 e $f22 che useremo per i confronti)
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # i (Outer loop)
    sw $s1, 8($sp)              # j (Inner loop)
    sw $s2, 12($sp)             # Numero studenti
    sw $s3, 16($sp)             # Limite loop interno
    sw $s4, 20($sp)             # Flag "swapped"
    swc1 $f20, 24($sp)          # Media Studente J
    swc1 $f22, 28($sp)          # Media Studente J+1

    la $t0, student_count
    lw $s2, 0($t0)              # Carica numero totale di studenti

    li $t0, 2
    blt $s2, $t0, sort_gpa_end  # Se gli studenti sono 0 o 1, è già ordinato

    li $s0, 0                   # i = 0
sort_gpa_outer:
    sub $s3, $s2, $s0
    addi $s3, $s3, -1
    ble $s3, $zero, sort_gpa_end

    li $s1, 0                   # j = 0
    li $s4, 0                   # swapped = 0

sort_gpa_inner:
    bge $s1, $s3, sort_gpa_inner_end

    # ---------------------------------------------------------
    # CALCOLO MEDIA STUDENTE [ j ]
    # ---------------------------------------------------------
    sll $t0, $s1, 2
    la $t1, student_active
    add $t1, $t1, $t0
    lw $t2, 0($t1)
    
    beq $t2, $zero, j_inactive  # Se inattivo salta

    move $a0, $s1               # Prepara indice j per la utility
    jal get_student_gpa
    beq $v1, $zero, j_no_exams  # Se attivo ma ha 0 esami, salta
    mov.s $f20, $f0             # Altrimenti, salva la sua vera media in $f20
    j calc_j_done

j_inactive:
    li $t0, -1                  # Carica -1
    mtc1 $t0, $f20              
    cvt.s.w $f20, $f20          # Converte a float (-1.0)
    j calc_j_done

j_no_exams:
    mtc1 $zero, $f20            # Float 0.0 per chi non ha esami
    
calc_j_done:

    # ---------------------------------------------------------
    # CALCOLO MEDIA STUDENTE [ j + 1 ]
    # ---------------------------------------------------------
    addi $a0, $s1, 1            # $a0 = j + 1
    sll $t0, $a0, 2
    la $t1, student_active
    add $t1, $t1, $t0
    lw $t2, 0($t1)
    
    beq $t2, $zero, j1_inactive
    
    jal get_student_gpa         # $a0 è già j+1, richiamo la utility
    beq $v1, $zero, j1_no_exams
    mov.s $f22, $f0             # Salva la sua vera media in $f22
    j calc_j1_done

j1_inactive:
    li $t0, -1
    mtc1 $t0, $f22
    cvt.s.w $f22, $f22          # -1.0
    j calc_j1_done

j1_no_exams:
    mtc1 $zero, $f22            # 0.0

calc_j1_done:

    # ---------------------------------------------------------
    # CONFRONTO E SCAMBIO
    # ---------------------------------------------------------
    # Vogliamo l'ordine DECRESCENTE (il voto più alto in cima).
    # Quindi scambiamo se Media(j) < Media(j+1).
    c.lt.s $f20, $f22           # Compara se $f20 < $f22
    bc1f no_swap_gpa            # Se Falso (cioè j >= j+1), va bene così e non scambia

    # SCAMBIO FISICO DEI DUE RECORD (usando l'helper del Case 13)
    move $a0, $s1               # $a0 = j
    addi $a1, $s1, 1            # $a1 = j + 1
    jal swap_all_student_data   
    li $s4, 1                   # Imposta flag swapped = 1

no_swap_gpa:
    addi $s1, $s1, 1            # j++
    j sort_gpa_inner

sort_gpa_inner_end:
    beq $s4, $zero, sort_gpa_end # Se passata pulita senza scambi, fine algoritmo
    addi $s0, $s0, 1             # i++
    j sort_gpa_outer

sort_gpa_end:
    li $v0, 4
    la $a0, sort_gpa_success_msg
    syscall

    # Ripristino stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lwc1 $f20, 24($sp)
    lwc1 $f22, 28($sp)
    addi $sp, $sp, 32
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
    
# ========================================================================================================================================
# FUNZIONE 15: print_statistics (Case 15)
# Calcola in un solo passaggio: Totale attivi, età media, media esami e media ponderata globale.
# ========================================================================================================================================
print_statistics:
    # --- Salvataggio Registri ---
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # i (Indice ciclo)
    sw $s1, 8($sp)              # count (Totale studenti nel DB)
    sw $s2, 12($sp)             # a. Accumulatore: Totale studenti ATTIVI
    sw $s3, 16($sp)             # b. Accumulatore: Somma delle età
    sw $s4, 20($sp)             # c. Accumulatore: Somma totale degli esami
    sw $s5, 24($sp)             # Contatore: Studenti con ALMENO 1 esame
    swc1 $f20, 28($sp)          # d. Accumulatore: Somma delle medie ponderate

    la $t0, student_count
    lw $s1, 0($t0)              # Carica numero studenti
    
    li $s0, 0                   # i = 0
    li $s2, 0                   # active_count = 0
    li $s3, 0                   # sum_age = 0
    li $s4, 0                   # sum_exams = 0
    li $s5, 0                   # count_students_with_exams = 0

    mtc1 $zero, $f20            
    cvt.s.w $f20, $f20          # sum_gpa = 0.0

stat_loop:
    beq $s0, $s1, stat_end_loop # Se i == count, esci dal ciclo

    # --- Controllo Attivo ---
    sll $t0, $s0, 2
    la $t1, student_active
    add $t1, $t1, $t0
    lw $t2, 0($t1)
    beq $t2, $zero, stat_next   # Se eliminato (0), passa al prossimo studente

    # È attivo! Aggiorniamo le statistiche
    addi $s2, $s2, 1            # Incrementa totale attivi

    # Somma Età
    la $t1, student_age
    add $t1, $t1, $t0
    lw $t3, 0($t1)
    add $s3, $s3, $t3           # sum_age += age[i]

    # Somma Esami
    la $t1, student_nexams
    add $t1, $t1, $t0
    lw $t4, 0($t1)
    add $s4, $s4, $t4           # sum_exams += nexams[i]

    # Somma Media Ponderata (usiamo la utility creata in precedenza)
    move $a0, $s0
    jal get_student_gpa         # Ritorna media in $f0, status in $v1
    beq $v1, $zero, stat_next   # Se lo studente ha 0 esami, non fa media sui voti
    
    addi $s5, $s5, 1            # Incrementa contatore studenti con voti
    add.s $f20, $f20, $f0       # sum_gpa += media dello studente

stat_next:
    addi $s0, $s0, 1            # i++
    j stat_loop

stat_end_loop:
    # --- STAMPE FINALI A SCHERMO ---
    li $v0, 4
    la $a0, stat_title_msg
    syscall

    beq $s2, $zero, stat_no_active # Se non c'è nessuno studente attivo, salta stampe e avvisa

    # a. Stampa Totale Studenti Attivi (Intero)
    li $v0, 4
    la $a0, stat_tot_act_msg
    syscall
    move $a0, $s2
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # Converto il numero totale di studenti in Float per le successive divisioni
    mtc1 $s2, $f1
    cvt.s.w $f1, $f1            # $f1 = float(active_count)

    # b. Stampa Età Media (Float)
    li $v0, 4
    la $a0, stat_avg_age_msg
    syscall
    mtc1 $s3, $f0               
    cvt.s.w $f0, $f0            # Converte sum_age in float
    div.s $f12, $f0, $f1        # div_age = sum_age / active_count
    li $v0, 2
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # c. Stampa Media Esami (Float)
    li $v0, 4
    la $a0, stat_avg_exm_msg
    syscall
    mtc1 $s4, $f0
    cvt.s.w $f0, $f0            # Converte sum_exams in float
    div.s $f12, $f0, $f1        # div_exams = sum_exams / active_count
    li $v0, 2
    syscall
    li $v0, 4
    la $a0, newline_msg
    syscall

    # d. Stampa Media Ponderata Globale (Float)
    li $v0, 4
    la $a0, stat_avg_gpa_msg
    syscall

    beq $s5, $zero, stat_zero_gpa # Se nessuno ha esami, stampa 0.0

    mtc1 $s5, $f2
    cvt.s.w $f2, $f2            # $f2 = float(studenti_con_esami)
    div.s $f12, $f20, $f2       # globale_gpa = sum_gpa / studenti_con_esami
    li $v0, 2
    syscall
    j stat_exit_print

stat_zero_gpa:
    mtc1 $zero, $f12
    cvt.s.w $f12, $f12          # Stampa 0.0
    li $v0, 2
    syscall

stat_exit_print:
    li $v0, 4
    la $a0, newline_msg
    syscall
    syscall                     # Doppio invio finale
    j stat_exit

stat_no_active:
    li $v0, 4
    la $a0, stat_no_act_msg
    syscall

stat_exit:
    # --- Ripristino Stack ---
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lwc1 $f20, 28($sp)
    addi $sp, $sp, 32
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
   
# ==============================================================================
# NOME: export_compact_report
# UTILIZZO: Case 16
# DESCRIZIONE: Genera un report tabulare compatto (una riga per studente) mostrando
#              ID, Nome, Cognome, Esami e Media. Segnala visivamente i record INATTIVI.
# ==============================================================================

export_compact_report:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)              # i (Indice del ciclo)
    sw $s1, 8($sp)              # count (Numero totale studenti)

    li $v0, 4
    la $a0, report_title
    syscall

    la $t0, student_count
    lw $s1, 0($t0)              # $s1 = numero totale di studenti inseriti nel DB
    li $s0, 0                   # i = 0

report_loop:
    beq $s0, $s1, report_end    # Se i == count, abbiamo finito

    # 1. Stampa apertura "[ID] "
    li $v0, 4
    la $a0, rep_open            # Stampa "["
    syscall
    
    sll $t0, $s0, 2             # $t0 = i * 4 (Offset per gli interi)
    la $t1, student_id
    add $t1, $t1, $t0
    lw $a0, 0($t1)              # Carica ID
    li $v0, 1                   # Stampa l'ID intero
    syscall
    
    li $v0, 4
    la $a0, rep_close           # Stampa "] "
    syscall

    # 2. Controllo se è attivo
    la $t1, student_active
    add $t1, $t1, $t0
    lw $t2, 0($t1)
    bne $t2, $zero, report_active # Se attivo (1), salta alla stampa dei dati

    # --- Studente INATTIVO ---
    li $v0, 4
    la $a0, rep_inactive
    syscall
    j report_next_line          # Salta a fine riga

report_active:
    # --- Studente ATTIVO: Nome e Cognome ---
    li $t3, 20
    mul $t1, $s0, $t3           # $t1 = i * 20 (Offset per le stringhe)
    
    li $v0, 4
    la $a0, student_name
    add $a0, $a0, $t1
    syscall                     # Stampa Nome
    
    la $a0, rep_space
    syscall                     # Stampa spazio
    
    la $a0, student_surname
    add $a0, $a0, $t1
    syscall                     # Stampa Cognome

    # 3. Stampa " - Esami: N"
    la $a0, rep_exams
    syscall
    
    la $t2, student_nexams
    add $t2, $t2, $t0           # Usa l'offset intero $t0
    lw $a0, 0($t2)
    li $v0, 1
    syscall                     # Stampa numero esami

    # 4. Calcola e Stampa Media Ponderata
    move $a0, $s0               # Passa l'indice 'i'
    jal get_student_gpa         # Ritorna media in $f0, stato in $v1

    beq $v1, $zero, report_no_gpa # Se non ha esami, stampa "N/A"

    li $v0, 4
    la $a0, rep_gpa             # Stampa " - Media: "
    syscall
    
    mov.s $f12, $f0
    li $v0, 2                   # Stampa il float della media
    syscall
    j report_next_line

report_no_gpa:
    li $v0, 4
    la $a0, rep_no_exams        # Stampa " - Media: N/A"
    syscall

report_next_line:
    li $v0, 4
    la $a0, newline_msg         # Va a capo per il prossimo studente
    syscall

    addi $s0, $s0, 1            # i++
    j report_loop

report_end:
    li $v0, 4
    la $a0, newline_msg
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
    
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
    
# ==============================================================================
# NOME: recursive_print_exams
# UTILIZZO: Case 17 (Interfaccia)
# DESCRIZIONE: Trova lo studente tramite ID e, se possiede esami registrati, 
#              prepara i parametri e innesca il motore ricorsivo per la stampa.
# ==============================================================================

recursive_print_exams:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # 1. Chiedi ID e cerca lo studente
    chiedi_intero(search_id_msg, $t0)
    cerca_studente_per_id($t0, rec_print_not_found)
    move $s0, $v0           # $s0 = Indice studente trovato

    # Stampa intestazione e anagrafica dello studente
    li $v0, 4
    la $a0, rec_exams_title
    syscall
    move $a0, $s0
    print_student($a0)

    # 2. Controlla il numero di esami che ha sostenuto
    sll $t0, $s0, 2
    la $t1, student_nexams
    add $t1, $t1, $t0
    lw $s1, 0($t1)          # $s1 = numero esami

    beq $s1, $zero, rec_print_no_exams # Se è 0, salta e avvisa

    # 3. AVVIA LA RICORSIONE! Prepariamo gli argomenti per il "motore"
    move $a0, $s0           # Arg 0: Indice studente
    li $a1, 0               # Arg 1: Indice dell'esame corrente (inizia da 0)
    move $a2, $s1           # Arg 2: Numero totale di esami (Condizione di fine)
    jal print_exams_recursive_helper
    
    li $v0, 4
    la $a0, newline_msg
    syscall
    j rec_print_exit

rec_print_no_exams:
    li $v0, 4
    la $a0, rec_no_exams_msg
    syscall
    j rec_print_exit

rec_print_not_found:
    li $v0, 4
    la $a0, not_found_msg
    syscall

rec_print_exit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------

# ==============================================================================
# NOME: print_exams_recursive_helper
# UTILIZZO: Case 17 (Motore Ricorsivo)
# DESCRIZIONE: Algoritmo ricorsivo puro. Stampa i dati dell'esame corrente e 
#              chiama se stessa incrementando l'indice per l'esame successivo.
# NOTE: SALVATAGGIO CRITICO NELLO STACK: salva $ra e i parametri ad ogni iterazione.
# ==============================================================================

print_exams_recursive_helper:
    # -------------------------------------------------------------
    # 1. CASO BASE (Condizione di uscita)
    # Se abbiamo raggiunto l'ultimo esame, la ricorsione si ferma e torna indietro
    # -------------------------------------------------------------
    beq $a1, $a2, recursive_base_case 

    # -------------------------------------------------------------
    # 2. SALVATAGGIO NELLO STACK (Il cuore della ricorsione)
    # Dobbiamo salvare il Return Address e i parametri ad ogni chiamata!
    # -------------------------------------------------------------
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)          # Salva indice studente
    sw $a1, 8($sp)          # Salva indice esame corrente
    sw $a2, 12($sp)         # Salva totale esami

    # -------------------------------------------------------------
    # 3. STAMPA L'ESAME CORRENTE
    # -------------------------------------------------------------
    # Calcolo offset assoluto: (Studente * 20) + esame_corrente
    li $t0, 20
    mul $t1, $a0, $t0
    add $t1, $t1, $a1       
    
    sll $t2, $t1, 2         # Offset per interi (*4)
    li $t0, 46
    mul $t3, $t1, $t0       # Offset per stringhe (*46)

    # Stampa " - Nome Esame (Crediti: "
    li $v0, 4
    la $a0, rec_exam_bullet
    syscall
    la $a0, exam_name
    add $a0, $a0, $t3
    syscall
    la $a0, rec_exam_cred
    syscall

    # Stampa Crediti
    la $t0, exam_credits
    add $t0, $t0, $t2
    lw $a0, 0($t0)
    li $v0, 1
    syscall

    # Stampa ", Voto: "
    li $v0, 4
    la $a0, rec_exam_grad
    syscall

    # Stampa Voto
    la $t0, exam_grade
    add $t0, $t0, $t2
    lw $a0, 0($t0)
    li $v0, 1
    syscall

    # Stampa ")\n"
    li $v0, 4
    la $a0, rec_exam_close
    syscall

    # -------------------------------------------------------------
    # 4. CHIAMATA RICORSIVA (Invoca se stessa per il prossimo esame)
    # -------------------------------------------------------------
    # Ripristina gli argomenti vecchi (nel caso siano stati alterati dai print)
    lw $a0, 4($sp)
    lw $a2, 12($sp)
    lw $a1, 8($sp)          
    
    addi $a1, $a1, 1        # Incrementa di 1 l'esame da stampare
    
    jal print_exams_recursive_helper # <--- ECCO LA RICORSIONE!

    # -------------------------------------------------------------
    # 5. RIPRISTINO DELLO STACK (Quando le funzioni tornano indietro)
    # -------------------------------------------------------------
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    addi $sp, $sp, 16

recursive_base_case:
    jr $ra                  # Torna alla chiamata precedente!
