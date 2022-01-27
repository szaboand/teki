Unit TObjects;
{*****************************************************************************
******************************************************************************
*                            TObjects 4.1e (01)                              *
*                        1997.04.02. - 2000.07.02.                           *
*                       (P) Szab¢ Andr s 1984-1998                           *
*                       (C) TwinNet Kft. 1997-1998                           *
******************************************************************************
*****************************************************************************}

{*****************************************************************************
*                                                                            *
*     Megval¢s¡tott objektumok:                                              *
*        - Icon                                                              *
*        - Button                                                            *
*        - CButton                                                           *
*        - Text                                                              *
*        - EditWindows                                                       *
*        - RButton                                                           *
*                                                                            *
*****************************************************************************}

Interface

Uses TObject,TWSys; { TObject V4.1d ; TWSys V1.1a }

{****************************************************************************}
{***                            IconType                                  ***}
{***                    (C) Szab¢ Andr s 1997.06.05.                      ***}
{****************************************************************************}

Type
 IconType            = object (TObjectType)
  BitMap             : pointer;                { Ikon le¡r¢ c¡me             }
  LDX                : word;                   { BitMap logikai sz‚less‚g    }
  BackColor          : byte;                   { Ikon t”rl‚s sz¡ne           }

  Constructor Init(IDD,XX,YY,DXX,DYY:word;BMP:pointer); { Inicializ l s      }
  Procedure   Draw;virtual;                    { Rajzol¢ elj r s             }
  Procedure   Hide;virtual;                    { Eltntet‹ elj r s           }
 end;

{****************************************************************************}
{***                            TextType                                  ***}
{***                    (C) Szab¢ Andr s 1997.06.06.                      ***}
{****************************************************************************}

 TextType            = object (TObjectType)
  CDX,CDY            : word;                   { Sz‚less‚g/Magass g karakterben}
  EX,EY              : word;                   { X,Y ir ny£ eltol s          }
  TextPointer        : pointer;                { Sz”veg le¡r¢ c¡me           }
  BackColor          : byte;                   { Sz”veg t”rl‚s sz¡ne         }
  TextColor          : byte;                   { Sz”vegsz¡n                  }
  TextBackColor      : byte;                   { Sz”vegh tt‚rsz¡n            }
  Chars              : byte;                   { Karakterk‚szlet k¢dja       }
  LineSpace          : word;                   { Sorok k”z”tti hely          }
  TextOver           : boolean;                { Fell¡r s jelz‹je           }
  TextFlag           : word;                   { Jelz‹bitek                  }
  ControlCode        : byte;                   { Vez‚rl‹ k¢dok kezdet‚t jelz‹}

  Constructor Init(IDD,XX,YY,DXX,DYY:word;TP:pointer); { Inicializ l s       }
  Procedure   Draw;virtual;                    { Rajzol¢ elj r s             }
  Procedure   Hide;virtual;                    { Eltntet‹ elj r s           }
 end;

{****************************************************************************}
{***                            ButtonType                                ***}
{***                    (C) Szab¢ Andr s 1997.06.05.                      ***}
{****************************************************************************}

 ButtonType          = object (TObjectType)
  BText              : string [100];           { Button sz”veg               }
  TX,TY              : word;                   { Button sz”veg X,Y koordin ta}
  BackColor          : byte;                   { Button t”rl‚s szine         }
  ButtonColor        : byte;                   { Button sz¡n                 }
  DarkColor          : byte;                   { S”t‚t keretsz¡n             }
  LightColor         : byte;                   { Vil gos keretsz¡n           }
  TextColor          : byte;                   { Sz”vegsz¡n                  }
  OffTextColor       : byte;                   {Kikapcsolt  llapot sz”vegsz¡n}
  BorderColor        : byte;                   { Keretsz¡n                   }
  MFocusBorderColor  : byte;                   { Mouse f¢kusz lt keretsz¡n   }
  KFocusTextColor    : byte;                   { Key f¢kusz lt sz”vegsz¡n    }
  KFocusBorderColor  : byte;                   { Key f¢kusz lt keretsz¡n     }
  BFlags             : byte;                   { Button jelz‹bitek           }
  Chars              : byte;                   { Karakterk‚szlet k¢dja       }
  IX,IY              : word;                   { Ikon X,Y koordin ta         }
  IDX,IDY            : word;                   { Ikon sz‚less‚g,magass g     }
  IconShape          : pointer;                { Ikon mutat¢                 }
  IconMask           : pointer;                { Ikon maszk mutat¢           }

  Constructor Init(IDD,XX,YY:word;tText:string);{ Inicializ l¢ elj r s       }
  Procedure   Draw;virtual;                    { Rajzol¢ elj r s             }
  Procedure   Hide;virtual;                    { Eltntet‹ elj r s           }

  Procedure   MouseFocusOff;virtual;           { Mouse f¢kusz ki             }
  Procedure   KeyFocusOff;virtual;             { Billentû f¢kusz ki          }

  Procedure   MouseLeftButtonPush;virtual;     { Mouse bal gomb le           }
  Procedure   MouseLeftButtonPop;virtual;      { Mouse bal gomb fel          }

  Procedure   KeyPush;virtual;                 { Billentyû lenyom s          }
  Procedure   KeyPop;virtual;                  { Billentyû felenged‚s        }

  Procedure   DoButton;virtual;                { Gomb parancs v‚grehajt s    }
 end;

{****************************************************************************}
{***                            CButtonType                                ***}
{***                    (C) Szab¢ Andr s 1997.07.11.                      ***}
{****************************************************************************}

 CButtonType          = object (TObjectType)
  BText              : string [100];           { CButton sz”veg              }
  TX,TY              : word;                   { CButton sz”veg X,Y koord.   }
  BX,BY              : word;                   { Border sz‚less‚g/magass g   }
  CDX                : word;                   { Sz”veg ‚s mez‹ k”z”tti hely }
  BackColor          : byte;                   { CButton t”rl‚s szine        }
  CButtonBackColor   : byte;                   { CButton hatt‚rsz¡n          }
  DarkColor          : byte;                   { S”t‚t keretsz¡n             }
  LightColor         : byte;                   { Vil gos keretsz¡n           }
  TextColor          : byte;                   { Sz”vegsz¡n                  }
  OffTextColor       : byte;                   {Kikapcsolt  llapot sz”vegsz¡n}
  BorderColor        : byte;                   { Keretsz¡n                   }
  MFocusBorderColor  : byte;                   { Mouse f¢kusz lt keretsz¡n   }
  KFocusTextColor    : byte;                   { Key f¢kusz lt sz”vegsz¡n    }
  Chars              : byte;                   { Karakterk‚szlet k¢dja       }
  Value              : byte;                   { CButton  llapot             }
  MaxValue           : byte;                   { Max ‚rt‚k                   }
  ValueChars         : string[255];            { Value szimb¢lumok           }
  CBFlag             : word;                   { Jelz‹bitek                  }

  Constructor Init(IDD,XX,YY:word;tText:string;V:word);{ Inicializ l¢ elj r s}
  Procedure   Draw;virtual;                    { Rajzol¢ elj r s             }
  Procedure   Hide;virtual;                    { Eltntet‹ elj r s           }

  Procedure   ChangeValue;virtual;             { rt‚kv ltoztat s            }
  Procedure   MouseLeftButtonPush;virtual;     { Mouse bal gomb le           }
  Procedure   KeyPush;virtual;                 { Billentyû lenyom s          }

  Procedure   DoCButton;virtual;               { Gomb parancs v‚grehajt s    }
 end;

{****************************************************************************}
{***                              EditType                                ***}
{***                    (C) Szab¢ Andr s 1998.02.07.                      ***}
{****************************************************************************}

 EditType          = object (TObjectType)
  CDX,CDY            : word;                   { Sz‚less‚g/Magass g karakterben}
  EX,EY              : word;                   { X,Y ir ny£ eltol s          }
  TextPointer        : pointer;                { Sz”veg le¡r¢ c¡me           }
  BackColor          : byte;                   { Sz”veg t”rl‚s sz¡ne         }
  TextColor          : byte;                   { Sz”vegsz¡n                  }
  TextBackColor      : byte;                   { Sz”vegh tt‚rsz¡n            }
  Chars              : byte;                   { Karakterk‚szlet k¢dja       }
  LineSpace          : word;                   { Sorok k”z”tti hely          }
  TextOver           : boolean;                { Fell¡r s jelz‹je           }
  TextFlag           : word;                   { Jelz‹bitek                  }
  ControlCode        : byte;                   { Vez‚rl‹ k¢dok kezdet‚t jelz‹}

  EditText           : string;                 { Edit sz”veg                 }
  EditFlag           : word;                   { Jelz‹bitek                  }
  DBorderColor       : byte;                   { S”t‚t keretsz¡n             }
  LBorderColor       : byte;                   { Vil gos keretsz¡n           }
  CursorX            : byte;                   { Sz”vegkurzor pozici¢ja      }
  CursorColor        : byte;                   { Sz”vegkurzor szine          }
  MaxTextLength      : byte;                   { Max sz”veghossz             }
  KFocusTextColor    : byte;                   { Sz”vegszin bill. f¢kuszn l  }
  KFocusTextBackColor: byte;                   { Sz”veghszin bill. f¢kuszn l }

  Constructor Init(IDD,XX,YY,DXX:word;SString:string);{ Inicializ l s        }
  Procedure   InsertChar;                      { Karakterbeszur s            }
  Procedure   Draw;virtual;                    { Rajzol¢ elj r s             }
  Procedure   Hide;virtual;                    { Eltntet‹ elj r s           }
  Procedure   ShowCursor;                      { Kurzor megjelen¡t‚s         }
  Procedure   HideCursor;                      { Kurzor eltntet‚s           }
  Procedure   KeyFocusOn;virtual;              { Bill. f¢kusz be             }
  Procedure   KeyFocusOff;virtual;             { Bill. f¢kusz ki             }
  Procedure   KeyPush;virtual;                 { Bill. lenyom s              }
  Procedure   ControlKey;virtual;              { Enter/Esc bill. lenymom sa  }
  Procedure   MouseLeftButtonPush;virtual;     { Mouse bal gomb le           }
 end;

{****************************************************************************}
{***                            RButtonType                               ***}
{***                    (C) Szab¢ Andr s 1998.09.13.                      ***}
{****************************************************************************}

 RButtonType          = object (TObjectType)
  BText              : string [100];           { RButton sz”veg              }
  TX,TY              : word;                   { RButton sz”veg X,Y koord.   }
  BX,BY              : word;                   { Border sz‚less‚g/magass g   }
  CDX                : word;                   { Sz”veg ‚s mez‹ k”z”tti hely }
  BackColor          : byte;                   { RButton t”rl‚s szine        }
  RButtonBackColor   : byte;                   { RButton hatt‚rsz¡n          }
  DarkColor          : byte;                   { S”t‚t keretsz¡n             }
  LightColor         : byte;                   { Vil gos keretsz¡n           }
  TextColor          : byte;                   { Sz”vegsz¡n                  }
  OffTextColor       : byte;                   {Kikapcsolt  llapot sz”vegsz¡n}
  BorderColor        : byte;                   { Keretsz¡n                   }
  MFocusBorderColor  : byte;                   { Mouse f¢kusz lt keretsz¡n   }
  KFocusTextColor    : byte;                   { Key f¢kusz lt sz”vegsz¡n    }
  Chars              : byte;                   { Karakterk‚szlet k¢dja       }
  Value              : byte;                   { RButton  llapot             }
  RGroup             : word;                   { RButton csoportjelz‹        }
  ValueChar          : char;                   { RButton ON jelz‹ karakter   }
  RBFlag             : word;                   { Jelz‹bitek                  }

  Constructor Init(IDD,XX,YY:word;tText:string;RG,V:word);{ Inicializ l¢ elj.}
  Procedure   Draw;virtual;                    { Rajzol¢ elj r s             }
  Procedure   Hide;virtual;                    { Eltntet‹ elj r s           }
  Procedure   SetValue;                        { rt‚kbe ll¡t s              }
  Function    GetValue:word;                   { Csoport‚rt‚k lek‚rdez‚se    }

  Procedure   MouseLeftButtonPush;virtual;     { Mouse bal gomb le           }
  Procedure   KeyPush;virtual;                 { Billentyû lenyom s          }

  Procedure   DoRButton;virtual;               { Gomb parancs v‚grehajt s    }
  Procedure   NextRButton;virtual;             { K”vetkez‹ RButton be ll¡t sa}
  Procedure   PrevRButton;virtual;             { El”z‹ RButton be ll¡t sa    }
 end;

{****************************************************************************}
{***                            Konstansok                                ***}
{****************************************************************************}
Const

 Char8x8                                  = $01;
 Char8x14                                 = $02;
 Char8x16                                 = $03;

 TextControlFlag                          = $0001;
 ASCIIControlFlag                         = $0002;
 TextControlCode                          = ord ('þ');
 TCC_SetDefault                           = ord ('D');
 TCC_SetTextColor                         = ord ('T');
 TCC_SetTextBackColor                     = ord ('B');

 ST_BackColor               : byte        = $07;
 ST_TextColor               : byte        = $00;
 ST_TextBackColor           : byte        = $01;

 ST_ButtonColor             : byte        = $07;
 ST_ButtonDarkColor         : byte        = $08;
 ST_ButtonLightColor        : byte        = $0F;
 ST_ButtonTextColor         : byte        = $00;
 ST_ButtonOffTextColor      : byte        = $08;
 ST_ButtonBorderColor       : byte        = $00;
 ST_ButtonMFocusBorderColor : byte        = $00;
 ST_ButtonKFocusTextColor   : byte        = $04;
 ST_ButtonKFocusBorderColor : byte        = $00;

 ST_CButtonBorderColor      : byte        = $00;
 ST_CButtonTextColor        : byte        = $00;
 ST_CButtonDarkColor        : byte        = $08;
 ST_CButtonLightColor       : byte        = $0F;
 ST_CButtonBackColor        : byte        = $07;
 ST_CButtonMFocusBorderColor: byte        = $02;
 ST_CButtonKFocusTextColor  : byte        = $04;
 ST_CButtonOffTextColor     : byte        = $08;

 ST_EditDBorderColor        : byte        = $08;
 ST_EditLBorderColor        : byte        = $0F;
 ST_EditCursorColor         : byte        = $0E;
 ST_EditKFocusTextColor     : byte        = $0F;
 ST_EditKFocusTextBackColor : byte        = $00;

 ST_RButtonBorderColor      : byte        = $00;
 ST_RButtonTextColor        : byte        = $00;
 ST_RButtonDarkColor        : byte        = $08;
 ST_RButtonLightColor       : byte        = $0F;
 ST_RButtonBackColor        : byte        = $07;
 ST_RButtonMFocusBorderColor: byte        = $02;
 ST_RButtonKFocusTextColor  : byte        = $04;
 ST_RButtonOffTextColor     : byte        = $08;

 KeyTable_HU                : array [0..86] of char =
  (' ',' ','1','2','3','4','5','6','7','8','9','”','','¢',' ',' ',
   'q','w','e','r','t','z','u','i','o','p','‹','£',' ',' ',
   'a','s','d','f','g','h','j','k','l','‚',' ','0',' ','û',
   'y','x','c','v','b','n','m',',','.','-',' ','*',' ',' ',' ',' ',' ',
   ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','-',' ',
   ' ',' ','+',' ',' ',' ',' ',' ',' ',' ','¡');

  KeyTable_HU_Shift          : array [0..86] of char =
  (' ',' ','1','"','+','!','%','/','=','(',')','™','š','à',' ',' ',
   'Q','W','E','R','T','Z','U','I','O','P','Š','é',' ',' ',
   'A','S','D','F','G','H','J','K','L','','µ','',' ','ë',
   'y','x','c','v','b','n','m','?',':','_',' ',' ',' ',' ',' ',' ',' ',
   ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
   ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','¡');

   KeyTable_HU_AltGr          : array [0..86] of char =
  (' ',' ','~',' ','^','ô','ø','','`','ú','ï','ñ','','÷',' ',' ',
   '\','|',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
   ' ',' ',' ','[',']',' ',' ','ˆ','','$','á',' ',' ','Ï',
   '>','#','&','@','{','}',' ',';',' ','*',' ',' ',' ',' ',' ',' ',' ',
   ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
   ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','<');

 Fl_ButtonPush              : word        = $0001;

 EndOfText                  : byte        = $00;
 EndOfLine                  : byte        = $0A;

 UnknowObject                             = $0000;
 IconTypeObject                           = $0001;
 TextTypeObject                           = $0002;
 ButtonTypeObject                         = $0003;
 CButtonTypeObject                        = $0004;
 EditTypeObject                           = $0005;
 RButtonTypeObject                        = $0006;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Implementation

{****************************************************************************}
{***                          Seg‚delj r sok                              ***}
{****************************************************************************}

Procedure _SetChars(K:byte);
Begin
Case K of
     Char8x8    : ROM_8x8;
     Char8x14   : ROM_8x14;
     Char8x16   : ROM_8x16;
     end;
End;

Procedure _TextOut(X,Y,DX,DY,EX,EY,LS:word;TP:pointer;F:word;DTC,DBC:byte);
var z:^byte;mi:string;EXX,DXX:word;
Begin
Z:=TP;
while DY>0 do
      begin
      DXX:=DX;mi:='';EXX:=EX;
      while (Z^<>EndOfText) and (Z^<>EndOfLine) do
            begin
            If (Z^=TextControlCode) and (F and TextControlFlag<>0)
               then begin
                    Inc(Z);
                    repeat
                          Case Z^ of
                               TCC_SetDefault      : begin SetColor(DTC);SetTextBackColor(DBC);end;
                               TCC_SetTextColor    : begin Inc(Z);SetColor(Z^);end;
                               TCC_SetTextBackColor: begin Inc(Z);SetTextBackColor(Z^);end;
                               end;
                    Inc(z);
                    until Z^=TextControlCode;
                    end
               else If EXX=0
                       then If DXX>0
                            then If (F and ASCIIControlFlag=0) or (Z^<>13)
                                    then begin mi:=mi+chr(z^);Dec(DXX);end
                                    else
                            else
                       else Dec(EXX);
            Inc(z);
            end;
      while DXX>0 do begin mi:=mi+' ';Dec(DXX);end;
      If EY=0
         then begin OutStringXY(X,Y,mi);Inc(Y,GetCharY+LS);Dec(DY);end
         else Dec(EY);
      IF Z^=EndOfLine then Inc(z);
      end;
End;

{***************************** IconType met¢dusai ***************************}

Procedure IconType.Draw;
Begin
If BitMap=nil then exit;
MouseHide;CopyFromMem(X,Y,DX,DY,LDX,BitMap^);MouseShow;
End;

Constructor IconType.Init(IDD,XX,YY,DXX,DYY:word;BMP:pointer) ;
Begin
LDX:=DXX;BitMap:=BMP;BackColor:=ST_BackColor;
Inherited Init(IDD,IconTypeObject,XX,YY,DXX,DYY);
End;

Procedure IconType.Hide;
Begin
Inherited Hide;
if BitMap=nil then Exit;
MouseHide;SetColor(BackColor);Bar(X,Y,X+DX,Y+DY);MouseShow;
End;

{***************************** TextType met¢dusai ***************************}

Procedure TextType.Draw;
Begin
SetColor(TextColor);SetTextBackColor(TextBackColor);
SetTextOver(byte(TextOver));_SetChars(Chars);
_TextOut(X,Y,CDX,CDY,EX,EY,LineSpace,TextPointer,TextFlag,TextColor,TextBackColor);
End;


Constructor TextType.Init(IDD,XX,YY,DXX,DYY:word;TP:pointer);
Begin
CDX:=DXX;CDY:=DYY;TextPointer:=TP;
EX:=0;EY:=0;LineSpace:=0;BackColor:=ST_BackColor;
TextColor:=ST_TextColor;TextBackColor:=ST_TextBackColor;
Chars:=2;TextOver:=true;TextFlag:=ASCIIControlFlag;
Inherited Init(IDD,TextTypeObject,XX,YY,DXX*8,DYY*(14+LineSpace));
Mask:=C_TObjectMouseFocusMask+C_TObjectKeyFocusMask;
End;

Procedure TextType.Hide;
Begin
Inherited Hide;MouseHide;
SetColor(BackColor);Bar(X,Y,X+DX,Y+DY-2);
MouseShow;
End;

{**************************** ButtonType met¢dusai **************************}

Procedure ButtonType.Draw;
Var I,J,TXX,TYY,X2,Y2:word;Text:string;Ma,Sh:^byte;
Begin
MouseHide;
x2:=x+dx;y2:=y+dy;_SetChars(Chars);Text:=BText;Ma:=IconMask;Sh:=IconShape;
If Flag and C_TObjectReDrawFlag<>0 then
   begin
   SetColor(ButtonColor);Bar(x+1,y+1,x2-1,y2-1);
   Flag:=Flag and (65535-C_TObjectReDrawFlag);
   end;
if Flag and C_TObjectMouseFocusFlag=0
   then SetColor(BorderColor) else SetColor(MFocusBorderColor);
if Flag and C_TObjectKeyFocusFlag<>0 then SetColor(KFocusBorderColor);
Rectangle(x,y,x2,y2);
If BFlags and 1=0 { Push }
   then begin
        Setcolor(DarkColor);
        Line(x2-1,y+1,x2-1,y2-1);Line(x2-2,y+2,x2-2,y2-1);
        Line(x+1,y2-1,x2-1,y2-1);Line(x+2,y2-2,x2-1,y2-2);
        Setcolor(LightColor);
        Line(x+1,y+1,x2-2,y+1);Line(x+1,y+1,x+1,y2-2);
        Line(x+2,y+1,x+2,y2-3);
        TXX:=TX;TYY:=TY;
        If SH<>nil
           then If Ma<>nil
                then For j:=0 to IDY-1 do
                         for i:=0 to IDX-1 do
                             begin
                             if Ma^=1 then PutPixel(X+IX+I,Y+IY+J,Sh^);
                             Inc(Sh);Inc(Ma);
                             end
                else For j:=0 to IDY-1 do
                         for i:=0 to IDX-1 do
                             begin PutPixel(X+IX+I,Y+IY+J,Sh^);Inc(Sh);end;
        end
   else begin
        Setcolor(ButtonColor);
        Line(x2-1,y+1,x2-1,y2-1);Line(x2-2,y+2,x2-2,y2-1);
        Line(X+2,y2-2,x2-1,y2-2);Line(X+1,y2-1,x2-1,y2-1);
        Line(X+2,y+1,X+2,y2-3);
        Setcolor(DarkColor);
        Line(X+1,y+1,x2-2,y+1);Line(X+1,y+1,X+1,y2-2);
        Line(x2-1,y+1,x2-1,y2-1);Line(X+1,y2-1,x2-1,y2-1);
        TXX:=TX+1;TYY:=TY+1;
        If SH<>nil
           then If Ma<>nil
                then For j:=1 to IDY do
                         for i:=1 to IDX do
                             begin
                             if Ma^=1 then PutPixel(X+IX+I,Y+IY+J,Sh^);
                             Inc(Sh);Inc(Ma);
                             end
                else For j:=1 to IDY do
                         for i:=1 to IDX do
                             begin PutPixel(X+IX+I,Y+IY+J,Sh^);Inc(Sh);end;
        end;
if Text<>''
   then begin
        If Flag and C_TObjectOnFlag=0
           then SetColor(OffTextColor)
           else if Flag and C_TObjectKeyFocusFlag=0
                   then SetColor(TextColor) else SetColor(KFocusTextColor);
        SetTextBackColor(ButtonColor);
        SetTextOVer(1);OutStringXY(X+TXX,Y+TYY,Text);SetColor(ButtonColor);
        If TXX<>TX
           then begin
                Line(X+TX,Y+TY,X+TX,Y+TY+GetCharY);
                Line(X+TX,Y+TY,X+TX+Length(Text)*GetCharX,Y+TY);
                end
        end;
MouseShow;
End;

Procedure ButtonType.Hide;
Begin
Inherited Hide;MouseHide;
SetColor(BackColor);Bar(X,Y,X+DX,Y+DY);
MouseShow;
End;

Constructor ButtonType.Init(IDD,XX,YY:word;tText:string);
Begin
DX:=length(tText)*8+8;DY:=14+8;
ButtonColor:=ST_ButtonColor;BorderColor:=ST_ButtonBorderColor;
DarkColor:=ST_ButtonDarkColor;LightColor:=ST_ButtonLightColor;
TextColor:=ST_ButtonTextColor;BackColor:=ST_BackColor;
KFocusTextColor:=ST_ButtonKFocusTextColor;OffTextColor:=ST_ButtonOffTextColor;
MFocusBorderColor:=ST_ButtonMFocusBorderColor;KFocusBorderColor:=ST_ButtonKFocusBorderColor;
BText:=tText;TX:=5;TY:=4;Chars:=2;
IX:=0;IY:=0;IDX:=0;IDY:=0;IconShape:=Nil;IconMask:=nil;
Inherited Init(IDD,ButtonTypeObject,XX,YY,DX,DY);
End;

Procedure ButtonType.KeyFocusOff;
Begin
BFlags:=BFlags and (65535-Fl_ButtonPush);
Inherited KeyFocusOff;
End;

Procedure ButtonType.MouseFocusOff;
Begin
BFlags:=BFlags and (65535-Fl_ButtonPush);
Inherited MouseFocusOff;
End;

Procedure ButtonType.MouseLeftButtonPush;
Begin
BFlags:=BFlags or Fl_ButtonPush;
Draw;
SetKeyFocus;
End;

Procedure ButtonType.MouseLeftButtonPop;
Begin
If BFlags and Fl_ButtonPush=0 then Exit;
BFlags:=BFlags and (65535-Fl_ButtonPush);
Draw;DoButton;
End;

Procedure ButtonType.KeyPush;
Begin
If BFlags and Fl_ButtonPush<>0 then Exit;
If Command.KeyCode<>28 then Exit;
BFlags:=BFlags or Fl_ButtonPush;
Draw;
End;

Procedure ButtonType.KeyPop;
Begin
If BFlags and Fl_ButtonPush=0 then Exit;
If Command.KeyCode<>28 then Exit;
BFlags:=BFlags and (65535-Fl_ButtonPush);
Draw;DoButton;
End;

Procedure ButtonType.DoButton;
Begin
End;

{**************************** CButtonType met¢dusai *************************}

Procedure CButtonType.Draw;
Begin
MouseHide;
_SetChars(Chars);
If Flag and C_TObjectReDrawFlag<>0 then
   begin
   BorderDraw_2b(x,y,BX,BY,CButtonBackColor,DarkColor,LightColor);
   Flag:=Flag and (65535-C_TObjectReDrawFlag);
   end;
Case Value of
     0 : begin SetColor(CButtonBackColor);Bar(x+2,y+2,x+BX,y+BY);end;
     else begin
          If Flag and C_TObjectOnFlag=0
           then SetColor(OffTextColor) else SetColor(BorderColor);
           SetTextOVer(1);OutStringXY(X+5,Y+2,ValueChars[Value]);
          end;
     end;
if BText<>''
   then begin
        If Flag and C_TObjectOnFlag=0
           then SetColor(OffTextColor)
           else if (Flag and C_TObjectKeyFocusFlag=0) and (Flag and C_TObjectMouseFocusFlag=0)
                   then SetColor(TextColor) else SetColor(KFocusTextColor);
        SetTextOVer(0);OutStringXY(X+TX+CDX,Y+TY,BText);
        end;
MouseShow;
End;

Procedure CButtonType.Hide;
Begin
Inherited Hide;MouseHide;
SetColor(BackColor);Bar(X,Y,X+DX,Y+DY);
MouseShow;
End;

Constructor CButtonType.Init(IDD,XX,YY:word;tText:string;V:word);
Begin
BX:=12;BY:=14;
DX:=length(tText)*8+BX+6;DY:=BY+5;CDX:=3;
BorderColor:=ST_CButtonBorderColor;TextColor:=ST_CButtonTextColor;
BackColor:=ST_BackColor;CButtonBackColor:=ST_CButtonBackColor;
DarkColor:=ST_CButtonDarkColor;LightColor:=ST_CButtonLightColor;
KFocusTextColor:=ST_CButtonKFocusTextColor;MFocusBorderColor:=ST_CButtonMFocusBorderColor;
OffTextColor:=ST_CButtonOffTextColor;
BText:=tText;TX:=BX+8;TY:=3;Chars:=2;
Value:=V;MaxValue:=1;ValueChars:='x';CBFlag:=0;
Inherited Init(IDD,CButtonTypeObject,XX,YY,DX,DY);
End;

Procedure CButtonType.ChangeValue;
Begin
Inc(Value);If Value>MaxValue then Value:=0;
End;

Procedure CButtonType.MouseLeftButtonPush;
Begin
ChangeValue;Draw;SetKeyFocus;
If CBFlag and 1<>0 then DoCButton;
End;

Procedure CButtonType.KeyPush;
Begin
If (Command.KeyCode<>28) and (Command.KeyCode<>57) then Exit;
ChangeValue;Draw;If CBFlag and 1<>0 then DoCButton;
End;

Procedure CButtonType.DoCButton;
Begin
End;

{***************************** EditType met¢dusai ***************************}

Procedure EditType.Draw;
Begin
MouseHide;
_SetChars(Chars);
If EditFlag and 1=1
   then begin
        EditFlag:=EditFlag and (65535-1);
        BorderDraw_2a(X,Y,CDX*GetCharX+2,CDY*GetCharY+2,TextBackColor,DBorderColor,LBorderColor);
        end;
if Flag and C_TObjectKeyFocusFlag=0
   then begin SetColor(TextColor);SetTextBackColor(TextBackColor);end
   else begin SetColor(KFocusTextColor);SetTextBackColor(KFocusTextBackColor);end;
SetTextOver(byte(TextOver));
_TextOut(X+4,Y+4,CDX,CDY,EX,EY,LineSpace,TextPointer,TextFlag,TextColor,TextBackColor);
If Flag and C_TObjectKeyFocusFlag<>0 then ShowCursor;
MouseShow;
End;

Constructor EditType.Init(IDD,XX,YY,DXX:word;SString:string);
var TP:^byte;
Begin
CDX:=DXX;CDY:=1;
If length(SString)>250 then SString:=Copy(SString,1,250);
EditText:=SSTring;TP:=@EditText;Inc(TP);TextPointer:=TP;
EditText:=EditText+chr(0);MaxTextLength:=DXX;
If length(EditText)>DXX then EX:=Length(EditText)-DXX else EX:=0;
CursorX:=length(EditText);If CursorX>DXX then CursorX:=DXX;
If CursorX>0 then Dec(CursorX);CursorColor:=ST_EditCursorColor;
EY:=0;LineSpace:=0;BackColor:=ST_BackColor;
TextColor:=ST_TextColor;TextBackColor:=ST_TextBackColor;
KFocusTextColor:=ST_EditKFocusTextColor;KFocusTextBackColor:=ST_EditKFocusTextBackColor;
DBorderColor:=ST_EditDBorderColor;LBorderColor:=ST_EditLBorderColor;
Chars:=2;TextOver:=true;TextFlag:=ASCIIControlFlag;EditFlag:=1;
Inherited Init(IDD,EditTypeObject,XX,YY,DXX*8+6,1*(14+LineSpace)+6);
End;

Procedure EditType.Hide;
Begin
MouseHide;
Inherited Hide;
SetColor(BackColor);Bar(X,Y,X+DX,Y+DY);
MouseShow;
End;

Procedure EditType.ShowCursor;
var _XX,_YY:word;
Begin
MouseHide;
SetColor(CursorColor);_SetChars(Chars);
_XX:=X+CursorX*GetCharX+3;_YY:=Y+GetCharY+2;
PutPixel(_XX,_YY,CursorColor);
PutPixel(_XX+GetCharX,_YY,CursorColor);
Line(_XX,_YY+1,_XX+GetCharX,_YY+1);
MouseShow;
End;

Procedure EditType.HideCursor;
var _XX,_YY:word;
Begin
MouseHide;
SetColor(TextBackColor);_SetChars(Chars);
_XX:=X+CursorX*GetCharX+3;_YY:=Y+GetCharY+2;
PutPixel(_XX,_YY,TextBackColor);
PutPixel(_XX+GetCharX,_YY,TextBackColor);
Line(_XX,_YY+1,_XX+GetCharX,_YY+1);
MouseShow;
End;

Procedure EditType.KeyFocusOn;
Begin
Inherited KeyFocusOn;
ShowCursor;
End;

Procedure EditType.KeyFocusOff;
Begin
Inherited KeyFocusOff;
HideCursor;
End;

Procedure EditType.InsertChar;
var INCC:boolean;
Begin
If Length(EditText)>=MaxTextLength then Exit;
HideCursor;IncC:=True;
If (Command.KeyTable[6] and 4=4) or (Command.KeyTable[5] and 64=64)
   then Insert(KeyTable_HU_Shift[Command.KeyCode],EditText,EX+CursorX+1)
   else If (Command.KeyTable[6] and 1=1)
           then if KeyTable_HU_AltGr[Command.KeyCode]<>' '
                   then Insert(KeyTable_HU_AltGr[Command.KeyCode],EditText,EX+CursorX+1)
                   else IncC:=False
           else Insert(KeyTable_HU[Command.KeyCode],EditText,EX+CursorX+1);
If IncC then If (CursorX+1<CDX) then Inc(CursorX) else Inc(EX);
Draw;ShowCursor;
End;

Procedure EditType.KeyPush;
var i:word;
Begin
Case Command.KeyCode of
     75: If CursorX>0
            then begin HideCursor;Dec(CursorX);ShowCursor;end
            else If EX>0
                    then begin
                         HideCursor;Dec(EX);
                         Draw;ShowCursor;
                         end;
     77: If (CursorX+1<CDX) and (CursorX+EX+1<length(EditText))
            then begin HideCursor;Inc(CursorX);ShowCursor;end
            else If CursorX+1+EX<length(EditText)
                 then begin HideCursor;Inc(EX);Draw;ShowCursor;end;
     71: begin
         HideCursor;CursorX:=0;
         If EX>0 then begin EX:=0;Draw;End;
         ShowCursor;
         end;
     79: begin
         HideCursor;CursorX:=length(EditText)-1;
         If CursorX+1>CDX
            then begin EX:=length(EditText)-CDX;CursorX:=CDX-1;end;
         Draw;ShowCursor;
         end;
     14: If CursorX+EX>0
            then begin
                 HideCursor;
                 EditText:=Copy(EditText,1,CursorX+EX-1)+Copy(EditText,CursorX+EX+1,length(EditText));
                 If EX>0 then Dec(EX) else Dec(CursorX);
                 Draw;ShowCursor;
                 end;
     83: If CursorX+EX+1<length(EditTexT)
            then begin
                 HideCursor;
                 EditText:=Copy(EditText,1,CursorX+EX)+Copy(EditText,CursorX+EX+2,length(EditText));
                 If (EX+1=length(EditText)) and (EX>0)
                    then begin
                         i:=CDX;
                         repeat
                               Dec(EX);Inc(CursorX);Dec(i);
                         until (EX<1) or (I<1);Dec(CursorX);
                         end;
                 Draw;ShowCursor;
                 end;
      1     : ControlKey;
      2..13 : InsertChar;
     16..27 : InsertChar;
     28     : ControlKey;
     30..41 : InsertChar;
     43..53 : InsertChar;
     55     : InsertChar;
     57     : InsertChar;
     86     : InsertChar;
     74     : InsertChar;
     78     : InsertChar;
     end;
End;

Procedure EditType.ControlKey;
Begin
End;

Procedure EditType.MouseLeftButtonPush;
Begin
SetKeyFocus;
End;

{**************************** RButtonType met¢dusai *************************}

Procedure RButtonType.Draw;
Begin
MouseHide;
_SetChars(Chars);
If Flag and C_TObjectReDrawFlag<>0 then
   begin
   BorderDraw_2b(x,y,BX,BY,RButtonBackColor,DarkColor,LightColor);
   Flag:=Flag and (65535-C_TObjectReDrawFlag);
   end;
Case Value of
     0 : begin SetColor(RButtonBackColor);Bar(x+2,y+2,x+BX,y+BY);end;
     else begin
          If Flag and C_TObjectOnFlag=0
           then SetColor(OffTextColor) else SetColor(BorderColor);
           SetTextOVer(0);OutStringXY(X+5,Y+1,ValueChar);
          end;
     end;
if BText<>''
   then begin
        If Flag and C_TObjectOnFlag=0
           then SetColor(OffTextColor)
           else if (Flag and C_TObjectKeyFocusFlag=0) and (Flag and C_TObjectMouseFocusFlag=0)
                   then SetColor(TextColor) else SetColor(KFocusTextColor);
        SetTextOVer(1);SetTextBackColor(BackColor);OutStringXY(X+TX+CDX,Y+TY,BText);
        end;
MouseShow;
End;

Procedure RButtonType.Hide;
Begin
Inherited Hide;MouseHide;
SetColor(BackColor);Bar(X,Y,X+DX+2,Y+DY);
MouseShow;
End;

Constructor RButtonType.Init(IDD,XX,YY:word;tText:string;RG,V:word);
Begin
BX:=12;BY:=12;
DX:=length(tText)*8+BX+6;DY:=BY+3;CDX:=3;
BorderColor:=ST_RButtonBorderColor;TextColor:=ST_RButtonTextColor;
BackColor:=ST_BackColor;RButtonBackColor:=ST_RButtonBackColor;
DarkColor:=ST_RButtonDarkColor;LightColor:=ST_RButtonLightColor;
KFocusTextColor:=ST_RButtonKFocusTextColor;MFocusBorderColor:=ST_RButtonMFocusBorderColor;
OffTextColor:=ST_RButtonOffTextColor;RGroup:=RG;
BText:=tText;TX:=BX+8;TY:=3;Chars:=2;Value:=V;ValueChar:=chr(7);RBFlag:=0;
Inherited Init(IDD,RButtonTypeObject,XX,YY,DX,DY);
Mask:=C_TObjectKeyFocusMask;If V<>0 then SetValue;
End;

Procedure RButtonType.SetValue;
var RTO:TObjectPointer;ARBO:^RButtonType;P:pointer;MG:word;
Begin
RTO:=GetRootTObjectPointer;
while RTO<>nil
      do begin
         If RTO^.OType=RButtonTypeObject
            then begin
                 P:=RTO;ARBO:=P;
                 If (ARBO^.RGroup=RGroup) and (ARBO<>@Self) and (ARBO^.Value<>0)
                    then begin
                         ARBO^.Value:=0;
                         ARBO^.Mask:=ARBO^.Mask or C_TObjectKeyFocusMask;
                         ARBO^.Draw;
                         end;
                 end;
         RTO:=RTO^.NextTObject;
         end;
Value:=1;Mask:=Mask and (65535-C_TObjectKeyFocusMask);
End;

Function RButtonType.GetValue:word;
var RTO:TObjectPointer;ARBO:^RButtonType;P:pointer;MG,MGG:word;
Begin
RTO:=GetRootTObjectPointer;MG:=0;MGG:=0;
while RTO<>nil
      do begin
         If RTO^.OType=RButtonTypeObject
            then begin
                 P:=RTO;ARBO:=P;
                 If (ARBO^.RGroup=RGroup)
                    then begin Inc(MG); If (ARBO^.Value=1) then MGG:=MG;end;
                 end;
         RTO:=RTO^.NextTObject;
         end;
GetValue:=MGG;
End;

Procedure RButtonType.MouseLeftButtonPush;
Begin
SetValue;Draw;SetKeyFocus;
If RBFlag and 1<>0 then DoRButton;
End;

Procedure RButtonType.KeyPush;
Begin
Case Command.KeyCode of
     72 : PrevRButton;
     80 : NextRButton;
     end;
End;

Procedure RButtonType.DoRButton;
Begin
End;

Procedure RButtonType.NextRButton;
var Ki:boolean;RTO:TObjectPointer;ARBO:^RButtonType;P1,P2:Pointer;
Begin
RTO:=GetRootTObjectPointer;while RTO<>@Self do RTO:=RTO^.NextTObject;
P1:=RTO;RTO:=RTO^.NextTObject;Ki:=False;
while (RTO<>P1) and (not Ki) do
      begin
      if RTO=nil then RTO:=GetRootTObjectPointer;
      If RTO^.OType=RButtonTypeObject
         then begin
              P2:=RTO;ARBO:=P2;
              If ARBO^.RGroup=RGroup
                 then begin
                      ARBO^.SetValue;ARBO^.Draw;ARBO^.SetKeyFocus;
                      If RBFlag and 1<>0 then ARBO^.DoRButton;
                      Ki:=true;
                      end
                 else RTO:=RTO^.NextTObject;
              end
         else RTO:=RTO^.NextTObject;
      end;
End;

Procedure RButtonType.PrevRButton;
var Ki:boolean;ETO,RTO:TObjectPointer;ARBO:^RButtonType;P1,P2:Pointer;
Begin
ETO:=GetRootTObjectPointer;while ETO^.NextTObject<>nil do ETO:=ETO^.NextTObject;
RTO:=GetRootTObjectPointer;while RTO<>@Self do RTO:=RTO^.NextTObject;
P1:=RTO;RTO:=RTO^.PrevTObject;Ki:=False;
while (RTO<>P1) and (not Ki) do
      begin
      if RTO=nil then RTO:=ETO;
      If RTO^.OType=RButtonTypeObject
         then begin
              P2:=RTO;ARBO:=P2;
              If ARBO^.RGroup=RGroup
                 then begin
                      ARBO^.SetValue;ARBO^.Draw;ARBO^.SetKeyFocus;
                      If RBFlag and 1<>0 then ARBO^.DoRButton;
                      Ki:=true;
                      end
                 else RTO:=RTO^.PrevTObject;
              end
         else RTO:=RTO^.PrevTObject;
      end;
End;


{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
END.