# ----------------------------------------------------- #
#         FUNDAMENTOS DE SISTEMAS COMPUTACIONAIS        #
#                    RISC-V BLACKJACK                   #
#                LUCAS DA PAZ (xLucaspx)                #
# ----------------------------------------------------- #

# Dados do programa -------------------------------------
.data
s_Intro:         .string "Bem-vindo ao Blackjack!\n"
s_PlayerGets:    .string "\nO jogador recebe: "
s_PlayerHand:    .string "\nSua mão: "
s_DealerGets:    .string "O dealer recebe: "
s_DealerHand:    .string "\nO dealer revela sua mão: "
s_DealerHas:     .string "\nO dealer tem: "
s_DealerMustHit: .string "\n\nO dealer deve continuar pedindo cartas...\n"
s_DealerReveals: .string "\nO dealer revela: "
s_HiddenCard:    .string " e uma carta oculta\n"
s_PlayerOp:      .string "\nO que você deseja fazer? (1 - Hit, 2 - Stand): "
s_PlayAgain:     .string "\nDeseja jogar novamente? (1 - Sim, 2 - Não): "
s_InvalidOp:     .string "Opção inválida!\n"
s_PlayerBurst:   .string "\n\nO jogador estourou! O dealer venceu!\n"
s_DealerBurst:   .string "\n\nO dealer estourou! Você venceu!\n"
s_PlayerWins:    .string "\n\nVocê venceu com "
s_DealerWins:    .string "\n\nO dealer venceu com "
s_GameIsTied:    .string "\n\nO jogo empatou em "
s_Points:        .string " pontos\n"
s_And:           .string " e "
s_PlusSign:      .string " + "
s_EqualSign:     .string " = "
s_Endl:          .string "\n"
v_CardSymbols:   .ascii  "J\0", "Q\0", "K\0", "A\0"
v_DrawnCards:    .half   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
v_PlayerCards:   .half   0, 0, 0, 0, 0, 0, 0, 0, 0
v_DealerCards:   .half   0, 0, 0, 0, 0, 0, 0, 0, 0

# Código ------------------------------------------------
.text
.globl main
main:
	li s1 1             # define HIT/PLAY_OP   -> s1
	li s2 2             # define STAND/STOP_OP -> s2
	la s3 v_DrawnCards  # short* s3 = &v_DrawnCards
	la s4 v_PlayerCards # short* s4 = &v_PlayerCards
	la s5 v_DealerCards # short* s5 = &v_DealerCards

	jal p_Run           # run()

	j halt              # halt

# void run() --------------------------------------------
p_Run:
	addi sp sp -4          # stack management
	sw ra 0(sp)            # stores ra

	jal p_PrintHeader      # printHeader()

	p_Run_loop:
		jal p_Blackjack      # blackjack()
		jal p_PrintEndMenu   # printEndMenu()
		jal f_ReadInt        # a0 = op
		beq a0 s1 p_Run_loop # if (a0 == play_op) continue
		beq a0 s2 p_Run_halt # if (op == stop_op) break
		la a0 s_InvalidOp    # a0 = &s_InvalidOp
		jal p_PrintString    # printString(a0)
		j p_Run_loop         # continue

	p_Run_halt:
		lw ra 0(sp)          # retrieves ra
		addi sp sp 4         # restores stack
	jr ra                  # return

# short drawCard(v_Hand &a0) ----------------------------
f_DrawCard:
	add t0 x0 s3                     # t0 = &v_DrawnCards
	add t1 x0 a0                     # t1 = &v_Hand
	li t2 4                          # t2 = 4 (max times a card can be drawn)

	li a7 42                         # a7 = 42 (rand int range)
	li a1 12                         # a1 = 12 (upper bound)
	p_DrawCard_sort:                 # do ... while (v_DrawnCards[a0] >= t2)
		ecall                          # a0 = random int [0, bound]
		slli t3 a0 1                   # t3 = a0 * 2 (to access half word)
		add t3 t3 t0                   # t3 = &v_DrawnCards[a0]
		lh t4 0(t3)                    # t4 = v_DrawnCards[a0]
		bge t4 t2 p_DrawCard_sort      # if (v_DrawnCards[a0] < t2) break

	addi t4 t4 1                     # t4++
	sh t4 0(t3)                      # v_DrawnCards[a0]++
	addi a0 a0 1                     # a0++ (so the card is between 1 and 13)

	xor t2 t2 t2                     # t2 = 0
	p_DrawCard_handIndex:            # while (v_Hand[t2] != 0)
		slli t3 t2 1                   # t3 = t2 * 2 (to access half word)
		add t3 t3 t1                   # t3 = &v_Hand
		lh t4 0(t3)                    # t4 = v_Hand[t2]
		addi t2 t2 1                   # t2++
		bgt t4 x0 p_DrawCard_handIndex # if (t4 <= 0) break

	sh a0 0(t3)                      # v_hand[t2] = a0
	jr ra                            # return a0

# void deal() -------------------------------------------
p_Deal:
	addi sp sp -8                  # stack management
	sw ra 0(sp)                    # stores ra
	sw s11 4(sp)                   # stores s11

	xor s11 s11 s11                # s11 = 0
	p_Deal_loop:                   # for (s11 = 0; s11 < t2; s11++)
		andi t1 s11 0x1              # t1 = s11 & 1
		bne t1 x0 p_Deal_loop_dealer # if (t1 != 0) deal to player
		add a0 x0 s4                 # a0 = &v_PlayerCards
		j p_Deal_loop_draw
		p_Deal_loop_dealer:          # else deal to dealer
			add a0 x0 s5               # a0 = &v_DealerCards
		p_Deal_loop_draw:
			jal f_DrawCard             # drawCard(a0)
		addi s11 s11 1               # s11++
		addi t2 x0 4                 # t2 = 4
		blt s11 t2 p_Deal_loop       # if (s11 >= t2) break

	lw ra 0(sp)                    # retrieves ra
	lw s11 4(sp)                   # retrieves s11
	addi sp sp 8                   # restores stack
	jr ra                          # return

# void blackjack() --------------------------------------
p_Blackjack:
	addi sp sp -12                # stack management
	sw ra 0(sp)                   # stores ra
	sw s10 4(sp)                  # stores s10
	sw s11 8(sp)                  # stores s11

	jal p_Deal                    # deal()
	jal p_PrintGameStart          # printGameStart()

	jal f_PlayerRound             # a0 = playerRound()
	add s10 x0 a0                 # s10 = playerPoints

	addi t0 x0 21                 # t0 = 21 (maxPoints)
	ble s10 t0 p_Blackjack_dealer # if (playerPoints > maxPoints)
	add a0 x0 s5                  # a0 = &v_DealerCards
	jal f_SumPoints               # a0 = sumPoints(v_DealerCards)
	add s11 x0 a0                 # s11 = dealerPoints
	j p_Blackjack_end             # goto p_Blackjack_end

	p_Blackjack_dealer:
		jal f_DealerRound           # a0 = dealerRound()
		add s11 x0 a0               # s11 = dealerPoints

	p_Blackjack_end:
		add a0 x0 s10               # a0 = playerPoints
		add a1 x0 s11               # a1 = dealerPoints
		jal p_PrintWinner           # PrintWinner(a0, a1)
		jal p_ResetGame             # resetGame()

	lw ra 0(sp)                   # retrieves ra
	lw s10 4(sp)                  # retrieves s10
	lw s11 8(sp)                  # retrieves s11
	addi sp sp 12                 # restores stack
	jr ra                         # return

# void printGameStart() ---------------------------------
p_PrintGameStart:
	addi sp sp -4         # stack management
	sw ra 0(sp)           # stores ra

	la a0 s_PlayerGets    # a0 = &s_PlayerGets
	jal p_PrintString     # printString(a0)
	lh a0 0(s4)           # a0 = v_PlayerCards[0]
	jal p_PrintInt        # printInt(a0)
	la a0 s_And           # a0 = &s_And
	jal p_PrintString     # printString(a0)
	lh a0 2(s4)           # a0 = v_PlayerCards[1]
	jal p_PrintInt        # printInt(a0)

	la a0 s_DealerReveals # a0 = &s_DealerReveals
	jal p_PrintString     # printString(a0)
	lh a0 0(s5)           # a0 = v_DealerCards[0]
	jal p_PrintInt        # printInt(a0)
	la a0 s_HiddenCard    # a0 = &s_HiddenCard
	jal p_PrintString     # printString(a0)

	lw ra 0(sp)           # retrieves ra
	addi sp sp 4          # restores stack
	jr ra                 # return

# short playerRound() ----------------------------------
f_PlayerRound:
	addi sp sp -12                   # stack management
	sw ra 0(sp)                      # stores ra
	sw s10 4(sp)                     # stores s10
	sw s11 8(sp)                     # stores s11

	add a0 x0 s4                     # a0 = &v_PlayerCards
	jal f_SumPoints                  # a0 = sumPoints(v_PlayerCards)
	add s10 x0 a0                    # s10 = a0 (points)
	jal p_PrintPlayerHand            # printPlayerHand(a0)

	addi s11 x0 21                   # s11 = 21 (maxPoints)
	f_PlayerRound_loop:
		bge s10 s11 f_PlayerRound_halt # if (points >= maxPoints) break
		jal p_PrintPlayerMove          # printPlayerMove()
		jal f_ReadInt                  # a0 = op
		beq a0 s1 f_PlayerRound_hit
		beq a0 s2 f_PlayerRound_halt   # if (op == stand_op) break
		la a0 s_InvalidOp              # a0 = &s_InvalidOp
		jal p_PrintString              # printString(a0)
		j f_PlayerRound_loop           # continue
		f_PlayerRound_hit:             # if (op == hit_op)
			add a0 x0 s4                 # a0 = &v_PlayerCards
			jal f_DrawCard               # drawCard(a0)
			jal p_PrintDrawnCardPlayer   # printDrawnCardPlayer(a0)
			add a0 x0 s4                 # a0 = &v_PlayerCards
			jal f_SumPoints              # a0 = points
			add s10 x0 a0                # s10 = a0
			jal p_PrintPlayerHand        # printPlayerHand(a0)
			j f_PlayerRound_loop

	f_PlayerRound_halt:
	add a0 x0 s10                    # a0 = points

	lw ra 0(sp)                      # retrieves ra
	lw s10 4(sp)                     # retrieves s10
	lw s11 8(sp)                     # retrieves s11
	addi sp sp 12                    # restores stack
	jr ra                            # return points

# short dealerRound() ----------------------------------
f_DealerRound:
	addi sp sp -12                   # stack management
	sw ra 0(sp)                      # stores ra
	sw s10 4(sp)                     # stores s10
	sw s11 8(sp)                     # stores s11

	add a0 x0 s5                     # a0 = &v_DealerCards
	jal f_SumPoints                  # a0 = sumPoints(v_DealerCards)
	add s10 x0 a0                    # s10 = a0 (points)
	jal p_RevealDealerHand           # revealDealerHand(a0)

	addi s11 x0 17                   # s11 = 17 (dealerLimit)
	f_DealerRound_loop:
		bge s10 s11 f_DealerRound_halt # if (points >= dealerLimit) break
		add a0 x0 s5                   # a0 = &v_DealerCards
		jal f_DrawCard                 # drawCard(a0)
		jal p_PrintDrawnCardDealer     # printDrawnCardDealer(a0)
		add a0 x0 s5                   # a0 = &v_DealerCards
		jal f_SumPoints                # a0 = points
		add s10 x0 a0                  # s10 = a0
		jal p_PrintDealerHand          # printDealerHand(a0)
		j f_DealerRound_loop

	f_DealerRound_halt:
	add a0 x0 s10                    # a0 = points

	lw ra 0(sp)                      # retrieves ra
	lw s10 4(sp)                     # retrieves s10
	lw s11 8(sp)                     # retrieves s11
	addi sp sp 12                    # restores stack
	jr ra                            # return points

# void printDrawnCardDealer(card &a0) -------------------
p_PrintDrawnCardDealer:
	addi sp sp -8         # stack management
	sw ra 0(sp)           # stores ra
	sw s11 4(sp)          # stores s11

	add s11 x0 a0         # s11 = card
	la a0 s_DealerMustHit # a0 = &s_DealerMustHit
	jal p_PrintString     # printString(a0)
	la a0 s_DealerGets    # a0 = &s_DealerGets
	jal p_PrintString     # printString(a0)
	add a0 x0 s11         # a0 = card
	jal p_PrintCard       # printInt(a0)

	lw ra 0(sp)           # retrives ra
	lw s11 4(sp)          # retrieves s11
	addi sp sp 8          # restores stack
	jr ra                 # return

# void printDrawnCardPlayer(card &a0) -------------------
p_PrintDrawnCardPlayer:
	addi sp sp -8      # stack management
	sw ra 0(sp)        # stores ra
	sw s11 4(sp)       # stores s11

	add s11 x0 a0      # s11 = card
	la a0 s_PlayerGets # a0 = &s_PlayerGets
	jal p_PrintString  # printString(a0)
	add a0 x0 s11      # a0 = card
	jal p_PrintCard    # printInt(a0)

	lw ra 0(sp)        # retrives ra
	lw s11 4(sp)       # retrieves s11
	addi sp sp 8       # restores stack
	jr ra              # return

# void printPlayerMove() --------------------------------
p_PrintPlayerMove:
	addi sp sp -4     # stack management
	sw ra 0(sp)       # stores ra

	la a0 s_PlayerOp  # a0 = &s_PlayerOp
	jal p_PrintString # printString(a0)

	lw ra 0(sp)       # retrieves ra
	addi sp sp 4      # restores stack
	jr ra             # return

# void printPlayerHand(points &a0) ----------------------
p_PrintPlayerHand:
	addi sp sp -8      # stack management
	sw ra 0(sp)        # stores ra
	sw s11 4(sp)       # stores s11

	add s11 x0 a0      # s11 = points

	la a0 s_PlayerHand # a0 = &s_Player_Hand
	jal p_PrintString  # print(a0)

	add a0 x0 s11      # a0 = points
	add a1 x0 s4       # a1 = &v_PlayerCards
	jal p_PrintHand    # printHand(points a0, v_cards &a1)

	lw ra 0(sp)        # retrieves ra
	lw s11 4(sp)       # retrieves s11
	addi sp sp 8       # restores stack
	jr ra              # return

# void printDealerHand(points &a0) ----------------------
p_PrintDealerHand:
	addi sp sp -8     # stack management
	sw ra 0(sp)       # stores ra
	sw s11 4(sp)      # stores s11

	add s11 x0 a0     # s11 = points

	la a0 s_DealerHas # a0 = &s_DealerHas
	jal p_PrintString # print(a0)

	add a0 x0 s11     # a0 = points
	add a1 x0 s5      # a1 = &v_DealerCards
	jal p_PrintHand   # printHand(points a0, v_cards &a1)

	lw ra 0(sp)       # retrieves ra
	lw s11 4(sp)      # retrieves s11
	addi sp sp 8      # restores stack
	jr ra             # return

# void revealDealerHand(points &a0) ---------------------
p_RevealDealerHand:
	addi sp sp -8      # stack management
	sw ra 0(sp)        # stores ra
	sw s11 4(sp)       # stores s11

	add s11 x0 a0      # s11 = points

	la a0 s_DealerHand # a0 = &s_DealerHand
	jal p_PrintString  # print(a0)

	add a0 x0 s11      # a0 = points
	add a1 x0 s5       # a1 = &v_DealerCards
	jal p_PrintHand    # printHand(points a0, v_cards &a1)

	lw ra 0(sp)        # retrieves ra
	lw s11 4(sp)       # retrieves s11
	addi sp sp 8       # restores stack
	jr ra              # return

# void printHand(const points &a0, const v_Hand &a1) ----
p_PrintHand:
	addi sp sp -12                   # stack management
	sw ra 0(sp)                      # stores ra
	sw s10 4(sp)                     # stores s10
	sw s11 8(sp)                     # stores s11

	add s11 x0 a0                    # s11 = points
	xor s10 s10 s10                  # s10 = 0
	p_PrintHand_loop:                # while (v_Hand[s10 + 1] != 0)
		slli t1 s10 1                  # t1 = s10 * 2
		add t1 t1 a1                   # t1 = &v_Hand[s10]
		lh t2 0(t1)                    # t2 = v_Hand[s10]
		ble t2 x0 p_PrintHand_loop_end # if (v_Hand[s10] <= 0) break
		add a0 x0 t2                   # a0 = v_Hand[s10]
		jal p_PrintCard                # printCard(a0)
		addi s10 s10 1                 # s10++
		slli t1 s10 1                  # t1 = (s10 + 1) * 2
		add t1 t1 a1                   # t1 = &v_Hand[s10 + 1]
		lh t2 0(t1)                    # t2 = v_Hand[s10 + 1]
		ble t2 x0 p_PrintHand_loop_end # if (v_Hand[s10 + 1] <= 0) break
		la a0 s_PlusSign               # a0 = &s_PlusSign
		jal p_PrintString              # printString(a0)
		j p_PrintHand_loop

	p_PrintHand_loop_end:
		la a0 s_EqualSign              # a0 = &s_EqualSign
		jal p_PrintString              # printString(a0)
		add a0 x0 s11                  # a0 = points
		jal p_PrintInt                 # printInt(a0)

	lw ra 0(sp)                      # retrieves ra
	lw s10 4(sp)                     # retrieves s10
	lw s11 8(sp)                     # retrieves s11
	addi sp sp 12                    # restores stack
	jr ra                            # return

# void PrintWinner(playerPoints &a0, dealerPoints &a1) --
p_PrintWinner:
	addi sp sp -4                       # stack management
	sw ra 0(sp)                         # stores ra

	addi t0 x0 21                       # t0 = 21 (maxPoints)
	bgt a0 t0 p_PrintWinner_playerBurst # if (playerPoints > maxPoints) goto p_PrintWinner_playerBurst
	bgt a1 t0 p_PrintWinner_dealerBurst # if (dealerPoints > maxPoints) goto p_PrintWinner_dealerBurst
	bgt a0 a1 p_PrintWinner_player      # if (playerPoints > dealerPoints) goto p_PrintWinner_player
	bgt a1 a0 p_PrintWinner_dealer      # if (dealerPoints > playerPoints) goto p_PrintWinner_dealer
	la a0 s_GameIsTied                  # else a0 = &s_GameIsTied
	jal p_PrintString                   # printString(a0)
	add a0 x0 a1                        # a0 = points
	j p_PrintWinner_points              # goto p_PrintWinner_points
	p_PrintWinner_playerBurst:
		la a0 s_PlayerBurst               # a0 = &s_PlayerBurst
		jal p_PrintString                 # printString(a0)
		j p_PrintWinner_halt              # goto p_PrintWinner_halt
  p_PrintWinner_dealerBurst:
  	la a0 s_DealerBurst               # a0 = &s_DealerBurst
  	jal p_PrintString                 # printString(a0)
  	j p_PrintWinner_halt              # goto p_PrintWinner_halt
  p_PrintWinner_player:
  	add t0 x0 a0                      # t0 = playerPoints
  	la a0 s_PlayerWins                # a0 = &s_PlayerWins
  	jal p_PrintString                 # printString(a0)
  	add a0 x0 t0                      # a0 = playerPoints
  	j p_PrintWinner_points            # goto p_PrintWinner_points
  p_PrintWinner_dealer:
  	la a0 s_DealerWins                # a0 = &s_DealerWins
  	jal p_PrintString                 # printString(a0)
  	add a0 x0 a1                      # a0 = dealerPoints
  p_PrintWinner_points:
  	jal p_PrintInt                    # printInt(a0) (points)
  	la a0 s_Points                    # a0 = &s_Points
  	jal p_PrintString                 # printString(a0)
  p_PrintWinner_halt:
  	lw ra 0(sp)                       # retrieves ra
  	addi sp sp 4                      # restores stack
  jr ra                               # return

# short sumPoints(v_Hand &a0) ---------------------------
f_SumPoints:
	addi t0 x0 0                        # t0 = 0
	addi t1 x0 0                        # t1 = 0 (aceCount)
	addi t4 x0 1                        # t4 = 1 (ace)
	addi t6 x0 10                       # t6 = 10 (max card value)
	xor t5 t5 t5                        # t5 = 0 (sum)
	f_SumPoints_cards:
		slli t2 t0 1                      # t2 = t0 * 2 (to access half word)
		add t2 t2 a0                      # t2 = &v_Hand[t0]
		lh t3 0(t2)                       # t3 = v_Hand[t0]
		ble t3 x0 f_SumPoints_cards_end   # if (v_Hand[t0] <= 0) break
		addi t0 t0 1                      # t0++
		bne t3 t4 f_SumPoints_cards_sum   # if (v_Hand[t0] == ace)
		addi t1 t1 1                      # aceCount++
		j f_SumPoints_cards               # continue
		f_SumPoints_cards_sum:            # else
			bgt t3 t6 f_SumPoints_cards_max # if (v_Hand[t0] <= 10)
			add t5 t5 t3                    # sum += v_Hand[t0]
			j f_SumPoints_cards             # continue
		f_SumPoints_cards_max:            # else
			addi t5 t5 10                   # sum += 10
			j f_SumPoints_cards

	f_SumPoints_cards_end:
	addi t0 x0 0                        # t0 = 0
	addi t4 x0 10                       # t4 = 10
	f_SumPoints_aces:                   # while (t0 < aceCount)
		bge t0 t1 f_SumPoints_halt        # if (t0 >= aceCount) break;
		addi t0 t0 1                      # t0++
		bgt t5 t4 f_SumPoints_aces_low    # if (sum <= 10)
		addi t5 t5 11                     # sum += 11
		j f_SumPoints_aces                # continue
		f_SumPoints_aces_low:             # else
			addi t5 t5 1                    # sum += 1
			j f_SumPoints_aces

	f_SumPoints_halt:
		add a0 x0 t5                      # a0 = sum
	jr ra                               # return sum

# void resetGame() --------------------------------------
p_ResetGame:
	addi sp sp -4     # stack management
	sw ra 0(sp)       # stores ra

	add a0 x0 s3      # a0 = s3 (&v_DrawnCards)
	li a1 12          # a1 = 12 (v_DrawnCards.size)
	jal p_ClearVector # clearVector(a0, a1)

	add a0 x0 s4      # a0 = s4 (&v_PlayerCards)
	li a1 9           # a1 = 9 (v_PlayerCards.size)
	jal p_ClearVector # clearVector(a0, a1)

	add a0 x0 s5      # a0 = s5 (&v_DealerCards)
	jal p_ClearVector # clearVector(a0, a1)

	lw ra 0(sp)       # retrieves ra
	addi sp sp 4      # restores stack
	jr ra             # return

# void clearVector(vector &a0, sizet_t a1) -----------
p_ClearVector:
	xor t0 t0 t0                   # t0 = 0
	add t1 x0 a0                   # t1 = &a0
	p_ClearVector_loop:            # while (t0 < a1)
		bge t0 a1 p_ClearVector_halt # if (t0 >= a1 (size)) break
		sh x0 0(t1)                  # mem[&t1] = 0
		addi t1 t1 2                 # t1 += 2 (half word)
		addi t0 t0 1                 # t0++
		j p_ClearVector_loop

	p_ClearVector_halt:
		jr ra                        # return

# void printHeader() ------------------------------------
p_PrintHeader:
	addi sp sp -4     # stack management
	sw ra 0(sp)       # stores ra

	la a0 s_Intro     # a0 = &s_Intro
	jal p_PrintString # printString(&a0)

	lw ra 0(sp)       # retrieves ra
	addi sp sp 4      # restores stack
	jr ra             # return

# void printEndMenu() -----------------------------------
p_PrintEndMenu:
	addi sp sp -4     # stack management
	sw ra 0(sp)       # stores ra

	la a0 s_PlayAgain # a0 = &s_PlayAgain
	jal p_PrintString # printString(&a0)

	lw ra 0(sp)       # retrieves ra
	addi sp sp 4      # restores stack
	jr ra             # return


# void printCard(const card &a0) -----------------------
p_PrintCard:
	addi sp sp -4     # stack management
	sw ra 0(sp)       # stores ra

	addi t0 x0 1              # t0 = 1 (ace)
	beq a0 t0 p_PrintCard_ace # if (card == ace) goto p_PrintCard_ace
	addi t0 x0 11             # t0 = 11
	blt a0 t0 p_PrintCard_num # if (card < 11) goto p_PrintCard_J
	beq a0 t0 p_PrintCard_J   # if (card == 11) goto p_PrintCard_J
	addi t0 x0 12             # t0 = 12
	beq a0 t0 p_PrintCard_Q   # if (card == 12) got p_PrintCard_Q
		la a0 v_CardSymbols     # else (card > 12) a0 = &v_CardSymbols
		addi a0 a0 4            # a0 = &v_CardSymbols[K]
		jal p_PrintString       # printString(a0)
		j p_PrintCard_halt
	p_PrintCard_ace:          # case ACE
		la a0 v_CardSymbols     # a0 = &v_CardSymbols
		addi a0 a0 6            # a0 = &v_CardSymbols[A]
		jal p_PrintString       # printString(a0)
		j p_PrintCard_halt
	p_PrintCard_num:          # if (card > 1 && card < 11)
		jal p_PrintInt          # printInt(a0)
		j p_PrintCard_halt
	p_PrintCard_J:            # case J
		la a0 v_CardSymbols     # a0 = &v_CardSymbols[J]
  	jal p_PrintString       # printString(a0)
  	j p_PrintCard_halt
	p_PrintCard_Q:            # case Q
		la a0 v_CardSymbols     # a0 = &v_CardSymbols
		addi a0 a0 2            # a0 = &v_CardSymbols[Q]
  	jal p_PrintString       # printString(a0)
	p_PrintCard_halt:
		lw ra 0(sp)             # retrieves ra
		addi sp sp 4            # restores stack
	jr ra                     # return

# void printInt(const int &a0) --------------------------
p_PrintInt:
	li a7 1 # a7 = 1 (print int)
	ecall   # call print(&a0)
	jr ra   # return

# void printString(const string &a0) --------------------
p_PrintString:
	li a7 4 # a7 = 4 (print string)
	ecall   # call print(&a0)
	jr ra   # return

# int readInt() -----------------------------------------
f_ReadInt:
	li a7 5 # a7 = 5 (read int)
	ecall   # a0 = n
	jr ra   # return a0

# -------------------------------------------------------
halt:
	li a7 93       # a7 = 93 (exit code)
	xor a0 a0 a0   # a0 = 0 (exit status)
	ecall          # exits
