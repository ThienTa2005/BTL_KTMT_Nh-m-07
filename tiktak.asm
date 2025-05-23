;TIC-TAC-TOE  
.MODEL SMALL
.STACK 100H
.DATA
DEVELOP DB  'Phat trien boi nhom 07 - KTMT nhom 02 PTIT.$'   
; DONG 1, 2, 3, 4 DE BIEU BIEN LOGO GAME TIC TAC TOE 
D1 DB 4,4,4,4,4,32,4,32,4,4,4,4,32,32,32,4,4,4,4,4,32,32,4,4,32,32,4,4,4,4,32,32,32,4,4,4,4,4,32,32,4,4,32,32,4,4,4,4,'$'
D2 DB 32,32,4,32,32,32,4,32,4,32,32,32,32,32,32,32,32,4,32,32,32,4,32,32,4,32,4,32,32,32,32,32,32,32,32,4,32,32,32,4,32,32,4,32,4,'$'
D3 DB 32,32,4,32,32,32,4,32,4,32,32,32,32,32,32,32,32,4,32,32,32,4,4,4,4,32,4,32,32,32,32,32,32,32,32,4,32,32,32,4,32,32,4,32,4,4,4,4,'$'
D4 DB 32,32,4,32,32,32,4,32,4,4,4,4,32,4,32,32,32,4,32,32,32,4,32,32,4,32,4,4,4,4,32,4,32,32,32,4,32,32,32,32,4,4,32,32,4,4,4,4,32,4,'$'
SKIP DB 'Nhan phim bat ky de tiep tuc...$'
; LUAT CHOI
R DB 'Luat choi:$' 
R1 DB '1. Nguoi choi se choi lan luot.$'
R2 DB '2. Nguoi choi 1 se bat dau game.$'
R3 DB '3. Nguoi choi 1 se la "X" va Nguoi choi 2 se la "O".$'
R4 DB '4. Bang choi se duoc danh dau cac vi tri bang cac con so.$'
R5 DB '5. Dien vi tri so cua o de danh dau vi tri chon.$'
R6 DB '6. Dat 3 dau cua ban theo chieu ngang, doc hoac cheo de gianh chien thang.$'   
R7 DB 'Chuc may man!$' 
; KI HIEU CHO NGUOI CHOI 
PC1 DB ' (X)$'
PC2 DB ' (O)$' 
; DUONG KE BANG
L2 DB '--- --- ---$'
N1 DB ' | $'
; SO CUA O TRONG BANG 
C1 DB '1$' 
C2 DB '2$'
C3 DB '3$'
C4 DB '4$'
C5 DB '5$'
C6 DB '6$'
C7 DB '7$'
C8 DB '8$'
C9 DB '9$'    
; DAU HIEN TAI (X/O) ---------------------------
CUR DB 88
; NGUOI CHOI SO... DI CHUYEN VA KIEM TRA CO XEM TRAN DAU THANG HAY HOA
PLAYER DB 50, '$' 
MOVES DB 0
DONE DB 0
DR DB 0 
; DAU VAO NHAP O -------------------------
INP DB ' : Nhap vao o so : $'
TKN DB 'O nay da duoc chon! Vui long chon o khac...$' 
; DONG THONG BAO CUOI CUNG -------------------------------
W1 DB 'Nguoi choi $'
W2 DB ' da thang tran dau nay!$'
DRW DB 'Tran dau hoa!$'
; DONG THONG BAO CO CHOI TIEP HAY KHONG -----------------------------
TRA DB 'Ban co muon choi tiep? (c/k): $'
WI DB  'Dau vao loi! Vui long nhap lai...   $' 
; DONG TRONG
EMP DB '                                                             $'       
;DI CHUYEN CON TRO
GOTOXY MACRO x,y        
       MOV DL,x
       MOV DH,y
       MOV BX,0
       MOV AH,2
       INT 10H 
ENDM
;KIEM TRA CHIEN THANG
CHECKWIN MACRO a, b, c, label_next     
    MOV AL, a
    MOV BL, b
    MOV CL, c
    CMP AL, BL
    JNZ label_next
    CMP BL, CL
    JNZ label_next
    MOV DONE, 1
    JMP BOARD
ENDM
;IN RA MAN HINH
PRINT MACRO x        
    LEA DX,x
    MOV AH,9
    INT 21H
ENDM  
; KIEM TRA NEU 0 DA DUOC CHON
CHECKTAKEN MACRO x   
    CMP x, 88  
    JZ TAKEN
    CMP x, 79  
    JZ TAKEN 
    MOV x, CL
    JMP CHECKWIN
ENDM          
;LENH NHAY KIEM TRA DAU VAO
JUMPIF MACRO VAL, LABEL 
    CMP BL, VAL
    JZ LABEL
ENDM    
;XOA MAN HINH
CLRSCR MACRO  
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
ENDM     
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX    
; --------- BIEU DIEN MAN HINH TIEU DE ---------    
    TITLESCREEN: 
            GOTOXY 14,7 
            PRINT D1
            GOTOXY 14,8 
            PRINT D2             
            GOTOXY 14,9
            PRINT D3
            GOTOXY 14,10  
            PRINT D2 
            GOTOXY 14,11 
            PRINT D4
            GOTOXY 18,13 
            PRINT DEVELOP 
            GOTOXY 24,14  
            PRINT SKIP
            MOV AH, 7    
            INT 21H
            CLRSCR                     
; ----------- BIEU DIEN LUAT CHOI --------------                                     
    RULES:
            GOTOXY 7,6
            PRINT R            
            GOTOXY 7,7 
            PRINT R1  
            GOTOXY 7,8 
            PRINT R2            
            GOTOXY 7,9
            PRINT R3
            GOTOXY 7,10
            PRINT R4           
            GOTOXY 7,11      
            PRINT R5            
            GOTOXY 7,12
            PRINT R6           
            GOTOXY 7,13 
            PRINT R7
            GOTOXY 7,15    
            PRINT SKIP
            MOV AH, 7  
            INT 21H 
 ; ---------- KHOI TAO ---------------------
       INIT: 
            MOV PLAYER, 50     
            MOV MOVES, 0  
            MOV DONE, 0
            MOV DR, 0 
            MOV C1, 49
            MOV C2, 50
            MOV C3, 51
            MOV C4, 52
            MOV C5, 53
            MOV C6, 54
            MOV C7, 55
            MOV C8, 56
            MOV C9, 57      
            
                                   
; ------------DOI NGUOI CHOI ----------       
    PLRCHANGE:                         
        CMP PLAYER, 49
        JZ P2
        CMP PLAYER, 50
        JZ P1        
        P1:
            MOV PLAYER, 49
            MOV CUR, 88                                    
            JMP BOARD             
        P2:
            MOV PLAYER, 50
            MOV CUR, 79
            JMP BOARD                                               
; ------------ KIEM TRA CHIEN THANG -----------
    CHECKWIN:    
       CHECK1: CHECKWIN C1, C2, C3, CHECK2
       CHECK2: CHECKWIN C4, C5, C6, CHECK3
       CHECK3: CHECKWIN C7, C8, C9, CHECK4
       CHECK4: CHECKWIN C1, C4, C7, CHECK5
       CHECK5: CHECKWIN C2, C5, C8, CHECK6
       CHECK6: CHECKWIN C3, C6, C9, CHECK7                   
       CHECK7: CHECKWIN C1, C5, C9, CHECK8      
       CHECK8: CHECKWIN C3, C5, C7, DRAWCHECK            
       DRAWCHECK:
            MOV AL, MOVES
            CMP AL, 9
            JB PLRCHANGE            
            MOV DR, 1
            JMP BOARD                
; ------------ CHIEN THANG ------------------------
    VICTORY:                                       
            PRINT W1
            MOV AH, 2
            MOV DL, PLAYER
            INT 21H
            PRINT W2  
            JMP END 
; ------------ TRAN HOA ------------  
    DRAW:
            PRINT DRW
            JMP END
; ------------ KET THUC ------------              
    END:
                GOTOXY 28,15
                PRINT SKIP
                MOV AH, 7  
                INT 21H
                JMP TRYAGAIN                    
; ------------- BANG ----------   
    BOARD: 
        CLRSCR   
        GOTOXY 32,8                   
        PRINT C1     
        PRINT N1     
        PRINT C2     
        PRINT N1        
        PRINT C3           
        GOTOXY 31,9          
        PRINT L2               
        GOTOXY 32,10            
        PRINT C4     
        PRINT N1       
        PRINT C5     
        PRINT N1       
        PRINT C6               
        GOTOXY 31,11          
        PRINT L2
        GOTOXY 32,12                 
        PRINT C7     
        PRINT N1       
        PRINT C8     
        PRINT N1      
        PRINT C9        
; ---------------------------------          
        GOTOXY 20,14   
        CMP DONE, 1
        JZ VICTORY 
        CMP DR, 1
        JZ DRAW                    
; ------------ DAU VAO --------------
  INPUT:  
    PRINT W1
    MOV AH, 2
    MOV DL, PLAYER
    INT 21H 
    CMP PLAYER, 49
    JZ PL1
        PRINT PC2
    JMP TAKEINPUT
    PL1:
        PRINT PC1 
    TAKEINPUT:
    PRINT INP   
    MOV AH, 1
    INT 21H   
    INC MOVES ; TANG BO DEM LEN 1 DON VI 
    MOV BL, AL 
    SUB BL, 48
    MOV CL, CUR 
; KIEM TRA XEM DAU VAO CO THUOC 1-9 HAY KHONG
    JUMPIF 1, C1U
    JUMPIF 2, C2U
    JUMPIF 3, C3U
    JUMPIF 4, C4U
    JUMPIF 5, C5U
    JUMPIF 6, C6U
    JUMPIF 7, C7U
    JUMPIF 8, C8U
    JUMPIF 9, C9U    
; NEU DAU VAO KHONG HOP LE
    DEC MOVES
        GOTOXY 20,14  
    PRINT WI
    MOV AH, 7  
    INT 21H
        GOTOXY 20,14
    PRINT EMP  
        GOTOXY 20,14
    JMP INPUT
    TAKEN:
        DEC MOVES
            GOTOXY 20,14     
        PRINT TKN  
        MOV AH, 7   
        INT 21H 
            GOTOXY 20,14   
        PRINT EMP 
            GOTOXY 20,14
        JMP INPUT 
        C1U: CHECKTAKEN C1
        C2U: CHECKTAKEN C2
        C3U: CHECKTAKEN C3
        C4U: CHECKTAKEN C4 
        C5U: CHECKTAKEN C5
        C6U: CHECKTAKEN C6
        C7U: CHECKTAKEN C7 
        C8U: CHECKTAKEN C8
        C9U: CHECKTAKEN C9
    TRYAGAIN:
        CLRSCR  
        GOTOXY 24,10
        PRINT TRA
        MOV AH, 1     
        INT 21H
        CMP AL,99 ;KIEM TRA 'c'
        JZ INIT 
        CMP AL,67 ;KIEM TRA 'C'
        JZ INIT     ;DAU VAO LA 'C'/'c' THI VAN MOI
        CMP AL, 107 ;KIEM TRA 'k'
        JZ EXIT
        CMP AL, 75  ;KIEM TRA 'K'
        JZ EXIT     ;DAU VAO LA 'K'/'k' THI THOAT 
        ; NEU DAU VAO LOI
        GOTOXY 24,10
        PRINT WI 
        MOV AH, 7 
        INT 21H
        GOTOXY 24,10
        PRINT EMP
        JMP TRYAGAIN ; THU LAI   
    EXIT:
        MOV AH, 4CH
        INT 21H 
    MAIN ENDP
END MAIN
