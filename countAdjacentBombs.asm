.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
   	lw $t5, 0($sp)
	save_context
	move $s0, $t5
	move $s1, $a0
	move $s2, $a1
  
  li $t7, -1
  li $v0, 0
  
  # Linha
  addi $s6, $a0, -1	# i = linha - 1
  

  loop_i:	
  	addi $t1, $s1, 1	# k1 = linha + 1					# for (int i = 0; i < SIZE; ++i) {
  	bgt $s6, $t1, end_i 
  	addi $s7, $a1, -1
  	loop_j:					# for (int j = 0; j < SIZE; ++j) {
  		addi $t1, $s2, 1	# k1 = linha + 1
  		bgt $s7, $t1, end_j
  		
  		# Verifica limites
            	blt $s6, 0, prox_col
            	li $t0, SIZE
            	bge $s6, $t0, prox_col
            	blt $s7, 0, prox_col
            	bge $s7, $t0, prox_col
  		
  		# Calcular endereço
  		sll $t0, $s6, 5 
  		sll $t3, $s7, 2 
  		add $t0, $t0, $t3
  		add $t0, $t0, $s0	# endereço base + i * 32 + j
  		lw $t3, 0($t0)		# Carregar o valor de board[i][j] em $t3
  		
  		# Verifica se board[i][j] == -1
  		li $t7, -1
  		beq $t3, $t7, incrementa_cont
		
		# Vai para a próxima coluna
		prox_col:
                	addi $s7, $s7, 1
                	j loop_j
                	
		# Incrementa contador
		incrementa_cont:
			addi $v0, $v0, 1
            		j prox_col
  
  	end_j:
		addi $s6, $s6, 1
                j loop_i
  	end_i:
  		restore_context
    		jr $ra              # Retorna da chamada de função
              	
