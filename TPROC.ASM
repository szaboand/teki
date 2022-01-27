;*****************************************************************************
;***                                                                       ***
;***             (C) Szab¢ Andr†s 1996 Budapest-Hungary                    ***
;***                                                                       ***
;***       	            TProc routins V1.7			           ***
;***                                                                       ***
;*****************************************************************************

;****************** Utols¢ m¢dos°t†s: 1998.04.16. ****************************

;*****************************************************************************
;***                                                                       ***
;***                     Turbo Assembler deklar†ci¢k                       ***
;***                                                                       ***
;*****************************************************************************

	.MODEL TPASCAL          ; Turbo Pascal modell
	.CODE
        .286                    ; 286-os k¢dok

        PUBLIC	_TProcOn
        PUBLIC  _TProcOff
        PUBLIC  _Get_Command_From_Puffer
        PUBLIC  _Put_Command_To_Puffer
        PUBLIC  _SetTimer
        PUBLIC  _ClearCommandPuffer
        PUBLIC  _GetTProcInfo
        PUBLIC  _SetTProcFlag
        PUBLIC  _SetMouseEvent
        PUBLIC  _SetTimeCounter
        PUBLIC  _GetTimeCounter

;*****************************************************************************
;***                                                                       ***
;***                           Adatok                                      ***
;***                                                                       ***
;*****************************************************************************


Old_IRQ9          DD   ?          ; RÇgi billenty˚ megszak°t†s vektor
Old_INT1C         DD   ?          ; RÇgi idîz°tã megszak°t†s vektor
CommandSize       DW   32         ; Command rekord hossza byte-ban
TimerSize         DW   12         ; Timer rekord hossza byte-ban
MaxCommand        DW   128        ; Maxim†lis commandok sz†ma a pufferban
MaxTimer          DW   10         ; Maxim†lis idîz°tãk sz†ma
Key_Code          DW   0          ; Billenty˚ k¢d
Key_Table         DB   16 DUP (0) ; Billenty˚zet t†bla
Mouse_X           DW   0          ; Mouse X koordin†ta
Mouse_Y           DW   0          ; Mouse Y koordin†ta
Mouse_Button      DW   0          ; Mouse gomb †llapota
OldMouse_X        DW   0          ; OldMouse X koordin†ta
OldMouse_Y        DW   0          ; OldMouse Y koordin†ta
OldMouse_Button   DW   0          ; OldMouse gomb †llapota
Param1            DW   0          ; ParamÇret 1
Param2            DW   0          ; ParamÇter 2
ComPuffNum        DW   0          ; Command puffer mutat¢
Command_Puffer    DB 4128 DUP (0) ; Command puffer ( 128x32 byte + 32 (0) byte )
Timer             DB  120 DUP (0) ; Idîz°tã adatok ( 10x12 byte )
TProcFlag         DW   0          ; TProc jellemzãk
                                ; xxxxxxxxxxxxxxx1 : PutCommand tiltott
                                ; xxxxxxxxxxxxxx1x : MouseCommand tiltott
                                ; xxxxxxxxxxxxx1xx : KeyCommand tiltott
                                ; xxxxxxxxxxxx1xxx : TimerCommand tiltott
                                ; xxxxxxxxxxx1xxxx : GetComand tiltott
MouseType         DW   1          ; EgÇr t°pusk¢d
KeyType           DW   2          ; Billenty˚zet t°pusk¢d
TimerType         DW   3          ; Megszak°t†s t°pusk¢d
MouseEventOfs     DW   Offset _MouseIntEvent ; EgÇr esemÇnyvezÇrlã offset
MouseEventSeg     DW   Seg    _MouseIntEvent ; EgÇr esemÇnyvezÇrlã szegmens
MouseINTAct       DW   0          ; EgÇrkezelÇs be/ki (0:ki 1:be)
MouseDIVX         DB   0          ; EgÇr oszt†sar†ny (eltol†s)
MouseDIVY         DB   0          ; EgÇr oszt†sar†ny (eltol†s)
TimeCounter       DW   0          ; Idîz°tã sz†ml†l¢


;*****************************************************************************
;***                                                                       ***
;***       Command elhelyezÇse a CommandPuffer-ban (PUBLIC elj†r†s)        ***
;***                                                                       ***
;***             Be: CX= Command k¢d                                       ***
;***                 SI: Command t°pus                                     ***
;***                 DX= 0: Puffer vÇgÇre                                  ***
;***                     1: Puffer eljÇre                                  ***
;***                 AX= ParamÇter_1                                       ***
;***                 BX= ParamÇter_2                                       ***
;***             Ki: AX= Hibak¢d                                           ***
;***                     0: OK                                             ***
;***                     1: Puffer megtelt                                 ***
;***                     2: PutCommand tiltott                             ***
;***                                                                       ***
;*****************************************************************************

_Put_Command_To_Puffer PROC FAR ; Command elhelyezese a CommandPufferban

              MOV     Param1,AX                ; ParamÇter 1 elmentÇse
              MOV     Param2,BX                ; ParamÇter 2 elmentÇse
              MOV     BX,word ptr TProcFlag    ; BX= TProc jelzãbitek
              AND     BX,1                     ; Ha nem tiltott a PutCommand
              JZ      OK1_PCTP                 ; akkor tov†bb
              MOV     AX,2                     ; Hibak¢d=2
              JMP     Exit_PCTP                ; Ugr†s kilÇpÇsre
Ok1_PCTP:     MOV     BX,word ptr ComPuffNum   ; BX= Commandok sz†ma a pufferban
              CMP     BX,word ptr MaxCommand   ; Ha a puffer nem betelt
              JNZ     Ok2_PCTP                 ; akkor tov†bb
              MOV     AX,1                     ; Hibak¢d=1
              JMP     Exit_PCTP                ; Ugr†s kilÇpÇsre
Ok2_PCTP:     PUSH    SI                       ; SI megãrzÇse
              PUSH    CX                       ; CX megãrzÇse
              PUSH    DX                       ; DX megãrzÇse
              MOV     AX,Seg Command_Puffer    ; ES:DI a CommandPufferra mutat
              MOV     ES,AX
              MOV     DI,Offset Command_Puffer
              MOV     AX,word ptr CommandSize  ; AX= Command rekordhossz
              MUL     BX                       ; CommandPuffer c°msz†m°t†s
              ADD     DI,AX                    ; ES:DI a pufferhelyre mutat
              POP     DX                       ; DX helyre†ll°t†sa
              CMP     DX,0                     ; Ha Dx=0
              JZ      Put_PCTP                 ; Akkor a puffer sorba
              MOV     SI,DI                    ; SI=DI
              ADD     DI,word ptr CommandSize  ; DI=DI+1 Command hossz
              MOV     CX,AX                    ; CX+1 byteot mozgatunk
              INC     CX
              STD                              ; Csîkkentve DI,SI-t
              REP     SegES MOVSB              ; Mozgat†s
              MOV     DI,Offset Command_Puffer
Put_PCTP:     POP     CX
              POP     SI
              MOV     ES:[DI],SI               ; Command t°pusa
              MOV     ES:[DI+2],CX             ; Command utas°t†sk¢d
              MOV     CX,word ptr Mouse_X
              MOV     ES:[DI+4],CX             ; Mouse X koordin†ta
              MOV     CX,word ptr Mouse_Y
              MOV     ES:[DI+6],CX             ; Mouse Y koordin†ta
              MOV     CX,word ptr Mouse_Button
              MOV     ES:[DI+8],CX             ; Mouse gomb
              MOV     CX,Param1                ; ParamÇret 1
              MOV     ES:[DI+10],CX
              MOV     CX,Param2                ; ParamÇret 2
              MOV     ES:[DI+12],CX
              MOV     CX,word ptr Key_Code
              MOV     ES:[DI+14],CX            ; Billenty˚ k¢d
              MOV     SI,offset Key_Table      ; Billenty˚ t†bla
              ADD     DI,16
              MOV     CX,16
              CLD
              REP     SegES MOVSB
              INC     word ptr ComPuffNum      ; Puffermutat¢ nîvelÇse
              XOR     AX,AX
Exit_PCTP:    RET
_Put_Command_To_Puffer ENDP


;*****************************************************************************
;***                                                                       ***
;***    Command kivÇtele a CommandPuffer-b¢l ( PUBLIC elj†r†s)             ***
;***                                                                       ***
;***            Be: ES:DI Command elhelyezÇsi c°me                         ***
;***                AX= 0:Kiveszi                                          ***
;***                    1:M†solja                                          ***
;***            Ki: AX= Hibak¢d                                            ***
;***                    0:OK                                               ***
;***                    1:Nincs command a pufferban                        ***
;***                    2:GetCommand tiltott
;***                BX=Commandok sz†ma a CommandPuffer-ban                 ***
;***                                                                       ***
;*****************************************************************************

_Get_Command_From_Puffer PROC FAR ; Command kivÇtele a pufferbîl

              CLI                             ; Megszak°t†s tiltott
              MOV     BX,word ptr TProcFlag   ; BX= TProc jelzãbitek
              AND     BX,16                   ; Ha nem tiltott a GetCommand
              JZ      OK1_GCFP                ; akkor tov†bb
              MOV     AX,2                    ; Hibak¢d=2
              JMP     Exit_GCFP               ; Ugr†s kilÇpÇsre
OK1_GCFP:     MOV     BX,word ptr ComPuffNum
              CMP     BX,0                    ; Ha van command a pufferba
              JNZ     OK_GCFP                 ; akkor ugr†s
              XOR     AX,AX                   ; egyÇbkÇnt
              MOV     ES:[DI],AX              ; Command t°pus = 0
              MOV     ES:[DI+2],AX            ; Command k¢d = 0
              MOV     AX,0001h                ; VisszatÇrÇsi k¢d = 1
              JMP     Exit_GCFP               ; Ugr†s kilÇpÇsre
OK_GCFP:      PUSH    DS                      ; Adatszegmens megãrzÇse
              PUSH    AX                      ; AX megãrzÇse
              MOV     AX,Seg Command_Puffer
              MOV     DS,AX
              MOV     SI,Offset Command_Puffer ; DS:SI a CommandPufferre mutat
              MOV     CX,word ptr CommandSize  ; CX a Command rekordhossza
              CLD
              REP     MOVSB                    ; M†sol†s az ES:DI c°mre
              POP     AX                       ; AX vissza†ll°t†sa
              CMP     AX,0                     ; Ha AX<>0 akkor nem veszi ki
              JNZ     NoGet_GCFP               ; a Command-ot a pufferbãl
              MOV     AX,Seg Command_Puffer
              MOV     ES,AX
              MOV     SI,Offset Command_Puffer ; ES:SI CommandPuffere mutat
              MOV     DI,SI
              MOV     AX,word ptr CommandSize  ; AX a COmmand rekordhossza
              ADD     SI,AX                    ; ES:SI a kîvetkezã commandra
              MUL     BX                       ;
              MOV     CX,AX                    ; CX= m†soland¢ byteok sz†ma
              CLD
              REP     SegES MOVSB              ; Puffer m†sol†sa
              DEC     word ptr ComPuffNum      ; Puffersz†ml†l¢ csîkkentÇse
NoGet_GCFP:   POP     DS                       ; Eredeti adatszegmens
              XOR     AX,AX                    ; VisszatÇrÇsi k¢d = 0 (OK)
Exit_GCFP:    STI                              ; Megszak°t†sok engedÇlyezÇse
              RET
_Get_Command_From_Puffer ENDP

;*****************************************************************************
;***                                                                       ***
;***          KeyTable bit be°r†s/tîrlÇs   (belsã elj†r†s)                 ***
;***                                                                       ***
;***                   Be: BX=Bitsz†m (0..127)                             ***
;***                   Ki: -                                               ***
;***                                                                       ***
;*****************************************************************************

_SetBit PROC NEAR
              DEC     BX
              MOV     CX,BX
              SHR     BX,3
              AND     CX,7
              MOV     AL,80h
              SHR     AL,CL
              OR      [Offset Key_Table+BX],AL
              RET
_SetBit ENDP

_ClearBit PROC NEAR
              DEC     BX
              MOV     CX,BX
              SHR     BX,3
              AND     CX,7
              MOV     AL,80h
              SHR     AL,CL
              NOT     AL
              AND     [Offset Key_Table+BX],AL
              RET
_ClearBit ENDP

;*****************************************************************************
;***                                                                       ***
;***     Èj billenty˚zet megszak°t†s kezelã (belsã INT elj†r†s)            ***
;***                                                                       ***
;*****************************************************************************

_New_IRQ9 PROC FAR                           ; Billenty˚ megszak°t†s program
              CLI                            ; Megszak°t†sok tilt†sa
              PUSH    DS                     ; Regiszterek mentÇse
              PUSH    ES
              PUSHA
              PUSHF
              MOV     AX,SEG Key_Code
              MOV     DS,AX                  ; DS= Key_Code szegmense
              IN      AL,60H                 ; Billenty˚ port olvas†sa AL-be
              MOV     BL,AL                  ; BL=AL
              XOR     BH,BH                  ; Lenyom†s/FelengedÇs
              AND     BL,7Fh                 ; bit kimaszkol†sa
              MOV     word ptr Key_Code,BX   ; Key_Code = Bill. scan k¢d
              SHL     AL,1                   ; Le/Fel bit Carry-be
              JC      CB                     ; Ugr†s ha felengedÇs
              CALL    _SetBit                ; KeyTable bit be°r†s
              MOV     CX,0001h               ; Key_Push k¢d
              JMP     T1                     ; Ugr†s tov†bb
CB:           CALL    _ClearBit              ; KeyTable bit tîrlÇs
              MOV     CX,0002h               ; Key_Pop k¢d
T1:           MOV     BX,word ptr TProcFlag  ; BX= TProc jelzãbitek
              AND     BX,4                   ; Ha tiltott
              JNZ     T2                     ; akkor nincs PutCommand
              MOV     SI,word ptr KeyType    ; SI= Key command t°pusk¢d
              MOV     DX,0000h               ; Puffer vÇgÇre helyezve
              MOV     AX,0                   ; ParamÇter1=0
              MOV     BX,0                   ; ParamÇter2=0
              CALL    _Put_Command_To_Puffer ; Command elhelyezÇse
T2:           IN      AL,61h                 ; Billenty˚ port nyugt†z†s
              MOV     AH,AL
              OR      AL,80h
              OUT     61h,AL
              MOV     AL,AH
              NOP
              NOP
              NOP
              OUT     61h,AL
              CLI
              MOV     AL,20h
              OUT     20h,AL
              POPF
              POPA
              POP      ES
              POP      DS
              STI
              IRET
_New_IRQ9 ENDP

;*****************************************************************************
;***                                                                       ***
;***       Mouse megszak°t†s kiv†lt¢ k¢d meg†llap°t†s (belsã elj†r†s)      ***
;***                                                                       ***
;***       Ki:  AX bitjei                                                  ***
;***                 0: EgÇr X ir†ny£ mozg†s                               ***
;***                 1: EgÇr Y ir†ny£ mozg†s                               ***
;***                 2: EgÇrgombot (valamelyiket) lenyomt†k                ***
;***                 3: Bal oldali egÇrgomb lenyom†sa                      ***
;***                 4: Bal oldali egÇrgomb felengedÇse                    ***
;***                 5: Jobb oldali egÇrgomb lenyom†sa                     ***
;***                 6: Jobb oldali egÇrgomb felengedÇse                   ***
;***                 7: KîzÇpsã gomb lenyom†sa                             ***
;***                 8: KîzÇpsã gomb felengedÇse                           ***
;***                                                                       ***
;*****************************************************************************

_MouseIntReason PROC FAR
              XOR     AX,AX                  ; AX=0
              CMP     CX,word ptr OldMouse_X ; X ir†ny£ elmozdul†s tîrtÇnt?
              JZ      NoXMove_MIR            ; Ha nem akkor tov†bb
              MOV     word ptr OldMouse_X,CX ; OldMouseX=MouseX
              OR      AX,1                   ; AX=xxxxxxxxxxxxxxx1
NoXMove_MIR:  CMP     DX,word ptr OldMouse_Y ; Y ir†ny£ elmozdul†s tîrtÇnt?
              JZ      NoYMove_MIR            ; Ha nem akkor tov†bb
              MOV     word ptr OldMouse_Y,DX ; OldMouseY=MouseY
              OR      AX,2                   ; AX=xxxxxxxxxxxxxx1x
NoYMove_MIR:  CMP     BX,word ptr OldMouse_Button ; EgÇrgombot nyomt†k le?
              JZ      NoButton_MIR           ; Ha nem akkor tov†bb
              OR      AX,4                   ; AX=xxxxxxxxxxxxx1xx
              MOV     CX,BX
              XOR     CX,word ptr OldMouse_Button ; V†ltoz†s
              AND     CX,1                   ; a bal egÇrgombn†l ?
              JZ      NoLB_MIR               ; ha nem ugr†s
              AND     CX,BX                  ; Maszkol†s
              CMP     CX,1                   ; Lenyom†s tîrtÇnt?
              JNZ     NoLBPush_MIR           ; Nem akkor ugr†s
              OR      AX,8                   ; AX=xxxxxxxxxxxx1xxx
              JMP     NoLB_MIR
NoLBPush_MIR: OR      AX,16                  ; AX=xxxxxxxxxxx1xxxx
NoLB_MIR:     MOV     CX,BX
              XOR     CX,word ptr OldMouse_Button ; V†ltoz†s
              AND     CX,2                   ; a jobb egÇrgombn†l ?
              JZ      NoRB_MIR
              AND     CX,BX                  ; Maszkol†s
              CMP     CX,2                   ; Lenyom†s tîrtÇnt?
              JNZ     NoRBPush_MIR           ; Nem akkor ugr†s
              OR      AX,32                  ; AX=xxxxxxxxxx1xxxxx
              JMP     NoRB_MIR
NoRBPush_MIR: OR      AX,64                  ; AX=xxxxxxxxx1xxxxxx
NoRB_MIR:     MOV     CX,BX
              XOR     CX,word ptr OldMouse_Button ; V†ltoz†s
              AND     CX,4                   ; a kîzÇpsã egÇrgombn†l ?
              JZ      NoMB_MIR
              AND     CX,BX                  ; Maszkol†s
              CMP     CX,2                   ; Lenyom†s tîrtÇnt?
              JZ      NoMBPush_MIR           ; Igen akkor ugr†s
              OR      AX,128                 ; AX=xxxxxxxx1xxxxxxx
              JMP     NoMB_MIR               ; ugr†s tov†bb
NoMBPush_MIR: OR      AX,256                 ; AX=xxxxxxx1xxxxxxxx
NoMB_MIR:
              MOV     word ptr OldMouse_Button,BX ;OldMouseButton=MouseButton

NoButton_MIR:
              RET
_MouseIntReason ENDP

;*****************************************************************************
;***                                                                       ***
;***            Mouse megszak°t†s kezelã (belsã INT elj†r†s)               ***
;***                                                                       ***
;*****************************************************************************

_MouseInt PROC FAR                           ; Mouse megszak°t†s program
              CLI
              PUSH    DS
              PUSH    ES
              PUSHA
              PUSHF
              PUSH    CX
              PUSH    DX
              MOV     AX,CX
              MOV     CL,byte ptr MouseDIVX
              SHR     AX,CL
              MOV     CL,byte ptr MouseDIVY
              SHR     DX,CL
              MOV     word ptr Mouse_X,AX
              MOV     word ptr Mouse_Y,DX
              MOV     word ptr Mouse_Button,BX
              MOV     AX,word ptr OldMouse_X
              MOV     CL,byte ptr MouseDIVX
              SHR     AX,CL
              MOV     word ptr Param1,AX
              MOV     AX,word ptr OldMouse_Y
              MOV     CL,byte ptr MouseDIVY
              SHR     AX,CL
              MOV     word ptr Param2,AX
              POP     DX
              POP     CX
              CALL    _MouseIntReason        ; Megszak°t†s oka
              MOV     BX,word ptr TProcFlag  ; BX= TProc jelzãbitek
              AND     BX,2                   ; Ha tiltott
              JNZ     Exit_MI                ; akkor nincs PutCommand
              PUSH    AX
              MOV     CX,AX                  ; Mouse command k¢d
              MOV     SI,word ptr MouseType  ; SI= Mouse Command t°pusk¢d
              MOV     DX,0000h               ; Puffer vÇgÇr helyezve
              MOV     AX,word ptr Param1     ; ParamÇter1=OldMouse_X
              MOV     BX,word ptr Param2     ; ParamÇter2=OldMouse_Y
              CALL    _Put_Command_To_Puffer ; Command elhelyezÇse
              POP     AX
Exit_MI:      MOV     SI,word ptr Param1     ; SI=ParamÇter1=OldMouse_X
              MOV     DI,word ptr Param2     ; DI=ParamÇter2=OldMouse_Y
              MOV     CX,word ptr Mouse_X    ; CX=Mouse X
              MOV     DX,word ptr Mouse_Y    ; DX=Mouse Y
              CALL    dword ptr [MouseEventOfs] ; EsemÇnykezelã h°v†sa
              POPF
              POPA
              POP     ES
              POP     DS
Exit2_MI:     STI
Exit3_MI:     RET
_MouseInt ENDP

;*****************************************************************************
;***                                                                       ***
;***            Mouse kÅlsã megszak°t†s kezelã be†ll°t†s                   ***
;***            Be:  ES=Mouse esemÇnyvezÇrlã szegmensc°me                  ***
;***                 DI=Mouse esemÇnyvezÇrlã offszetc°me                   ***
;***                                                                       ***
;*****************************************************************************

_SetMouseEvent PROC FAR
              CLI
              MOV     word ptr MouseEventSeg,ES
              MOV     word ptr MouseEventOfs,DI
              STI
              RET
_SetMouseEvent ENDP

;*****************************************************************************
;***                                                                       ***
;***      Mouse kÅlsã megszak°t†s kezelã alapbe†ll°t†s (belsã elj†r†s)     ***
;***             Be: CX=Mouse X koordni†ta                                 ***
;***                 DX=Mouse Y koordni†ta                                 ***
;***                 SI=Mouse rÇgi X koordin†ta                            ***
;***                 DI=Mouse rÇgi Y koordin†ta                            ***
;***                 AX=Mouse megszak°t†s oka                              ***
;*****************************************************************************

_MouseINTEvent PROC FAR
              RET
_MouseINTEvent ENDP

;*****************************************************************************
;***                                                                       ***
;***            Timer megszak°t†s kezelã (belsã INT elj†r†s)               ***
;***                                                                       ***
;*****************************************************************************

_TimerInt PROC FAR                           ; Timer megszak°t†s program
              CLI
              PUSH    DS                     ; Regiszterek mentÇse
              PUSH    ES
              PUSHA
              PUSHF
              INC     word ptr TimeCounter   ; Idîz°tã nîvelÇse
              MOV     AX,Seg Timer           ; ES:DI idîz°tã adatai
              MOV     ES,AX
              MOV     DI,Offset Timer
              MOV     BX,10                  ; 10 idîz°tã lehetsÇges
Loop_1:       MOV     AX,ES:[DI]             ; Elsã adat a Time
              CMP     AX,0                   ; Ha 0 akkor
              JZ      Next_TI                ; vedd a kîvetkezã idîz°tãt
              INC     word ptr ES:[DI+2]     ; Nîveld az idîz°tãt
              CMP     word ptr ES:[DI+2],AX  ; Egyenlã a Time ÇrtÇkÇvel?
              JNZ     Next_TI                ; Ha nem -> kîvetkezã idîz°tã
              MOV     word ptr ES:[DI+2],0   ; Idîz°tã = 0
              MOV     SI,word ptr TimerType  ; SI= TimerType
              MOV     CX,ES:[DI+4]           ; CX= Command k¢d
              MOV     DX,ES:[DI+6]           ; Puffer vÇgÇre helyezve
              MOV     AX,ES:[DI+8]           ; ParamÇter1
              PUSH    BX
              PUSH    ES
              PUSH    DI
              MOV     BX,word ptr TProcFlag  ; BX= TProc jelzãbitek
              AND     BX,8                   ; Ha tiltott
              JNZ     No_PutT                ; akkor nincs PutCommand
              MOV     BX,ES:[DI+10]          ; ParamÇter2
              CALL    _Put_Command_To_Puffer ; Command elhelyezÇse
No_PutT:      POP     DI
              POP     ES
              POP     BX
Next_TI:      ADD     DI,word ptr TimerSize  ; DI=DI+Timer rekordhossz
              DEC     BX                     ; BX csîkkentÇse
              JNZ     Loop_1                 ; Ha van mÇg idîz°tã -> Vissza
              POPF
              POPA
              POP      ES
              POP      DS
              STI
              IRET
_TimerInt ENDP

;*****************************************************************************
;***                                                                       ***
;***                Timer INT be†ll°t†s  (PUBLIC elj†r†s)                  ***
;***                                                                       ***
;***             Be: BX=Timer sz†m                                         ***
;***                 CX=Time                                               ***
;***                 SI=Command K¢d                                        ***
;***                 AX=ParamÇter1                                         ***
;***                 DI=ParamÇter2                                         ***
;***                 DX= Prior°t†s                                         ***
;***                     0:Puffer vÇgÇre                                   ***
;***                     1:Puffer elejÇre                                  ***
;***             Ki: -                                                     ***
;***                                                                       ***
;*****************************************************************************

_SetTimer PROC FAR                           ; Timer be†ll°t†s
              CLI
              PUSH    DX
              MOV     Param1,AX
              MOV     Param2,DI
              CMP     BX,word ptr MaxTimer
              JAE     Exit_ST
              MOV     AX,Seg Timer
              MOV     ES,AX
              MOV     DI,Offset Timer
              MOV     AX,word ptr TimerSize
              MUL     BX
              ADD     DI,AX
              POP     DX
              MOV     word ptr ES:[DI],CX     ; [0] = Time
              MOV     word ptr ES:[DI+2],0    ; [1] = ActTime=0
              MOV     word ptr ES:[DI+4],SI   ; [2] = Command k¢d
              MOV     word ptr ES:[DI+6],DX   ; [3] = Prior°t†s
              MOV     AX,Param1
              MOV     word ptr ES:[DI+8],AX   ; [4] = ParamÇter1
              MOV     AX,Param2
              MOV     word ptr ES:[DI+10],AX   ; [5] = ParamÇter2
Exit_ST:      STI
              RET
_SetTimer ENDP

;*****************************************************************************
;***                                                                       ***
;***               Command Puffer tîrlÇse  (PUBLIC elj†r†s)                ***
;***                                                                       ***
;***               Be: -                                                   ***
;***               Ki: -                                                   ***
;***                                                                       ***
;*****************************************************************************

_ClearCommandPuffer PROC FAR
              MOV     AX,Seg Command_Puffer
              MOV     ES,AX
              MOV     DI,Offset Command_Puffer
              MOV     AX, word ptr CommandSize
              MOV     BX, word ptr MaxCommand
              MUL     BX
              MOV     CX,AX
              XOR     AX,AX
              MOV     word ptr ComPuffNum,AX
              CLD
              REP     STOSB

              MOV     AX,Seg Key_Table
              MOV     ES,AX
              MOV     DI,Offset Key_Table
              MOV     CX,16
              XOR     AX,AX
              CLD
              REP     STOSB
	      RET
_ClearCommandPuffer ENDP


;*****************************************************************************
;***                                                                       ***
;***                TProc bekapcsol†sa  (PUBLIC elj†r†s)                   ***
;***                                                                       ***
;***                   Be: AL    MouseDIVX                                 ***
;***                       AH    MouseDIVY                                 ***
;***                   Ki: ES:DI CommandPuffer c°me                        ***
;***                                                                       ***
;*****************************************************************************

_TProcOn	PROC FAR                     ; TProc bekapcsol†sa
              CLI
              MOV     MouseDivX,AL
              MOV     MouseDivY,AH
              MOV     AX,0003h
              INT     33h
              MOV     word ptr OldMouse_X,CX
              MOV     word ptr OldMouse_Y,DX
              CALL    _ClearCommandPuffer    ; CommandPuffer null†z†sa
              XOR     AX,AX                  ; TProcFlag=0
              MOV     word ptr TProcFlag,AX
              PUSH    DS
              MOV     AX,3509h               ; INT 9 vektor lekÇrdezÇs
              INT     21h
              MOV     AX,Seg Old_IRQ9
              MOV     DS,AX
              MOV     word ptr Old_IRQ9,BX
              MOV     word ptr Old_IRQ9+2,ES
              MOV     AX,351Ch               ; INT 1C vektor lekÇrdezÇs
              INT     21h
              MOV     AX,Seg Old_INT1C
              MOV     DS,AX
              MOV     word ptr Old_INT1C,BX
              MOV     word ptr Old_INT1C+2,ES
              MOV     AX,Seg _New_IRQ9       ; Uj INT9 be†ll°t†sa
              MOV     DS,AX
              MOV     DX,Offset _New_IRQ9
              MOV     AX,2509h
              INT     21h                    ; Uj bill. megszak°t†s vektor
              MOV     AX,Seg _TimerInt       ; Uj INT1C be†ll°t†sa
              MOV     DS,AX
              MOV     DX,Offset _TimerInt
              MOV     AX,251Ch
              INT     21h                    ; Uj timer megszak°t†s vektor
              MOV     CX,127                 ; Mouse Int be†ll°t†s
              MOV     AX,Seg _MouseInt
              MOV     ES,AX
              MOV     DX,Offset _MouseInt
              MOV     AX,12
              INT     33h
              POP     DS
              MOV     AX,Seg Command_Puffer
              MOV     ES,AX
              MOV     DI,Offset Command_Puffer
              STI
	      RET
_TProcOn	ENDP

;*****************************************************************************
;***                                                                       ***
;***               TProc kikapcsol†sa   (PUBLIC elj†r†s)                   ***
;***                                                                       ***
;***                   Be: -                                               ***
;***                   Ki: -                                               ***
;***                                                                       ***
;*****************************************************************************

_TProcOff PROC FAR                           ; TProc kikapcsol†sa
              PUSH    DS
              MOV     AX,Seg Old_IRQ9        ; RÇgi INT9 vissza†ll°t†sa
              MOV     DS,AX
              MOV     DX,word ptr Old_IRQ9
              MOV     AX,word ptr Old_IRQ9+2
              MOV     DS,AX
              MOV     AX,2509h
              INT     21h
              MOV     AX,Seg Old_INT1C        ; RÇgi INT1C vissza†ll°t†sa
              MOV     DS,AX
              MOV     DX,word ptr Old_INT1C
              MOV     AX,word ptr Old_INT1C+2
              MOV     DS,AX
              MOV     AX,251Ch
              INT     21h
              MOV     CX,0                   ;  Mouse Int kikapcsol†s
              MOV     AX,Seg _MouseInt
              MOV     ES,AX
              MOV     DX,Offset _MouseInt
              MOV     AX,12
              INT     33h
              POP     DS
              CALL    _ClearCommandPuffer
	      RET
_TProcOff ENDP



;*****************************************************************************
;***                                                                       ***
;***               Info lekerdezÇs  (PUBLIC elj†r†s)                       ***
;***                                                                       ***
;***               Be: -                                                   ***
;***               Ki: ES:SI = CommandPuffer -re mutat                     ***
;***                   ES:DI = _MouseInt mutat                             ***
;***                   ES:DX = Key_Table -ra mutat                         ***
;***                      BX = Commandok sz†ma a CommandPuffer-ban         ***
;***                      CX = TProcFlag                                   ***
;***                      AX = BillentyÅ k¢d                               ***
;***                                                                       ***
;*****************************************************************************

_GetTProcInfo PROC FAR
              MOV     AX,CS
              MOV     ES,AX
              MOV     SI,Offset Command_Puffer
              MOV     DI,Offset _MouseInt
              MOV     BX, word ptr ComPuffNum
              MOV     AX, word ptr Key_Code
              MOV     CX, word ptr TProcFlag
              MOV     DX,Offset Key_Table
	      RET
_GetTProcInfo ENDP

;*****************************************************************************
;***                                                                       ***
;***               TProcFlag be†ll°t†s  (PUBLIC elj†r†s)                   ***
;***                                                                       ***
;***               Be: DX   = TProcFlag                                    ***
;***               Ki: -                                                   ***
;*****************************************************************************

_SetTProcFlag PROC FAR
              MOV     word ptr TProcFlag,DX
	      RET
_SetTProcFlag ENDP

;*****************************************************************************
;***                                                                       ***
;***              TimeCounter be†ll°t†s  (PUBLIC elj†r†s)                   ***
;***                                                                       ***
;***               Be: DX   = Counter ÇrtÇke (†ltal†ban nulla)             ***
;***               Ki: -                                                   ***
;*****************************************************************************

_SetTimeCounter PROC FAR
              MOV     word ptr TimeCounter,DX
	      RET
_SetTimeCounter ENDP

;*****************************************************************************
;***                                                                       ***
;***              TimeCounter lekÇrdezÇs (PUBLIC elj†r†s)                  ***
;***                                                                       ***
;***               Be: -                                                   ***
;***               Ki: AX= TimeCounter ÇrtÇke                              ***
;*****************************************************************************

_GetTimeCounter PROC FAR
              MOV     AX,word ptr TimeCounter
	      RET
_GetTimeCounter ENDP

;*****************************************************************************
;*****************************************************************************
;*****************************************************************************

END