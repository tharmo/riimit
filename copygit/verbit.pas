unit verbit;
interface
uses
  Classes, SysUtils,strutils,riimiutils,math;

{$mode objfpc}{$H+}
type tverlka=record esim:string;kot,ekasis,vikasis:word;vahva:boolean;w:word;end;
type tversis=record ekaav,vikaav:word;sis:string[8];w:word;end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tverav=record ekasana,takia,vikasana:word;h,v,av:string[1];w:word;end;  //lis‰‰ viek‰ .takia - se josta etuvokaalit alkavat
type tvsana=record san:string[15];akon:string[4];takavok:boolean;end;
{type tsija=record
  vv,hv:boolean;
  num,vparad,hparad:byte;
  vmuomids,hmuomids:array[1..16] of byte;
  ending:string[15];

end;
LKS:27 /sis:79 /av:455 /w:8003
}
type thitrec=record lk,si,av,san:word;end;
type tverbit=class(tobject)
    lmmids:array[0..49] of array[0..67] of string[15];
    protomids:array[0..49] of array[0..12] of string[15];
     // lk:60 lv:130 av:683
     lkat,lktot,latot,avtot,taivluokkia:word;
     //sijat:array[0..49] of array[0..75] of string[8];
     sijat:array[0..66] of tsija;
     lUOKS:array[0..30] of tverlka; //78-52+1:+USEAMPI varalla
     sisS:array[0..127] of tversis;
     AVS:array[0..1023] of tverav;
     vhitlist:tlist;
     //VOKS:a   rray[0..160] of tverlvok;
     //sanat:array[0..27816] of tsana;
     sanat:array[0..16383] of tvsana;
     procedure genlist;
    procedure generate(runko,sis,astva:str16;luokka,sana:integer;aresu:tstringlist;hakutakvok:boolean);
   // procedure etsi(haku:ansistring;aresu:tstringlist;onjolist:tlist);
    procedure listaa;
    procedure siivoosijat;
    procedure etsi(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
    procedure etsiold(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
    procedure luesanat(fn:string);
    procedure luesijat(fn:string);
    procedure listsijat;
    procedure luemids(fn:string);
    procedure createsija(si:integer;ss:ansistring);
    constructor create(wfile,midfile,sijafile:string);
    function numtowrd(snum:integer):thitrec;
    //procedure listaasanat;
    procedure listaasijat;
{    procedure uusetsi;
    procedure listaasanat;
    procedure luemids;
    }
    procedure haesijat(haku:ansistring;sikalauma:tstringlist);
end;
const luokkia=24;sikoja=66;
const VprotoLOPut:array[0..11] of ansistring =('a','a', 'n', '', 'a', 'ut', 'i', 'tu', 'en', 'isi', 'kaa', 'emme');
const
vvahvanheikot =[5,6,7,8,9,10,13,14,15,24,25,26,27,29,30,31,32,33,34,35,36];
//VVAHVAT: ,0,1,2,3,4,11,12,16,17,18,19,20,21,22,23,28,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65
vheikonheikot=[0,1,2,3,4,13,14,15,16,17,18,19,20,21,22,29,30,31,32,33,34,35,36,37,38,62,63,64,65];
vsijanimet:array[0..66] of ansistring =
  ('V Inf1 Lat ','V Inf1 Act Tra Sg PxPl1 ','V Inf1 Act Tra Sg PxSg1 ','V Inf1 Act Tra Sg PxPl2 ','V Inf1 Act Tra Sg PxSg2 ','V Impv Act Sg2 ','V Prs Act ConNeg ','V Prs Act Pl1 ','V Prs Act Sg1 ','V Prs Act Sg2 ','V Prs Act Pl2 ','V Prs Act Pl3 ','V Prs Act Sg3 ','V Prs Pass ConNeg ','V Prs Pass Pe4 ','PrfPrc Pass Pos Nom Pl ','V Pot Act Sg3 ','V Pot Act Pl1 ','V Pot Act Sg1 ','V Pot Act Sg2 ','V Pot Act Pl2 ','V Pot Act Pl3 ','PrfPrc Act Pos Nom Sg ','V Pst Act Sg3 ','V Pst Act Pl1 ','V Pst Act Sg1 ','V Pst Act Sg2 ','V Pst Act Pl2 ','V Pst Act Pl3 ','V Inf2 Pass Ine ','V Cond Pass Pe4 ','V Impv Pass Pe4 ','V Inf3 Pass Ins ','V Pot Pass Pe4 ','PrsPrc Pass Pos Nom Sg ','V Pst Pass Pe4 ','V Pst Pass ConNeg ','V Inf2 Act Ins ','V Inf2 Act Ine Sg ','V Cond Act Sg3 ','V Cond Act Pl1 ','V Cond Act Sg1 ','V Cond Act Sg2 ','V Cond Act Pl2 ','V Cond Act Pl3 ','AgPrc Pos Nom Sg ','AgPrc Pos Ill Sg ','V Act Inf5 Px3 ','V Act Inf5 PxPl1 ','V Act Inf5 PxSg1 ','V Act Inf5 PxPl2 ','V Act Inf5 PxSg2 ','V Inf3 Ade ','V Inf3 Man ','V Inf3 Ine ','V Inf3 Ela ','V Inf3 Abe ','V N Nom Sg ','V N Par Sg ','V N Par Sg ','PrsPrc Act Pos Nom Sg ','PrsPrc Act Pos Nom Pl ','V Impv Act Pl2 ','V Impv Act Pl1 ','V Impv Act Sg3','V Impv Act Pl3','V Act Inf5 Px3 ');
vsijaesim:array[0..66] of ansistring = ('kehua','kehuaksemme','kehuakseni','kehuaksenne','kehuaksesi','kehu',{'VIRHE',}'kehu','kehumme','kehun','kehut','kehutte','kehuvat','kehuu','kehuta','kehutaan','kehutut','kehunee','kehunemme','kehunen','kehunet','kehunette','kehunevat','kehunut','kehui','kehuimme','kehuin','kehuit','kehuitte','kehuivat','kehuttaessa','kehuttaisiin','kehuttakoon','kehuttaman','kehuttaneen','kehuttava','kehuttiin','kehuttu','kehuen','kehuessa','kehuisi','kehuisimme','kehuisin','kehuisit','kehuisitte','kehuisivat','kehuma','kehumaan','kehumaisillaan','kehumaisillamme','kehumaisillani','kehumaisillanne','kehumaisillasi','kehumalla','kehuman','kehumassa','kehumasta','kehumatta','kehuminen','kehumista','kehumista','kehuva','kehuvat','kehukaa','kehukaamme','koon','koot','kehumaisillansa');
vesims: array[1..27] of ansistring =('hioa', 'sulaa', 'pieks‰‰', 'soutaa', 'jauhaa', 'kaataa', 'laskea', 'tuntea', 'l‰hte‰', 'kolhia', 'naida', 'saada', 'vied‰', 'k‰yd‰', 'p‰‰st‰', 'puhella', 'aterioida', 'suudita', 'piest‰', 'n‰hd‰', 'parata', 'niiata', 'kasketa', 'nimet‰', 'taitaa', 'kumajaa', 'kaikaa');
//'trio', 'plasebo', 'oboe', 'viidakko', 'kebab', 'diesel', 'hanhi', 'boutique', 'dia', 'kahdeksan', 'apaja', 'idea', 'orkidea', 'kahakka', 'juohea', 'taempi', 'vajaa', 'maa', 'tie', 'nugaa', 'reggae', 'buffet', 'lohi', 'ruuhi', 'loimi', 'huoli', 'paasi', 'kansi', 'lapsi', 'peitsi', 'kaksi', 's‰vel', 'morsian', 'hapan', 'l‰mmin', 'parahin', 'vasen', 'sulhanen', 'iskias', 'vakaus', 'uskalias', 'mies', 'ohut', 'kev‰t', 'nelj‰s', 'tuhat', 'kuollut', 'poikue', 'sammal');


{$mode objfpc}{$H+}



implementation
function red(st:string):string;
begin result:='<b style="color:red">'+st+'</b>';
end;
function blue(st:string):string;
begin result:='<b style="color:blue">'+st+'</b>';
end;
function listsija(sika:tsija):string;
begin
   with sika do  result:=' {'+inttostr(num)+'('+inttostr(vparad)+' '+inttostr(hparad)+'):'+ending+'} ';
end;
function tverbit.numtowrd(snum:integer):thitrec;
var lu,si,av,sa:integer;
var lux,six,avx,sax:integer;
 koko:string;
begin
   //for six:=luoks[67-52].ekasis to luoks[67-52].vikasis do    writeln(siss[six].sis);
   //for avx:=siss[luoks[67-52].ekasis].ekaav to siss[luoks[67-52].ekasis].vikaav do    writeln(avs[avx].v,avs[avx].h);
   fillchar(result,sizeof(result),0);
  // result:=[0,0,0,0]
  //for six:=0 to 50 do writeln('/',siss[six].w);
    for lux:=0 to luokkia do
    begin
      //writeln('<li>LKA:',lux+52,' ',luoks[lux].kot,'/',luoks[lux].w,' (',snum,') <ul>');//,luoks[lux].ekasis,' to ',luoks[lux].vikasis );
      if luoks[lux].w>=snum then
      begin
        //writeln('<li>',lux,luoks[lux].kot,'<ul>');
        result.lk:=lux;
        for six:=luoks[lux].ekasis to luoks[lux].vikasis do
          if siss[six].w>=snum then
          begin
            //writeln('<li>Sis:',six,' ',siss[six].sis,' ',siss[six].w,'<ul>');
            result.si:=six;
            for avx:=siss[six].ekaav to siss[six].vikaav do
            if avs[avx].w>=snum then
              begin
                //writeln('<li>AV:',avx,' ',avs[avx].v,avs[avx].h,'');
                result.av:=avx;
                for sax:=avs[avx].ekasana to avs[avx].vikasana do
                 if sax=snum then begin
                  result.san:=sax;
                 // writeln(sax);
                  //writeln('<li>',sax,' ',sanat[sax].san,sanat[sax].akon,'');
                  break;
                end;
                break;
              end;
            //writeln('</ul>');
            break;
          end;
         //writeln('</ul>');
         break;
      end;
      //writeln('</ul>');
    end;
  koko:='a'+lmmids[result.lk,0]+'.'+siss[result.si].sis+'.'+ifs(result.lk+52<63,avs[result.av].v,avs[result.av].h)+'.'+sanat[result.san].san+sanat[result.san].akon;
   if not sanat[result.san].takavok then koko:=etu(koko);
  if random(55555) mod 55555=1 then
  writeln('<li>',reversestring(koko),'   ',snum,' ',result.lk+52,':<hr/>');
end;
procedure tverbit.genlist;
var sija,lu,si,av,sa,cut:integer;
  sijast,lust,sist,avst,sofar:string;
  mylust,mysist,myavst:string;
  vahvaluokka,vahvasija:boolean;yksvaan:integer;
  cutav:boolean;
procedure dosana(snum:integer);
//var san:integer;
begin
  //if length(sanat[snum].san)>3 then exit;
   if cutav then writeln('zxc');
sofar:=sijast+lust+sist+avst;
writeln('<li><span title:="'+inttostr(lu+51),'"> ',reversestring(sijast+''+mylust+''+mysist+''+myavst+''+sanat[snum].san+sanat[snum].akon)+'</span>');
end;

procedure doav(avn:integer);
var i:integer;
begin
 av:=avn;
 if lu+51=58 then if (avs[av].v<>'k') or (avs[av].h<>'') then exit;
 //writeln('<li>AV:',avs[av].v,avs[av].h,'</li>');
   //if cut>1 then
//   if avs[av].v=avs[av].h then  if yksvaan<2 then yksvaan:=yksvaan+1 else begin yksvaan:=0;exit;end;
   avst:=ifs(vahvasija,avs[av].v,avs[av].h);
   myavst:=ifs(cutav,'',avst);
   if avs[av].v<>avs[av].h then writeln('<b>',avst,':</b>');
   for i:=avs[av].ekasana to avs[av].ekasana do dosana(i);exit;
   for i:=avs[av].ekasana to min(avs[av].ekasana+1,avs[av].vikasana) do dosana(i);
end;
procedure dosis(snum:integer);//;mylust:string);
var i:integer;
begin
   mysist:=siss[snum].sis;
   mylust:=lust;
   try
   if lust='*' then mylust:=mysist[1];
   except writeln('<h3>(',mysist,'/',lust,')');end;
   if cut>0 then writeln('CUT:',cut,sist,'!');
   if cut>0 then
   begin
     if cut=2 then delete(mysist,length(mysist),1)
     else  delete(mysist,1,1);
     mylust:=stringreplace(mylust,'_','',[rfReplaceAll]);
     //mylust:='';//mysis:='';
     writeln('<b>[',sist,'/',mysist,']</b>');
   end;
   yksvaan:=0;

   //for i:=max(siss[snum].ekaav,siss[snum].vikaav-1) to siss[snum].vikaav do doav(i);
   for i:=siss[snum].ekaav to siss[snum].ekaav  do doav(i);
   exit;
   for i:=siss[snum].ekaav to siss[snum].vikaav  do doav(i);
end;
procedure dolka(lnum:integer);
var i:integer; mylust:string;
begin
   lu:=lnum;
   cut:=0;
   if not (lu+51 in [52]) then exit;
   lust:=lmmids[lu,sija];
   if (lu+51=71) then if ((sijat[sija].hparad=2) and  (sija>10)) then lust:='-ek' else if  (sija in [23,28]) then lust:='-k';
   vahvaluokka:=(lu+51<63) or (lu+51 in [76]);
   if vahvaluokka then vahvasija:=not (sija in vheikonheikot)
   else vahvasija:=not (sija in vheikonheikot);
   if pos('_',lust)>0 then if pos('__',lust)>0 then cut:=2 else cut:=1;
      cutav:=pos('-',lust)>0;
   //if cut=0 then exit;
//   writeln('<li><b>',lu+51,'</b>',lust,cut,': ');
   for i:=luoks[lu].ekasis+1 to luoks[lu].vikasis  do dosis(i);
end;
var i:integer;
begin
   for sija:=0 to 66 do
   begin
    //if not (sija in  [0,5,10,11,12,13,16,23,36,37,39,45]) then continue;
    //if not (sija in  [0,5,10,11,12]) then continue;
      //sijast:=reversestring(sijat[sija].ending);
      sijast:=(sijat[sija].ending);
      //writeln('</ul><hr/><li>SIJA:',sija,'|',sijast,' ',vahvasija,sijat[sija].hparad);//,'<ul>');
      for i:=1 to 27 do dolka(i);
   end;

end;
procedure tverbit.siivoosijat;
var
  i,j,lu,sis:integer;
  svok,mm:string[5];
  //gens,mygens:tstringlist;
begin


  //gens:=tstringlist.create;
  //mygens:=tstringlist.create;
  //gens.loadfromfile('gen.csv');
  writeln('<hr>LISTAApasSIJAT:::');
  write('<pre>         :::::');
  for j:=0 to sikoja do   if (j in  [0,5,9,12,13,16,23,36,37,39,45]) then

   write(',',copy(inttostr(j)+'                  ',1,16));
  write(^j,'             ');
  for j:=0 to sikoja do
    if (j in  [0,5,9,12,13,16,23,36,37,39,45]) then
    write(',',copy(vsijaesim[j]+'                   ',1,16));
  write(^j,'             ');
  for j:=0 to sikoja do
    if (j in  [0,5,9,12,13,16,23,36,37,39,45]) then
    write(',',copy(vsijanimet[j]+'              ',1,16));
  write(^j,'             ');
  for j:=0 to sikoja do
    if (j in  [0,5,9,12,13,16,23,36,37,39,45]) then
    write(',',copy(sijat[j].ending+'                   ',1,16));
  write(^j);

  for i:=0 to 26 do
  begin
   write(i+52,'  ;',copy(vesims[i+1]+'                ',1,16));

   for j:=0 to sikoja do
     if (j in  [0,5,9,12,13,16,23,36,37,39,45]) then
     begin
        mm:=lmmids[i+1,j];
     //  if i+1>31 then if pos('-',mm)=1 then delete(mm,1,1);
     //  if i+1 in [33,34,35,36,37] then if pos('n',mm)=1 then delete(mm,1,1);
     //  if i+1 in [39,40,41,42] then if pos('s',mm)=1 then delete(mm,1,1);
       //if i+1 in [43,44] then if pos('t',mm)=1 then delete(mm,1,1);
       //if mm=lmmids[i,j] then write(',',copy(mm+'                    ',1,8))
       //else write(',',copy(mm+'/'+copy(lmmids[i,j],1,length(lmmids[i,j])-length(mm))+'                    ',1,8));
       write(',',copy(reversestring(mm)+'                       ',1,16));

     end;

     //mygens.commatext:=gens[i];
     {try
     FOR J:=2 TO 5 DO
     write(COPY(mygens[j]+'                 ',1,6));
     except       write('FAIL%',i,'#',gens.count);end;
     }

     writeln;
  end;
  writeln('</pre>LISLOPPU</pre></pre>juu');
end;

procedure tverbit.listsijat; var i,j,k:integer;
function td(st:string):string;
  begin   result:= '<td>'+st+'</td>';end;

function vh(lu,si:integer):string;
 Var tag:string;
  begin
   //  if lu+51<64 then result:=ifs(si in vHEIKOtsijat,'','!!')
   //ELSE  result:=ifs(si in HHEIKOtsijat,'','!!')
   if lu+51<64 then TAG:=ifs(si in vvahvanheikot,'SPAN','B')
 ELSE  tAG:=ifs(si in vHEIKOnheikot,'SPAN','B');
WRITELN('<TD><',TAG,'>'+reversestring(LMMIDS[LU,SI])+'</'+TAG+'></td>');
  end;
begin
   writeln('<table border="1"><tr><td/>');
   for j:=0 to sikoja do     if (j in  [0,5,10,11,12,13,16,23,25,36,37,39,45]) then writeln(td(inttostr(j)+reversestring(sijat[j].ending)));
   writeln('</tr>');
   for i:=1 to 26 do
   begin
    writeln('<tr>',td(inttostr(i+51)+luoks[i].esim));
     for j:=0 to sikoja do   if (j in  [0,5,10,11,12,13,16,23,25,36,37,39,45]) then
    VH(I,J);//(;;writeln(td(reversestring(lmmids[i,j])+vh(i,j)));
   end;
end;

procedure tverbit.listaa;
  function b(st:string):string;
    begin result:='<b>'+st+'</b>';end;
var lu,sis,av,san:Integer;myav,mysis,mymid:string;
curlka:tverlka;cursis:tversis;curav:tverav;cursan:tvsana;
begin
  writeln('<ul>');
  for lu:=0 to 27 do
  begin
    curlka:=luoks[lu];
    mymid:=lmmids[lu-1,1];
    writeln('<li>',lu+52,B(curlka.ESIM),' ',mymid,curlka.kot,' ',curlka.ekasis,'...',curlka.vikasis,' ',curlka.w);
    writeln('<ul>');
   for  sis:=curlka.ekasis to curlka.vikasis do
   begin
     cursis:=siss[sis];
     mysis:=cursis.sis;
     //if lmmids[lu-1,1]='*' then begin mymid:=mysis[1]+'';end;// else    mymid:=lmmids[lu-1,1];
     writeln('<li>sis:',b(mysis+'.'),' ',cursis.ekaav,'...',cursis.vikaav,' ',cursis.w);
     //if lu=1 then continue;
     writeln('<ul>');
    for av:=cursis.ekaav to cursis.vikaav do
    begin
      curav:=avs[av];
      if (lu+52<63) or (lu+52>76) then myav:=curav.v else  myav:=curav.h;
      writeln('<li>',b(curav.v+curav.h),' ',curav.ekasana,'...',curav.vikasana,' ',sanat[curav.vikasana].san,sanat[curav.vikasana].akon,' ',curav.w);
      //for san:=curav.ekasana to curav.vikasana do writeln(' ',reversestring(mymid+mysis+''+myav+''+sanat[san].san+sanat[san].akon)+'a');
    end;
    writeln('</ul>');
   end;
   writeln('</ul>');
  end;
  writeln('</ul>');
  writeln('<li>ss',sanat[4908].san);
end;
procedure tverbit.etsi(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
var sanasopi,sanajatko,avsopi,avjatko,sissopi,sisjatko,lkasopi,lkajatko,sikaloppu,sikasopi,xvok:string;
    curlka:tverlka;cursis:tversis;curav:tverav;cursan:tvsana;
    cutvok,cutav:integer;
    //cut_si,cut_av,cut_lka,cut_san,i,j:integer;
    tc,hakutc:integer;
     d,hakueitaka,hakueietu,heikkomuoto,hit:boolean;
     siat,sikanum,lu:integer;sika:tsija;resst:string;
     eatkon:boolean;
//procedure checkhit(yht,sanax,hakux:string;sa:integer);
procedure checkhit(yht,sanax,hakux:string;sa:integer);
var thishit:thit;sana,color:string;
begin

  sana:=sanat[sa].san;
//     if hakueitaka then if sanat[sa].takavok then exit;
//     if hakueietu then if not sanat[sa].takavok then exit;
     if hakux=sanax then color:='green'
     else if hakux='' then color:='blue'
     else if sanax='' then color:='purple'
     else color:='red';
     if not sanat[sa].takavok then sana:=etu(sana);
    // if hakueitaka then todo:=etu(todo);
    //if d then
    writeln('<li style="color:',color,'">%',curlka.kot,'#',sika.num,'/<em>',
    sanat[sa].akon, reversestring(sikasopi+'.'+lkasopi+'/'+sissopi+'\'+avsopi+'|'+sana),'/</em>',sa,
     ' ',sanat[sa].akon,'<b>',reversestring(sanax+'/'+hakux+':'+yht),'</b> ');
   // writeln('<li style="color:',color,'">',sopi,'|',sanax,hakux);
  exit;
  thishit:=thit.Create;
  with thishit.sana do
  begin
    alku:=cursan.san;
    akon:=cursan.akon;
    v:=curav.v;
    h:=curav.h;
    sis:=cursis.sis;
    luokka:=curlka.kot;
    sloppu:=lmmids[luokka-52,0];
    takvok:=not hakueitaka;
    sananum:=sa;   if d then writeln('xxx:',alku,'.',akon,'.',v,h,'.',sis,'.',luokka);
  end;
  vhitlist.add(thishit);
end;

procedure fullhit(sana,haku:string;sa:integer);
var kokosana:string;
begin
  try
  KOKOsana:=reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sana+sanat[sa].akon);
  if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
 resst:=('<b style="color:green" title="'+inttostr(curlka.kot)+'#'+inttostr(sika.num)+'##'+inttostr(sa)+'">H:/'+KOKOSANA +'</b> '+inttostr(19548+sa));
 if d then writeln(resst);
 hit:=true;
 except writeln('failfull');end;
end;

procedure shorthit(sana,haku:string;sa:integer);
var epos:word;kokosana:string;
begin
 //write('<li>[',sana,'/',haku,']',kokosana,':');

  // if sana='' then write('<hr>empty:',sana);
  epos:=length(sana)+1;
  kokosana:=sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[sa].san+sanat[sa].akon;
   if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
  //avsopi+''+(sissopi)+''+lkasopi+''+sikasopi;
 haku:=copy(haku,epos-1);
 //writeln('<li>::::',kokosana,'  :  ',sana,'\',haku,'!',epos);
 //sana:=copy(sana,epos);
 //write('[',copy(hsana,'/',haku,']',epos);//,kokosana,'  . <b>',kokosana[1],'/',haku[1],'+</b>:',lkajatko+'+',lkasopi, ' ',sanat[sa].san);
 //writeln('long:',sanat[sa].akon,reversestring(sikasopi+'.'+lkasopi+'/'+sissopi+'\'+avsopi+'|'+sana)+' --',sana[epos],'\',sana,'\',kokohaku[1],sana,' ',haku);
 if (sana<>'') and ((pos(haku[1],vokaalit)>0) and (pos(haku[2],vokaalit)>0) and
  (isdifto(haku[2],haku[1]))) then
 //if pos(kokosana[2],vokaalit)<1 then
 else //writeln('NOGO:',haku[1],kokosana[1], isdifto(haku[1],kokosana[1]))
 writeln('<b style="color:blue"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">',
 reversestring(kokosana),'/</b>');//,sa,haku);
end;


procedure longhit(sana,haku:string;sa:integer);
var epos:word;kokohaku,kokosana:string;i,tc:integer;olivok:string[2];
begin
kokohaku:=haku+''+avsopi+''+reversestring(sissopi)+''+reversestring(lkasopi)+''+reversestring(sikasopi);
kokosana:=sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[sa].san+sanat[sa].akon;
if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
//if sa=376 then
 //writeln('<li>::::',kokohaku,':',sana,'\',haku,'!');
 epos:=length(haku)+1;
 haku:=copy(haku,epos);
 sana:=copy(sana,epos);
 //write('<span>[',reversestring(sana),'/',reversestring(haku),']',string(kokohaku),'  <b>',reversestring(kokosana),'</b>:');
 //writeln('long:',sanat[sa].akon,reversestring(sikasopi+'.'+lkasopi+'/'+sissopi+'\'+avsopi+'|'+sana)+' --',sana[epos],'\',sana,'\',kokohaku[1],sana,' ',haku);
 try               // [u/]usi uusi: [u/]usi       [uo/]husi kuohusi:
 if  (sana<>'') and ((pos(sana[1],vokaalit)>0) and (pos(kokohaku[1],vokaalit)>0) and (isdifto(sana[1],kokohaku[1]))
 and (pos(kokohaku[2],vokaalit)<1))
  then writeln('<!--NOGO:',kokohaku,'?',sana,'-->')
 else
 begin
     tc:=1;//pit‰is olla tavurajalla, eli tavu on aloitettu.. ei ei: saa uurtaa   -> RUU   aie he > ia   kapusta  ja -> SUPA
     //if pos(kokohaku[1],vokaalit)>0 then olivok:=kokohaku[1] else
     olivok:=''; //
     for i:=1 to length(sana) do
     begin
       if pos(sana[i],vokaalit)<1 then //konsonantti
       begin
        if olivok<>'' then begin tc:=tc+1;olivok:='';end  //konsonanti vokaalin edell‰
        else //kaksoiskonsonantti .. ei mit‰‰n
       end
       else //vokaali
       begin
         if olivok<>'' then  if isdifto(olivok[1],sana[i]) then begin tc:=tc+1;olivok:='';end;
         //else
          olivok:=sana[i];

       end;
       //write(' ',sana[i],olivok,'%',tc);
     end;
     if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
     if (tc mod 2)= 0 then
     writeln('/<b style="color:#888"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">',  reversestring(kokosana),'/</b>');//,sana,'%',tc,',');//,sa,haku);
     //writeln('<li style="color:purple">%',curlka.kot,'#',sika.num,'/<em><b>', reversestring(sikasopi+''+lkasopi+'/'+sissopi+''+avsopi+''+sanat[sa].san+sanat[sa].akon),'/</b></em>',sa,kokohaku[2]);
 end;
 except writeln('FAIL:',kokohaku,'!');end;
end;

function sana_f(san:integer;koita,passed:string):boolean;
var i,j:word;hakujatko,sana:string;yhtlen,slen,hlen:word;
begin
try
cursan:=sanat[san];
sana:=cursan.san;
if eatkon then  delete(sana,1,1);
 //if d then writeln('/S:',red(koita),blue(cursan.san));
 if hakueitaka then if cursan.takavok then exit;
 if hakueietu then if not cursan.takavok then exit;
result:=false;
if xvok<>'' then if length(sana)>0 then delete(sana,1,1);//sana[1]:=xvok[1];
if xvok<>'' then writeln('<li>[**',xvok,'/',sana,']');
//if sana=koita then //if cursan.akon=hakunen.akon then
if sana=koita then if cursan.akon=hakunen.akon then begin fullhit(sana,koita,san);end;
;//else if (sana='') or (pos(sana,koita)=1) then shorthit(sana,koita,san)
//else if (koita='') or (pos(koita,sana)=1) then longhit(sana,koita,san)
//else if cursan.san='' then}
//writeln('<span  style="color:white">%',curlka.kot,'#',sika.num,'/<em><b style="color:blue">',
//reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[san].san+sanat[san].akon),'/</b></em>',san,'</span>');//,kokohaku[2]);
 except writeln('!');//,san,'/',curlka.kot);
 end;
end;

function av_f(av:integer;koita,passed:string):boolean;
var san,i,j:integer;myav:string;
begin
  curav:=avs[av];
  result:=false;;
  myav:=ifs(heikkomuoto,curav.h,curav.v);
  //if d then
  //writeln('<li>{',myav,'}');//,red(koita+xvok),blue(myav),' :',curav.v,curav.h,'/',curav.ekasana,'-',curav.vikasana);
  if cutav>0 then if myav<>'' then begin myav:='';end;
  if d then writeln('<li>(',myav,'/',curav.v+'/',curav.h,'\',cutav,')',red(koita),blue(myav));
  if koita='' then begin result:=true;avsopi:=myav;avjatko:=koita;if d then writeln('<li>AVX:',red(koita+xvok),blue(myav)) end else
  begin
    if (myav='') or (pos(myav,koita)=1)  then result:=true
    else  begin  if pos(myav,koita)=1 then if d then writeln('<li>AVLOPPU:',koita,myav);  exit;
          end;
    avjatko:=copy(koita,length(myav)+1,99);//xvok;
    avsopi:=copy(koita,1,length(myav));//xvok;
  end;
  //avsopi:=myav;

    if d then writeln('/AV:',red(avjatko+xvok),blue(avsopi),' ',curav.ekasana,'..',curav.vikasana);
    try
    //if d then  for san:=curav.ekasana to min(curav.vikasana,curav.ekasana+50) do write('/',sanat[san].san);
    for san:=curav.ekasana to curav.vikasana do //!!!
          sana_f(san,avjatko,passed);
  except writeln('faILAV!!!');end;
end;
function sis_f(sis:integer;koita,passed:string;dbl:boolean):boolean;
var av,i,j:integer;mysis:string;
begin
  cursis:=siss[sis];
  mysis:=cursis.sis;
  if dbl then MYSIS:=MYSIS[1]+MYSIS;
  if d then writeln('<li>sisu:',red(koita),'/',blue(mysis+'!'),cutvok,xvok,' ',cursis.ekaav,'-',cursis.vikaav);
  //writeln('<li> ', curlka.kot,' ',sis,cursis.sis,'#',cursis.ekaav,'-',cursis.vikaav);
  if koita='' then BEGIN sisjatko:=koita+mysis; sissopi:='';END
  ELSE
  begin
    //while (cut>0) and (mysis<>'') {and(koita<>'')} do
    if cutvok=1 then  begin if d then write('?/',koita,cutvok);delete(mysis,1,1);delete(koita,1,0);END;
    if cutvok=2 then  begin mysis:=mysis[1];END;

    result:=false;;
    if (mysis='') or (pos(mysis,koita)=1) then result:=true
    else  begin  if pos(koita,mysis)=1 then if d then writeln('<li>EOW:',curlka.kot,'/',red(koita),'|',blue(mysis));  exit;
    end;
    sisjatko:=copy(koita,length(mysis)+1,99);
    sissopi:=copy(koita,1,length(mysis));
    //sissopi:=mysis;
  END;
   if d then writeln('<li>Sisu:',red(koita),'/',blue(mysis+'!'),cutvok,cutav,xvok);
   if  d then   write('<b>/',sisjatko,'|',sissopi,'\</b>');
    //if d then for av:=cursis.ekaav to cursis.vikaav do write('[',avs[av].v,'.',avs[av].h,']');
    if d then writeln('<ul>');
  for av:=cursis.ekaav to cursis.vikaav do
   av_f(av,sisjatko,passed);
    if d then writeln('</ul>');

end;
function lka_f(lka,sija:integer;koita,passed:string):boolean;
var sisus,i,j,para:integer;luokka:word;mid:string;dbl:boolean;repeats:integer;
begin
  curlka:=luoks[lka];
  repeats:=1;
  //if curlka.kot<>62 then exit;
    if lu+52=68 then repeats:=2;  //kaikilla 68'illa on kaksi taivutustapaa
    if (lu+52 in [55,57,60]) then if sijat[sija].vparad=6 then repeats:=2;
    if (lu+52 in [76]) then if sijat[sija].vparad=5 then repeats:=2;
    if (lu+52 in [74,75]) then if sijat[sija].vparad=9 then repeats:=2;
 repeat
  dbl:=false;
  eatkon:=false;
  if curlka.vahva then para:=sijat[sija].vparad else para:=sijat[sija].hparad ;
  mid:=lmmids[lka,sija];
  if (lu+52=71) then if ((sijat[sija].hparad=2) and  (sija>10)) then begin IF D THEN writeln('!!!???');mid:='ek-' end else if  (sija in [23,28]) then begin IF D THEN writeln('!!!');mid:='k-'; end;
  //aint it pretty?
  if lu+52=68 then if repeats=2 then begin mid:=lmmids[10,sija];end;
  if repeats=2 then if lu+52=55 then if sijat[sija].vparad=6 then  begin mid:='';end;
  if repeats=2 then if lu+52=57 then if sijat[sija].vparad=6 then  begin mid:='-s';end;
  if repeats=2 then if lu+52=60 then if sijat[sija].vparad=6 then  begin mid:='--sk';eatkon:=true;end;
  if repeats=2 then if lu+52=76 then if sijat[sija].vparad=5 then  begin mid:='-nn';end;
  if repeats=2 then if lu+52 in [74,75] then if sijat[sija].vparad=9 then  begin mid:='';end;
  if lu+52=71 then if (sija in [23,28]) then mid:='-k';
  repeats:=repeats-1;
  result:=false;
  cutav:=0;cutvok:=0;xvok:='';
  if mid='*' then begin mid:='';dbl:=true;end;
  //if pos('_',lust)>0 then if pos('__',lust)>0 then cut:=2 else cut:=1;
  //if pos('_',mid)>0 then if pos(koita[1],vokaalit)>0 then
  // begin xvok:=koita[1];mid:='';writeln('xxxxxxxxxxxxxx',xvok,lka+51,curlka.esim);end;//if pos(,koita)begin
  while (mid<>'') and (mid[length(mid)]='_') do begin if d then write('?',mid);cutvok:=cutvok+1;delete(mid,length(mid),1);end;
  //v‰livokaaleissa pihistell‰‰n
  while (length(mid)>0) and (length(koita)>0) and (mid[1]='-') do
   begin cutav:=cutav+1;delete(mid,1,1);delete(koita,1,0);; end;
   //av-konsonanttia ei vaadita kun on joku vakkari (s) tilalla
  if d then writeln('<li>TRY:',lka+52,curlka.esim,' #',sija,'<b>',mid,'/',lmmids[lka,sija],'/</b>'
   ,ifs(curlka.vahva,'v:'+inttostr(sika.vparad),'h'+inttostr(sika.vparad)),'=',para,' ',red(koita),' / ', blue(mid),cutvok,cutav,'///',curlka.ekasis,'-',curlka.vikasis,'::',repeats,'</li>');
  if d then for sisus:=curlka.ekasis to curlka.vikasis do writeln('!\',siss[sisus].sis);
  //exit;
  if (mid='') or (koita='') OR (pos(mid,koita)=1) then result:=true
  else
  begin
       //62naida a / -12-12:: /ei:a-
     if pos(koita,mid)=1 then if d then writeln('//EOW:',koita,mid);   if d then write('/ei:',blue(koita),red(mid));
     continue;
  end;
  //if pos(koita,mid)=1 then writeln('//EOW:',koita,mid);
  lkajatko:=copy(koita,length(mid)+1,99);
  lkasopi:=copy(koita,1,length(mid));
  //lkasopi:=mid;
  heikkomuoto:=false;
  if curlka.vahva then begin if  sija in vvahvanheikot then heikkomuoto:=true;end
  else  if  sija in vheikonheikot then heikkomuoto:=true;
  if d then   writeln('<li>LK:',lka+52,red(lkajatko),' / ', blue(lkasopi), curlka.ekasis,'-',curlka.vikasis,koita,'(',mid,')',heikkomuoto,'</li>');
  //if d then for sisus:=curlka.ekasis to curlka.vikasis do writeln('!\',siss[sisus].sis);
  if d then   writeln('<ul>');
  for sisus:=curlka.ekasis to curlka.vikasis do
   sis_f(sisus,lkajatko,passed,dbl);
  if d then writeln('</ul>');
 until repeats<=0;
end;
// tverbit.etsi(
var sikalauma:tstringlist;passed:string;
begin
try

///writeln('ykshaku');
vhitlist.clear;
d:=false;
//d:=true;
   sikalauma:=tstringlist.create;

     try
     sikalauma.clear;
     haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p‰‰te m‰ts‰‰ hakusanaan
     //for lu:=0 to 25 do  writeln(' /',lu,' ',lu+52,lmmids[lu,1]);

     if d then
       for siat:=0 to sikalauma.count-1 do writeln('<li>--',sikalauma[siat],ptrint(sikalauma.objects[siat]),sijat[ptrint(sikalauma.objects[siat])].ending);
     //if d then   writeln('<li>hae:',hakunen.akon,'|<b>',string(hakunen.koko),'</b>:',sikalauma.count);//,'<ul></li>');
     except writeln('faildosiat');end;
     resst:='';
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
        sikanum:=ptrint(sikalauma.objects[siat]);
        //if sikanum<>0 then continue;
        sika:=sijat[sikanum];
        sikaloppu:=sikalauma[siat];
        if sikaloppu='' then begin continue;passed:=copy(sika.ending,1,length(hakunen.loppu));
           sikasopi:=copy(sika.ending,length(hakunen.loppu),999);writeln('<li>HAKLO:',passed,'/',hakunen.loppu,'/',sikasopi);end
        ;//else continue;
        sikasopi:=sika.ending;//(sikaloppu,length(sikaloppu)-length(sika.ending)+1);
        hakutc:=tavucount(hakunen.koko);
        //if d then
        //writeln('<li>muoto:',reversestring(sikaloppu),'|',reversestring(sikasopi),' //<b>',reversestring(sika.ending),'#</b>',sika.num,'! ',hakunen.koko,hakutc);
        hakutc:=hakutc mod 2;
        hakueitaka:=hakunen.eitaka;
        hakueietu:=hakunen.eietu;
        if d then writeln('<li>HAKUNEN::',hakunen.lk,' #',sika.num,'><b>',listsija(sika),'</b> ',sikaloppu,'/ea:',hakueitaka,'/e‰',hakueietu);
        if d then writeln('<ul>');
        for lu:=0 to 24 do
         //???? if (hakunen.lk=0) or (hakunen.lk=lu) then
          //if lu+52=57 then
          lka_f(lu,sikanum,sikaloppu,passed);

        if d then writeln('</ul>');
     end;
     if resst='' then
       writeln('<li>Eiei::',hakunen.koko,' :',hakunen.lk,' #',sika.num,'><b>',listsija(sika),'</b> ',sikaloppu,'/ea:',hakueitaka,'/e‰',hakueietu,'</li>');
     if d then writeln('</ul>');

except writeln('<li>failetsi');end;

end; //etsi
procedure tverbit.etsiold(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
var
 ha,lu,siat,sisus,sikanum,av,sa:integer;
 sss:ANSIstring;
 sika:tsija;
 d,hakueitaka,hakueietu:boolean;
 //hakukonst,
   l_sija,l_lu,did_sis,todo_sis,todo_av,did_av,todo_san,did_san:string;
 ekaero,myav,a_sija,a_lu,lopvok:string;
 //cut,lkcut:WORD;
 //xhakusanat,
 tc,hakutc:integer;
 ahit:tkokosana;
 sikalauma, riimit,xxresu:tstringlist;
 vahvako,takako,xkon,nogood:boolean;
 erotus:integer;
 eka,vika:integer;
 //liika,sisliika,avliika,sanliika:string;liikatavut:integer;
  //string[15];
  function red(st:string):string;
  begin result:='<b style="color:red">'+st+'</b>';
  end;
  function blue(st:string):string;
  begin result:='<b style="color:blue">'+st+'</b>';
  end;

  function muotosopii(anas,uppol:ansistring;var tamaj,tamahit:ansistring;vAR cut:integer):boolean;
  var s:string;
  begin
   try
   result:=false;
   s:=uppol;
   cut:=0;
   xkon:=false;
  //writeln('?__(',anas,'/',uppol,pos('*',uppol),') ');

   while (uppol<>'') and (uppol[length(uppol)]='-') do
   begin //write('*');
      cut:=cut+1;
       delete(uppol,length(uppol),1);
    end;
   if pos('*',uppol)>0 then // luokassa 52 myˆs vokaaki punoa -> punoo, murtua, //if pos(anas[1],konsonantit)>0 then
   begin     //tuplakonsonantti tulossa sanan alussa luokan m‰‰reiden mukaan, viel‰ ei tiedet‰ mik‰, pannaan muistiin ett‰ osataan tsekata seuraavassa vaiheessa
       //writeln('<li>tuplakonsonantti');
       xkon:=true;
       //writeln('<li>didxkon');
       if anas<>'' then uppol:=anas[1] else uppol:='';
    end else
   if anas='' then begin result:=true;tamaj:='';tamahit:=uppol;writeln(''); exit;end;
   tamaj:='';
   if (uppol<>'') and (pos(anas,uppol)=1) then
   begin
      //.liika:=reversestring(uppol);
      //liika:=reversestring(copy(uppol,length(anas)+1));
      tamahit:=(uppol);
      tamaj:='';
      result:=true;
      //writeln('lˆytyijo:',tamahit,'!');
   end else
   if (uppol='') or (pos(uppol,anas)=1) then
   begin
    result:=true;
    tamaj:=copy(anas,length(trim(uppol))+1);
    tamahit:=(uppol);//writeln('>>',uppol,'>',anas);
   end;
  //finally //if lu+52=61 then if result then writeln('<li>fitted:[',s,']<b>got:',tamahit,' </b>/left:',tamaj,'/cut:',cut);
  //end;
  except writeln('eimuotosovisovittaa');end;
  end;

  //function sopii(anas,uppol:string;var alku,loppu:string;var cut:integer):boolean;
  function sopii(anas,uppol:string;var sopi,remains:string;var cut:integer):boolean;
  var eiloppu:boolean;
  begin
  try
  //writeln(anas,'/',uppol,' ');
    {liloppu:=anas='';
    if oliloppu then if lopvok<>'' then
    begin
      if pos(uppol[1],vokaalit)>0 then
        if not isdifto(uppol[1],lopvok[1]) then begin writeln('<li>eikelpovokaali'); end
        else begin writeln('<li>okvokaali'); end;
    end;}
   //if lu+52=69 then
  //if anas='' then
  //if nogood then  writeln('<li>wasnogood:[[',anas,'/',uppol,'#',cut,']]');          //{ti/tio#0}
   try   //loppu reversoitu, mik‰ ei kai hyv‰ ...
   // alku = pala joka todetaan sopivaksi ja poistetaan hausta , loppu=j‰ljelle j‰‰v‰, myˆhemmin tutkittava (oikeasti sanan alku).
   //s:=uppol;
   result:=false;
   //if uppol='' then writeln('Empty:');
   //WHILE (uppol<>'') AND (cut>0) do BEGIN write('?',uppol[1]);delete(uppol,1,1);cut:=cut-1;END;
   WHILE (uppol<>'') AND (cut>0) do
   BEGIN //write('?',uppol[1]);
    delete(uppol,1,1);cut:=cut-1;END;
   //if anas='' then
   if anas=uppol then begin
      remains:='';sopi:=uppol;result:=true;
     exit;
   end;
   if (anas='') or (pos(anas,uppol)=1) then
   begin
    //jos sana oli tyhj‰, niin ohitetaan vaatimus sopivuudesta ja pannaan sovitettava muistiin ik‰‰n kuin olisi sopimut (tutkittava sana pidempi kuin rimattava)
    result:=true;
    //if (uppol<>'') and (pos(uppol[1],vokaalit)>0) then nogood:=true else nogood:=false;
    remains:='';//edelleen ei mit‰‰n etsitt‰v‰‰;
    sopi:=copy(uppol,length(anas)+1); //writeln(uppol,'-',anas,'==',sopi);//
    exit;
   end;
   sopi:='';
   if (uppol='') or (pos(uppol,anas)=1) then
   begin
    result:=true;
    remains:=copy(anas,length(trim(uppol))+1);
    sopi:=uppol;
   end;
    finally
     //if lu+52=69 then if result then writeln('<li>fit:',uppol,'/',anas,'==',alku,'/',loppu,'%',cut,'_',s,'!')    else writeln('nogo:',anas,'/',s,cut,'!');
      //if not oliloppu then if remains='' then writeln('<li>LOPPU:',anas,'/',uppol,'#',cut,result,']]')          //{ti/tio#0}
      ;//else writeln('+[[',anas,'/',uppol,'#',cut,']]');

    end;
    except writeln('<li>eisovisovittaa');end;
  end;

procedure savehit(todo:string);
var thishit:thit;
begin
  //writeln('<h1>exact:',todo,'/',sanat[san].san,san,'</h1>');
  thishit:=thit.Create;
  with thishit.sana do
  begin
    alku:=sanat[sa].san;
    akon:=sanat[sa].akon;
    v:=ahit.v;
    h:=ahit.h;
    sis:=ahit.sis;
    luokka:=ahit.luokka;
    sloppu:=lmmids[luokka,0];
    takvok:=not hakueitaka;

    sananum:=sa;
    if d then writeln('xxx:',alku,'.',akon,'.',v,h,'.',sis,'.',luokka);
    //xxx:kki.p..iu.37 !kki
  end;
  vhitlist.add(thishit);
end;
var cut_si,cut_av,cut_lu,cut_san,i,j:integer; pvok:boolean;//haku:string;

begin
try
//writeln('ykshaku');
vhitlist.clear;
d:=false;
d:=true;
   sikalauma:=tstringlist.create;

     try
     //haku:=reversestring(hakunen.koko);
     sikalauma.clear;
     //hakukonst:='';
     //while pos(haku[length(haku)],konsonantit)>0 do begin hakukonst:=haku[length(haku)]+hakukonst;delete(haku,length(haku),1); end;
     haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p‰‰te m‰ts‰‰ hakusanaan

     if d then for siat:=0 to sikalauma.count-1 do writeln('<li>--',sikalauma[siat],ptrint(sikalauma.objects[siat]),sijat[ptrint(sikalauma.objects[siat])].ending);
     if d then writeln('<li>haetaan:',hakunen.koko,'|<b>',hakunen.akon,'</b>',sikalauma.count,'</li>');
     except writeln('faildosiat');end;
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
       if d then writeln('<li>???:',hakunen.loppu,':');
         sikanum:=ptrint(sikalauma.objects[siat]);
        sika:=sijat[sikanum];
        l_sija:=sikalauma[siat];
        hakutc:=tavucount(hakunen.koko);
        //for i:=1 to length(haku) do if pos(haku[i],konsonantit)>0 then begin if pvok then hakutc:=hakutc+1;pvok:=false;end else pvok:=true;
        if d then writeln('haemuoto:',l_sija,hakutc,' /p‰‰te=',sika.ending,sika.num,'!',hakunen.koko,hakutc);
        hakutc:=hakutc mod 2;
        if d then writeln('haemuoto:',l_sija,hakutc,' /p‰‰te=',sika.ending,sika.num,'!',hakunen.koko);
        //hakutakvok:=pos
        //voksointu(l_sija,hakueietu,hakueitaka);
        hakueitaka:=hakunen.eitaka;
        hakueietu:=hakunen.eietu;
        //IF D THEN
        if d then writeln('<li>HAKUNEN::',reversestring(l_sija),'#',sika.num,'>',sika.vparad,'.<b>PƒƒTE:',reversestring(sika.ending),'</b>/',l_sija,'/ea:',hakueitaka,'/e‰',hakueietu,'<ul>');
        for lu:=0 to 25 do
        //for lu:=0 to 0 do
        begin
           //d:=true;//lu+52=52;
           //if lu+52<>56 then continue;
           if d then  writeln('<li>?? ',lu+52,'#',sikanum,'[',lmmids[lu,sikanum],']',protomids[lu,sika.vparad],':',L_SIJA);
            cut_lu:=0;
            //.liika:='';
            //IF D THEN writeln('<li>lka::<b>/',lu+52,'#',sikanum,'\</b>',lmmids[lu,sikanum],'|');
            //cut_si:=cut_lu;
         try
           //.liika:='';
          if not muotosopii(l_sija,lmmids[lu,sikanum],l_lu,a_lu,cut_lu) then begin        //  writeln('<li>nogo!##!',lu,'#',sikanum);
             continue;end;
         except writeln('ei:sija',l_sija,'/m:',lmmids[lu,sikanum],'/lul:',l_lu,'/a',a_lu,'/cut:',cut_lu,'!');raise;end;
         try
            IF D THEN
            writeln('<li>lu::',lu+52,'#',sikanum,'+++!',red(a_lu),blue(l_lu),'#',l_lu,cut_lu,'<b>mid:',lmmids[lu,sikanum],'!</b>');
            if luoks[lu].vahva then begin if sika.vv then vahvako:=true else vahvako:=false;end
            else begin if sika.hv then vahvako:=true else vahvako:=false;end;
            //if lu=0 then WRITELN('sopii!xkon=',xkon,'!');
              ahit.luokka:=lu;
            IF D THEN for sisus:=luoks[lu].ekasis to luoks[lu].vikasis do write('_',siss[sisus].sis,'_');
            if d then writeln('<ul>');
         except writeln('ei:luokka',l_sija,'/m:',lmmids[lu,sikanum],'/lul:',l_lu,'/a',a_lu,'/cut:',cut_lu,'!');raise;end;
          try
            for sisus:=luoks[lu].ekasis to luoks[lu].vikasis do
            begin                  //SISUSKALUT
               try

               cut_si:=cut_lu;
               //sisliika:=liika;
               IF D THEN  write('<li>sis:(',siss[sisus].sis,':',cut_si,'/',cut_lu,l_lu,')',cut_si,'=?',red(l_lu),'?');
               //        writeln('#####',lu);

               if not sopii(l_lu,siss[sisus].sis,did_sis,todo_sis,cut_si) then continue;
               //if lu+52=62 then
               IF D THEN writeln('<li>SIS=',red(todo_sis),blue('+'+did_sis),'<b>.',a_lu,'</b>#|',sika.ending,'_',a_lu,cut_si,'/',ifs(xkon,'XKON','eixkon'),'\',cut_si,'!',siss[sisus].sis,'!',sisus);
               if d then writeln('::',sisus,'/',xkon);
               try
               if xkon then if (a_lu='') or (siss[sisus].sis[1]<>a_lu[1]) then continue;//begin writeln('<li>latefail::',siss[sisus].sis[1],'!=',a_lu[1]);continue; end;
               except writeln('error:mississ');continue;end;
               //miten xcon and sisliika<>''??
               ahit.sis:=siss[sisus].sis;
               except writeln('--------');end;
               for av:=siss[sisus].ekaav to siss[sisus].vikaav do
               begin   //AV
                  try
                   cut_av:=cut_si;
                   myav:=ifs(vahvako,avs[av].v,avs[av].h);
                   ahit.h:=avs[av].h;
                   ahit.v:=avs[av].v;
                   //.avliika:=sisliika;
                   IF D THEN writeln('<li>AV::',red('('+todo_sis),blue(did_sis+')'),'<b>[[',myav,'</b>',avs[av].v,avs[av].h,']]',cut_av,'.',cut_si,'/[',hakunen.koko,lu+52);
                   //if avliika<>'' then begin avliika:=myav+avliika;end else
                   //if l_sis='' then begin avliika:=myav+avliika;writeln('"',avliika);end else
                   if not sopii(todo_sis,myav,did_av,todo_av,cut_av) then continue;
                   eka:=avs[av].ekasana;vika:=avs[av].vikasana;
                   if hakueietu then  vika:=eka+avs[av].takia-1;
                   if hakueitaka then eka:=avs[av].ekasana+avs[av].takia;
                    //  AV::(iao)[[#0.0/]]/lsis:FALSE [[ia/#0]] ,  //hioin
                                                                   //aioin
                                 // av+++            |ia               |o 74...74:::74...75...74TRUEFALSE
                   if d then writeln(',av+++',red(todo_av),'|',blue(did_av),'   |',did_sis,' ',eka,'...',vika,':::',avs[av].ekasana,'...',avs[av].ekasana+avs[av].takia,'...',avs[av].vikasana,hakueietu,hakueitaka,'::',SANAT[EKA].SAN,SANAT[EKA].AKON);
                    //  [[ia/i#0]] (((o))
                   //IF D THEN  for sa:=eka to vika do writeln('\',sanat[sa].akon+reversestring(sanat[sa].san));
                   if d then writeln('<ul>');
                   for sa:=eka to vika do
                   begin
                     if  onjolist<>nil then if onjolist.indexof(pointer(sa))>=0 then continue;
                     //writeln('[',sanat[sa].san);
                     //writeln(todo_av,'/',sanat[sa].san,sanat[sa].akon,'\');
                     cut_san:=cut_av;
                     if cut_av>0 then writeln('<h1>CUTSANA</h1>');
                     if not sopii(todo_av,sanat[sa].san,did_san,todo_san,cut_san) then continue;// begin writeln('ZZZ:',todo_av,'/',sanat[sa].san);continue;end;
                     //if length(todo_san)>=length(l_av) then
                     //writeln('<LI>|||',todo_san,'|');
                     //if (pos(todo[j],vokaalit)>0) or (pos(target[j],vokaalit)>0) then exit;// else writeln('+',todo[i]);
                     //writeln(sa,' ');
                     if d then IF TODO_san<>'' then if pos(todo_san[1],vokaalit)>0 then writeln('<li>VOKVOKVOK');
                     sss:=sika.ending+a_lu+''+did_sis+''+did_av+''+sanat[sa].san;
                     erotus:=length(hakunen.loppu)-length(sss);
                     if erotus<>0 then
                     begin
                     if erotus<0 then     //sss longer
                       ekaero:=copy(sss,length(sss)+erotus+1,1)
                     else
                       ekaero:=copy(hakunen.loppu,length(hakunen.loppu)-erotus+1,1);
                       if pos(ekaero,VOKAALIT)>0 THEN BEGIN if d then  WRITELN('<LI>EIKƒY:',SANAT[SA].AKON+REVERSESTRING(SSS),'/',hakunen.akon+reversestring(hakunen.loppu));continue;END;
                     end;
                     //writeln('<li><b>',sss,'</b> %',haku,'%',erotus,sanat[sa].akon);
                     sss:=reversestring(sss);
                     //if myav='' then if todo_san<>'' then if pos(todo_san,vokaalit)>0 then begin  writeln('<b>(((',todo_san,'))</b>');continue; end;
                     //if (sanat[sa].akon=hakukonst) then
                     //if d then
                     //writeln('<li>!!?!!',sss,'=',haku,'//e:',sika.ending+'/lu:',a_lu+'/si:'+a_sis+'/av:',a_av+'/sa:'+sanat[sa].san+'/k:'+sanat[sa].akon);
                     //if d then if length(sss)>length(hakunen.loppu)
                     //then writeln('<li style="color:red">!!?!!',sss,'=',hakunen.loppu,'//e:',sika.ending+'/lu:',a_lu+'/si:'+did_sis+'/av:',did_av+'/sa:'+sanat[sa].san+'/k:'+sanat[sa].akon,'</li>')
                     //else writeln('<li style="color:green">!!?!! ',sanat[sa].akon+ '',(sss),'=',hakunen.loppu,'//e:',sika.ending+'/lu:',a_lu+'/si:'+did_sis+'/av:',did_av+'/sa:'+sanat[sa].san+'/k:'+sanat[sa].akon,sa,'</li>');
                     if reversestring(sanat[sa].akon)+sss=hakunen.akon+reversestring(hakunen.loppu) then
                     savehit(did_san);
                     tc:=tavucount(sss);
                     if tc mod 2 <> hakutc then begin //if d then   writeln('HIT:ERIPARI:',sanat[sa].akon+'>', sss,tc mod 2,hakutc,tc);
                        continue;end;
                     sss:=reversestring(sanat[sa].akon)+sss;
                     if sanat[sa].takavok then sss:=etu(sss);
                     if onjolist<>nil then onjolist.add(pointer(sa));
                     aresu.add(sss);
                    //if d then

                    if d then writeln('<li>HIT:',sss,lu+52,'#',sikanum,'/',sa,'<li>',sika.ending,'/',did_sis,'/',did_av,'/<b>'+sanat[sa].san,'</b>',sanat[sa].akon,'!!!<b>',did_san,'</b>!',sanat[sa].akon=did_san,sa,'!!',did_av,'!!<b>tc=',tc,'</b>:',sanat[sa].san,':</li>');
                    //if onjolist<>nil then writeln('--',onjolist.indexof(pointer(sa)));
                    //break;
                   end;
                   if d then writeln('</ul>');
                   except writeln('eiverav');raise;end;
               end;  //AV
               if d then writeln('</ul>sisuskalut');
             end;   //SISUSKALUT
          except writeln('eiverilka',52+lu);raise;end;
             writeln('</ul>');
          end;  //TAIVUTUSLUOKKA
          if d then writeln('</ul>','didluokka',lu);
          //writeln('##',reversestring(haku));
      end; // SIJAMUOTO
     if d then writeln('</ul>tehtiinkaisika');
     except writeln('</ul>eeieieitehtiinkaisika');end;
end;


procedure tverbit.haesijat(haku:ansistring;sikalauma:tstringlist);
var i,lk,hitpos:integer;mylop:ansistring;j:ptrint;a:ansichar;
begin
 // KAIKKI ON JO REVERSOITU
//writeln('<hr>HAESIJAT:',reversestring(haku));
for j:=0 to 66 do
 begin
     //if mylop='*' then
    //writeln('<li>sija:',j,' ',sijat[j].ending,'=',haku,'?');
    mylop:=sijat[j].ending; ////VERBEISSA EI loppup‰‰tteiss‰ toistoja kuten nominien illatiiviss‰
    if mylop='*' then writeln('<li>sija:',j);
    if (mylop='') or (mylop='*') then hitpos:=1 else
    //if matchendvar(haku,mylop,alku) then  //EIIKƒ TƒTƒ KUN KAIKKI ON KƒƒNNETTU
    hitpos :=POS(mylop,haku);
    //if hitpos>0 then writeln(' [:<b>',j,reversestring(mylop),':</b>', hitpos,haku,'] ');
    if hitpos=1 then  //EIIKƒ TƒTƒ KUN KAIKKI ON KƒƒNNETTU
   begin
        sikalauma.addobject(mylop,tobject(@sijat[j]));//@sijat[j]));  //TEMPPUILUA, NUMERO PANNAAN OBJEKTIPOINTTERIIN

    //sikalauma.addobject(copy(haku,length(mylop)+1)+','+mylop,tobject(j));//@sijat[j]));  //TEMPPUILUA, NUMERO PANNAAN OBJEKTIPOINTTERIIN
//    writeln('+++',j);
  //ei etsit‰ riimej‰ suoraa p‰‰tteist‰ (grillasi/ maisillasi)
   end else if pos(haku,mylop)=1 then
   sikalauma.addobject('',tobject(@sijat[j]));//@sijat[j]));  //TEMPPUILUA, NUMERO PANNAAN OBJEKTIPOINTTERIIN
 end;
end;

procedure tverbit.luesanat(fn:string);
var sl:tstringlist;ms:tsija;sanafile:textfile;sana,konsti,myav:ansistring;
i,j,k,l:word;differ:byte;
  prevsl:tstringlist;
  clka,csis,cav,csan,ulka:integer;
  prlim:word;
procedure uusluokka;
begin
try
   luoks[clka].vikasis:=csis;
   luoks[clka].w:=csan-1;
   clka:=clka+1;
   luoks[clka].ekasis:=csis+1;
   //writeln('</ul><li>LKA <b>',clka+52,'</b>:',luoks[clka].ekasis,'-',csis,'  ',sana,' //','::<b>',clka,'/',csis,'/',cav,'/',csan,'</b><ul>');
 try luoks[clka].esim:=sl[7];except luoks[clka].esim:='xxx';end;
 luoks[clka].kot:=strtointdef(prevsl[0],99);//clka+51;
 if (clka+52<65) or (clka+52=76) then   luoks[clka].vahva:=true else  luoks[clka].vahva:=false;
 prlim:=0;
except writeln('faillka');end;

end;
procedure uussis;
begin
siss[csis].vikaav:=cav;
siss[csis].sis:=prevsl[1];//+prevsl.commatext);
siss[csis].w:=csan-1;
csis:=csis+1;
siss[csis].ekaav:=cav+1;
siss[csis].sis:=(sl[1]);
prlim:=0;
//writeln('</ul><li>SIS:',csis,' /sana',csan,'  /lka:<b>',clka,'/','</b> ',csan+19548,'<ul>');
end;
procedure uusav;
begin
avs[cav].w:=csan-1;
avs[cav].vikasana:=csan-1;
avs[cav].v:=prevsl[2]; //prob redundant
avs[cav].h:=prevsl[3];
 if avs[cav].v='_' then avs[cav].v:=avs[cav].h;
 //writeln('<li>','<b>av:',avs[cav].v,avs[cav].h,'</b>','..',csan, '   ',sl[2],sl[3],' :::',clka,'/',csis,'/',cav,'/',csan);
cav:=cav+1;
//if sl[4]='0' then begin avs[cav].ekasana:=csan+1;end else  begin avs[cav].ekasana:=9999; avs[cav].takia:=csan+1;end;
avs[cav].ekasana:=csan;
avs[cav].takia:=0;
avs[cav].v:=sl[2];
avs[cav].h:=sl[3];
if avs[cav].v='_' then avs[cav].v:=avs[cav].h  //"_" k‰ytettiin aastevaihtelun puuttumisen merkkaamiseen. sorttautuu siistimmin
else prlim:=0;
//write(' >',avs[cav].v,avs[cav].h);
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
  //prevsl.commatext:='52,o, , ,0,i,h,';
  //prevsl.commatext:='x,x,x,x,x,';
  //while (not eof) and (readln(sanafile,sana);
  //prevsl.commatext:=sana;
  luoks[0].vahva:=true;
  luoks[0].ekasis:=0;
  siss[0].ekaav:=0;
  avs[0].ekasana:=0;
  writeln('xxxxxxxxxxxxxxx');
  while not eof(sanafile) do
  begin
     try
     readln(sanafile,sana);
     sl.commatext:=sana;
     ulka:=strtointdef(sl[0],0);
     //if ulka>58 then break;
     if ulka<52 then continue;
     if alko then begin prevsl.commatext:=sana;end;  //eka sana ei aloita luokkia
     differ:=4;
     for i:=0 to sl.count-2 do if prevsl[i]<>sl[i] then begin differ:=i;break; end;
    if differ=3  then differ:=2;      // av-heikot erosivat mutta vahva oli sama. yhdistet‰‰n - AV oli eri
    if (differ<1) then uusluokka;
    if (differ<2) then  uussis;
    if (differ<4) then uusav;
         //if sl[4]='0' then avs[cav].takia:=csan+1; //pit‰is olla sortattu vokaalisoinnun mukaan, eli ei tarttis laittaa  joka sanalle talteen
    sanat[csan].san:=(sl[5]);
    sanat[csan].takavok:=sl[4]='0';
    sanat[csan].akon:=(sl[6]);
    if sl[4]='0' then avs[cav].takia:=avs[cav].takia+1;  //lasketaan takavokaalisten m‰‰r‰‰ av-luokassa hakujen tehostamiseksi
    //if not alko then
    //if alko then
    //if not alko then
    csan:=csan+1;
    alko:=false;
    prevsl.commatext:=sana;  //t‰h‰n taas seuraavaa sanaa verrataan
    prlim:=prlim+1;
    except writeln('failav');end;
    if clka>=12  then myav:=avs[cav].h else myav:=avs[cav].v;   //heikot muotot
    if (clka<12) or (clka>23) then myav:=avs[cav].v else myav:=avs[cav].h;   //12 ekaa ja pari vikaa ovat vahvoja
   end;
  writeln('<h1>LKS:',CLKa,' /sis:',csis,' /av:',cav,' /w:',csan,'</h1>');
  for i:=0999 to clka do
   begin
       writeln('<li>',i+52,'<ul>');
       for j:=luoks[i].ekasis to luoks[i].vikasis  do
       begin
          writeln('<li>',j,':',siss[j].sis,'<ul>');
          for k:=siss[j].ekaav to siss[j].vikaav  do
          begin
             writeln('<li>',k,':',avs[k].av,avs[k].v,avs[k].h,'<ul>');
             writeln('<li>',avs[k].ekasana+19548,sanat[avs[k].ekasana].san,'',sanat[avs[k].ekasana].akon,' ',avs[k].vikasana+19548,sanat[avs[k].vikasana].san,sanat[avs[k].vikasana].akon);

              writeln('</ul>');
          end;

           writeln('</ul>');
       end;

       writeln('</ul>');
   end;

end;



constructor tverbit.create(wfile,midfile,sijafile:string);
begin
writeln('luemids');
vhitlist:=tlist.create;
luemids(midfile);//'vmids.csv');
writeln('luettu,luesijat');
writeln('lue');
luesijat('vsijat.csv');
writeln('luettu,listaa');
//listaasijat;
writeln('listattu');
//luesanat(wfile);
writeln('<hr>etsi<hr>');
//etsi;
//  writeln('<hr>listaakaikki<hr>');
//   listaasanat;
writeln('<hr>listaSkaikki<hr>');
end;


procedure tverbit.createsija(si:integer;ss:ansistring);
var sl:tstringlist;ms:tsija; j:word;num:integer;
begin
try
sl:=tstringlist.create;
sl.commatext:=ss;
num:=strtointdef(sl[0],98);
sijat[si].num:=num;
sijat[si].vparad:=strtointdef(sl[1],255);
sijat[si].hparad:=strtointdef(sl[3],255);
sijat[si].vv:=sl[2]='v1';
sijat[si].hv:=sl[4]='h1';
sijat[si].ending:=reversestring(sl[5]);
sijat[si].onverbi:=true;
sijat[si].name:=vsijanimet[num];
sijat[si].esim:=vsijaesim[num];
//writeln('<li>',si,':',sl.commatext,':');

for j:=0 to 27 do
  //if (j<12) or (j>24) then
  if (j+52<64) or (j+52=76) then
   lmmids[j,si]:=reversestring(protomids[j,sijat[si].vparad])
 else //for j:=12 to 27 do
   lmmids[j,si]:=reversestring(protomids[j,sijat[si].hparad]);
//luoks[0].vahva:=true;
except
writeln('<li>fail:',si,':',sl.count,'!</li>');
end;
//writeln(',',si,lmmids[0,si]);
sl.free;
end;
procedure tverbit.listaasijat;
var lu,si:word;
begin
  writeln('<table border="1"><tr><td></td>');
  for si:=0 to 64 do
   writeln('<td>',si,'</td>');
  writeln('</tr><tr><td></td>');
  for si:=0 to 64 do
   writeln('<td>',sijat[si].vparad,' ',sijat[si].hparad,'</td>');
  writeln('</tr>');
  writeln('<tr><td>xx</td> ');
  for si:=0 to 64 do
   writeln('<td>',si,reversestring(sijat[si].ending),'</td>');
  writeln('</tr>');
  for lu:=0 to luokkia do
  begin
    //if (lu+52>59) or (lu>63)  then continue;
    writeln('<tr><td>',ifs(luoks[lu].vahva,'<b>'+inttostr(lu+52)+'</b>',inttostr(lu+52)),'</td>');
    for si:=0 to 64 do
    writeln('<td>',lu,si,reversestring(lmmids[lu,si]),'</td>');
    //writeln('<td>',lmmids[lu,sijat[si].vparad],'</td>');
    writeln('</tr>');
   end;
   writeln('</table');



end;

procedure tverbit.luesijat(fn:string);
var i,j:integer;
 vheikot,hheikot,vvahvat,hvahvat:string;
 slist:tstringlist;
begin
 slist:=tstringlist.create;
 slist.loadfromfile(fn);//'vsijat.csv');
 for i:=0 to slist.count-1 do     // 0..65
 begin
  createsija(i,slist[i]);
  if sijat[i].vv then  vvahvat:=vvahvat+','+inttostr(i) else vheikot:=vheikot+','+inttostr(i);
  if sijat[i].hv then hvahvat:=hvahvat+','+inttostr(i) else hheikot:=hheikot+','+inttostr(i);
  //writeln('<li>',i,':',vsijanimet[i],'/',vsijaesim[i],' <b>',reversestring(sijat[i].ending),'</b>');
 end;
 {for i:=1 to 11 do
  begin
   for j:=1 to slist.count-1 do
     if (sijat[j].vparad=i) or (sijat[j].hparad=i) then write('*');
  end;
 //writeln('<table><tr>'); for i:=0 to slist.count for i:=0 to slist count
 }
 slist.free;
end;

procedure tverbit.luemids(fn:string);
var i,j:integer;
 slist,mlist:tstringlist;
begin
writeln('<h1>tverbit.luemids</h1>');
slist:=tstringlist.create;
mlist:=tstringlist.create;
  slist.loadfromfile(fn);//'vmids.csv');
  //writeln('<pre>',slist.commatext,'</pre>');
  slist.delete(0);  slist.delete(0);  slist.delete(0);  slist.delete(0);
  for i:=0 to slist.count-1 do
  begin
     mlist.commatext:=slist[i];
     //writeln('<pre>',mlist.commatext,'</pre>');
     mlist.delete(4);
     //writeln('<pre>',mlist.commatext,'</pre>');
     for j:=1 to 10 do
     begin
      protomids[i,j]:=trim(mlist[j+1]);
     end;
  end;
end;


procedure tverbit.generate(runko,sis,astva:str16;luokka,sana:integer;aresu:tstringlist;hakutakvok:boolean);
var lukn,sijax,prlim,x:integer;
si,sikanum,ha,lkx:integer;sika:tsija;
 d,vahvaluokka,vahvasija:boolean;         sofar:string;
  {$H-}
  //((lk,sis,av,san,sija:integer;
  //hakunen:tvhaku;
  mymid,mysis,myav,mysana,mysija,lopvok,myend:str16;
   sikalauma, riimit,xxresu:tstringlist;
   function red(st:string):string;
   begin result:='<b style="color:red">'+st+'</b>';
   end;
   function blue(st:string):string;
   begin result:='<b style="color:blue">'+st+'</b>';
   end;

begin
   d:=true;
   //d:=false;
    //if d then
    writeln('<h3>RUNKO:',runko,'/',astva,'/',sis,'</h3></ul>');
    //writeln('<li>',luokka,'/',scount);
    //for si:=0 to scount-1 do writeln('/',lmmids[luokka,si]);
    vahvaluokka:=luokka+52<63;
    for si:=0 to sikoja-1 do
    begin try
      mymid:=lmmids[luokka,si];
      if pos('?',mymid)>0 then continue;
      myend:=reversestring(sijat[si].ending);

      sofar:=runko;
      //writeln('[',mymid,'|',myend,']');
      //if pos('*',mymid)>0 then begin mymid[length(mymid)]:=sofar[length(sofar)];end;
      if pos('*',mymid)>0 then begin mymid[length(mymid)]:=SIS[length(SIS)];end;
      sika:=sijat[si];
      if vahvaluokka then vahvasija:=NOT(si in vvahvanHEIKOT)
      else vahvasija:=not (si in vHEIKOnheikot);
      if astva='' then myav:='' else
      if vahvasija then  myav:=astva[1] else
      if length(astva)>1 then myav:=astva[2] else myav:='';
      sofar:=sofar+myav+sis;

      while (mymid<>'') and (mymid[length(mymid)]='-') do begin delete(mymid,length(mymid),1);delete(sofar,length(sofar),1);end;
      if pos('!',mymid)=1 then continue;
      sofar:=sofar+reversestring(mymid);
      sofar:=sofar+myend;
      if not hakutakvok then sofar:=etu(sofar);
      if d then writeln('<li>',luokka+52,'#',si,' ',sofar,sana);//,' [',runko,'|',myav,'|',sis,'|',mymid,'|',myend,vAHVALUOKKA,']</li>');
       //if not hakutakvok then sofar:=etu(sofar);
      aresu.addobject(sofar,tobject(ptrint(sana)));
      except writeln('nomuoto',luokka,'#',si);end;
     end;
     if d then writeln('</ul>');
   //end;
end;



end.

