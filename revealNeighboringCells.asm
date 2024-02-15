.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	lw $t6,0($sp)
	save_context
	move $s0, $t6
	move $s1, $a0
	move $s2, $a1
    
     	li $t7, -2
     	
     	# Linha
  	addi $s6, $s1, -1	# i = linha - 1
  	
  	loop_i:						# for (int i = 0; i < SIZE; ++i) {
  		addi $t1, $s1, 1
  		bgt $s6, $t1, end_i 
  		addi $s7, $s2, -1
  		loop_j:						# for (int j = 0; j < SIZE; ++j) {
  			li $t0, SIZE
  			addi $t1, $s2, 1
  			bgt $s7, $t2, end_j
  		
  			# Verifica limites
            		blt $s6, 0, prox_col
            		bge $s6, $t0, prox_col
            		blt $s7, 0, prox_col
            		bge $s7, $t0, prox_col
  		
  			# Calcular endereço
  			sll $t0, $s6, 5 
  			sll $t3, $s7, 2 
  			add $t0, $t0, $t3
  			add $t0, $t0, $s0	# endereço base + i * 32 + j
  			lw $t3, 0($t0)		# Carregar o valor de board[i][j] em $t3
  		
  			# Verifica se board[i][j] == -2
  			li $t7, -2
  			beq $t3, $t7, conta_bombas_adj
  			
  			# Vai para a próxima coluna
			prox_col:
                		addi $s7, $s7, 1
                		j loop_j
  		
  		conta_bombas_adj:
  			addi $sp, $sp, -4
		  	sw $s0, 0($sp)
		  	move $a0, $s6
		  	move $a1, $s7
  			jal countAdjacentBombs
			addi $sp, $sp, 4
    			move $s3, $v0	# x = countAdjacentBombs(a0, a1, a2)
    			
    			sll $t0, $s6, 5 
  			sll $t3, $s7, 2 
  			add $t0, $t0, $t3
  			add $t0, $t0, $s0	# endereço base + i * 32 + j
    			
		    	sw $s3, 0($t0)	# Armazena o resultado em board[linha][coluna] == board[i][j] = x;
		    	
		    	beqz $s3, revela_adjacentes
		    	j prox_col
		
		revela_adjacentes:
			addi $sp, $sp, -4
		  	sw $s0, 0($sp)
			move $a0, $s6
		  	move $a1, $s7
		    	jal revealNeighboringCells
		    	addi $sp, $sp, 4
		    	j prox_col
	
	end_j:
		addi $s6, $s6, 1
                j loop_i
  	end_i:
  		restore_context
    		jr $ra              # Retorna da chamada de função
              	
