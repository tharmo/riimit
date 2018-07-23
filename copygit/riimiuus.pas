unit riimiuus;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,verbit,nominit;
const vahvatverbiluokat=[52..63,76];
const vahvatnominiluokat=[1..32,76];

type tlka=record esim:string;kot,ekasis,vikasis:word;vahva:boolean;vikasana:word;end;
type tsis=record ekaav,vikaav:word;sis:string[8];vikasana:word;end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lisää viekä .takia - se josta etuvokaalit alkavat
type tsan=record san:string[15];akon:string[4];takavok:boolean;end;

type tsanasto=class(tobject)
 vcount,ncount:integer;
 lks:array[0..80] of tlka;
 siss:array[0..255] of tsis;
 avs:array[0..1200] of tav;
 sans:array[0..32767] of tsan;
 verbit:tverbit;
 nominit:tnominit;
 //0-pohjasia, mutta data alkaa 1:stä
 procedure luesanat(fn:string);
 procedure listaa;
 constructor create;
 end;

implementation
uses riimitys,riimiutils;
constructor tsanasto.create;
begin
luesanat('sanatuus.csv');
verbit:=tverbit.create('sanatuus.csv','vmids.csv','vsijat.csv');
nominit:=tnominit.create('nomsall.csv','nmids.csv');
end;



procedure tsanasto.luesanat(fn:string);
var sl:tstringlist;ms:tsija;sanafile:textfile;sana:ansistring;
i,j,k,l:word;differ:byte;
  prevsl:tstringlist;
  clka,csis,cav,csan,ulka:integer;
  prlim:word;
procedure uusav;
begin
  avs[cav].vikasana:=csan;
   //writeln('<li>','<b>av:',avs[cav].v,avs[cav].h,'</b>','..',csan, '   ',sl[2],sl[3],' :::',clka,'/',csis,'/',cav,'/',csan);
  cav:=cav+1;
  avs[cav].ekasana:=csan+1;
  avs[cav].takia:=0;  //takavokaalisten määrä  .. ei käytetä vielä
  avs[cav].v:=sl[2];
  avs[cav].h:=sl[3];
  if avs[cav].v='_' then avs[cav].v:=avs[cav].h  //"_" käytettiin aastevaihtelun puuttumisen merkkaamiseen. sorttautuu siistimmin
  else prlim:=0;
  //write(' >',avs[cav].v,avs[cav].h);
end;
procedure uussis;
begin
siss[csis].vikasana:=csan;
siss[csis].vikaav:=cav;
csis:=csis+1;
siss[csis].ekaav:=cav+1;
siss[csis].sis:=(sl[1]);
prlim:=0;
writeln('</ul><li>SIS:<b>',siss[csis].sis,'</b> ',csis,' /sana',csan,'  /lka:<b>',clka,'/','</b> ',csan+19548,'<ul>');
end;
procedure uusluokka;
var kot:integer;
begin
try
   lks[clka].vikasis:=csis;
   lks[clka].vikasana:=csan;
   clka:=clka+1;
   lks[clka].ekasis:=csis+1;
 try lks[clka].esim:=sl[7];except lks[clka].esim:='xxx';end;
 kot:=strtointdef(prevsl[0],99);//clka+51;
 lks[clka].kot:=kot;//clka+51;
 if (kot in vahvatverbiluokat+vahvatnominiluokat) then   lks[clka].vahva:=true else  lks[clka].vahva:=false;
 writeln('</ul>-',csis,'<li>LKA <b>',kot,'</b>:',lks[clka].ekasis,'  ',sana,' //','::<b>',clka,'/',csis,'/',cav,'/',csan,'</b><ul>');
 prlim:=0;
except writeln('faillka');end;

end;

//tverbit.luesana
var alko:boolean;
begin
   prlim:=0;
   alko:=true;
  clka:=0;csis:=0;cav:=0;csan:=0;
  assign(sanafile,fn);//'verbsall.csv');
  reset(sanafile);
  sl:=tstringlist.create;
  prevsl:=tstringlist.create;
  prevsl.commatext:='1,x,v,h,0,x,x,x';
  {lks[0].vahva:=true;
  lks[0].ekasis:=0;
  siss[0].ekaav:=0;
  avs[0].ekasana:=0;}
  // tämmönenkin toimii:  for i in vahvatverbiluokat+vahvatnominiluokat do  writeln(i);
  while not eof(sanafile) do
  begin
     try
     readln(sanafile,sana);
     sl.commatext:=sana;
     ulka:=strtointdef(sl[0],0);
     //if ulka>58 then break;
     //if ulka<52 then continue;
     //if alko then begin prevsl.commatext:=sana;end;  //eka sana ei aloita luokkia
     differ:=4;
     if alko then differ:=0 else
     for i:=0 to sl.count-2 do if prevsl[i]<>sl[i] then begin differ:=i;break; end;
    if differ=3  then differ:=2;      // av-heikot erosivat mutta vahva oli sama. yhdistetään - AV ylipäätään oli eri
    if (differ<1) then uusluokka;
    if (differ<2) then  uussis;
    if (differ<4) then uusav;
     alko:=false;
         //if sl[4]='0' then avs[cav].takia:=csan+1; //pitäis olla sortattu vokaalisoinnun mukaan, eli ei tarttis laittaa  joka sanalle talteen
    sans[csan].san:=(sl[5]);
    sans[csan].takavok:=sl[4]='0';
    sans[csan].akon:=(sl[6]);
    if sl[4]='0' then avs[cav].takia:=avs[cav].takia+1;  //lasketaan takavokaalisten määrää av-luokassa hakujen tehostamiseksi
    csan:=csan+1;
    alko:=false;
    prevsl.commatext:=sana;  //tähän taas seuraavaa sanaa verrataan
    prlim:=prlim+1;  //just for debug to make managable listings .. not used
    except writeln('failav');end;
   end;
    writeln('<h1>LKS:',CLKa,' /sis:',csis,' /av:',cav,' /w:',csan,'</h1>');
    for i:=0999 to clka do
    begin
       writeln('<li>',i+52,'<ul>');
       for j:=lks[i].ekasis to lks[i].vikasis  do
       begin
          writeln('<li>',j,':',siss[j].sis,'<ul>');
          for k:=siss[j].ekaav to siss[j].vikaav  do
          begin
             writeln('<li>',k,':',avs[k].av,avs[k].v,avs[k].h,'<ul>');
             writeln('<li>',avs[k].ekasana+19548,sans[avs[k].ekasana].san,'',sans[avs[k].ekasana].akon,' ',avs[k].vikasana+19548,sans[avs[k].vikasana].san,sans[avs[k].vikasana].akon);

              writeln('</ul>');
          end;

           writeln('</ul>');
       end;

       writeln('</ul>');
    end;
 end;
procedure tsanasto.listaa;
  function b(st:string):string;
    begin result:='<b>'+st+'</b>';end;
var lu,sis,av,san:Integer;myav,mysis,mymid:string;
curlka:tlka;cursis:tsis;curav:tav;cursan:tsan;
begin
  writeln('<ul>');
  for lu:=0 to 78 do
  begin
    curlka:=lks[lu];
//    mymid:=lmmids[lu-1,1];
    writeln('<li>',lu,
    B(curlka.ESIM),' ',mymid,curlka.kot,' ',curlka.ekasis,'...',curlka.vikasis,' ',curlka.vikasana);
    writeln('<ul>');
   for  sis:=curlka.ekasis to curlka.vikasis do
   begin
     cursis:=siss[sis];
     mysis:=cursis.sis;
     //if lmmids[lu-1,1]='*' then begin mymid:=mysis[1]+'';end;// else    mymid:=lmmids[lu-1,1];
     writeln('<li>sis:',b(mysis+'.'),' ',cursis.ekaav,'...',cursis.vikaav,' ',cursis.vikasana);
     //if lu=1 then continue;
     writeln('<ul>');
    for av:=cursis.ekaav to cursis.vikaav do
    begin
      curav:=avs[av];
      if (lu+52<63) or (lu+52>76) then myav:=curav.v else  myav:=curav.h;
      writeln('<li>',b(curav.v+curav.h),' ',curav.ekasana,'...',curav.vikasana,' ',sans[curav.vikasana].san,sans[curav.vikasana].akon,' ',curav.vikasana);
      //for san:=curav.ekasana to curav.vikasana do writeln(' ',reversestring(mymid+mysis+''+myav+''+sanat[san].san+sanat[san].akon)+'a');
    end;
    writeln('</ul>');
   end;
   writeln('</ul>');
  end;
  writeln('</ul>');
end;

end.

