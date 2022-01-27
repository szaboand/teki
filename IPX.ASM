;*****************************************************************************
;***                                                                       ***
;***             (C) Szab¢ Andr†s 1999 Budapest-Hungary                    ***
;***                                                                       ***
;***                         IPX Routines V1.1                             ***
;***                                                                       ***
;*****************************************************************************

;****************** Utols¢ m¢dos°t†s: 1999.01.08. ****************************

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


	PUBLIC _IPXInit
        PUBLIC _IPXGetAddress
        PUBLIC _IPXGetMaxPacketSize
        PUBLIC _IPXOpenSocket
        PUBLIC _IPXCloseSocket
        PUBLIC _IPXListenForPacket
        PUBLIC _IPXSendPacket
        PUBLIC _IPXRelenquishControl

;*****************************************************************************
;***                                                                       ***
;***                  Assembler v†ltoz¢k deklar†ci¢ja                      ***
;***                                                                       ***
;*****************************************************************************

_IPXEntry DD 0                  ; IPX belÇpÇsi pont

;*****************************************************************************
;***                                                                       ***
;***                          Assembler elj†r†sok                          ***
;***                                                                       ***
;*****************************************************************************

;*****************************************************************************
;*                                                                           *
;* Elj†r†s:     _IPXInit                                                     *
;* T°pus  :     KÅlsã elj†r†s                                                *
;* Le°r†s :     IPX driver install†lts†g ellenãrzÇse                         *
;* Bemenet:     -                                                            *
;* Kimenet:     DX:AX belÇpÇsi pont, ha install†lt, egyÇbkÇnt DX=0, AX=0     *
;*                                                                           *
;*****************************************************************************

_IPXInit PROC FAR

    MOV AX,7A00h
    INT 2Fh
    CMP AL,0FFh
    JNZ _IPXInit_Exit
    MOV word ptr [_IPXEntry+0],di
    MOV word ptr [_IPXEntry+2],es
_IPXInit_Exit:
    MOV dx,word ptr [_IPXEntry+2]
    MOV ax,word ptr [_IPXEntry+0]
    RET

_IPXInit ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s: _IPXGetAddress                                                   *
;* T°pus  : KÅlsã elj†r†s                                                    *
;* Le°r†s : IPX c°m lekÇrdezÇse                                              *
;* Bemenet: ES:SI puffer a c°mnek (10 byte)                                  *
;* Kimenet: ES:SI feltîltîtt puffer c°me                                     *
;*                                                                           *
;*****************************************************************************

_IPXGetAddress PROC FAR

    MOV bx,0009h
    CALL [_IPXEntry]
    RET

_IPXGetAddress ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s: _IPXGetMaxPacketSize                                             *
;* T°pus  : KÅlsã elj†r†s                                                    *
;* Le°r†s : IPX packet maxim†lis mÇretÇnek lekÇrdezÇs                        *
;* Bemenet: -                                                                *
;* Kimenet: AX: Packet size with preamble                                    *
;*          CX: IPX retry count                                              *
;*                                                                           *
;*****************************************************************************

_IPXGetMaxPacketSize PROC FAR

    MOV bx,001Ah
    CALL [_IPXEntry]
    RET

_IPXGetMaxPacketSize ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s: _IPXOpenSocket                                                   *
;* T°pus  : KÅlsã elj†r†s                                                    *
;* Le°r†s : IPX socket nyit†sa                                               *
;* Bemenet: AL: Socket longevity                                             *
;*          DX: Socket number (0000: dinamikus allok†ci¢)                    *
;* Kimenet: AL: Hibak¢d (00 ha sikerÅlt)                                     *
;*          DX: Socket sz†m                                                  *
;*                                                                           *
;*****************************************************************************

_IPXOpenSocket PROC FAR

    MOV  BX,0000h
    CALL [_IPXEntry]
    MOV  AH,00h
    RET

_IPXOpenSocket ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s: _IPXCloseSocket                                                  *
;* T°pus  : KÅlsã elj†r†s                                                    *
;* Le°r†s : IPX socket lez†r†sa                                              *
;* Bemenet: DX: Socket number (high byte in DL!)                             *
;* Kimenet: -                                                                *
;*                                                                           *
;*****************************************************************************

_IPXCloseSocket PROC FAR

    MOV  BX,0001h
    CALL [_IPXEntry]
    RET

_IPXCloseSocket ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s: _IPXListenForPacket                                              *
;* T°pus  : KÅlsã elj†r†s                                                    *
;* Le°r†s : IPX packet lekÇrdezÇse                                           *
;* Bemenet: ES:SI = Event Control Block c°me                                 *
;* Kimenet: AL : status (00:OK, $FF: No listening socket for packet          *
;*                                                                           *
;*****************************************************************************

_IPXListenForPacket PROC FAR

    MOV BX,0004h
    CALL [_ipxentry]
    MOV AH,00h
    RET

_IPXListenForPacket ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s: _IPXSendPacket                                                   *
;* T°pus  : KÅlsã elj†r†s                                                    *
;* Le°r†s : IPX packet kÅldÇse                                               *
;* Bemenet: ES:SI = Event Control Block c°me                                 *
;* Kimenet: -                                                                *
;*                                                                           *
;*****************************************************************************

_IPXSendPacket PROC FAR

    MOV bx,0003h
    CALL [_ipxentry]
    RET

_IPXSendPacket ENDP

;*****************************************************************************
;*                                                                           *
;* Elj†r†s: _IPXRelequishControl                                             *
;* T°pus  : KÅlsã elj†r†s                                                    *
;* Le°r†s : -                                                                *
;* Bemenet: -                                                                *
;* Kimenet: -                                                                *
;*                                                                           *
;*****************************************************************************

_IPXRelenquishControl PROC FAR

    MOV BX,000Ah
    CALL [_ipxentry]
    RET

_IPXRelenquishControl ENDP

;*****************************************************************************
;***                                                                       ***
;***                            IPX Routines End                           ***
;***                                                                       ***
;*****************************************************************************

END

