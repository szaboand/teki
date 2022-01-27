;*****************************************************************************
;***                                                                       ***
;***             (C) Szab¢ Andr†s 1996 Budapest-Hungary                    ***
;***                                                                       ***
;***                256 Color Assembly Routines V1.8                       ***
;***                                                                       ***
;*****************************************************************************

;****************** Utols¢ m¢dos°t†s: 1998.04.18. ****************************

;*****************************************************************************
;***                                                                       ***
;***                     Turbo Assembler deklar†ci¢k                       ***
;***                                                                       ***
;*****************************************************************************

	.MODEL SMALL
	.CODE
        .286                    ; 286-os k¢dok

;*****************************************************************************
;***                                                                       ***
;***                     KÅlsã elj†r†sok export†l†sa                       ***
;***                                                                       ***
;*****************************************************************************


                PUBLIC  _Select_Page_256
                PUBLIC  _SetMode_256
                PUBLIC  _GetMode_256
                PUBLIC  _ClearScreen_256
                PUBLIC  _WritePixel_256
                PUBLIC  _GetPixel_256
                PUBLIC  _Line_256
                PUBLIC  _SolidRect_256
                PUBLIC  _CopyBlock_256
                PUBLIC  _CopyFromMem_256
                PUBLIC  _CopyToMem_256
                PUBLIC  _OutTextXY_256
                PUBLIC  _SetChars_256
                PUBLIC  _GetActPage_256


;*****************************************************************************
;***                                                                       ***
;***                  Assembler v†ltoz¢k deklar†ci¢ja                      ***
;***                                                                       ***
;*****************************************************************************

ActPage                 DB      00          ; Aktu†lis page
PageFuncOff             DW  Offset SP_Exit  ; Lapoz¢ fÅggvÇny offszetc°m
PageFuncSeg             DW  Seg    SP_Exit  ; Lapoz¢ fÅggvÇny szegmensc°m

Graf_Seg                DW      0A000h      ; Videomem¢ria szegmensc°me
Video_Pitch             DW      ?           ; VideoMod logikai szÇlessÇge
Video_Pages             DW      ?           ; Video lapok sz†ma

Arg_X0                  DW      ?           ; Line/SolidRectangle v†ltoz¢
Arg_Y0                  DW      ?           ; Line/SolidRectangle v†ltoz¢
Arg_X1                  DW      ?           ; Line/SolidRectangle v†ltoz¢
Arg_Y1                  DW      ?           ; Line/SolidRectangle v†ltoz¢
Arg_Color               DB      ?           ; Line/SolidRectangle v†ltoz¢
Delta_X                 DW      ?           ; Line v†ltoz¢
D1                      DW      ?           ; Line v†ltoz¢
D2                      DW      ?           ; Line v†ltoz¢

Arg_DX                  DW      ?           ; CopyBlock v†ltoz¢
Arg_DY                  DW      ?           ; CopyBlock v†ltoz¢
Arg_Src_X               DW      ?           ; CopyBlock v†ltoz¢
Arg_Src_Y               DW      ?           ; CopyBlock v†ltoz¢
Arg_Dst_X               DW      ?           ; CopyBlock v†ltoz¢
Arg_Dst_Y               DW      ?           ; CopyBlock v†ltoz¢
Src_Page                DB      ?           ; CopyBlock v†ltoz¢
Dst_Page                DB      ?           ; CopyBlock v†ltoz¢
Pitch                   DW      ?           ; CopyBlock v†ltoz¢
Ras_Buffer	        DB 1024 DUP (0)	    ; CopyBlock TMP t†rol¢
C_Arg_DX                DW      ?           ; CopyMem v†ltoz¢
C_Arg_DY                DW      ?           ; CopyMem v†ltoz¢
C_Pitch                 DW      ?           ; CopyMem v†ltoz¢
C_PageNo                DB      ?           ; CopyMem v†ltoz¢

CharY                   DW      ?           ; Karakter magass†ga pixelben
CharX                   DW      ?           ; Karakter szÇlesssÇge pixelben
CharXbyte               DW      ?           ; Karakter szÇlessÇge byteban
CharByte                DW      ?           ; Karaktert le°r¢ byteok sz†ma
CharGenSeg              DW      ?           ; Karakter gener†tor szegmensc°me
CharGenOfs              DW      ?           ; Karakter gener†tor ofsetc°me

Over                    DB      ?           ; OutTextXY FelÅl°r†s jelzãje
TextColor               DB      ?           ; OutTextXY Text szin
TextBackColor           DB      ?           ; OutTextXY Text h†ttÇr szin
TextSeg                 DW      ?           ; OutTextXY Text szegmensc°me
TextOfs                 DW      ?           ; OutTextXY Text offsetc°me
StartOfs                DW      ?           ; OutTextXY Text video kezdãc°me
StartPage               DB      ?           ; OutTextXY Text page kezdãÇrtÇke
TextLine                DW      ?           ; OutTextXY Sorsz†ml†l¢
TextRow                 DW      ?           ; OutTextXY SzÇlessÇg sz†ml†l¢
PageNo                  DB      ?           ; OutTextXY Page mutat¢


;*****************************************************************************
;***                                                                       ***
;***                      Assembler elj†r†sok                              ***
;***                                                                       ***
;*****************************************************************************


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _Select_Page                                                 *
;* T°pus  :     KÅlsã/Belsã elj†r†s                                          *
;* Le°r†s :     DL-ben megadott lapot †ll°tja be                             *
;* Bemenet:     DL = Page                                                    *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_Select_Page_256    PROC FAR

               CMP      DL,ActPage
               JZ       SP_Exit
               MOV      ActPage,DL
               CALL     dword ptr [PageFuncOff] ; Lapoz¢ fÅggvÇny h°v†sa
SP_Exit:
               RET

_Select_Page_256 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _SetMode_256                                                 *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     A 256 sz°n˚ m¢d adatait †ll°tja be                           *
;* Bemenet:     DX: Video_Pich , ES:DI= Lapoz¢ fÅggvÇny c°me                 *
;*              CX: Video lapok sz†ma                                        *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_SetMode_256 PROC FAR

               MOV      Video_Pitch,DX          ; Logikai szÇlessÇg=DX
               MOV      Video_Pages,CX          ; Video lapok sz†ma=CX
               MOV      PageFuncSeg,ES          ; Lapoz¢ fÅggvÇny szegmesc°me
               MOV      PageFuncOff,DI          ; Lapoz¢ fÅggvÇny offsetc°me
               XOR      DL,DL                   ; DL=0
               CALL     _Select_Page_256             ; Page †ll°t†s
               RET

_SetMode_256 ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _GetMode_256                                                 *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     A 256 sz°n˚ m¢d adatait kÇrdezi le                           *
;* Bemenet:     -                                                            *
;* Kimenet:     DX= Logikai szÇlessÇg, ES:DI= Karakter adatok mutat¢ja       *
;*              AL= ActPage                                                  *
;*                                                                           *
;*****************************************************************************

_GetMode_256 PROC FAR

               MOV      DX,Video_Pitch       ; DX=Logikai szÇlessÇg
               MOV      AX,Seg CharY
               MOV      ES,AX
               MOV      DI,Offset CharY      ; ES:DI Karakter adatok
               MOV      AL,ActPage           ; AL=Aktu†lis Page
               RET

_GetMode_256 ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _ClearScreen_256                                             *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     KÇpernyã tîrlÇse BL sz°nnel                                  *
;* Bemenet:     BL: Sz°n                                                     *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_ClearScreen_256   PROC FAR

        MOV     AH,BL                   ; AH=Sz°n
        MOV     AL,AH                   ; AH=Sz°n
        XOR     DX,DX                   ; DX=0 Page sz†ml†l¢
        MOV     ES,Graf_Seg             ; ES=Video szegmens c°m
Cls_Page_Loop:
        CALL    _Select_Page_256             ; Page v†laszt†s
        XOR     DI,DI                   ; Offset=0
        MOV     CX,8000h                ; Word-ok sz†ma
        REP     STOSW                   ; Page tîrlÇse AX sz°nnel
        INC     DX                      ; Kîvetkezã lap
        CMP     DX,Video_Pages          ; Mindegyik lap megvolt ?
        JL      Cls_Page_Loop           ; Ha nem ugr†s vissza
        RET

_ClearScreen_256   ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     WritePixel_256                                               *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     CX:DX pixel megjelen°tÇse BL sz°nben                         *
;* Bemenet:     CX: X koordin†ta , DX: Y koordin†ta , BL: Pixel szin         *
;* Kimenet:                                                                  *
;*                                                                           *
;*****************************************************************************


_WritePixel_256    PROC FAR

               MOV      AX,Video_Pitch          ; AX= Video szÇlessÇg
               MUL      DX                      ; AX= Sor offsetc°m
               ADD      AX,CX                   ; AX= Offsetc°m
               ADC      DX,0                    ; DX korrekci¢ja (ADD Carry)
               MOV      ES,Graf_Seg             ; ES= Video szegmens
               MOV      DI,AX                   ; ES:DI= c°m
               CALL     _Select_Page_256             ; Aktu†lis page †ll°t†sa
               MOV      ES:[DI],BL              ; SetPixel
               RET

_WritePixel_256    ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     GetPixel_256                                                 *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     CX:DX pixel lekÇrdezÇse AL-be                                *
;* Bemenet:     CX: X koordin†ta , DX: Y koordin†ta                          *
;* Kimenet:     AL: Pixel szin                                               *
;*                                                                           *
;*****************************************************************************


_GetPixel_256    PROC FAR

               MOV      AX,Video_Pitch          ; AX= Video szÇlessÇg
               MUL      DX                      ; AX= Sor offsetc°m
               ADD      AX,CX                   ; AX= Offsetc°m
               ADC      DX,0                    ; DX korrekci¢ja (ADD Carry)
               MOV      ES,Graf_Seg             ; ES= Video szegmens
               MOV      DI,AX                   ; ES:DI= c°m
               CALL     _Select_Page_256             ; Aktu†lis page †ll°t†sa
               MOV      AL,ES:[DI]              ; GetPixel
               RET

_GetPixel_256    ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _Line_256                                                    *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Vonalh£z¢ elj†r†s                                            *
;* Bemenet:     CX,DX= X1,Y1 koordin†ta  SI,DI= X2,Y2 koordin†ta             *
;*              BL= Sz°n                                                     *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_Line_256           PROC FAR
        PUSH    DS
        PUSH    ES
        MOV     Arg_Y0,DX
        MOV     Arg_X0,CX
        MOV     Arg_Y1,DI
        MOV     Arg_X1,SI
        MOV     Arg_Color,BL
        MOV     AX,Arg_y0
        MUL     Video_Pitch
        ADD     AX,Arg_x0
        ADC     DX,0
        PUSH    AX
        MOV     PageNo,DL
        CALL    _Select_Page_256
        MOV     DS,Graf_Seg
        MOV     AX,Video_Pitch
        MOV     Pitch,AX
        MOV     SI,Arg_x1
        SUB     SI,Arg_x0
        MOV     Delta_x,SI
        JGE     dxispos
        NEG     SI
dxispos:
        MOV     DI,Arg_y1
        SUB     DI,Arg_y0
        JGE     dyispos
        NEG     WORD PTR Pitch
        NEG     DI
dyispos:
        CMP     SI,DI
        JGE     NL_xmajor
        JMP     NL_ymajor
NL_JumpToDone:
        POP     DI
        JMP     NL_linedone
NL_xmajor:
        MOV     CX,SI
        INC     CX
        SAL     DI,1
        MOV     DX,DI
        SUB     DX,SI
        NEG     SI
        ADD     SI,DX
        MOV     d1,DI
        MOV     d2,SI
        POP     DI
        TEST    WORD PTR Pitch,8000h
        JZ      NL_yp
        NEG     WORD PTR Pitch
        TEST    WORD PTR Delta_x,8000h
        JNZ     NL_long_jump
        JMP     NL_xpyn
NL_long_jump:
        JMP     NL_xnyn
NL_yp:
        TEST    WORD PTR Delta_x,8000h
        JZ      NL_xpyp
        JMP     NL_xnyp
NL_xpyp:
        MOV     AL,Arg_Color
NL_next0:
        MOV     [DI],AL
        ADD     DI,1
        JC      NL_fix0
NL_page0:
        TEST    DX,8000h
        JNZ     NL_dneg0
        ADD     DX,d2
        ADD     DI,Pitch
        JC      NL_fix00
        LOOP    NL_next0
        JMP     NL_linedone
NL_dneg0:
        ADD     DX,d1
        LOOP    NL_next0
        JMP     NL_linedone
NL_fix0:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JMP     SHORT NL_page0
NL_fix00:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next0
        JMP     NL_linedone
NL_xnyp:
        MOV     AL,Arg_Color
NL_next3:
        MOV     [DI],AL
        SUB     DI,1
        JC      NL_fix3
NL_page3:
        TEST    DX,8000h
        JNZ     NL_dneg3
        ADD     DX,d2
        ADD     DI,Pitch
        JC      NL_fix33
        LOOP    NL_next3
        JMP     NL_linedone
NL_dneg3:
        ADD     DX,d1
        LOOP    NL_next3
        JMP     NL_linedone
NL_fix3:
        PUSH    DX
        XCHG    DL,PageNo
        DEC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JMP     SHORT NL_page3
NL_fix33:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next3
        JMP     NL_linedone
NL_xpyn:
        MOV     AL,Arg_Color
NL_next7:
        MOV     [DI],AL
        ADD     DI,1
        JC      NL_fix7
NL_page7:
        TEST    DX,8000h
        JNZ     NL_dneg7
        ADD     DX,d2
        SUB     DI,Pitch
        JC      NL_fix77
        LOOP    NL_next7
        JMP     NL_linedone
NL_dneg7:
        ADD     DX,d1
        LOOP    NL_next7
        JMP     NL_linedone
NL_fix7:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JMP     SHORT NL_page7
NL_fix77:
        PUSH    DX
        XCHG    DL,PageNo
        DEC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next7
        JMP     NL_linedone
NL_xnyn:
        MOV     AL,Arg_Color
NL_next4:
        MOV     [DI],AL
        SUB     DI,1
        JC      NL_fix4
NL_page4:
        TEST    DX,8000h
        JNZ     NL_dneg4
        ADD     DX,d2
        SUB     DI,Pitch
        JC      NL_fix44
        LOOP    NL_next4
        JMP     NL_linedone
NL_dneg4:
        ADD     DX,d1
        LOOP    NL_next4
        JMP     NL_linedone

NL_fix4:
        PUSH    DX
        XCHG    DL,PageNo               ; Preserve AL, and fetch page number
        DEC     DL                      ; Update page number
        CALL    _Select_Page_256             ; Select new page number
        XCHG    DL,PageNo               ; Save updated page, restore AL
        POP     DX
        JMP     SHORT NL_page4
NL_fix44:
        PUSH    DX
        XCHG    DL,PageNo
        DEC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next4
        JMP     NL_linedone
NL_JumpToDone1:
        POP     DI
        JMP     NL_linedone
NL_ymajor:
        MOV     CX,DI
        INC     CX
        SAL     SI,1
        MOV     DX,SI
        SUB     DX,DI
        NEG     DI
        ADD     DI,DX
        MOV     d2,DI
        MOV     d1,SI
        POP     DI
        TEST    WORD PTR Pitch,8000h
        JZ      NL_py
        NEG     WORD PTR Pitch
        TEST    WORD PTR Delta_x,8000h
        JNZ     NL_jump_long
        JMP     NL_pxny
NL_jump_long:
        JMP     NL_nxny
NL_py:
        TEST    WORD PTR Delta_x,8000h
        JZ      NL_pxpy
        JMP     NL_nxpy
NL_pxpy:
        MOV     AL,Arg_Color
NL_next1:
        MOV     [DI],AL
        ADD     DI,Pitch
        JC      NL_fix1
NL_page1:
        TEST    DX,8000h
        JNZ     NL_dneg1
        ADD     DX,d2
        ADD     DI,1
        JC      NL_fix11
        LOOP    NL_next1
        JMP     NL_linedone
NL_dneg1:
        ADD     DX,d1
        LOOP    NL_next1
        JMP     NL_linedone
NL_fix1:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JMP     SHORT NL_page1
NL_fix11:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next1
        JMP     NL_linedone
NL_nxpy:
        MOV     AL,Arg_Color
NL_next2:
        MOV     [DI],AL
        ADD     DI,Pitch
        JC      NL_fix2
NL_page2:
        TEST    DX,8000h
        JNZ     NL_dneg2
        ADD     DX,d2
        SUB     DI,1
        JC      NL_fix22
        LOOP    NL_next2
        JMP     NL_linedone
NL_dneg2:
        ADD     DX,d1
        LOOP    NL_next2
        JMP     NL_linedone
NL_fix2:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JMP     SHORT NL_page2
NL_fix22:
        PUSH    DX
        XCHG    DL,PageNo
        DEC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next2
        JMP     NL_linedone
NL_pxny:
        MOV     AL,Arg_Color
NL_next6:
        MOV     [DI],AL
        SUB     DI,Pitch
        JC      NL_fix6
NL_page6:
        TEST    DX,8000h
        JNZ     NL_dneg6
        ADD     DX,d2
        ADD     DI,1
        JC      NL_fix66
        LOOP    NL_next6
        JMP     NL_linedone
NL_dneg6:
        ADD     DX,d1
        LOOP    NL_next6
        JMP     NL_linedone
NL_fix6:
        PUSH    DX
        XCHG    DL,PageNo
        DEC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JMP     SHORT NL_page6
NL_fix66:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next6
        JMP     NL_linedone
NL_nxny:
        MOV     AL,Arg_Color
NL_next5:
        MOV     [DI],AL
        SUB     DI,Pitch
        JC      NL_fix5
NL_page5:
        TEST    DX,8000h
        JNZ     NL_dneg5
        ADD     DX,d2
        SUB     DI,1
        JC      NL_fix55
        LOOP    NL_next5
        JMP     NL_linedone
NL_dneg5:
        ADD     DX,d1
        LOOP    NL_next5
        JMP     NL_linedone
NL_fix5:
        PUSH    DX
        XCHG    DL,PageNo
        DEC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JMP     SHORT NL_page5
NL_fix55:
        PUSh    DX
        XCHG    DL,PageNo
        DEC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        LOOP    NL_next5
        JMP     NL_linedone
NL_linedone:
End_Line:
        POP     ES
        POP     DS
        RET

_Line_256           ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _SolidRect_256                                               *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Sz°nes tÇglalap rajzol†s                                     *
;* Bemenet:     CX,DX= X1,Y1 koordin†ta  SI,DI= X2,Y2 koordin†ta             *
;*              BL= Sz°n                                                     *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************


_SolidRect_256     PROC FAR
        PUSH    DS
        PUSH    ES
        MOV     Arg_Y0,DX
        MOV     Arg_X0,CX
        MOV     Arg_Y1,DI
        MOV     Arg_X1,SI
        MOV     Arg_Color,BL
        MOV     AX,Arg_X0
        MOV     BX,Arg_X1
        CMP     BX,AX
        JGE     X_In_Order
        MOV     Arg_X0,BX
        MOV     Arg_X1,AX
X_In_Order:
        MOV     AX,Arg_Y0
        MOV     BX,Arg_Y1
        CMP     BX,AX
        JGE     Y_In_Order
        MOV     Arg_Y0,BX
        MOV     Arg_Y1,AX
Y_In_Order:
        MOV     AX,Arg_y0
        MUL     Video_Pitch
        ADD     AX,Arg_x0
        ADC     DX,0
        MOV     DI,AX
        MOV     PageNo,DL
        CALL    _Select_Page_256
        MOV     ES,Graf_Seg
        MOV     CX,Arg_x1
        SUB     CX,Arg_x0
        INC     CX
        MOV     BX,Video_Pitch
        SUB     BX,CX
        MOV     Pitch,BX
        MOV     DX,Arg_y1
        SUB     DX,Arg_y0
        INC     DX
        MOV     AL,Arg_Color
        MOV     AH,AL
Scan_LoopRC:
        PUSH    CX
        MOV     BX,CX
        ADD     BX,DI
        JNC     Scan_In_PageRc
        SUB     CX,BX
        SHR     CX,1
        REP     STOSW
        ADC     CX,CX
        REP     STOSB
        MOV     CX,BX
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        JCXZ    Scan_DoneRC
Scan_In_PageRc:
        SHR     CX,1
        REP     STOSW
        ADC     CX,CX
        REP     STOSB
Scan_DoneRc:
        POP     CX
        ADD     DI,Pitch
        JC      Rect_Fix_Page
        DEC     DX
        JG      Scan_LoopRc
        JMP     SHORT End_Rect
Rect_Fix_Page:
        PUSH    DX
        XCHG    DL,PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,PageNo
        POP     DX
        DEC     DX
        JG      Scan_LoopRc
End_Rect:
        POP     ES                      ; Restore saved registers
        POP     DS
        RET
_SolidRect_256     ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _CopyBlock_256                                               *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     VideoMemoria-Videomem¢ria †tvitel                            *
;* Bemenet:     CX: X1 koordin†ta , DX: Y1 koordin†ta                        *
;*              SI: X2 koordin†ta , DI: Y2 koordin†ta                        *
;*              AX: SzÇlessÇg     , BX: Magass†g                             *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************


_CopyBlock_256 PROC    FAR

        MOV     Arg_Src_X,CX
        MOV     Arg_Src_Y,DX
        MOV     Arg_Dst_X,SI
        MOV     Arg_Dst_Y,DI
        MOV     Arg_DX,AX
        MOV     Arg_DY,BX
        PUSH    DS
        PUSH    ES
_BitBlt:
        MOV     AX,Arg_Dst_Y
        CMP     AX,Arg_Src_Y
        JL      BB_XPYP                 ; FelÅlrãl lefelÇ
        JE      Check_X
        JMP     BB_XPYN                 ; Letrãl felfelÇ
Check_X:
        MOV     AX,Arg_Dst_X
        CMP     AX,Arg_Src_X
        JLE     BB_XPYP
        JMP     BB_XNYP
BB_XPYP:                                ; Balr¢l-jobbra, fentrãl-lefelÇ
        MOV     AX,Arg_Src_Y            ; Kezdãc°m offset sz†m°t†s
        MUL     Video_Pitch
        ADD     AX,Arg_Src_X
        ADC     DX,0
        MOV     SI,AX                   ; SI=Kezdãc°m offset
        MOV     Src_Page,DL             ; Src_Page= Start Page
        CALL    _Select_Page_256             ; Page †ll°t†s
        MOV     DS,Graf_Seg             ; DS=Video szegmens
        MOV     AX,Video_Pitch
        SUB     AX,Arg_DX
        MOV     Pitch,AX
        MOV     AX,Arg_Dst_Y            ; VÇgc°m offset sz†m°t†s
        MUL     Video_Pitch
        ADD     AX,Arg_Dst_X
        ADC     DX,0
        MOV     DI,AX                   ; DI=VÇgc°m offset
        MOV     Dst_Page,DL             ; Dst_Page= End Page
        MOV     ES,Graf_Seg             ; ES=Video szegmens
        CMP     DL,Src_Page             ; Ugyanazon a Page-en maradunk ?
        JNE     BB_Dif_Pages            ; Ha nem akkor ugr†s
        MOV     AX,Arg_Src_Y            ; Utols¢ forr†s pixel sz†m°t†s
        ADD     AX,Arg_DY
        DEC     AX
        MOV     CX,Arg_Src_X
        ADD     CX,Arg_DX
        DEC     CX
        MUL     Video_Pitch
        ADD     AX,CX
        ADC     DX,0
        CMP     DL,Src_Page             ; Utols¢ pixel ua. lapon van ?
        JNE     BB_Dif_Pages            ; ha nem ugr†s tov†bb
        MOV     AX,Arg_Dst_Y            ; Utols¢ cÇl pixel sz†m°t†s
        ADD     AX,Arg_DY
        DEC     AX
        MOV     CX,Arg_Dst_X
        ADD     CX,Arg_DX
        DEC     CX
        MUL     Video_Pitch
        ADD     AX,CX
        ADC     DX,0
        CMP     DL,Src_Page             ; Utols¢ pixel ua. lapon van ?
        JNE     BB_Dif_Pages            ; ha nem ugr†s tov†bb
BB_Line_Loop:                           ; Ugyanazon a lapon maradunk
        MOV     CX,Arg_DX               ; Mozgatand¢ byteok sz†ma
        SHR     CX,1                    ; /2, mert word-îket mozgatunk
        REP     MOVSW                   ; M†sol†s
        ADC     CX,CX
        REP     MOVSB                   ; Utols¢ byte m†sol†sa
        ADD     SI,Pitch                ; Forr†s mutat¢ nîvelÇse
        ADD     DI,Pitch                ; CÇl mutat¢ nîvelÇse
        DEC     Arg_DY                  ; Sorsz†ml†l¢ csîkkentÇse
        JG      BB_Line_Loop            ; Ha van mÇg sor akkor ugr†s vissza
        JMP     BB_Done                 ; Ugr†s a vÇgÇre
BB_Dif_Pages:
        MOV     BX,DS                   ; Forr†s szegens megãrzÇse BX-ben
BB_Row:
        MOV     CX,Arg_DX               ; CX=szÇlessÇg
        PUSH    DI                      ; CÇloffset megãrzÇse
        MOV     DX,CS
        MOV     ES,DX                   ; ES=†tmeneti puffer szegmense
        MOV     DS,BX                   ; DS= forr†s szegmens
        LEA     DI,Ras_Buffer           ; DI= †tmeneti puffer offset
        MOV     AX,SI                   ; forr†s sor azonos lapon van ?
        ADD     AX,CX
        JC      BB_Col                  ; ha nem akkor ugr†s
        SHR     CX,1                    ; CX/2 word-ît mozgatunk
        REP     MOVSW                   ; M†sol†s a TMP pufferba
        ADC     CX,CX                   ; Utols¢ byte
        REP     MOVSB                   ; m†sol†sa a TMP pufferba
BB_Row_In:
        POP     DI                      ; DI a cÇloffset
        ADD     SI,Pitch                ; Kîvetkezã sor
        JC      BB_Fix00                ; Ha lapv†lt†s akkor ugr†s
BB_00:
        MOV     DL,Dst_Page             ; DL=CÇl page
        CALL    _Select_Page_256             ; Page †ll°t†s
BB_Out:
        MOV     DX,CS                   ; µtmeneti puffer szegmese a CS-ben
        MOV     DS,DX                   ; DS=†tmeneti puffer szegmese
        MOV     ES,BX                   ; ES=Forr†s szegmens
        MOV     CX,Arg_DX
        PUSH    SI
        LEA     SI,Ras_Buffer           ;SI=TMP puffer offset
        MOV     AX,DI                   ;A cÇlsor azonos lapon van?
        ADD     AX,CX
        JC      BB_Col1                 ; Ha nem ugr†s
        SHR     CX,1                    ; CX/2 word-ît mozgatunk
        REP     MOVSW                   ; M†sol†s a TMP pufferbãl a kÇpre
        ADC     CX,CX                   ; utols¢ byte
        REP     MOVSB                   ; m†sol†sa a TMP pufferbãl a kÇpre
BB_Row_Out:
        POP     SI
        ADD     DI,Pitch                ; Kîvetkezã sor
        JC      BB_Fix10                ; Lapv†lt†s kell
BB_10:
        MOV     DL,Src_Page             ; Forr†s page
        CALL    _Select_Page_256             ; †ll°t†s
BB_11:
        DEC     Arg_DY                  ; Sorsz†ml†l¢ csîkkentÇse
        JG      BB_Row                  ; Ha nincs vÇge akkor ugr†s vissza
        JMP     BB_Done                 ; Ugr†s a vÇgÇre
BB_Col:
        MOV     AL,[SI]                 ; m†sol†s byteonkÇnt
        STOSB                           ; a TMP pufferba
        ADD     SI,1
        JC      BB_Fix20                ; lapv†lt†s
        LOOP    BB_Col                  ; ha van mÇg byte ugr†s vissza
        JMP     BB_Row_In               ; Kîvetkezã sor
BB_Col1:
        LODSB                           ; Forr†s byte
        MOV     ES:[DI],AL              ; a cÇlc°mre
        ADD     DI,1                    ; cÇlc°m nîvelÇse
        JC      BB_Fix30                ; ha lapv†lt†s akkor ugr†s
        LOOP    BB_Col1                 ; ha van mÇg byte ugr†s vissza
        JMP     BB_Row_Out              ; Kîvetketã sor
BB_Fix00:
        INC     Src_Page                ; Forr†s page nîvelÇse
        JMP     BB_00
BB_Fix10:
        INC     Dst_Page                ; CÇl page nîvelÇse
        JMP     BB_10
BB_Fix20:
        INC     Src_Page                ; Forr†s page nîvelÇs
        MOV     DL,Src_Page             ;
        CALL    _Select_Page_256             ; Çs be†ll°t†sa
        LOOP    BB_Col                  ; ugr†s vissza ha van mÇg byte
        JMP     BB_Row_In               ; kîvetkezã sor
BB_Fix30:
        INC     Dst_Page                ; CÇl page nîvelÇse
        MOV     DL,Dst_Page             ;
        CALL    _Select_Page_256             ; Çs †l°t†sa
        LOOP    BB_Col1                 ; ugr†s vissza ha van mÇg byte
        JMP     BB_Row_Out              ; Kîvetkezã sor
BB_Done:
        JMP     End_BitBlt              ; Ugr†s kilÇpÇsre

BB_XNYP:                                ; Jobbr¢l-balra, fentrãl lefelÇ
        STD
        MOV     AX,Arg_Src_Y
        MOV     CX,Arg_Src_X
        ADD     CX,Arg_DX
        DEC     CX
        MUL     Video_Pitch
        ADD     AX,CX
        ADC     DX,0
        MOV     SI,AX
        MOV     Src_Page,DL
        CALL    _Select_Page_256
        MOV     DS,Graf_Seg
        MOV     AX,Video_Pitch
        ADD     AX,Arg_DX
        MOV     Pitch,AX
        MOV     AX,Arg_Dst_Y
        MOV     CX,Arg_Dst_X
        ADD     CX,Arg_DX
        DEC     CX
        MUL     Video_Pitch
        ADD     AX,CX
        ADC     DX,0
        MOV     DI,AX
        MOV     Dst_Page,DL
        MOV     ES,Graf_Seg
        CMP     DL,Src_Page
        JNE     BBXR_Dif_Pages
        MOV     AX,Arg_Src_Y
        ADD     AX,Arg_DY
        DEC     AX
        MUL     Video_Pitch
        ADD     AX,Arg_Src_X
        ADC     DX,0
        CMP     DL,Src_Page
        JNE     BBXR_Dif_Pages
        MOV     AX,Arg_Dst_Y
        ADD     AX,Arg_DY
        DEC     AX
        MUL     Video_Pitch
        ADD     AX,Arg_Dst_X
        ADC     DX,0
        CMP     DL,Src_Page
        JNE     BBXR_Dif_Pages
BBXR_Line_Loop:
        MOV     CX,Arg_DX
        REP     MOVSB
        ADD     SI,Pitch
        ADD     DI,Pitch
        DEC     Arg_DY
        JG      BBXR_Line_Loop
        JMP     BBXR_Done
BBXR_Dif_Pages:
        MOV     BX,DS
BBXR_Row:
        MOV     CX,Arg_DX
        PUSH    DI
        MOV     DX,CS
        MOV     ES,DX
        MOV     DS,BX
        LEA     DI,Ras_Buffer[1023]
        MOV     AX,SI
        SUB     AX,CX
        JC      BBXR_Col
        REP     MOVSB
BBXR_Row_In:
        POP     DI
        ADD     SI,Pitch
        JC      BBXR_Fix00
BBXR_00:
        MOV     DL,Dst_Page
        CALL    _Select_Page_256
BBXR_Out:
        MOV     CX,Arg_DX
        MOV     DX,CS
        MOV     DS,DX
        MOV     ES,BX
        PUSH    SI
        LEA     SI,Ras_Buffer[1023]
        MOV     AX,DI
        SUB     AX,CX
        JC      BBXR_Col1
        REP     MOVSB
BBXR_Row_Out:
        POP     SI
        ADD     DI,Pitch
        JC      BBXR_Fix10
BBXR_10:
        MOV     DL,Src_Page
        CALL    _Select_Page_256
BBXR_11:
        DEC     Arg_DY
        JG      BBXR_Row
        JMP     BBXR_Done
BBXR_Fix00:
        INC     Src_Page
        JMP     BBXR_00
BBXR_Fix10:
        INC     Dst_Page
        JMP     BBXR_10
BBXR_Fix20:
        DEC     Src_Page
        MOV     DL,Src_Page
        CALL    _Select_Page_256
        LOOP    BBXR_Col
        JMP     BBXR_Row_In
BBXR_Fix30:
        DEC     Dst_Page
        MOV     DL,Dst_Page
        CALL    _Select_Page_256
        LOOP    BBXR_Col1
        JMP     BBXR_Row_Out
BBXR_Col:
        MOV     AL,[SI]
        STOSB
        SUB     SI,1
        JC      BBXR_Fix20
        LOOP    BBXR_Col
        JMP     BBXR_Row_In
BBXR_Col1:
        LODSB
        MOV     ES:[DI],AL
        SUB     DI,1
        JC      BBXR_Fix30
        LOOP    BBXR_Col1
        JMP     BBXR_Row_Out
BBXR_Done:
        CLD
        JMP     End_BitBlt

BB_XPYN:                                ; Balr¢l-jobbra, lentrãl-felfelÇ
        MOV     AX,Arg_Src_Y
        ADD     AX,Arg_DY
        DEC     AX
        MUL     Video_Pitch
        ADD     AX,Arg_Src_X
        ADC     DX,0
        MOV     SI,AX
        MOV     Src_Page,DL
        CALL    _Select_Page_256
        MOV     DS,Graf_Seg
        MOV     AX,Video_Pitch
        ADD     AX,Arg_DX
        MOV     Pitch,AX
        MOV     AX,Arg_Dst_Y
        ADD     AX,Arg_DY
        DEC     AX
        MUL     Video_Pitch
        ADD     AX,Arg_Dst_X
        ADC     DX,0
        MOV     DI,AX
        MOV     Dst_Page,DL
        MOV     ES,Graf_Seg
        CMP     DL,Src_Page
        JNE     BBRY_Dif_Pages
        MOV     AX,Arg_Src_Y
        MOV     CX,Arg_Src_X
        ADD     CX,Arg_DX
        DEC     CX
        MUL     Video_Pitch
        ADD     AX,CX
        ADC     DX,0
        CMP     DL,Src_Page
        JNE     BBRY_Dif_Pages
        MOV     AX,Arg_Dst_Y
        MOV     CX,Arg_Dst_X
        ADD     CX,Arg_DX
        DEC     CX
        MUL     Video_Pitch
        ADD     AX,CX
        ADC     DX,0
        CMP     DL,Src_Page
        JNE     BBRY_Dif_Pages
BBRY_Line_Loop:
        MOV     CX,Arg_DX
        SHR     CX,1
        REP     MOVSW
        ADC     CX,CX
        REP     MOVSB
        SUB     SI,Pitch
        SUB     DI,Pitch
        DEC     Arg_DY
        JG      BBRY_Line_Loop
        JMP     BBRY_Done
BBRY_Dif_Pages:
        MOV     BX,DS
BBRY_Row:
        MOV     CX,Arg_DX
        PUSH    DI
        MOV     DX,CS
        MOV     ES,DX
        MOV     DS,BX
        LEA     DI,Ras_Buffer
        MOV     AX,SI
        ADD     AX,CX
        JC      BBRY_Col
        SHR     CX,1
        REP     MOVSW
        ADC     CX,CX
        REP     MOVSB
BBRY_Row_In:
        POP     DI
        SUB     SI,Pitch
        JC      BBRY_Fix00
BBRY_00:
        MOV     DL,Dst_Page
        CALL    _Select_Page_256
BBRY_Out:
        MOV     CX,Arg_DX
        MOV     DX,CS
        MOV     DS,DX
        MOV     ES,BX
        PUSH    SI
        LEA     SI,Ras_Buffer
        MOV     AX,DI
        ADD     AX,CX
        JC      BBRY_Col1
        SHR     CX,1
        REP     MOVSW
        ADC     CX,CX
        REP     MOVSB
BBRY_Row_Out:
        POP     SI
        SUB     DI,Pitch
        JC      BBRY_Fix10
BBRY_10:
        MOV     DL,Src_Page
        CALL    _Select_Page_256
BBRY_11:
        DEC     Arg_DY
        JG      BBRY_Row
        JMP     BBRY_Done
BBRY_Col:
        MOV     AL,[SI]
        STOSB
        ADD     SI,1
        JC      BBRY_Fix20
        LOOP    BBRY_Col
        JMP     BBRY_Row_In
BBRY_Col1:
        LODSB
        MOV     ES:[DI],AL
        ADD     DI,1
        JC      BBRY_Fix30
        LOOP    BBRY_Col1
        JMP     BBRY_Row_Out
BBRY_Fix00:
        DEC     Src_Page
        JMP     BBRY_00
BBRY_Fix10:
        DEC     Dst_Page
        JMP     BBRY_10
BBRY_Fix20:
        INC     Src_Page
        MOV     DL,Src_Page
        CALL    _Select_Page_256
        LOOP    BBRY_Col
        JMP     BBRY_Row_In
BBRY_Fix30:
        INC     Dst_Page
        MOV     DL,Dst_Page
        CALL    _Select_Page_256
        LOOP    BBRY_Col1
        JMP     BBRY_Row_Out
BBRY_Done:

End_BitBlt:
        POP     ES
        POP     DS
        RET

_CopyBlock_256 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _CopyFromMem_256                                             *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Memoria-Videomem¢ria †tvitel                                 *
;* Bemenet:     CX: X1 koordin†ta , DX: Y1 koordin†ta                        *
;*              DS:SI= Mem¢ria c°m , DI= Logikai szÇlessÇg a mem¢ri†ban      *
;*              AX: SzÇlessÇg     , BX: Magass†g                             *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_CopyFromMem_256 PROC FAR

        PUSH    DS
        MOV     C_Arg_DX,AX
        MOV     C_Arg_DY,BX
        MOV     C_Pitch,DI
        MOV     AX,Video_Pitch
        MUL     DX
        ADD     AX,CX
        ADC     DX,0
        MOV     DI,AX
        MOV     C_PageNo,DL
        CALL    _Select_Page_256
        MOV     ES,Graf_Seg
        MOV     DX,Video_Pitch
        SUB     DX,C_Arg_dx
        MOV     BX,C_Pitch
        SUB     BX,C_Arg_dx
Scan_Loop:
        MOV     CX,C_Arg_dx
        MOV     AX,CX
        ADD     AX,DI
        JNC     Scan_In_Page
        SUB     CX,AX
        SHR     CX,1
        REP     MOVSW
        ADC     CX,CX
        REP     MOVSB
        MOV     CX,AX
        PUSH    DX
        XCHG    DL,C_PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,C_PageNo
        POP     DX
        JCXZ    Scan_Done
Scan_In_Page:
        SHR     CX,1
        REP     MOVSW
        ADC     CX,CX
        REP     MOVSB
Scan_Done:
        ADD     SI,BX
        ADD     DI,DX
        JC      Fix_Page
        DEC     C_Arg_dy
        JG      Scan_Loop
        JMP     End_Write
Fix_Page:
        PUSH    DX
        XCHG    DL,C_PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,C_PageNo
        POP     DX
        DEC     C_Arg_dy
        JG      Scan_Loop
End_Write:
Copy_End:
        POP     DS
        RET

_CopyFromMem_256 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _CopyToMem_256                                               *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     VideoMemoria-Mem¢ria †tvitel                                 *
;* Bemenet:     CX: X1 koordin†ta , DX: Y1 koordin†ta                        *
;*              DS:SI= Mem¢ria c°m , DI= Logikai szÇlessÇg a mem¢ri†ban      *
;*              AX: SzÇlessÇg     , BX: Magass†g                             *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_CopyToMem_256 PROC FAR

        PUSH    DS
        MOV     C_Arg_DX,AX
        MOV     C_Arg_DY,BX
        MOV     C_Pitch,DI
        MOV     AX,Video_Pitch
        MUL     DX
        ADD     AX,CX
        ADC     DX,0
        MOV     DI,AX
        MOV     C_PageNo,DL
        CALL    _Select_Page_256
        MOV     ES,Graf_Seg
        MOV     DX,Video_Pitch
        SUB     DX,C_Arg_dx
        MOV     BX,C_Pitch
        SUB     BX,C_Arg_dx
        XCHG    SI,DI
        XCHG    BX,DX
        MOV     AX,DS                   ; forr†s Çs a
	MOV	CX,ES
        MOV     DS,CX                   ; cÇl felcserÇlÇse
        MOV     ES,AX
Scan_Loop2:
        MOV     CX,C_Arg_dx
        MOV     AX,CX
        ADD     AX,SI
        JNC     Scan_In_Page2
        SUB     CX,AX
        SHR     CX,1
        REP     MOVSW
        ADC     CX,CX
        REP     MOVSB
        MOV     CX,AX
        PUSH    DX
        XCHG    DL,C_PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,C_PageNo
        POP     DX
        JCXZ    Scan_Done2
Scan_In_Page2:
        SHR     CX,1
        REP     MOVSW
        ADC     CX,CX
        REP     MOVSB
Scan_Done2:
        ADD     DI,DX
        ADD     SI,BX
        JC      Fix_Page2
        DEC     C_Arg_dy
        JG      Scan_Loop2
        JMP     CopyT_End
Fix_Page2:
        PUSH    DX
        XCHG    DL,C_PageNo
        INC     DL
        CALL    _Select_Page_256
        XCHG    DL,C_PageNo
        POP     DX
        DEC     C_Arg_dy
        JG      Scan_Loop2
CopyT_End:
        POP     DS
        RET

_CopyToMem_256 ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     OutTextXY                                                    *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Szîveg megjelen°tÇse                                         *
;* Bemenet:     CX= X koordin†ta , DX= Y koordin†ta , ES:DI= TextPointer     *
;*              BH= H†ttÇrSz°n , BL= TextSz°n , AH= FelÅl°r†s (0/1)          *
;* Kimenet:     -                                                            *
;*                                                                           *
;*******************************************************************************

_OutTextXY_256 PROC FAR

        PUSH    ES
        PUSH    DS
        PUSH    BP
        MOV     Over,AH
        MOV     TextColor,BL
        MOV     TextBackColor,BH
        MOV     TextSeg,ES
        MOV     TextOfs,DI
        MOV     AX,DX
        MUL     Video_Pitch
        ADD     AX,CX
        ADC     DX,0
        MOV     StartOfs,AX
        MOV     StartPage,DL
        MOV     BL,TextColor
        MOV     BH,TextBackColor
        MOV     TextLine,0
        CMP     Over,0
        JZ      LoopTextNoOver
        JMP     LoopTextOver
LoopTextNoOver:
        MOV     DL,StartPage
        MOV     PageNo,DL
        CALL    _Select_Page_256
        MOV     DI,TextOfs
        MOV     SI,StartOfs
LoopCharsNoOver:
        MOV     TextRow,0
        MOV     BP,CharGenOfs
        MOV     ES,TextSeg
        MOV     AH,0
        MOV     AL,ES:[DI]
        OR      AL,AL
        JNZ     OkTTO
        JMp     End_TextNoOver
OkTTO:
        MUL     CharByte
        ADD     BP,AX
        MOV     AX,CharXByte
        MUL     TextLine
        ADD     BP,AX
        MOV     ES,CharGenSeg
        ADD     BP,TextRow
LoopCharsNoOver2:
        MOV     ES,CharGenSeg
        MOV     AL,ES:[BP]
        MOV     CX,8
        MOV     ES,Graf_Seg
Cb:
        SAL     AL,1
        JNC     NoPix
        MOV     ES:[SI],BL
NoPix:
        ADD     SI,1
        JNC     NoPageNoOver
        INC     PageNo
        MOV     DL,PageNo
        CALL    _Select_Page_256
NoPageNoOver:
        LOOP    CB
        INC     TextRow
        MOV     AX,TextRow
        CMP     AX,CharXByte
        JZ      EndRowNoO
        INC     BP
        JMP     LoopCharsNoOver2
EndRowNoO:
        INC     DI
        JMP     LoopCharsNoOver
End_TextNoOver:
        INC     TextLine
        MOV     AX,TextLine
        CMP     AX,CharY
        JNZ     NeNo
        JMP     End_TextOut
NenO:
        MOV     AX,Video_Pitch
        ADD     StartOfs,AX
        JNC     JumpBack
        INC     StartPage
JumpBack:
        JMP     LoopTextNoOver
LoopTextOver:
        MOV     DL,StartPage
        MOV     PageNo,DL
        CALL    _Select_Page_256
        MOV     DI,TextOfs
        MOV     SI,StartOfs
LoopCharsOver:
        MOV     TextRow,0
        MOV     BP,CharGenOfs
        MOV     ES,TextSeg
        MOV     AH,0
        MOV     AL,ES:[DI]
        OR      AL,AL
        JNZ     OkTTOOv
        JMP     End_TextOver
OkTTOOv:
        MUL     CharByte
        ADD     BP,AX
        MOV     AX,CharXByte
        MUL     TextLine
        ADD     BP,AX
        MOV     ES,CharGenSeg
        ADD     BP,TextRow
LoopCharsOver2:
        MOV     ES,CharGenSeg
        MOV     AL,ES:[BP]
        MOV     CX,8
        MOV     ES,Graf_Seg
CbO:
        SAL     AL,1
        JNC     BackPix
        MOV     ES:[SI],BL
        JMP     TT1
BackPix:
        MOV     ES:[SI],BH
TT1:
        ADD     SI,1
        JNC     NoPageOver
        INC     PageNo
        MOV     DL,PageNo
        CALL    _Select_Page_256
NoPageOver:
        LOOP    CbO
        INC     TextRow
        MOV     AX,TextRow
        CMP     AX,CharXByte
        JZ      EndRowO
        INC     BP
        JMP     LoopCharsOver2
EndRowO:
        INC     DI
        JMP     LoopCharsOver
End_TextOver:
        INC     TextLine
        MOV     AX,TextLine
        CMP     AX,CharY
        JNZ     NeO
        JMP     End_TextOut
NeO:
        MOV     AX,Video_Pitch
        ADD     StartOfs,AX
        JNC     JumpBackOver
        INC     StartPage
JumpBackOver:
        JMP     LoopTextOver

End_TextOut:
        POP     BP
        POP     DS
        POP     ES
        RET

_OutTextXY_256 ENDP



;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _SetChars_256                                                *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Karakter gener†tor jellemzãk be†ll°t†sa                      *
;* Bemenet:     ES:BP= Karakter gener†tor c°me                               *
;*              CX= Karakter szÇlessÇge pixelben                             *
;*              DX= Karakter magass†ga pixelben                              *
;*              SI= Egy karaktert le°r¢ byte-ok sz†ma                        *
;*              AX= Egy karakter szÇlessÇge byte-ban                         *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_SetChars_256 PROC FAR

        MOV     CharByte,SI      ; Karakter le°ro byte-sz†m
        MOV     CharXByte,AX     ; Karakter szÇlessÇg byte-ban
        MOV     CharX,CX         ; Karakter szÇlessÇg pixelben
        MOV     CharY,DX         ; Karakter magass†ga pixelben
        MOV     CharGenSeg,ES    ; A ES:BP †ltal megc°mzett
        MOV     CharGenOfs,BP    ; Karaktergener†tor be†ll°t†sa
        RET                      ; VisszatÇrÇs

_SetChars_256 ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:   _GetActPage                                                    *
;* T°pus  :   KÅlsã elj†r†s                                                  *
;* Le°r†s :   Akt°v page lekÇrdezÇs                                          *
;* Bemenet:   -                                                              *
;* Kimenet:   AL= Akt°v page                                                 *
;*                                                                           *
;*****************************************************************************

_GetActPage_256 PROC FAR

              MOV     AL,ActPage       ; AL=ActPage
              RET                      ; VisszatÇrÇs

_GetActPage_256 ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:                                                                  *
;* T°pus  :                                                                  *
;* Le°r†s :                                                                  *
;* Bemenet:                                                                  *
;* Kimenet:                                                                  *
;*                                                                           *
;*****************************************************************************


;*****************************************************************************
;***                                                                       ***
;***                     TGraph_256 End                                    ***
;***                                                                       ***
;*****************************************************************************

END