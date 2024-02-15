.include "macros.asm"

.globl play

play:
	lw $t5, 0($sp)
	save_context
	move $s0, $t5
	move $s1, $a0
	move $s2, $a1

    
    li $t7, -1
    li $t6, -2
    
    # Encontrando a posição

    sll $t0, $s1, 5 
    sll $t1, $s2, 2 
    add $t0, $t0, $t1
    add $t0, $t0, $s0	# endereço base + i * 32 + j
    lw $t1, 0($t0)
    
    # Verifica se board[i][j] == -1 (atingiu uma bomba, fim de jogo)
    beq $t1, $t7, fim_de_jogo
    
    # Verifica se board[i][j] == -2 (posição do tabuleiro ainda não relevada)
    beq $t1, $t6, revela_posicao
    
    # Retorna 1
    j continua
    
    revela_posicao:
	move $a0, $s1
	move $a1, $s2
		  	
  	addi $sp, $sp, -4
  	sw $s0, 0 ($sp)
    	jal countAdjacentBombs
    	addi $sp, $sp, 4
    	
    	move $t2, $v0	# x = countAdjacentBombs(a0, a1, a2)
    	
    	sll $t0, $s1, 5 
    	sll $t1, $s2, 2 
    	add $t0, $t0, $t1
    	add $t0, $t0, $s0	# endereço base + i * 32 + j	
    	sw $t2, 0($t0)	# Armazena o resultado em board[linha][coluna]
    	
    	beqz $t2, revela_adjacentes
    	j continua
    
    revela_adjacentes:
    	addi $sp, $sp, -4
    	sw $s0, 0($sp)
    	move $a0, $s1
	move $a1, $s2
    	jal revealNeighboringCells
    	addi $sp, $sp, 4
    	j continua
    
    fim_de_jogo:
    	# Retorna 0 (jogo acabou)
    	li $v0, 0
    	restore_context
    	jr $ra
    
    continua:
    	li $v0, 1
    	restore_context
    	jr $ra
