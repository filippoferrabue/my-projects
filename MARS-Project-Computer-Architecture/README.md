# University Student Information System — MIPS Assembly

A text-based student records manager written entirely in **MIPS-32 assembly**, built for
the **MARS 4.5** simulator. University project for the *Calcolatori Elettronici* (Computer
Architecture) course — Università degli Studi di Bergamo, Electronics and Automation
Engineering (TEA), 2025/2026.

## The project

The program manages the academic careers of up to **100 students**, each with a transcript
of up to **20 passed exams**, through an interactive text menu with 17 operations: insert
and edit records, search by ID or surname, register exams, compute weighted averages, sort
the database and generate reports.

The interesting part is not the feature list but the constraint. MIPS assembly has no
structs, no objects and no dynamic memory allocation, so every data structure a
higher-level language gives you for free had to be built by hand in the `.data` segment.
The project is essentially an exercise in reconstructing those abstractions from raw
memory and integer arithmetic.

## How the data is organised

**Parallel arrays** store the student records. Each attribute lives in its own contiguous
block, and the same physical index `i` (0–99) ties them together — index 7 in
`student_name` and index 7 in `student_age` describe the same person:

```
student_id       .space   400     # 100 × 4 B
student_name     .space  2000     # 100 × 20 B (ASCIIZ)
student_surname  .space  2000     # 100 × 20 B
student_age      .space   400
student_year     .space   400
student_nexams   .space   400
student_active   .space   400     # 1 = active, 0 = deleted
```

**Linearised matrices** store the exams. A 2D structure of 100 students × 20 exams is
flattened into 2000 sequential slots, and the address of any cell is computed at runtime:

```
logical position = (i * 20) + k

credits, grades (words)  → byte offset = ((i * 20) + k) * 4
exam names (46 B each)   → byte offset = ((i * 20) + k) * 46
```

**Deletion is logical.** Removing a student clears the `student_active` flag rather than
shifting memory blocks, which keeps deletion at O(1) and preserves the alignment of the
parallel arrays. Scan and report routines simply skip inactive records.

**Averages use the FPU.** Grade averages are weighted by credits, so integer accumulators
are moved to the coprocessor with `mtc1`, converted with `cvt.s.w` and divided with
`div.s`.

Three guards keep the program from crashing: string input is hard-capped at 19 characters
so a long name cannot overwrite the adjacent arrays; the average routine checks the exam
count before touching the FPU, avoiding a division-by-zero trap; and ages outside the
range [18, 100] are rejected.

## Menu

| # | Routine | Description |
|---|---|---|
| 0 | `init_db` | Load the pre-populated database (50 records) |
| 1 | `insert_student` | Insert a new student with their exams |
| 2 | `print_all_students` | List all active students |
| 3 | `search_by_id` | Look up a student by ID |
| 4 | `search_by_surname` | Look up students by surname (multiple results) |
| 5 | `add_exam` | Add an exam to a transcript |
| 6 | `edit_student` | Edit a student's data |
| 7 | `delete_student` | Soft-delete a student |
| 8 | `calculate_gpa` | Weighted average for one student |
| 9 | `compute_best_student` | Top student by weighted average |
| 10 | `compute_total_credits` | Total credits earned |
| 11 | `print_students_above_threshold` | Students above a given average |
| 12 | `print_students_min_exams` | Students with at least N exams |
| 13 | `sort_students_by_id` | Sort the database by ID |
| 14 | `sort_students_by_gpa` | Sort the database by average |
| 15 | `print_statistics` | Database statistics |
| 16 | `export_compact_report` | Compact report, one line per student |
| 17 | `recursive_print_exams` | Transcript listing via recursive printing |
| 18 | — | Exit |

The database ships with **50 sample records** carrying real course names, credits and
grades. The dataset deliberately includes edge cases — duplicate surnames, already-deleted
records, empty and full transcripts — so every routine can be exercised immediately.

## Files

The code is split across six modules, linked at assembly time with `.include`:

| File | Role |
|---|---|
| `Ferrabue_progetto1.asm` | Entry point (`main`), memory allocation, menu, dispatch table |
| `macros.asm` | Reusable I/O macros and the `print_student` formatting macro |
| `database_studenti.asm` | Static data: the 50 pre-populated records |
| `inizializzazione.asm` | `init_db` — copies static records into the working arrays |
| `functions.asm` | The 17 menu routines |
| `utility_functions.asm` | Helpers: `copy_string`, `strip_newline`, `get_student_gpa` |

## Running it

You need **Java** and **MARS 4.5**, a single executable JAR you can download from the
[official page](http://courses.missouristate.edu/kenvollmar/mars/). No installation
required.

1. Put all six `.asm` files in the **same folder** — `.include` resolves paths relative to
   the file being assembled, so splitting them up breaks the build.
2. Open `Mars4_5.jar` (or run `java -jar Mars4_5.jar` from a terminal).
3. **File → Open** and select `Ferrabue_progetto1.asm`. Open only this one; the others are
   pulled in automatically.
4. Assemble with **F3**, then run with **F5**. The menu appears in the *Run I/O* pane.
5. Type **0** and press Enter to load the sample records — without this the database is
   empty and every query comes back with nothing. Then pick any option from 1 to 17.

A quick tour: `0` to load, `2` to list everyone, `3` then `1051` to look up a student, `8`
then `1051` for their average, `15` for statistics, `18` to quit.

## Report

`MARS-Project-Report.pdf` contains the full technical write-up: flowcharts and
line-by-line analysis of the assembly code. Written in Italian.

