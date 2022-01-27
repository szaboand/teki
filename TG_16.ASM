;*****************************************************************************
;***                                                                       ***
;***             (C) Szab¢ Andr†s 1996 Budapest-Hungary                    ***
;***                                                                       ***
;***                 16 Color Assembly Routines V1.8                       ***
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


                PUBLIC  _Select_Page_16
                PUBLIC  _SetMode_16
                PUBLIC  _GetMode_16
                PUBLIC  _ClearScreen_16
                PUBLIC  _WritePixel_16
                PUBLIC  _GetPixel_16
                PUBLIC  _Line_16
                PUBLIC  _SolidRect_16
                PUBLIC  _CopyBlock_16
                PUBLIC  _CopyFromMem_16
                PUBLIC  _CopyToMem_16
                PUBLIC  _OutTextXY_16
                PUBLIC  _SetChars_16
                PUBLIC  _GetActPage_16


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

GRAPHICS_CTRL_PORT	DW	03CEh	; Grafikai vezÇrlã regiszerek c°m
GRAPHICS_DATA_PORT	DW	03CFh	; Grafikai vezÇrlã regiszter adat
SET_RESET_REG		DB	0	; Set/Reset regiszter
SR_ENABLE_REG		DB	1       ; Set/Reset engedÇlyezÇs regiszter
COLOR_COMP_REG		DB	2       ; Szin îsszehasonl°t¢ regiszter
FN_SEL_REG		DB	3       ; M˚veleti k¢d regiszter
READ_PLANE_REG		DB	4       ; Bitplane v†laszt†s olvas†skor regiszter
MODE_REG		DB	5       ; ÷r†si/Olvas†si m¢d regiszter
MISC_REG		DB	6       ; Mem¢ria lap regiszter
COL_DONT_CARE_REG	DB	7       ; Sz°nfigyelÇs maszk regiszter
BIT_MASK_REG		DB	8       ; BitMaszk regiszter

SEQUENCER_PORT		DW	03C4h	; Video-sequencer regiszter
CLOCK_MOD_REG           DB      1       ; ‡rajel m¢d regiszter

PLANE_ENABLE_REG	DB	2	; BitPlane °r†smaszk regiszter

Arg_X                   DW      ?       ; _WritePixel_16 v†ltoz¢
Arg_Color               DB      ?       ; _WritePixel_16 v†ltoz¢

Arg_X0                  DW      ?       ; _Line_16 v†ltoz¢
Arg_Y0                  DW      ?       ; _Line_16 v†ltoz¢
Arg_X1                  DW      ?       ; _Line_16 v†ltoz¢
Arg_Y1                  DW      ?       ; _Line_16 v†ltoz¢
PageNo                  DB      ?       ; _Line_16 v†ltoz¢
First_Mask              DB      ?       ; _Line_16 v†ltoz¢
Pitch                   DW      ?       ; _Line_16 v†ltoz¢
Delta_X                 DW      ?       ; _Line_16 v†ltoz¢
D1                      DW      ?       ; _Line_16 v†ltoz¢
D2                      DW      ?       ; _Line_16 v†ltoz¢

Start_Page              DB      ?       ; _SolidBar_16 v†ltoz¢
Last_Mask               DB      ?       ; _SolidBar_16 v†ltoz¢

CharY                   DW      ?       ; Karakter magass†ga pixelben
CharX                   DW      ?       ; Karakter szÇlesssÇge pixelben
CharXbyte               DW      ?       ; Karakter szÇlessÇge byteban
CharByte                DW      ?       ; Karaktert le°r¢ byteok sz†ma
CharGenSeg              DW      ?       ; Karakter gener†tor szegmensc°me
CharGenOfs              DW      ?       ; Karakter gener†tor ofsetc°me

Over                    DB      ?       ; _OutTextXY v†ltoz¢
TextColor               DB      ?       ; _OutTextXY v†ltoz¢
TextBackColor           DB      ?       ; _OutTextXY v†ltoz¢
TextSeg                 DW      ?       ; _OutTextXY v†ltoz¢
TextOfs                 DW      ?       ; _OutTextXY v†ltoz¢
StartOfs                DW      ?       ; _OutTextXY v†ltoz¢
StartPage               DB      ?       ; _OutTextXY v†ltoz¢
TextLine                DW      ?       ; _OutTextXY v†ltoz¢
TextRow                 DW      ?       ; _OutTextXY v†ltoz¢
Rotation                DW      ?       ; _OutTextXY v†ltoz¢
TextMask                DB      ?       ; _OutTextXY v†ltoz¢
FirstMask               DB      ?       ; _OutTextXY v†ltoz¢

Arg_Src_X               DW      ?       ; _CopyBlock v†ltoz¢
Arg_Src_Y               DW      ?       ; _CopyBlock v†ltoz¢
Arg_Dst_X               DW      ?       ; _CopyBlock v†ltoz¢
Arg_Dst_Y               DW      ?       ; _CopyBlock v†ltoz¢
Arg_FN                  DB      ?       ; _CopyBlock v†ltoz¢
Arg_DX                  DW      ?       ; _CopyBlock v†ltoz¢
Arg_DY                  DW      ?       ; _CopyBlock v†ltoz¢
Src_Pitch               DW      ?       ; _CopyBlock v†ltoz¢
Dst_Pitch               DW      ?       ; _CopyBlock v†ltoz¢
SrcPage                 DB      ?       ; _CopyBlock v†ltoz¢
DstPage                 DB      ?       ; _CopyBlock v†ltoz¢
FirstSrc                DB      ?       ; _CopyBlock v†ltoz¢
FirstDst                DB      ?       ; _CopyBlock v†ltoz¢
Phase                   DB      ?       ; _CopyBlock v†ltoz¢
First_Fetch             DB      ?       ; _CopyBlock v†ltoz¢
Full_Count              DB      ?       ; _CopyBlock v†ltoz¢
Plane                   DB      ?       ; _CopyBlock v†ltoz¢
Ras_Buffer	        DB 1024 DUP (0)	; _CopyBlock TMP t†rol¢


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

_Select_Page_16    PROC FAR

               CMP      DL,ActPage
               JZ       SP_Exit
               MOV      ActPage,DL
               CALL     dword ptr [PageFuncOff] ; Lapoz¢ fÅggvÇny h°v†sa
SP_Exit:
               RET

_Select_Page_16 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _SetMode_16                                                  *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     A 16 sz°n˚ m¢d adatait †ll°tja be                            *
;* Bemenet:     DX: Video_Pich , ES:DI= Lapoz¢ fÅggvÇny c°me                 *
;*              CX: Video lapok sz†ma                                        *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_SetMode_16 PROC FAR

               MOV      Video_Pitch,DX          ; Logikai szÇlessÇg=DX
               MOV      Video_Pages,CX          ; Video lapok sz†ma=CX
               MOV      PageFuncSeg,ES          ; Lapoz¢ fÅggvÇny szegmesc°me
               MOV      PageFuncOff,DI          ; Lapoz¢ fÅggvÇny offsetc°me
               XOR      DL,DL                   ; DL=0
               CALL     _Select_Page_16         ; Page †ll°t†s
               RET

_SetMode_16 ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _GetMode_16                                                  *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     A 16 sz°n˚ m¢d adatait kÇrdezi le                            *
;* Bemenet:     -                                                            *
;* Kimenet:     DX= Logikai szÇlessÇg, ES:DI= Karakter adatok mutat¢ja       *
;*              AL= ActPage                                                  *
;*                                                                           *
;*****************************************************************************

_GetMode_16 PROC FAR

               MOV      DX,Video_Pitch       ; DX=Logikai szÇlessÇg
               MOV      AX,Seg CharY
               MOV      ES,AX
               MOV      DI,Offset CharY      ; ES:DI Karakter adatok
               MOV      AL,ActPage           ; AL=Aktu†lis Page
               RET


_GetMode_16 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _SelectColor                                                 *
;* T°pus  :     Belsã elj†r†s                                                *
;* Le°r†s :     Sz°n be†ll°t†s a 16 color m¢dhoz                             *
;* Bemenet:     AL: Sz°n                                                     *
;* Kimenet:     DX = Mask select data register                               *
;*                                                                           *
;*****************************************************************************

Select_Color PROC FAR

               PUSH    AX
               MOV     DX,GRAPHICS_CTRL_PORT
               MOV     AH,AL
               MOV     AL,SET_RESET_REG
               OUT     DX,AX
               MOV     DX,GRAPHICS_CTRL_PORT
               MOV     AL,SR_ENABLE_REG
               MOV     AH,0Fh
               OUT     DX,AX
               MOV     AL,BIT_MASK_REG
               OUT     DX,AL
               INC     DX
               POP     AX
               RET

Select_Color    ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _ClearScreen_16                                              *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     KÇpernyã tîrlÇse BL sz°nnel                                  *
;* Bemenet:     BL: Sz°n                                                     *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_ClearScreen_16   PROC FAR

        MOV     AL,BL
        CALL    Select_Color
        MOV     AL,0FFh
        OUT     DX,AL
        MOV     ES,Graf_Seg
        XOR     DX,DX
Cls_Page_Loop:
        CALL    _Select_Page_16
        XOR     DI,DI
        MOV     CX,8000h
        REP     STOSW
        INC     DX
        CMP     DX,Video_Pages
        JL      Cls_Page_Loop
        RET

_ClearScreen_16   ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     WritePixel_16                                                *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     CX:DX pixel megjelen°tÇse BL sz°nben                         *
;* Bemenet:     CX: X koordin†ta , DX: Y koordin†ta , BL: Pixel szin         *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************


_WritePixel_16    PROC FAR

        MOV     Arg_X,CX
        MOV     Arg_Color,BL
        MOV     AX,Video_Pitch
        MUL     DX
        SHR     CX,1
        SHR     CX,1
        SHR     CX,1
        ADD     AX,CX
        ADC     DX,0
        MOV     ES,Graf_Seg
        MOV     DI,AX
        CALL    _Select_Page_16
        MOV     AL,Arg_Color
        CALL    Select_Color
        MOV     CX,Arg_X
        AND     CX,7
        MOV     AL,80h
        SHR     AL,CL
        MOV     DX,GRAPHICS_CTRL_PORT
        MOV     AH,AL
        MOV     AL,BIT_MASK_REG
        OUT     DX,AX
        MOV     AH,ES:[DI]
        MOV     ES:[DI],AL
        RET


_WritePixel_16    ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     GetPixel_16                                                  *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     CX:DX pixel lekÇrdezÇse AL-be                                *
;* Bemenet:     CX: X koordin†ta , DX: Y koordin†ta                          *
;* Kimenet:     AL: Pixel szin                                               *
;*                                                                           *
;*****************************************************************************


_GetPixel_16  PROC FAR

                MOV     Arg_X,CX
                MOV     AX,DX
                MUL     Video_Pitch
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                ADC     DX,0
                MOV     ES,Graf_Seg
                MOV     DI,AX
                CALL    _Select_Page_16
                MOV     DX,GRAPHICS_CTRL_PORT
                MOV     AL,READ_PLANE_REG
                OUT     DX,AL
                INC     DX
                MOV     AL,3
                MOV     CX,Arg_x
                AND     CX,7
                MOV     BL,80h
                SHR     BL,CL
                XOR     BH,BH
Plane_Loop:
                OUT     DX,AL
                SHL     BH,1
                MOV     AH,ES:[DI]
                AND     AH,BL
                JZ      RP_Not_Set
                OR      BH,1
RP_Not_Set:
                DEC     AL
                JGE     Plane_Loop
                MOV     AL,BH
                XOR     AH,AH
                RET

_GetPixel_16    ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _Line_16                                                    *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Vonalh£z¢ elj†r†s                                            *
;* Bemenet:     CX,DX= X1,Y1 koordin†ta  SI,DI= X2,Y2 koordin†ta             *
;*              BL= Sz°n                                                     *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_Line_16           PROC FAR

                PUSH    DS
                MOV     Arg_Y0,DX
                MOV     Arg_X0,CX
                MOV     Arg_Y1,DI
                MOV     Arg_X1,SI
                MOV     Arg_Color,BL
                MOV     AX,DX
                MUL     Video_Pitch
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                ADC     DX,0
                PUSH    AX
                MOV     DS,Graf_Seg
                MOV     ES,Graf_Seg
                MOV     PageNo,DL
                CALL    _Select_Page_16
                MOV     CX,Arg_X0
                AND     CL,7
                MOV     BL,80h
                SHR     BL,CL
                MOV     First_Mask,BL
                MOV     AL,Arg_Color
                CALL    Select_Color
                MOV     AX,Video_Pitch
                MOV     Pitch,AX
                MOV     SI,Arg_X1
                SUB     SI,Arg_X0
                MOV     Delta_X,SI
                JGE     DX_Pos
                NEG     SI
DX_Pos:
                MOV     DI,Arg_Y1
                SUB     DI,Arg_Y0
                JGE     DY_Pos
                NEG     Pitch
                NEG     DI
DY_Pos:
                OR      SI,SI
                JE      Vertical
                OR      DI,DI
                JE      Horizontal
                CMP     SI,DI
                JL      Y_Major_Jump
                JMP     X_Major
Y_Major_Jump:
                JMP     Y_Major
Vertical:
                MOV     CX,DI
                INC     CX
                MOV     AL,First_Mask
                OUT     DX,AL
                POP     DI
                MOV     BX,Pitch
                OR      BX,BX
                JNS     Vert_Loop
                NEG     BX
                XCHG    SI,CX
                MOV     AX,Arg_Y1
                MUL     Video_Pitch
                MOV     CX,Arg_X1
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                ADC     DX,0
                MOV     DI,AX
                MOV     ES,Graf_Seg
                MOV     PageNo,DL
                CALL    _Select_Page_16
                XCHG    SI,CX
Vert_Loop:
                NOT     BYTE PTR [DI]
                ADD     DI,BX
                JC      Vert_Update_Seg
                LOOP    Vert_Loop
                JMP     End_Line
Vert_Update_Seg:
                PUSH    AX
                INC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                LOOP    Vert_Loop
                JMP     End_Line
Horizontal:
                POP     DI
                MOV     AX,Arg_X0
                CMP     Delta_X,0
                JNS     Horz_In_Order
                MOV     AX,Arg_Y1
                MUL     Video_Pitch
                MOV     CX,Arg_X1
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                ADC     DX,0
                MOV     DI,AX
                MOV     ES,Graf_Seg
                MOV     PageNo,DL
                CALL    _Select_Page_16
                MOV     DX,GRAPHICS_CTRL_PORT+1
                MOV     AX,Arg_X1
Horz_In_Order:
                MOV     CX,SI
                INC     CX
                AND     AX,7
                JZ      Horz_Full
                MOV     BL,0FFh
                XCHG    BH,CL
                MOV     CL,AL
                SHR     BL,CL
                XCHG    BH,CL
                ADD     CX,AX
                SUB     CX,8
                JGE     LineMask_Set
                NEG     CX
                SHR     BL,CL
                SHL     BL,CL
                XOR     CX,CX
LineMask_Set:
                MOV     AL,BL
                OUT     DX,AL
                MOV     AH,ES:[DI]
                STOSB
Horz_Full:
                MOV     BX,CX
                CMP     BX,8
                JL      Horz_Trailing
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                MOV     AL,0FFh
                OUT     DX,AL
                REP     STOSB
Horz_Trailing:
                AND     BL,7
                JZ      Horz_Done
                MOV     AL,0FFh
                MOV     CX,BX
                SHR     AL,CL
                NOT     AL
                OUT     DX,AL
                MOV     AL,ES:[DI]
                STOSB
Horz_Done:
                JMP     End_Line
X_Major:
                MOV     CX,SI
                INC     CX
                SAL     DI,1
                MOV     BX,DI
                SUB     BX,SI
                NEG     SI
                ADD     SI,BX
                MOV     D1,DI
                MOV     D2,SI
                POP     DI
                MOV     AL,First_Mask
                XOR     SI,SI
                OR      Pitch,SI
                JNS     XM_Y_Pos
                NEG     Pitch
                OR      Delta_X,SI
                JS      XNYN_Jump
                JMP     XPYN
XNYN_Jump:
                JMP     XNYN
XM_Y_Pos:
                OR      Delta_X,SI
                JNS     XPYP
                JMP     XNYP
XPYP:
XPYP_Next:
                OUT     DX,AL
                NOT     BYTE PTR [DI]
                ROR     AL,1
                ADC     DI,SI
                OR      BX,BX
                JS      XPYP_D_Neg
                ADD     BX,D2
                ADD     DI,Pitch
                JC      XPYP_Update_Seg
                LOOP    XPYP_Next
                JMP     End_Line
XPYP_D_Neg:
                ADD     BX,D1
                LOOP    XPYP_Next
                JMP     End_Line
XPYP_Update_Seg:
                PUSH    AX
                INC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                LOOP    XPYP_Next
                JMP     End_Line
XNYP:
XNYP_Next:
                OUT     DX,AL
                NOT     BYTE PTR [DI]
                ROL     AL,1
                SBB     DI,SI
                OR      BX,BX
                JS      XNYP_D_Neg
                ADD     BX,D2
                ADD     DI,Pitch
                JC      XNYP_Update_Seg
                LOOP    XNYP_Next
                JMP     End_Line
XNYP_D_Neg:
                ADD     BX,D1
                LOOP    XNYP_Next
                JMP     End_Line
XNYP_Update_Seg:
                PUSH    AX
                INC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                LOOP    XNYP_Next
                JMP     End_Line
XPYN:
XPYN_Next:
                OUT     DX,AL
                NOT     BYTE PTR [DI]
                ROR     AL,1
                ADC     DI,SI
                OR      BX,BX
                JS      XPYN_D_Neg
                ADD     BX,D2
                SUB     DI,Pitch
                JC      XPYN_Update_Seg
                LOOP    XPYN_Next
                JMP     End_Line
XPYN_D_Neg:
                ADD     BX,D1
                LOOP    XPYN_Next
                JMP     End_Line
XPYN_Update_Seg:
                PUSH    AX
                DEC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                LOOP    XPYN_Next
                JMP     End_Line
XNYN:
XNYN_Next:
                OUT     DX,AL
                NOT     BYTE PTR [DI]
                ROL     AL,1
                SBB     DI,SI
                OR      BX,BX
                JS      XNYN_D_Neg
                ADD     BX,D2
                SUB     DI,Pitch
                JC      XNYN_Update_Seg
                LOOP    XNYN_Next
                JMP     End_Line
XNYN_D_Neg:
                ADD     BX,D1
                LOOP    XNYN_Next
                JMP     End_Line
XNYN_Update_Seg:
                PUSH    AX
                DEC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                LOOP    XNYN_Next
                JMP     End_Line
Y_Major:
                MOV     CX,DI
                INC     CX
                SAL     SI,1
                MOV     BX,SI
                SUB     BX,DI
                NEG     DI
                ADD     DI,BX
                MOV     d2,DI
                MOV     d1,SI
                POP     DI
                MOV     AL,First_Mask
                XOR     SI,SI
                OR      Pitch,SI
                JNS     YM_Y_Pos
                NEG     Pitch
                OR      Delta_X,SI
                JS      NXNY_Jump
                JMP     PXNY
NXNY_Jump:
                JMP     NXNY
YM_Y_Pos:
                OR      Delta_X,SI
                JNS     PXPY
                JMP     NXPY
PXPY:
                OUT     DX,AL
PXPY_Next:
                NOT     BYTE PTR [DI]
                ADD     DI,Pitch
                JC      PXPY_Update_Seg
PXPY_Updated:
                OR      BX,BX
                JS      PXPY_D_Neg
                ADD     BX,D2
                ROR     AL,1
                OUT     DX,AL
                ADC     DI,SI
                LOOP    PXPY_Next
                JMP     End_Line
PXPY_D_Neg:
                ADD     BX,D1
                LOOP    PXPY_Next
                JMP     End_Line
PXPY_Update_Seg:
                PUSH    AX
                INC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                JMP     PXPY_Updated
NXPY:
                OUT     DX,AL
NXPY_Next:
                NOT     BYTE PTR [DI]
                ADD     DI,Pitch
                JC      NXPY_Update_Seg
NXPY_Updated:
                OR      BX,BX
                JS      NXPY_D_Neg
                ADD     BX,D2
                ROL     AL,1
                OUT     DX,AL
                SBB     DI,SI
                LOOP    NXPY_Next
                JMP     End_Line
NXPY_D_Neg:
                ADD     BX,D1
                LOOP    NXPY_Next
                JMP     End_Line
NXPY_Update_Seg:
                PUSH    AX
                INC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                JMP     NXPY_Updated

PXNY:
                OUT     DX,AL
PXNY_Next:
                NOT     BYTE PTR [DI]
                SUB     DI,Pitch
                JC      PXNY_Update_Seg
PXNY_Updated:
                OR      BX,BX
                JS      PXNY_D_Neg
                ADD     BX,D2
                ROR     AL,1
                OUT     DX,AL
                ADC     DI,SI
                LOOP    PXNY_Next
                JMP     End_Line
PXNY_D_Neg:
                ADD     BX,D1
                LOOP    PXNY_Next
                JMP     End_Line
PXNY_Update_Seg:
                PUSH    AX
                DEC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                JMP     PXNY_Updated
NXNY:
                OUT     DX,AL
NXNY_Next:
                NOT     BYTE PTR [DI]          
                SUB     DI,Pitch
                JC      NXNY_Update_Seg
NXNY_Updated:
                OR      BX,BX
                JS      NXNY_D_Neg
                ADD     BX,D2
                ROL     AL,1
                OUT     DX,AL
                SBB     DI,SI
                LOOP    NXNY_Next
                JMP     End_Line
NXNY_D_Neg:
                ADD     BX,D1
                LOOP    NXNY_Next
                JMP     End_Line
NXNY_Update_Seg:
                PUSH    AX
                DEC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
                POP     AX
                JMP     NXNY_Updated
End_Line:
                POP     DS
                RET

_Line_16 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _SolidRect_16                                                *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Sz°nes tÇglalap rajzol†s                                     *
;* Bemenet:     CX,DX= X1,Y1 koordin†ta  SI,DI= X2,Y2 koordin†ta             *
;*              BL= Sz°n                                                     *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************


_SolidRect_16     PROC FAR

                PUSH    DS
                MOV     Arg_Y0,DX
                MOV     Arg_X0,CX
                MOV     Arg_Y1,DI
                MOV     Arg_X1,SI
                MOV     Arg_Color,BL
                MOV     AX,CX
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
                MOV     AX,Arg_Y0               ;Fetch y coordinate
                MUL     Video_Pitch          ;       multiply by raster width
                MOV     CX,Arg_X0               ;       add x coordinate/8
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                ADC     DX,0
                MOV     DI,AX                   ;Save offset within page
                MOV     ES,Graf_Seg          ;Fetch segment
                MOV     PageNo,DL               ;Save page number for later
                MOV     Start_Page,DL
                CALL    _Select_Page_16
                MOV     AL,Arg_Color
                CALL    Select_Color
                MOV     CX,Arg_X1               ;Compute number of pixels in a line
                SUB     CX,Arg_X0
                INC     CX
                MOV     SI,Arg_Y1               ;Compute number of lines to do
                SUB     SI,Arg_Y0
                INC     SI
                MOV     AX,Arg_X0               ;Fetch x coordinate
                AND     AX,7                    ;Check for partial byte
                JZ      Full
                XCHG    BH,CL                   ;Preserve counter (CL into BH)
                MOV     BL,0FFh                 ;Compute the mask
                MOV     CL,AL
                SHR     BL,CL
                XCHG    BH,CL                   ;Restore counter
                ADD     CX,AX                   ;Update counter
                SUB     CX,8
                JGE     Mask_Set                ;Modify mask if only one byte
                NEG     CX
                SHR     BL,CL
                SHL     BL,CL
                XOR     CX,CX                   ;Indicate no more bytes
Mask_Set:
                MOV     AL,BL                   ;Fetch mask
                OUT     DX,AL                   ;Set mask register
                PUSH    CX                      ;Preserve counters
                PUSH    DI                      ;Save first byte offset
                MOV     CX,SI                   ;Number of lines to do
                MOV     BX,Video_Pitch
Lead_Loop:
                MOV     AH,ES:[DI]              ;Latch data
                MOV     ES:[DI],AH              ;Write new data
                ADD     DI,BX                   ;Point to next raster
                JC      Lead_Update_Seg
                LOOP    Lead_Loop
                JMP     Lead_Done
Lead_Update_Seg:                        ;Fix page if needed
                PUSH    DX
                XCHG    DL,PageNo               ;Fetch page number (preserve AL)
                INC     DL                      ;Advance to next page
                CALL    _Select_Page_16
                XCHG    DL,PageNo               ;Save new page number (restore AL)
                POP     DX
                LOOP     Lead_Loop
Lead_Done:                              ;Restore counters
                POP     DI
                POP     CX
                INC     DI                      ;Point to first full byte
Full:
                MOV     Last_Mask,CL            ;Save count of bits in last byte
                AND     Last_Mask,7
                SHR     CX,1                    ;Compute count of full bytes
                SHR     CX,1
                SHR     CX,1
                JCXZ    Trail                   ;Skip if no full bytes
                MOV     BX,Video_Pitch       ;Compute line to line increment
                SUB     BX,CX
                INC     BX
                PUSH    DX
                MOV     DL,Start_Page           ;Restore page number
                MOV     PageNo,DL
                CALL    _Select_Page_16
                POP     DX
                MOV     AL,0FFh                 ;Set mask
                OUT     DX,AL
                PUSH    SI
                PUSH    DI
Outer_Loop:
                PUSH    CX                      ;Preserve counter in CX
                REP     STOSB
                DEC     DI                      ;Point to last byte drawn
                ADD     DI,BX                   ;Point to next line
                JC      Full_Update_Seg         ;Check of page crossing
Outer_Update:
                POP     CX                      ;Restore counter (within line)
                DEC     SI                      ;Update counter of lines
                JG      Outer_Loop              ;If not done, go do another line
                POP     DI                      ;Restore pointer
                POP     SI                      ;Restore line counter
                ADD     DI,CX                   ;Point to the trailing byte
                JMP     Trail
Full_Update_Seg:
                PUSH    DX
                XCHG    DL,PageNo               ;Fetch page number (preserve AL)
                INC     DL                      ;Advance to next page
                CALL    _Select_Page_16
                XCHG    DL,PageNo
                POP     DX
                JMP     Outer_Update
Trail:
                MOV     CL,Last_Mask            ;Compute number of trailing bits
                OR      CL,CL
                JZ      End_Rect
                PUSH    DX
                MOV     DL,Start_Page           ;Restore page number
                MOV     PageNo,DL
                CALL    _Select_Page_16
                POP     DX
                MOV     BX,Video_Pitch       ;Get line to line increment
                MOV     AL,0FFh                 ;Compute mask
                SHR     AL,CL
                NOT     AL
                OUT     DX,AL                   ;Set the mask
                MOV     CX,SI                   ;Counter of bytes to do
Trail_Loop:
                MOV     AL,ES:[DI]              ;Latch data
                MOV     ES:[DI],AL              ;Set new data
                ADD     DI,BX                   ;Point to next line
                JC      Trail_Update_Seg        ;Update page if needed
                LOOP    Trail_Loop
                JMP     End_Rect
Trail_Update_Seg:
                PUSH    DX
                XCHG    DL,PageNo               ;Fetch page number (preserve AL)
                INC     DL                      ;Advance to next page
                CALL    _Select_Page_16
                XCHG    DL,PageNo               ;Save new page number (restore AL)
                POP     DX
                LOOP    Trail_Loop
End_Rect:
                POP     DS
                RET

_SolidRect_16     ENDP



;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     Compute_Phase                                                *
;* T°pus  :     Belsã elj†r†s                                                *
;* Le°r†s :     CopyBlock elj†r†s segÇdelj†r†sa                              *
;* Bemenet:     Src_X, Src_Y, Dst_X, Dst_Y, Dx, DY                           *
;* Kimenet:     AL= Mask az elsã bytehoz                                     *
;*              AH= Mask az utols¢ bytehoz                                   *
;*              CL= Forgat†s sz†m                                            *
;*              CH= Teljes byteok sz†ma                                      *
;*              BH= Number of fetches needed for first byte                  *
;*                                                                           *
;*****************************************************************************

Compute_Phase   PROC FAR

                MOV     CX,Arg_Dst_X
                AND     CL,7
                MOV     AL,0FFh
                SHR     AL,CL
                MOV     BL,8
                SUB     BL,CL
                XOR     BH,BH
                MOV     CX,Arg_Dst_X
                ADD     CX,Arg_DX
                AND     CL,7
                MOV     AH,0FFh
                SHR     AH,CL
                NOT     AH
                CMP     BX,Arg_DX
                JLE     Masks_Done
                AND     AL,AH
                XOR     AH,AH
                MOV     BX,Arg_DX
Masks_Done:
                MOV     CX,Arg_Dst_X
                SUB     CX,Arg_Src_X
                AND     CL,7
                NEG     BX
                ADD     BX,Arg_DX
                SHR     BX,1
                SHR     BX,1
                SHR     BX,1
                MOV     CH,BL
                MOV     BX,Arg_Src_X
                AND     BL,7
                MOV     DX,Arg_Dst_X
                AND     DL,7
                CMP     BL,DL
                MOV     BH,1
                JLE     Fetches
                INC     BH
Fetches:
                RET

Compute_Phase   ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     Copy_Raster                                                  *
;* T°pus  :     Belsã elj†r†s                                                *
;* Le°r†s :     CopyBlock elj†r†s segÇdelj†r†sa                              *
;* Bemenet:     -                                                            *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

Copy_Raster     PROC FAR

                PUSH    SI
                PUSH    DI
                PUSH    ES
                PUSH    DI
                LEA     DI,Ras_Buffer
                MOV     AX,CS
                MOV     ES,AX
                MOV     DL,SrcPage
                CALL    _Select_Page_16
                MOV     CL,Phase
                CMP     First_Fetch,1
                JLE     Get_1
Get_2:
               LODSB
               MOV     AH,AL
Get_1:
                LODSB
                MOV     BH,AL
                ROR     AX,CL
                MOV     AH,BH
                STOSB
                MOV     BL,Full_Count
                XOR     BH,BH
                OR      BX,BX
                JZ      Last
Full_Loop:
                LODSB
                MOV     DH,AL
                SHR     AX,CL
                MOV     AH,DH
                STOSB
                DEC     BX
                JG      Full_Loop
Last:
                LODSB
                SHR     AX,CL
                STOSB
                POP     DI
                POP     ES
                LEA     SI,Ras_Buffer
                MOV     AX,CS
                MOV     DS,AX
                MOV     DL,DstPage
                CALL    _Select_Page_16
                MOV     DX,GRAPHICS_CTRL_PORT
                MOV     AL,BIT_MASK_REG
                MOV     AH,First_Mask
                OUT     DX,AX
                MOV     AH,ES:[DI]
                MOVSB
                MOV     AH,0FFh
                OUT     DX,AX
                MOV     CL,Full_Count
                XOR     CH,CH
                JCXZ    FullDone
                CMP     Arg_Fn,0
                JZ      FnSrc
FullLoop:
                MOV     AH,ES:[DI]
                MOVSB
                LOOP    FullLoop
                JMP     FullDone
FnSrc:
                REP     MOVSB
FullDone:
                MOV     AH,Last_Mask
                OUT     DX,AX
                MOV     AL,ES:[DI]
                MOVSB
                MOV     DS,Graf_Seg          ;Restore pointers
                POP     DI
                POP     SI
                RET

Copy_Raster     ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     Reset_Graphics_Controller                                    *
;* T°pus  :     Belsã elj†r†s                                                *
;* Le°r†s :     CopyBlock elj†r†s segÇdelj†r†sa                              *
;* Bemenet:     -                                                            *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

Reset_Graphics_Controller PROC FAR

                MOV     DX,GRAPHICS_CTRL_PORT
                MOV     AL,BIT_MASK_REG
                MOV     AH,0FFh
                OUT     DX,AX
                MOV     AL,Fn_SEL_REG
                MOV     AH,0
                OUT     DX,AX
                MOV     AL,READ_PLANE_REG
                OUT     DX,AX
                MOV     AL,SR_ENABLE_REG
                OUT     DX,AX
                MOV     DX,SEQUENCER_PORT
                MOV     AL,PLANE_ENABLE_REG
                MOV     AH,0Fh
                OUT     DX,AX
                RET

Reset_Graphics_Controller ENDP

;************************************************************************
;                                                                       *
; Select_Plane                                                          *
;       Select plane passed in DL for read and write                    *
;                                                                       *
; Entry: DL - Page number                                               *
;                                                                       *
;************************************************************************

Select_Plane    PROC FAR
        PUSH    DX
        MOV     AH,DL
        ;Enable read
        AND     AH,3                    ;Force into range
        MOV     DX,GRAPHICS_CTRL_PORT   ;Fetch register port
        MOV     AL,READ_PLANE_REG       ;Fetch register index
        OUT     DX,AX                   ;Select plane for read
        ;Enable write
        XCHG    AL,CL                   ;Preserve CL
        MOV     CL,AH                   ;Convert plane number
        MOV     AH,1                    ;  to bit position
        SHL     AH,CL
        XCHG    AL,CL                   ;Restore CL
        MOV     DX,SEQUENCER_PORT       ;Fetch register port
        MOV     AL,PLANE_ENABLE_REG     ;Fetch register index
        OUT     DX,AX                   ;Select plane for write
        POP     DX
        RET
Select_Plane    ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _CopyBlock_16                                               *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     VideoMemoria-Videomem¢ria †tvitel                            *
;* Bemenet:     CX: X1 koordin†ta , DX: Y1 koordin†ta                        *
;*              SI: X2 koordin†ta , DI: Y2 koordin†ta                        *
;*              AX: SzÇlessÇg     , BX: Magass†g                             *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************


_CopyBlock_16 PROC    FAR

                MOV     Arg_Src_X,CX
                MOV     Arg_Src_Y,DX
                MOV     Arg_Dst_X,SI
                MOV     Arg_Dst_Y,DI
                MOV     Arg_FN,BL
                MOV     Arg_DX,AX
                MOV     Arg_DY,BP
BitBlt16:
                PUSH    DS
                PUSH    ES
                PUSH    DI
                PUSH    SI
                MOV     CX,Video_Pitch
                MOV     Src_Pitch,CX
                MOV     Dst_Pitch,CX
                CALL    Reset_Graphics_Controller
                MOV     DX,GRAPHICS_CTRL_PORT
                MOV     AL,Fn_SEL_REG
                MOV     AH,Arg_Fn
                AND     AH,3
                SHL     AH,1
                SHL     AH,1
                SHL     AH,1
                OUT     DX,AX
                MOV     AX,Arg_Dst_Y
                CMP     AX,Arg_Src_Y
                JL      BB_XPYP
                JMP     BB_XPYN
BB_XPYP:        MOV     AX,Arg_Src_Y
                MUL     Video_Pitch
                MOV     CX,Arg_Src_X
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                ADC     DX,0
                MOV     DS,Graf_Seg
                MOV     SI,AX
                MOV     SrcPage,DL
                MOV     FirstSrc,DL
                MOV     AX,Arg_Dst_Y
                MUL     Video_Pitch
                MOV     CX,Arg_Dst_X
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                ADC     DX,0
                MOV     ES,Graf_Seg
                MOV     DI,AX
                MOV     DstPage,DL
                MOV     FirstDst,DL
                CALL    Compute_Phase
                MOV     First_Mask,AL
                MOV     Last_Mask,AH
                MOV     Phase,CL
                MOV     First_Fetch,BH
                MOV     Full_Count,CH
                MOV     Plane,3
XPYP_Plane_Loop:
                MOV     DL,Plane
                CALL    Select_Plane
                MOV     AL,FirstSrc
                MOV     SrcPage,AL
                MOV     AL,FirstDst
                MOV     DstPage,AL
                PUSH    SI
                PUSH    DI
                MOV     BX,Arg_DY
XPYP_Raster_Loop:
                PUSH    BX
                CALL    Copy_Raster
                POP     BX
                DEC     BX
                JLE     XPYP_RasterDone
                ADD     SI,Src_Pitch
                JNC     XPYP_NUSPage
                INC     SrcPage
XPYP_NUSPage:
                ADD     DI,Dst_Pitch
                JNC     XPYP_NUDPage
                INC     DstPage
XPYP_NUDPage:
                JMP     XPYP_Raster_Loop
XPYP_RasterDone:
                POP     DI
                POP     SI
                DEC     Plane
                JGE     XPYP_Plane_Loop
                JMP     End_BitBlt
BB_XPYN:
                MOV     AX,Arg_Src_Y
                ADD     AX,Arg_DY
                DEC     AX
                MOV     CX,Arg_Src_X
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                MUL     Video_Pitch
                ADD     AX,CX
                ADC     DX,0
                MOV     DS,Graf_Seg
                MOV     SI,AX
                MOV     SrcPage,DL
                MOV     FirstSrc,DL
                MOV     AX,Arg_Dst_Y
                ADD     AX,Arg_DY
                DEC     AX
                MOV     CX,Arg_Dst_X
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                MUL     Video_Pitch
                ADD     AX,CX
                ADC     DX,0
                MOV     ES,Graf_Seg
                MOV     DI,AX
                MOV     DstPage,DL
                MOV     FirstDst,DL
                CALL    Compute_Phase
                MOV     First_Mask,AL
                MOV     Last_Mask,AH
                MOV     Phase,CL
                MOV     First_Fetch,BH
                MOV     Full_Count,CH
                MOV     Plane,3
XPYN_Plane_Loop:
                MOV     DL,Plane
                CALL    Select_Plane
                MOV     AL,FirstSrc
                MOV     SrcPage,AL
                MOV     AL,FirstDst
                MOV     DstPage,AL
                PUSH    SI
                PUSH    DI
                MOV     BX,Arg_DY
XPYN_Raster_Loop:
               PUSH    BX
               CALL    Copy_Raster
               POP     BX
               DEC     BX
               JLE     XPYN_RasterDone
               SUB     SI,Src_Pitch
               JNC     XPYN_NUSPage
               DEC     SrcPage
XPYN_NUSPage:
               SUB     DI,Dst_Pitch
               JNC     XPYN_NUDPage
               DEC     DstPage
XPYN_NUDPage:
               JMP     XPYN_Raster_Loop
XPYN_RasterDone:
               POP     DI
               POP     SI
               DEC     Plane
               JGE     XPYN_Plane_Loop
               JMP     End_BitBlt

End_BitBlt:
                CALL    Reset_Graphics_Controller
                POP     SI
                POP     DI
                POP     ES
                POP     DS
                RET

_CopyBlock_16 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _CopyFromMem_16                                              *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     Mem¢ria-Videomem¢ria †tvitel                                 *
;* Bemenet:     CX: X1 koordin†ta , DX: Y1 koordin†ta                        *
;*              DS:SI= Mem¢ria c°m , DI= Logikai szÇlessÇg a mem¢ri†ban      *
;*              AX: SzÇlessÇg     , BX: Magass†g                             *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_CopyFromMem_16 PROC FAR

                RET

_CopyFromMem_16 ENDP


;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _CopyToMem_16                                                *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     VideoMem¢ria-Mem¢ria †tvitel                                 *
;* Bemenet:     CX: X1 koordin†ta , DX: Y1 koordin†ta                        *
;*              DS:SI= Mem¢ria c°m , DI= Logikai szÇlessÇg a mem¢ri†ban      *
;*              AX: SzÇlessÇg     , BX: Magass†g                             *
;* Kimenet:     -                                                            *
;*                                                                           *
;*****************************************************************************

_CopyToMem_16 PROC FAR

                RET

_CopyToMem_16 ENDP


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

_OutTextXY_16 PROC FAR

                PUSH    DS
                PUSH    BP
                MOV     Over,AH
                MOV     TextColor,BL
                MOV     TextBackColor,BH
                MOV     TextSeg,ES
                MOV     TextOfs,DI
                MOV     AX,DX
                MUL     Video_Pitch
                MOV     Arg_X,CX
                SHR     CX,1
                SHR     CX,1
                SHR     CX,1
                ADD     AX,CX
                MOV     StartOfs,AX
                MOV     CX,Arg_X
                AND     CX,7
                MOV     First_Mask,0FFh
                SHR     First_Mask,CL
                MOV     AX,8
                SUB     AX,CX
                MOV     Rotation,AX
                MOV     StartPage,DL
                MOV     BL,TextColor
                MOV     BH,TextBackColor
                MOV     TextLine,0
                MOV     DX,GRAPHICS_CTRL_PORT   ;Use color for set/reset value
                MOV     AL,SR_ENABLE_REG
                MOV     AH,0Fh
                OUT     DX,AX
                CMP     Over,0
                JZ      LoopTextNoOver
                JMP     LoopTextOver
LoopTextNoOver:
                MOV     TextMask,0
                PUSH    DX
                MOV     DL,StartPage
                MOV     PageNo,DL
                CALL    _Select_Page_16
                POP     DX
                MOV     DI,TextOfs
                MOV     SI,StartOfs
LoopCharsNoOver:
                MOV     TextRow,0
                MOV     BP,CharGenOfs
                MOV     ES,TextSeg
                MOV     AH,0
                MOV     AL,ES:[DI]
                OR      AL,AL
                JNZ     OkTNo
                JMP     End_TextNoOver
OkTNo:
                MUL     CharByte
                ADD     BP,AX
                MOV     AX,CharXByte
                MUL     TextLine
                ADD     BP,AX
LoopCharsNoOver2:
                MOV     ES,CharGenSeg
                MOV     DX,GRAPHICS_CTRL_PORT   ;Use color for set/reset value
                MOV     AH,BL
                MOV     AL,SET_RESET_REG
                OUT     DX,AX
                MOV     AH,0
                MOV     AL,ES:[BP]
                MOV     CX,Rotation
                SHL     AX,CL
                OR      AH,TextMask
                MOV     TextMask,AL
                MOV     AL,BIT_MASK_REG         ;Select bit mask register
                OUT     DX,AX
                MOV     ES,Graf_Seg
                MOV     AH,ES:[SI]
                MOV     ES:[SI],AL
                ADD     SI,1
                JNC     NoPageNoOver
                INC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
NoPageNoOver:
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
                MOV     DX,GRAPHICS_CTRL_PORT   ;Use color for set/reset value
                MOV     AH,BL
                MOV     AL,SET_RESET_REG
                OUT     DX,AX
                MOV     AH,TextMask
                MOV     AL,BIT_MASK_REG         ;Select bit mask register
                OUT     DX,AX
                MOV     ES,Graf_Seg
                MOV     AH,ES:[SI]
                MOV     ES:[SI],AL
                INC     TextLine
                MOV     AX,TextLine
                CMP     AX,CharY
                JNZ     NeNoOvv
                JMP     End_TextOut
NenOOvv:
                MOV     AX,Video_Pitch
                ADD     StartOfs,AX
                JNC     JumpBackNoOver
                INC     StartPage
JumpBackNoOver:
                JMP     LoopTextNoOver
LoopTextOver:
                MOV     TextMask,0
                PUSH    DX
                MOV     DL,StartPage
                MOV     PageNo,DL
                CALL    _Select_Page_16
                POP     DX
                MOV     DI,TextOfs
                MOV     SI,StartOfs
                MOV     AL,First_Mask
                MOV     FirstMask,AL
LoopCharsOver:
                MOV     TextRow,0
                MOV     BP,CharGenOfs
                MOV     ES,TextSeg
                MOV     AH,0
                MOV     AL,ES:[DI]
                OR      AL,AL
                JNZ     OkT
                JMP     End_TextOver
OkT:
                MUL     CharByte
                ADD     BP,AX
                MOV     AX,CharXByte
                MUL     TextLine
                ADD     BP,AX
LoopCharsOver2:
                MOV     ES,CharGenSeg
                MOV     DX,GRAPHICS_CTRL_PORT   ;Use color for set/reset value
                MOV     AH,BH
                MOV     AL,SET_RESET_REG
                OUT     DX,AX
                MOV     AH,0
                MOV     AL,ES:[BP]
                MOV     CX,Rotation
                SHL     AX,CL
                OR      AH,TextMask
                MOV     AL,BIT_MASK_REG         ;Select bit mask register
                NOT     AH
                AND     AH,FirstMask
                MOV     FirstMask,0FFh
                OUT     DX,AX
                MOV     ES,Graf_Seg
                MOV     AH,ES:[SI]
                MOV     ES:[SI],AL
                MOV     AH,BL
                MOV     AL,SET_RESET_REG
                OUT     DX,AX
                MOV     AH,0
                MOV     ES,CharGenSeg
                MOV     AL,ES:[BP]
                MOV     CX,Rotation
                SHL     AX,CL
                OR      AH,TextMask
                MOV     TextMask,AL
                MOV     AL,BIT_MASK_REG         ;Select bit mask register
                OUT     DX,AX
                MOV     ES,Graf_Seg
                MOV     AH,ES:[SI]
                MOV     ES:[SI],AL
                ADD     SI,1
                JNC     NoPageOver
                INC     PageNo
                PUSH    DX
                MOV     DL,PageNo
                CALL    _Select_Page_16
                POP     DX
NoPageOver:
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
                MOV     AL,First_Mask
                NOT     AL
                MOV     FirstMask,AL
                MOV     DX,GRAPHICS_CTRL_PORT   ;Use color for set/reset value
                MOV     AH,BH
                MOV     AL,SET_RESET_REG
                OUT     DX,AX
                MOV     AH,TextMask
                MOV     AL,BIT_MASK_REG         ;Select bit mask register
                NOT     AH
                AND     AH,FirstMask
                OUT     DX,AX
                MOV     ES,Graf_Seg
                MOV     AH,ES:[SI]
                MOV     ES:[SI],AL
                MOV     AH,BL
                MOV     AL,SET_RESET_REG
                OUT     DX,AX
                MOV     AH,TextMask
                MOV     AL,BIT_MASK_REG         ;Select bit mask register
                OUT     DX,AX
                MOV     ES,Graf_Seg
                MOV     AH,ES:[SI]
                MOV     ES:[SI],AL
                INC     TextLine
                MOV     AX,TextLine
                CMP     AX,CharY
                JNZ     NeNoOv
                JMP     End_TextOut
NenOOv:
                MOV     AX,Video_Pitch
                ADD     StartOfs,AX
                JNC     JumpBackOver
                INC     StartPage
JumpBackOver:
                JMP     LoopTextOver
End_TextOut:
                POP     BP
                POP     DS
                RET

_OutTextXY_16 ENDP



;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _SetChars_16                                                *
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

_SetChars_16 PROC FAR

              MOV     CharByte,SI      ; Karakter le°ro byte-sz†m
              MOV     CharXByte,AX     ; Karakter szÇlessÇg byte-ban
              MOV     CharX,CX         ; Karakter szÇlessÇg pixelben
              MOV     CharY,DX         ; Karakter magass†ga pixelben
              MOV     CharGenSeg,ES    ; A ES:BP †ltal megc°mzett
              MOV     CharGenOfs,BP    ; Karaktergener†tor be†ll°t†sa
              RET                      ; VisszatÇrÇs

_SetChars_16 ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:   _GetActPage                                                    *
;* T°pus  :   KÅlsã elj†r†s                                                  *
;* Le°r†s :   Akt°v page lekÇrdezÇs                                          *
;* Bemenet:   -                                                              *
;* Kimenet:  AL= Akt°v page                                                  *
;*                                                                           *
;*****************************************************************************

_GetActPage_16 PROC FAR

              MOV     AL,ActPage       ; DL=ActPage
              RET                      ; VisszatÇrÇs

_GetActPage_16 ENDP

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
;***                     TGraph_16 End                                    ***
;***                                                                       ***
;*****************************************************************************

END