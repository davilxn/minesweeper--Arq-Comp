.include "macros.asm"

.globl checkVictory
checkVictory:
    save_context
    move $s0,$a0
    li $t4,0 #count=0
    
    li $s2,0  #i=0
    for_i:
    li $t0,SIZE
    bge $s2,$t0,fim_for_i
   
     li $s3,0 #j=0
 
    for_j:
    li $t0,SIZE
    bge $s3,$t0, fim_for_j
    sll $t0,$s2,5
    sll $t1,$s3,2 
    add $t0,$t0,$t1
    add $t0,$t0,$s0
    lw $t5,0($t0)
    bge $t5,$zero, if_do_count
    
     addi $s3,$s3,1
     j for_j
    fim_for_j:
    addi $s2,$s2,1
    j for_i
    
    
    if_do_count:
    	addi $t4,$t4,1
    	addi $s3,$s3,1
    	j for_j
    
    fim_for_i:
    li $t6,SIZE
    mul $t6,$t6,$t6
    subi $t6, $t6,BOMB_COUNT 
    blt $t4,$t6,if_retorno
     li $v0,1
     restore_context
     jr $ra
    if_retorno:
    li $v0, 0
    restore_context
    jr $ra

# your code here
