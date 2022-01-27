{****************************************************************************}
{***                                                                      ***}
{***                      Turbo Pascal TWMisc Unit                        ***}
{***                            1.0a Verzi¢                               ***}
{***                                                                      ***}
{***               (C) TwinNet 1998  (P) Szab¢ Andr†s 1997/98             ***}
{***                                                                      ***}
{***                      1997.02.16.  - 1998.11.25.                      ***}
{***                                                                      ***}
{****************************************************************************}

{****************************************************************************}
{********************** Rendszeridã lekÇrdezÇs ******************************}
{****************************************************************************}

procedure GetTime(var Ora, Perc, Mp, Szmp : word);
var o, p, m, szm: word;
begin
  asm
     mov ah,2Ch;int 21h;push dx
     mov ax,cx;xor cx, cx;mov cl,ah;mov o,cx;xor cx, cx;mov cl,al;mov p,cx
     mov dl, dh;xor dh, dh;mov m,dx;pop dx;xor dh, dh;mov szm,dx
  end;
ora:=o;perc:=p;mp:=m;szmp:=szm;
end;

Function GetTimeStr(l:byte):string;
var Ora,Perc,MPerc,SzMPerc:word;st,mi:string;
begin
GetTime(Ora,Perc,MPerc,SzMPerc);
str(Ora,st);while length(st)<2 do st:='0'+st;mi:=st;
str(Perc,st);while length(st)<2 do st:='0'+st;mi:=mi+':'+st;
str(MPerc,st);while length(st)<2 do st:='0'+st;
if l>0 then mi:=mi+':'+st;
str(SzMPerc,st);while length(st)<2 do st:='0'+st;
if l>1 then mi:=mi+'.'+st;
GetTimeStr:=mi;
end;

{****************************************************************************}
{********************** Rendszer d†tum lekÇrdezÇs ***************************}
{****************************************************************************}

procedure GetDate(var Ev, Ho, Nap, NapHet : word); assembler;
asm
   mov ah, 2Ah
   int 21h
   les bx, Ev
   mov es:[bx], cx
   xor cx, cx
   mov cl, dh
   les bx, Ho
   mov es:[bx], cx
   xor cx, cx
   mov cl, dl
   les bx, Nap
   mov es:[bx], cx
   xor cx, cx
   mov cl, al
   les bx, NapHet
   mov es:[bx], cx
end;

Function GetDateStr(l:boolean):string;
const napok : array [0..6] of string =
        ('Vas†rnap','HÇtfã','Kedd','Szerda','CsÅtîrtîk','PÇntek','Szombat');
      honapok : array [1..12] of string =
        ('Janu†r','Febru†r','M†rcius','µprilis','M†jus','J£nius','J£lius',
         'Augusztus','Szeptember','Okt¢ber','November','December');
var Ev, Ho, Nap, NapHet : word;st,mi:string;
begin
getdate(Ev, Ho, Nap, NapHet);
str(ev,st);mi:=st+'.';
if l
   then mi:=mi+' '+Honapok[ho]+' '
   else begin str(ho,st);while length(st)<2 do st:='0'+st;mi:=mi+st+'.';end;
str(nap,st);while length(st)<2 do st:='0'+st;mi:=mi+st+'.';
if l then mi:=mi+' '+napok[naphet];
GetDateStr:=mi;
end;

{****************************************************************************}
{********************** Windows jelenlÇt ellenãrzÇse ************************}
{****************************************************************************}

Function WindowsPresent:word;assembler;
asm
        MOV     AX,$1600
        INT     $2F
end;


{****************************************************************************}
{****************************************************************************}
{***                        Speaker kezelã elj†r†sok                      ***}
{****************************************************************************}
{****************************************************************************}

Procedure SpeakerOn;assembler;
Asm
   in   al,061h
   or   al,00000011b
   out  061h,al
end;

Procedure SpeakerOff;assembler;
Asm
   in   al,061h
   and  al,11111100b
   out  061h,al
End;

Procedure SetSpeakerFreq(Hz:word);assembler;
Asm
   mov  dx,0012h
   mov  ax,34ddh
   mov  bx,Hz
   cmp  bx,dx
   jc   @exit
   div  bx
   mov  dx,ax
   mov  al,10110110b
   out  043h,al
   mov  al,dl
   out  042h,al
   mov  al,dh
   out  042h,al
@exit:
End;

{****************************************************************************}
{****************************************************************************}
{***                     CMOS kezelã elj†r†sok                            ***}
{****************************************************************************}
{****************************************************************************}

Function  CMOSread(Adr:byte):byte;assembler;
Asm
   cli                  { Tiltjuk a megszak°t†sokat       }
   cmp   Adr,0ah        { Idìregisztert olvasunk ?        }
   jnc   @read          { Ugr†s tov†bb, ha nem            }
   mov   al,0ah
   out   70h,al         { Az idìz°tì st†tusregisztere     }
@wait:
   in    al,71h         { Beolvassuk a st†tusregisztert   }
   and   al,$80
   jnz   @wait          { V†rakozunk, ha friss°tÇs van    }
@read:
   mov   al,Adr
   out   70h,al         { A regiszter sz†ma a 70h porta   }
   in    al,71h         { Beolvassuk a CMOS b†jtot        }
   sti                  { EngedÇlyezzÅk a megszak°t†sokat }
End;

Procedure CMOSwrite(Adr,Dat:byte);assembler;
Asm
   cli                  { Tiltjuk a megszak°t†sokat       }
   cmp   Adr,0ah        { Idìregisztert olvasunk ?        }
   jnc   @write         { Ugr†s tov†bb, ha nem            }
   mov   al,0ah
   out   70h,al         { Az idìz°tì st†tusregisztere     }
@wait:
   in    al,71h         { Beolvassuk a st†tusregisztert   }
   and   al,$80
   jnz   @wait          { V†rakozunk, ha friss°tÇs van    }
@write:
   mov   al,Adr
   out   70h,al         { A regiszter sz†ma a 70h porta   }
   mov   al,Dat
   out   71h,al         { Ki°rjuk a CMOS b†jtot           }
   sti                  { EngedÇlyezzÅk a megszak°t†sokat }
End;

{****************************************************************************}
{****************************************************************************}
{***                                                                      ***}
{***                             TWMisc End                               ***}
{***                                                                      ***}
{****************************************************************************}
{****************************************************************************}