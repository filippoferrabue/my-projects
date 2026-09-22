#Filippo Ferrabue 
#Matricola: 1106769
#Progretto 1: University Student Information System
#Sessione Giugno 2026

.include "macros.asm"
.data
# Studenti (max 100)
student_id:         .space 400      # 100 × 4 byte
student_name:       .space 2000     # 100 × 20 byte
student_surname:    .space 2000     # 100 × 20 byte
student_age:        .space 400      # 100 × 4 byte
student_year:       .space 400      # 100 × 4 byte (anno iscrizione)
student_nexams:     .space 400      # 100 × 4 byte (numero esami superati)
student_active:     .space 400      # 100 × 4 byte (1=attivo, 0=eliminato)
student_count:      .word 0         # numero studenti inseriti
search_buffer:      .space 20       # spazio per inserire la parola da ricercare

# Esami (max 20 per studente, 100 studenti = 2000 totali)
exam_name:          .space 92000    # 2000 esami totali (100 stud. x 20) × 46 byte
exam_credits:       .space 8000     # 2000 × 4 byte
exam_grade:         .space 8000     # 2000 × 4 byte

# Menù e messaggi
menu_msg:           .asciiz "\n=== Student Information System ===\n0 Popolare database partendo da studente 0\n1 Insert student\n2 Print all students\n3 Search by ID\n4 Search by surname\n5 Add exam\n6 Edit student\n7 Delete student\n8 Weighted average\n9 Find the best student by weighted average\n10 Total credits\n11 Students above threshold\n12 Students with N exams\n13 Sort by ID\n14 Sort by average\n15 Statistics\n16 Export report\n17 Print exam list\n18 Exit\nChoice: "
insert_msg:           .asciiz "Students inserted successfully!\n"
insert_id_msg:      .asciiz "Student ID: "
insert_name_msg:    .asciiz "First name: "
insert_surname_msg: .asciiz "Last name: "
insert_age_msg:     .asciiz "Age: "
insert_year_msg:    .asciiz "Enrollment year: "
search_id_msg:      .asciiz "Enter ID to search: "
search_surname_msg: .asciiz "Enter surname to search: "
threshold_msg:      .asciiz "Enter average threshold: "
nexams_msg:         .asciiz "Enter minimum exams: "
exam_name_msg:      .asciiz "Exam name: "
exam_credits_msg:   .asciiz "Credits: "
exam_grade_msg:     .asciiz "Grade: "
yes_msg:        .asciiz "Si\n"
no_msg:         .asciiz "No (Eliminato)\n"
print_all_title:        .asciiz "\n=== ELENCO STUDENTI ATTIVI ===\n"
no_active_students_msg: .asciiz "Nessuno studente attivo presente nel database.\n"
total_displayed_msg:    .asciiz "\nTotale studenti attivi visualizzati: "
add_exam_choice_msg: .asciiz "Add an exam? (1=yes, 0=no): "
invalid_input_msg:  .asciiz "Invalid input, please try again.\n"



found_msg:          .asciiz "Student found!\n"
not_found_msg:      .asciiz "Student not found\n"
deleted_msg:        .asciiz "Student deleted\n"
error_msg:          .asciiz "Error: max students reached\n"
insert_success_msg: .asciiz "Student inserted successfully!\n"
duplicate_exam_msg: .asciiz "\n[!] ERRORE: Questo studente ha gia' registrato questo esame!\n\n"
exam_success_msg:   .asciiz "\n[V] Esame aggiunto con successo nel libretto!\n\n"
edit_menu_msg:     .asciiz "\nCosa vuoi modificare?\n1. Nome\n2. Cognome\n3. Eta'\n4. Anno Iscrizione\n0. Fine modifiche\nScelta: "
edit_success_msg:  .asciiz "\nModifiche salvate con successo!\n"
delete_confirm_msg: .asciiz "\nSei sicuro di voler eliminare questo studente? (1=Si, 0=No): "
delete_cancel_msg:  .asciiz "\nEliminazione annullata. Lo studente non e' stato rimosso.\n"
no_exams_msg:   .asciiz "\nImpossibile calcolare: lo studente non ha ancora registrato alcun esame.\n"
weight_avg_msg: .asciiz "Media Ponderata: "
best_student_msg:   .asciiz "\n=== MIGLIOR STUDENTE PER MEDIA PONDERATA ===\n"
no_best_msg:        .asciiz "\nNessuno studente attivo ha esami registrati per calcolare una media!\n"
total_credits_msg:  .asciiz "Crediti Totali Acquisiti: "
above_threshold_title:  .asciiz "\n=== STUDENTI CON MEDIA SUPERIORE ALLA SOGLIA ===\n"
no_students_above_msg:  .asciiz "Nessuno studente attivo supera la soglia di media inserita.\n"
min_exams_msg:      .asciiz "\nInserisci il numero minimo di esami superati (N): "
min_exams_title:    .asciiz "\n=== STUDENTI CON ALMENO N ESAMI SUPERATI ===\n"
no_min_exams_msg:   .asciiz "Nessuno studente attivo ha superato il numero di esami richiesto.\n"
sort_success_msg:   .asciiz "\nDatabase ordinato con successo per ID! (Gli studenti inattivi sono stati spostati in fondo)\n"
sort_gpa_success_msg: .asciiz "\nDatabase ordinato con successo per Media Ponderata (dal migliore al peggiore)!\n"
stat_title_msg:     .asciiz "\n=== STATISTICHE DEL DATABASE ===\n"
stat_tot_act_msg:   .asciiz "a. Totale studenti attivi: "
stat_avg_age_msg:   .asciiz "b. Eta' media: "
stat_avg_exm_msg:   .asciiz "c. Media esami per studente: "
stat_avg_gpa_msg:   .asciiz "d. Media ponderata globale: "
stat_no_act_msg:    .asciiz "Nessun dato disponibile (Nessuno studente attivo).\n"
report_title:       .asciiz "\n=== REPORT COMPATTO STUDENTI ===\n"
rep_open:           .asciiz "["
rep_close:          .asciiz "] "
rep_space:          .asciiz " "
rep_exams:          .asciiz " - Esami: "
rep_gpa:            .asciiz " - Media: "
rep_no_exams:       .asciiz " - Media: N/A"
rep_inactive:       .asciiz "INATTIVO"
rec_exams_title:    .asciiz "\n=== LISTA ESAMI (STAMPA RICORSIVA) ===\n"
rec_exam_bullet:    .asciiz "- "
rec_exam_cred:      .asciiz " (Crediti: "
rec_exam_grad:      .asciiz ", Voto: "
rec_exam_close:     .asciiz ")\n"
rec_no_exams_msg:   .asciiz "Nessun esame registrato per questo studente.\n"

space_msg:          .asciiz " "
newline_msg:        .asciiz "\n"
separator_msg:      .asciiz "-------------------\n"

id_label:           .asciiz "ID: "
name_label:         .asciiz "Name: "
surname_label:      .asciiz "Surname: "
age_label:          .asciiz "Age: "
year_label:         .asciiz "Year: "
nexams_label:       .asciiz "Exams: "
credits_label:      .asciiz "Credits: "
grade_label:        .asciiz "Grade: "
active_label:       .asciiz "Status: Active\n"
inactive_label:     .asciiz "Status: Inactive\n"
student_idx_label:  .asciiz "Student: "
slash_label:        .asciiz "/"

stats_total_msg:    .asciiz "Total active students: "

#inserisco il database che contiene le informazioni di 50 studenti generati casualmente -> che poi saranno da salvare sui rispettivi arrey
.include "database_studenti.asm"

.text
.globl main 
main:
main_loop:
    # stampa menù
    li $v0, 4
    la $a0, menu_msg
    syscall
    # leggi scelta
    li $v0, 5
    syscall
    move $t0, $v0           # $t0 = scelta utente

    # switch con beq per ogni caso
    li $t1, 1
    beq $t0, $t1, case1
    li $t1, 2
    beq $t0, $t1, case2
    li $t1, 3
    beq $t0, $t1, case3
    li $t1, 4
    beq $t0, $t1, case4
    li $t1, 5
    beq $t0, $t1, case5
    li $t1, 6
    beq $t0, $t1, case6
    li $t1, 7
    beq $t0, $t1, case7
    li $t1, 8
    beq $t0, $t1, case8
    li $t1, 9
    beq $t0, $t1, case9
    li $t1, 10
    beq $t0, $t1, case10
    li $t1, 11
    beq $t0, $t1, case11
    li $t1, 12
    beq $t0, $t1, case12
    li $t1, 13
    beq $t0, $t1, case13
    li $t1, 14
    beq $t0, $t1, case14
    li $t1, 15
    beq $t0, $t1, case15
    li $t1, 16
    beq $t0, $t1, case16
    li $t1, 17
    beq $t0, $t1, case17
    li $t1, 18
    beq $t0, $t1, case18
    beq $t0, $zero, case0
    j main_loop             # scelta non valida → rimostra il menù

case1:

    jal insert_student
    j main_loop
    
case2:

    jal print_all_students
    j main_loop
    
case3:

    jal search_by_id
    j main_loop
    
case4:

    jal search_by_surname
    j main_loop
    
case5:

    jal add_exam
    j main_loop
    
case6:

    jal edit_student
    j main_loop
    
case7:

    jal delete_student
    j main_loop
    
case8:

    jal calculate_gpa
    j main_loop
    
case9:

    jal compute_best_student
    j main_loop
    
case10:

    jal compute_total_credits
    j main_loop
    
case11:

    jal print_students_above_threshold
    j main_loop
    
case12:

    jal print_students_min_exams
    j main_loop

case13:

    jal sort_students_by_id
    j main_loop
    
case14:

    jal sort_students_by_gpa
    j main_loop
    
case15:

    jal print_statistics
    j main_loop
    
case16:

    jal export_compact_report
    j main_loop
    
case17:

    jal recursive_print_exams
    j main_loop
    
case18:   
    li $v0, 10
    syscall

case0:
    jal init_db         # Carica i dati dal database agli array
    li $v0, 4
    la $a0, insert_msg
    syscall
    j main_loop
  
    
.include "functions.asm" #file che si occupa di caricare i dati del database_studenti su gli arrey
.include "inizializzazione.asm"
.include "utility_functions.asm"
