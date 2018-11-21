unit riimiuus;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,verbikama,nominit,sanataulu,strutils,riimiutils;
const vahvatverbiluokat=[52..63,76];
const vahvatnominiluokat=[1..31,76];
const rimis=64;
type string31=string[31];

type tlka=record esim:string;kot,ekasis,vikasis:word;vahva:boolean;vikasana:word;end;
type tsis=record ekaav,vikaav:word;sis:string[8];vikasana:word;end;
type tsanainfo=record sana:string31;num,lka,sija:word;sanalka:byte; end;
type tsinfotaulu=class(tobject)
  taulu:array of tsanainfo;
  wcount:integer; //ei yli word...pit‰nee laajentaa myˆhemmin longwordiksi

  procedure add(gsana:string31;nnum,nlka,nsija:word;nsanalka:byte);
  constructor create(n:word);
end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lis‰‰ viek‰ .takia - se josta etuvokaalit alkavat
type tsanasto=class(tobject)
 vcount,ncount:integer;
 lks:array[0..80] of tlka;
 siss:array[0..255] of tsis;
 avs:array[0..1200] of tav;
 sans:array[0..32767] of tsan;
 sanataulu:array[0..32767] of string[20];
 verbit:tverbit;
 nominit:tnominit;
 eitaivu:tstaulu;
 hakulista:tstringlist;
 hitlist:array[1..30000] of word;hitcount:integer;
 //sanoja:tstringlist;
 slist:tstringlist;
 resutaulu:tsinfotaulu;
 function haenumero(sana:ANSISTRING;rev:boolean):word;
  procedure generatelist(wlist:tlist;all:boolean);
  procedure addtolist(sana:ansistring);
//rocedure luohaku;
 //0-pohjasia, mutta data alkaa 1:st‰
 procedure luesanat(fn:string);
 procedure listaa;
 procedure haemuodot;
 //function generateverb(resus:tstringlist;snum:word):ansistring;
 //function generatenom(resus:tstringlist;snum:word;all:boolean):ansistring;
 function generateverb(snum:word):ansistring;
 function generatenom(snum:word;all:boolean):ansistring;
 procedure concor;
 //function luohaku(fn:string):tstringlist;
 function etsiyks(hakusana,hakuakon,hakukoko:string;hakueietu,hakueitaka:boolean;sika:tsija;aresu:tstringlist;onjolist:tlist;var hits:word):word;
 procedure etsimuodot(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
 constructor create;
 procedure rajat;
 end;
var sanasto:tsanaSTO;

implementation
uses //riimitys,
  math;

procedure tsinfotaulu.add(gsana:string31;nnum,nlka,nsija:word;nsanalka:byte);
var rec:tsanainfo;
begin
 try
  wcount:=wcount+1;  //note: 1.base
// rec:=
taulu[wcount].sana:=gsana;
 taulu[wcount].num:=nnum;
 taulu[wcount].lka:=nlka;taulu[wcount].sija:=nsija;taulu[wcount].sanalka:=nsanalka;
 except writeln('failadd:',wcount,'!!');end;
end;
constructor tsinfotaulu.create(n:word);
begin
  setlength(taulu,n);
  wcount:=0;
end;
procedure tsanasto.rajat;
var i,pi:word;
begin


end;
procedure tsanasto.concor;
var numsf:textfile;line,s:ansistring;
    cc:array [0..35000] of array [0..15] of word;
    lnums:array[0..15] of word;
    function setnum(num:word):word;
     var j:word;
    begin
      for j:=0 to 15 do
       if lnums[j]=num then continue
       else if lnums[j]=0 then
       begin
         lnums[j]:=num;
         //lnums[0]:=lnums[0]+1;
         break;
       end;
    end;
    function setmat(a,b:word):word;
     var j:word;
    begin
      for j:=0 to 15 do
       if cc[a,j]=b then break
       else if cc[a,j]=0 then
       begin
         cc[a,j]:=b;
         break;
       end;
    end;
    procedure listmat;
    var row,col:word;
    begin
      for row:=0 to 30000 do
       if cc[row,0]<>0 then
       begin
         writeln('<li>',row,': ');
        for col:=0 to 15 do
        if cc[row,col]=0 then break else
         writeln(slist[cc[row,col]],',');
      end;
    end;

var i,j,n,b:word;c:integer;
begin
//SAN sanoja:=tstringlist.create;
  //SAN sanoja.loadfromfile('sanat_ok.ansi');
assign(numsf,'syn_ok.num');  //synonyymit/liittyv‰t sanat
//assign(inf,'sanatall.arev');  //kaikki ei-yhdyssanat
reset(numsf);
//writeln('<pre>');
for i:=0 to 30000 do cc[i,0]:=i;
c:=0;
 while not eof(numsf) do
 begin
  c:=c+1;//if c>5000 then break;
  readln(numsf,line);
  b:=1;
  //writeln('<li>');;
  for i:=1 to length(line) do
     if line[i]=',' then begin setnum(strtointdef(s,-999));s:='';end
    else s:=s+line[i];
  for i:=0 to 15 do if lnums[i]=0 then break else
   for j:=0 to 15 do if lnums[j]=0 then break else
    setmat(lnums[i],lnums[j]);
   //writeln(lnums[i]);
  fillchar(lnums,sizeof(lnums),0);
  cc[1]:=lnums;
 end;
 close(numsf);
 listmat;
end;

function tsanasto.generateverb(snum:word):ansistring;

var runko,sisu,astva:str16;aresu:tstringlist;hakutakvok:boolean;
 lukn,sijax,prlim,x:integer;
sija,sikanum,ha,lkx:integer;
sika:tsija;
 d,vahvaluokka,vahvasija:boolean;
 gsana:string;
 luokka,sis,av,san:word;
 //curlkacursis,cura
  { $H-}
  //((lk,sis,av,san,sija:integer;
  //hakunen:tvhaku;
  //mymid,mysis,myav,mysana,mysija,lopvok,myend:str16;
   sikalauma, riimit,xxresu:tstringlist;

function sijaa(sija:word;curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
var vokdbl,vokvex,konvex,kondbl:boolean;mid,myav,mysis,myend:ansistring;
begin
  try
   if sija=6 then exit;
   mysis:=cursis.sis;
   vahvasija:=true;

   myend:=reversestring(verbit.sijat[sija].ending);
   mid:=''+verbit.lmmids[luokka-52,sija];
   if curlka.vahva then begin if  sija in vvahvanheikot then vahvasija:=false;end
     else  if  sija in vheikonheikot then vahvasija:=false;
   myav:=ifs(vahvasija,avs[av].v,avs[av].h);     //writeln('[',mid,']');
   if (mid<>'') and (mid[1]='_') then
   begin
        if mysis='' then mysis:='ii' else begin MYSIS:=MYSIS[1]+MYSIS;delete(mid,1,1);end;
   end;
   if mid='!' then exit;
   if (mid<>'') and (mid[1]='*') then //mid[1]:=mysis[1];
      if mysis='' then  begin delete(mid,1,1);myav:=''; end else mid[1]:=mysis[1];  //loppuii vierasp sanoissa lka 5
   //if mysis=''then   mysis:='ii' else mySIS:=mySIS[1]+mySIS;  //loppuii vierasp sanoissa lka 5

   if (mid<>'')  and (mid[1]='-') then
   begin
       if (mid='--') then //writeln('<li>64:mid:',mid,'/sis:',mysis,sija);
       begin  mid:='';mysis:=mysis[1]; end    ///speak
       else
       begin
           delete(mid,1,1);
           delete(mysis,1,1);
       end;
   end;
  except writeln('failvs:<b>',cursan.san,cursan.akon,sija,'</b>');end;

   try
   gsana:=reversestring(myend)+string(mid+mysis+myav+sans[snum].san+sans[snum].akon);
  // writeln('<li>vvv_',reversestring(gsana));
   //if curlka.kot=64 then writeln('<li>zzx ',reversestring(gsana));
           //san; if konvex then if curlka.kot=60 then  delete(sana,1,1);  //vain "l‰hte‰" monikot l‰ksin
           //av:   if konvex then if myav<>'' then begin delete(myav,1,1);end;
           //sis;          if kondbl then if curlka.kot=67 then mysis:=MYSIS[1]+MYSIS;
                //                 if vokdbl then if mysis='' then mysis:='ii' else MYSIS:=MYSIS[1]+MYSIS;  //loppuii vierasp sanoissa lka 5
          //           if vokvex then f curlka.kot=64 //vied‰ vei then       delete(mysis,2,1) else delete(mysis,1,1);
       if not sans[snum].takavok then gsana:=etu(gsana);
       //if taka(gsana)<>taka(sanoja[snum]) then
       //resus.addobject(gsana,tobject(pointer(snum)));
       resutaulu.add(gsana,snum,curlka.kot,sija,2);
       //if reversestring(gsana)='jˆitt‰' then
        // writeln('<li>:',reversestring(gsana),':',sija,vahvasija,verbit.lmmids[luokka-52,sija],'/',mid);
  except writeln('failverb!!!',gsana);end;
end;

var curlka:tlka;
begin
  sija:=0;
  for lUOKKA:=0 to 78 do
  begin
    //writeln('<h4>LKA:',luokka,'</h4>');
    if lks[luokka].vikasana>=snum then
    begin
      curlka:=lks[luokka];
      vahvasija:=true;
      //if luokka<52 then
      begin
        for sis:=lks[lUOKka].ekasis to lks[lUOKka].vikasis do
        if siss[sis].vikasana>=snum then
         for AV:=SISS[SIS].ekaAV to SISS[SIS].VIKAAV do
          if avs[av].vikasana>=snum then
          //if avs[av].v<>avs[av].h then
          begin
           //writeln('<li>',snum,'#',luokka,sanoja[snum],';',curlka.kot,'.',reversestring(siss[sis].sis+'_'+avs[av].v+avs[av].h+'.'+sans[snum].san+sans[snum].akon),' ',luokka,curlka.vahva,siss[sis].sis,':');
           for sija:=0 to 66 do //sikoja do
           //for sija in [0,5,12,13,16,23,36,37,39,45] do //sikoja do
              sijaa(sija,curlka,siss[sis],avs[av],sans[snum]);
              //function sijaa(curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
              exit;
          end;
          exit;
        end;
      end;
         //for SAN:=AVS[AV].ekasana to avs[av].VIKAsana do
     //writeln('<hr>');
    end;
  end;

//function tsanasto.generatenom(resus:tstringlist;snum:word;all:boolean):ansistring;
function tsanasto.generatenom(snum:word;all:boolean):ansistring;
  function red(st:string):string; begin result:='<b style="color:red">'+st+'</b>';  end;
  function blue(st:string):string;  begin result:='<b style="color:blue">'+st+'</b>';  end;

var runko,sisu,astva:str16;aresu:tstringlist;hakutakvok:boolean;
 lukn,sijax,prlim,x:integer;
sija,sikanum,ha,lkx:integer;
sika:tsija;
 d,vahvaluokka,vahvasija:boolean;
 gsana:string;
 luokka,sis,av,san:word;
 //curlkacursis,cura
  { $H-}
  //((lk,sis,av,san,sija:integer;
  //hakunen:tvhaku;
  //mymid,mysis,myav,mysana,mysija,lopvok,myend:str16;
   sikalauma, riimit,xxresu:tstringlist;

function sijaa(sija:word;curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
var vokdbl,vokvex,konvex,kondbl:boolean;mid,myav,mysis,myend:ansistring; newrec:tsanainfo;
begin
  try
   mysis:=cursis.sis;
   vahvasija:=true;
   begin
     myend:=(nominit.sijat[sija].ending);
     try
     mid:=nominit.lmmids[luokka,sija];
      except writeln('FAILN:',snum,':',myend,',',mid,',',vahvasija,',',myav,'!',luokka,'/',sija);end;
     if curlka.vahva then if  not (sija in nvahvanvahvat) then vahvasija:=false;  //vv hh
     if not curlka.vahva then if  (sija in nheikonheikot) then vahvasija:=false;  //vv hh
     myav:=ifs(vahvasija,avs[av].v,avs[av].h);     //writeln('[',mid,']');
     if (mid<>'') and (mid[1]='_') then
     begin
        if mysis='' then mysis:='ii' else begin MYSIS:=MYSIS[1]+MYSIS;delete(mid,1,1);end;
     end;
     if mid='!' then exit;
     if (mid<>'') and (mid[1]='*') then //mid[1]:=mysis[1];
        if mysis='' then  begin delete(mid,1,1);mysis:=myav; end else mid[1]:=mysis[1];  //loppuii vierasp sanoissa lka 5
     //if mysis=''then   mysis:='ii' else mySIS:=mySIS[1]+mySIS;  //loppuii vierasp sanoissa lka 5
     if curlka.kot=19 then begin if mid<>'' then if mid[1]='-' then begin delete(mid,1,1);delete(mysis,length(mysis),1);end; end else
     while (mid<>'')  and (mid[1]='-') do  begin delete(mid,1,1);if mysis='' then myav:=''  else delete(mysis,1,1); end;
     gsana:=reversestring(myend)+string(mid+mysis+myav+sans[snum].san+sans[snum].akon);
     if not sans[snum].takavok then gsana:=etu(gsana);
         //if taka(gsana)<>taka(sanoja[snum]) then
     //writeln(' ',gsana);//,sija,vahvasija,verbit.lmmids[luokka-52,sija],'/',mid);
     //resus.addobject(gsana,tobject(pointer(snum)));
     resutaulu.add(gsana,snum,curlka.kot,sija,1);
       //procedure add(nnum:word;nlka:tlka;nsija:word;nsanalka:byte;);
      if snum=8035 then      writeln('<li>HIT:',gsana,snum,':',myend,',',mid,',',vahvasija,',',myav,'!',luokka,'/',sija,'=',resutaulu.taulu[resutaulu.wcount-1].num);

   end;
  except writeln('FAILnom!!!',snum);end;
end;
var curlka:tlka;
begin
  sija:=0;
  for lUOKKA:=0 to 49 do
  begin
    if lks[luokka].vikasana>=snum then
    begin
      curlka:=lks[luokka];
      vahvasija:=true;
      //if luokka<52 then
      begin
        for sis:=lks[lUOKka].ekasis to lks[lUOKka].vikasis do
        if siss[sis].vikasana>=snum then
         for AV:=SISS[SIS].ekaAV to SISS[SIS].VIKAAV do
          if avs[av].vikasana>=snum then
          //if avs[av].v<>avs[av].h then
          begin
           //writeln('<li>',luokka,sanoja[snum],';',curlka.kot,'.',reversestring(siss[sis].sis+'_'+avs[av].v+avs[av].h+'.'+sans[snum].san+sans[snum].akon),' ',luokka,curlka.vahva,siss[sis].sis,':');
           //for sija:=0 to 9 do //sikoja do
           for sija:=0 to  32 do //in [0,5,12,13,16,23,36,37,39,45] do //sikoja do
           //if (all) or (not (sija in [3,4,6..12,15..20,22,23,24])) then
           if (not (sija in [13,14,17])) then
              sijaa(sija,curlka,siss[sis],avs[av],sans[snum]);
              //function sijaa(curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
              exit;
          end;
          exit;
        end;
      end;
         //for SAN:=AVS[AV].ekasana to avs[av].VIKAsana do
     //writeln('<hr>');
    end;
  end;
 //for sana:=0 to 28000 do writeln(sans[sana].san);
 //exit;
{   d:=true;
   //d:=false;
    //if d then
    writeln('<h3>RUNKO:',runko,'/',astva,'/',sis,'</h3></ul>');
    //writeln('<li>',luokka,'/',scount);
    //for si:=0 to scount-1 do writeln('/',lmmids[luokka,si]);
    vahvaluokka:=luokka+52<63;
    for si:=0 to sikoja-1 do
    begin try
//!      mymid:=lmmids[luokka,si];
      if pos('?',mymid)>0 then continue;
//!      myend:=reversestring(sijat[si].ending);

      sofar:=runko;
      //writeln('[',mymid,'|',myend,']');
      //if pos('*',mymid)>0 then begin mymid[length(mymid)]:=sofar[length(sofar)];end;
      if pos('*',mymid)>0 then begin mymid[length(mymid)]:=SIS[length(SIS)];end;
//!      sika:=sijat[si];
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
 }
//end;
procedure tsanasto.addtolist(sana:ansistring);
begin
 resutaulu.add(sana,9999,99,1,3);
 //resutaulu.
 //listaa;
end;

procedure tsanasto.generatelist(wlist:tlist;all:boolean);
var j,snum:integer;  parts:tstringlist;
begin
 writeln(' _!!!!!!!!',wlist.count);

  for j:=0 to wlist.count-1 do
  begin

    //writeln('"""');
    snum:=integer(wlist[j]);
    //writeln(' <li>++',snum);//,string(slist[snum]),resutaulu.wcount, ' ');
    if (snum<0) or (snum>65000) then continue;
    //continue;
    if snum<19547 then
     //generatenom(turharesulist,snum,false)
     generatenom(snum,false)
    else if snum<25484 then
     generateverb(snum)
    else
    begin
       resutaulu.add(reversestring(slist[snum]),snum,99,1,3);
    end;
   // begin rlist.addobject(slist[j],tobject(pointer(j)));end;
      //writeln('<li>xxx:',snum,slist[snum]);

  end;
  exit;
  parts:=tstringlist.create;
  parts.loadfromfile('partikkelit.lst');
  //parts.loadfromfile('turha');
  for j:=0 to parts.count-1 do
  //resutaulu.add(reversestring(parts[j]),60000,99,0,3);
  resutaulu.add(string(parts[j]),60000,99,0,3);
end;
function tsanasto.haenumero(sana:ANSISTRING;rev:boolean):word;
var eitaka,eietu:boolean;akon,koko,loppu:ansistring;aresu:tstringlist;onjolista:tlist;
   hits,myhit:word;
begin
akon:='';
if rev then sana:=reversestring(sana);
voksointu(sana,eietu,eitaka);
koko:=sana;
while pos(sana[1],konsonantit)>0 do begin akon:=sana[1]+akon;   delete(sana,1,1); end;
loppu:=taka(reversestring(sana));
//continue;

//exit;
//resst:=resst+
//writeln(verbit.sanat[0].san);
//verbikama.
//writeln(verbit.sijat[10].ending+'!');
//writeln('numeroi;',sana,loppu+akon,koko,'',eietu,eitaka);//,verbit.vesims[1]);//,verbit.sijat[0],aresu,onjolista,hits);
try
  myhit:=etsiyks(loppu+akon,koko,'',eietu,eitaka,verbit.sijat[0],aresu,onjolista,hits);
except writeln('!-!',reversestring(akon+sana),myhit,koko);end;
// function etsiyks(hakusana,hakuakon,hakukoko:string;hakueietu,hakueitaka:boolean;sika:tsija;aresu:tstringlist;onjolist:tlist;var hits:word):word;
//writeln(verbit.sijat[0].ending);
  try
  if myhit=0 then myhit:=etsiyks (loppu+akon,koko,'',eietu,eitaka,nominit.sijat[0],aresu,onjolista,hits);
  except writeln('??',reversestring(akon+sana),myhit);end;
//etsiyks (HAKUNEN.loppu+hakunen.akon,hakunen.koko,'',hakunen.eietu,hakunen.eitaka,sika,aresu,onjolist,hits);
     //writeln('<li>hit;',sana,'######',myhit);
     result:=myhit;
end;

{
procedure tsanasto.luohaku;
var instream,hitfs,misfs:tfilestream;
     inf,synf,sanaf,misfile,numfile:textfile;
     sana,prevsana,hakurunko,akon,hakukoko,hitline:ansistring;
     hakueietu,hakueitaka:boolean;
     j,hitnum,ghits,hits:word;
     cc:integer;
     linehits,tries:tlist;
     olisana,ekasana:boolean;
     resus:tstringlist;
     muodot:tstaulu;
     //sanalista:tst
begin
 //writeln('<h1>haenum:</h1>',haenumero('voida'));
 sanoja:=tstringlist.create;       ////  ae ao ea eo ia io oa oe ua ue
 sanoja.loadfromfile('haku.lst');
 //sanoja.commatext:='vaaitsemalla,aatos';//paatti,pataraatti,mataatti,tiilla,tialla,raanulla,haella,haulla,hulla,tulla,puraisulla,sulla,muraisulla,voida,voit,puulla,uulla,ulla,alla,olla,talla,tolla,koivulla,voivulla,vuivulla,xulla,knulla,vuikukulla,vaikulla,vavalla,tavalla,kavavalla,zalla,ella,luulla,kuulla,keinulla,stulla,ktulla,voipivulla,katialla';
 //sanoja.commatext:='aa,xatora,kavatora,kivatora,ravatora,kvora,kora,vora,xora,atora,autora,avora,vatora,katora,hatora,matora,lavatora,kaora,kura';  //isona,ailla,pukisona,isona,risona,asia,iarilla,taioin,sialla,urha,murha,vurha,kukkavurha,kieltolailla,turha,illa,rilla,osasilla,trilla,arilla,aarilla,villa,loilla,vailla,hilla,krilla,tilla,stilla,ztilla,puttosilla,tuolla,maulla,silla,asasilla,soilla,tsilla,pussilla,risasilla,isasilla,haalla,ahilla';
 //sanoja.commatext:='xaa,jakoon,sorrettakoon, purettakoon, pingottakoon, neuvottakoon, kuivuttakoon';
 // writeln(sanoja.text);//:='ampua';
 //for j:=0 to sanoja.count-1 do begin writeln('<li>',sanoja[j],':');teenoodi(reversestring(sanoja[j])); end; exit;

 tries:=tlist.create;
 resus:=tstringlist.create;
 {
 for j:=0 to sanoja.count-1 do tries.add(pointer(haenumero(sanoja[j])));
//sanoja.loadfromfile('testisanat.ansi');
writeln('<h1>expand</h1>',sanoja.text);

FOR j:=0 TO TRIES.COUNT-1 DO writeln(integer(tries[j]));
expandlist(tries,resus);
}
//resus.commatext:='allup,allu,allum,allumaa,all,allus,allubusin,ilut,ilus,iluah,iluviah,iluv';
//writeln('<h3>sanoja</h3>',sanoja.text);
resus.duplicates:=dupIgnore;
resus.sorted:=true;
 for j:=0 to sanoja.count-1 do
   resus.add(trim(reversestring(ansilowercase(sanoja[j]))));//+'al');
resus.sort;
//writeln('<h1>expanded</h1>',resus.text);

//FOR j:=0 TO resus.COUNT-1 DO writeln(reversestring(resus[j]));

//for j:=0 to 0 do tries.add(pointer(19538+random(5500)));
//for j:=0 to 0 do tries.add(pointer(random(19538)));
//writeln('<h3>expand:</h3>');
//for j:=0 to resus.count-1 do writeln(reversestring(resus[j]));
muodot:=tstaulu.create;
//writeln('<h3>taulut',resus.count,'</h3>');

muodot.teetaulu(resus);
try
//writeln('<h3>Tehtytaulut',resus.count,'</h3>');

//muodot.riimit;;
except writeln('eionnaa');end;
exit;
{for j:=52 to 78 do //26000 do
begin generateverb(resus,lks[j-1].vikasana+1);
generateverb(resus,lks[j].vikasana);end;
for j:=1 to 49 do //26000 do
begin
   //generatenom(lks[j-1].vikasana-1);
   generatenom(resus,lks[j].vikasana-1);
end;
 exit;
 }
 concor;exit;
 linehits:=tlist.create;
//inf:=tfilestream.create('wikithe.txt',fmopenread);  //synonyymit/liittyv‰t sanat
//assign(inf,'gutsanat.iso');  //synonyymit/liittyv‰t sanat
//assign(inf,'sense.nums');  //synonyymit/liittyv‰t sanat
//assign(inf,'wikithe.ansi');  //synonyymit/liittyv‰t sanat
assign(inf,'syn_allx.ansi');  //synonyymit/liittyv‰t sanat
//assign(inf,'sanatall.arev');  //kaikki ei-yhdyssanat
reset(inf);
assign(synf,'syn_ok.ansi');  //synonyymit/liittyv‰t sanat
rewrite(synf);
assign(sanaf,'sanat_ok.ansi');  //synonyymit/liittyv‰t sanat
rewrite(sanaf);
assign(misfile,'testimiss.the');  //synonyymit/liittyv‰t sanat
assign(numfile,'syn_ok.num');  //synonyymit/liittyv‰t sanat
rewrite(misfile);
rewrite(numfile);

fillchar(sanataulu,sizeof(sanataulu),0);
  cc:=0;
  hitcount:=0;eitaivu.hitcount:=0;
  writeln('<li>xxx');
  //hitfs:=tfilestream.create('wikithe.txt',fmcreate);  //numerolista
  //misfs:=tfilestream.create('wikithe.txt',fmcreate);  //tunnistamattomat pohditaviksi
  try


    while //(cc<1000000) and
   (not eof(inf))  do
    begin
     try
     cc:=cc+1;
      if cc>212388 then break;
      //if cc>10000 then break;
     readln(inf,sana);
     if sana='' then
     begin
         //writeln('<hr>');
         if olisana and (ghits>1)then
         begin
          //writeln(' //',prevsana,integer(linehits[0]));
          sanataulu[integer(linehits[0])]:=copy(prevsana,1,20);
           writeln(synf,hitline);
           for j:=0 to linehits.count-1 do write(numfile,inttostr(integer(linehits[j]))+',');
           if (linehits.Count>0) then  writeln(numfile,'') else writeln(numfile);
           end;// else  writeln(reversestring(sana));
           ghits:=0;hitline:='';
         linehits.clear; olisana:=false;ekasana:=true;continue;
     end;
     //if sana<>'tyt‰r' then continue;
     sana:=stringreplace(trim(sana),'_','',[rfReplaceAll]);
     sana:=stringreplace((sana),'-','',[rfReplaceAll]);

     if ekasana then prevsana:=sana;
     sana:=reversestring(sana);
     akon:='';
     //if sana='' then begin writeln(outf,'*****');continue;end else
     voksointu(sana,hakueietu,hakueitaka);
     if hakueitaka and hakueietu then   continue;   //autorit‰‰risten harmiksi
     hakurunko:=taka((sana));
     hakukoko:=sana;
     hits:=0;
     hitnum:=etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,nominit.sijat[0],nil,nil,hits);
     if hakurunko[1]='a' then
     //res:=res+
     if hitnum=0 then hitnum:= etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,
     verbit.sijat[0],nil,nil,hits); //verb permuo p‰‰ttyy "a"
     if hitnum=0 then begin hitnum:=eitaivu.sexact(sana,eitaivu.sanalista);if hitnum<>0 then hitnum:=26000+hitnum;end;
     //if hits>0 then writeln('!!!',hitlist[hitcount],sans[hitlist[hitcount]].san,sans[hitlist[hitcount]].akon);//<li>H: ',sans[hitlist[hitcount]].san,sans[hitlist[hitcount]].akon,'#',hitlist[hitcount]);
     if hits=0 then if hitnum>0 then hits:=hits+1;// else writeln('<li>;:',reversestring(sana),'</li>');
     if ekasana then if hits>0 then olisana:=true;
     //if ekasana then writeln('<li>',reversestring(sana),hitnum);
     ekasana:=false;
     //if hits>1 then writeln(outf,akon,sana,'=',trim(res),' ',cc,'!',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
     //if hitnum>>0 then writeln(misfile,hitnum,',',string(sana));
     //writeln('<li>',reversestring(sana),'/ekako:',eka,' /sanako:',olisana,hitnum,' ',hits);
     //if hits=0 then writeln(misfile,sana)   else //
     if hits>0 then
      begin
        //hitline:=hitline+^j+reversestring(sana);ghits:=ghits+1;
        hitline:=hitline+reversestring(sana)+',';ghits:=ghits+1;
        linehits.add(pointer(hitnum));
        //writeln('<li style="color:green">',reversestring(sana),'</li>')
        //if (hits mod 10<>0) then
        //writeln('+');//<li>',akon,sana,'=',trim(res),' ',cc,'!',hits);
//        writeln(outf,akon,sana,'=',trim(res),' ',cc,'!',hits);
          // else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
          ;//else  writeln('<li><b>y:',akon,sana,'=',trim(res),' ',cc,'</b>',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
       end;
     except   writeln('<li>EiEtsi',sana,sana='','!');end;
     //if cc>20000 then break;
     //writeln('<li>',sana,res,hits);
   end;
    writeln('<li>didit');
  finally
    close(inf);
    close(synf);
    close(misfile);
    close(numfile);
  //hitfs.free;misfs.free;
  end;
  for cc:=0 to 30000 do  writeln(sanaf,resus[cc]);
  closefile(sanaf);
end;
}
constructor tsanasto.create;
var i:word;h:thakunen;//slist:tstringlist;
begin
resutaulu:=tsinfotaulu.create(65535);
//writeln('<style type="text/css">div div div{ font-size:1px;border:1px solid green;margin-left:1em} </style>');
{//+^m+' div div { font-size:0.5em} '+^m);
writeln('div div:hover div { display:block;font-size:1em;background:#ddd}');
writeln('xdiv div div:hover div div{ display:block;font-size:0.5em;background:#ff9}</style>');
//writeln('<div> x<div> y<div> z</div></div></div>');
}
{//exit;0}
//do99;exit;
luesanat('sanatuus.csv');
verbit:=tverbit.create('sanatuus.csv','vmids.csv','vsijat.csv');
//nominit:=tnominit.create('nomsall.csv','nmids.csv');
nominit:=tnominit.create('nmids.csv'); //'nomsall.csv'
//eitaivu:=tstaulu.create('eitaivu.lst',nil);
writeln('<li>sanasto luotu</li>');
//for i:=0 to 80 do  writeln('<li>LKA:',lks[i].kot,' ',lks[i].vikasana);


//do99;exit;
//numeroikaikki;
//verbit.listaasijat;//exit;
//exit;
writeln('sanasto luotu');//, verbej‰',verbit.lmmids[15,0],'!');
//nominit.sanat:=sans^;
//nominit.listaa;
 //nominit.siivoosijat;
// haemuodot;
end;

procedure tsanasto.haemuodot;
var i:word;
begin
{   luohaku('haku.lst');
    for i:=0 to hakulista.count-1 do
    begin
        etsimuodot(thakunen(hakulista.objects[i]),nil,nil);
    end;0}
end;
{
function tsanasto.luohaku(fn:string):tstringlist;
var //hakunen:tvhaku;
     ha,i,ohits,hs,hm,hakuluokka:integer;hakusana:string;
     hakunen:thakunen;
     aresulist,aresulist2,HAKULInes,uushAKUlista,ahaku:tstringlist;
     onjolist:tlist;
begin
   //exit;
   hakulista:=tstringlist.create; //tsanasto.hakulista
   hakulines:=tstringlist.create; //tmp
   ahaku:=tstringlist.create;
   hakulines.loADFROMFILE(fn);//'haku.lst');
    //!!!TEEhakulista(hakuset,HAKULISTA);
   //onjolist:=tlist.create;
   //for ha:=0 to length(hakuset)-1 do
   for hA:=0 TO hakuLInes.count-1 do
   begin
     //onjolist.clear;
     //if pos('isi',hakulista[ha])>0 then continue;
     if trim(hakulines[ha])='' then continue;
     ahaku.commatext:=hakulines[ha];
     hakusana:=ahaku[0];
     if hakusana='###' then break;
     if hakusana='' then continue;
     TRY HAKULUOKKA:=strtoint(ahaku[1]); except hakuluokka:=0;end;
     //writeln('<li><em style="color:#000">HAKU:',hakusana,ha,'/',hakulista.count,'</em> ');
     //teehaku(hakunen,hakusana,hakuluokka);
     haKUNEN:=THAKUNEN.CREATE;
     hakunen.akon:='';
     hakunen.lk:=hakuluokka;
     voksointu(hakusana,hakunen.eietu,hakunen.eitaka);
     hakunen.koko:=hakusana;
     while pos(hakusana[1],konsonantit)>0 do begin hakunen.akon:=hakusana[1]+hakunen.akon;
        delete(hakusana,1,1); end;
     hakunen.loppu:=taka(reversestring(hakusana));
     hakulista.addobject(hakusana,hakunen);
  end;
  result:=hakulista;
  hakulines.free;
end;
}


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
      avs[cav].takia:=0;  //takavokaalisten m‰‰r‰  .. ei k‰ytet‰ viel‰
      avs[cav].v:=sl[2];
      avs[cav].h:=sl[3];
      if avs[cav].v='_' then avs[cav].v:=avs[cav].h  //"_" k‰ytettiin aastevaihtelun puuttumisen merkkaamiseen. sorttautuu siistimmin
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
    //writeln('</ul><li>SIS:<b>',siss[csis].sis,'</b> ',csis,' /sana',csan,'  /lka:<b>',clka,'/','</b> ',csan+19548,'<ul>');
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
     kot:=strtointdef(sl[0],99);//clka+51;
     lks[clka].kot:=kot;//clka+51;
     if (kot in vahvatverbiluokat+vahvatnominiluokat) then   lks[clka].vahva:=true else  lks[clka].vahva:=false;
     //writeln('</ul>-',csis,'<li>LKA <b>',kot,'</b>:',lks[clka].ekasis,'  ',sana,' //','::<b>',clka,'/',csis,'/',cav,'/',csan,'</b><ul>');
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
  // t‰mmˆnenkin toimii:  for i in vahvatverbiluokat+vahvatnominiluokat do  writeln(i);
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
    if differ=3  then differ:=2;      // av-heikot erosivat mutta vahva oli sama. yhdistet‰‰n - AV ylip‰‰t‰‰n oli eri
    if (differ<1) then uusluokka;
    if (differ<2) then  uussis;
    if (differ<4) then uusav;
     alko:=false;
         //if sl[4]='0' then avs[cav].takia:=csan+1; //pit‰is olla sortattu vokaalisoinnun mukaan, eli ei tarttis laittaa  joka sanalle talteen
      csan:=csan+1;

    sans[csan].san:=(sl[5]);
    sans[csan].takavok:=sl[4]='0';
    sans[csan].akon:=(sl[6]);
    if sl[4]='0' then avs[cav].takia:=avs[cav].takia+1;  //lasketaan takavokaalisten m‰‰r‰‰ av-luokassa hakujen tehostamiseksi
    //csan:=csan+1;
    alko:=false;
    prevsl.commatext:=sana;  //t‰h‰n taas seuraavaa sanaa verrataan
    prlim:=prlim+1;  //just for debug to make managable listings .. not used
    except writeln('failav');end;
   end;
    writeln('<li>Sanasto luettu ',fn,'  LKS:',CLKa,' /sis:',csis,' /av:',cav,' /w:',csan,'</h1>');
    for i:=0999 to clka do
    begin
       writeln('<li>',i, '>',lks[i].vikasana,'<ul>');
       for j:=lks[i].ekasis to lks[i].vikasis  do
       begin
          writeln('<li>',j,'si:<b>',siss[j].sis, '</b> >',siss[j].vikasana,'<ul>');
          for k:=siss[j].ekaav to siss[j].vikaav  do
          begin
             writeln('<li>',k,':av<b>',avs[k].av,avs[k].v,avs[k].h, '</b>>',avs[k].vikasana,'<ul>');
             writeln('<li>',avs[k].ekasana,reversestring(sans[avs[k].ekasana].san+sans[avs[k].ekasana].akon),' ',avs[k].vikasana,reversestring(sans[avs[k].vikasana].san+sans[avs[k].vikasana].akon));

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

function listsija(sika:tsija):string;
begin
   with sika do  result:=' [['+inttostr(num)+' '+ name+' ('+esim+') '+inttostr(vparad)+' '+inttostr(hparad)+'):<b>'+ending+'</b>]] ';
end;

function tsanasto.etsiyks(hakusana,hakuakon,hakukoko:string;hakueietu,hakueitaka:boolean;sika:tsija;
  aresu:tstringlist;onjolist:tlist;var hits:word):word;
var sanasopi,sanajatko,avsopi,avjatko,sissopi,sisjatko,lkasopi,lkajatko,sikaloppu,sikasopi:string;
    curlka:tlka;cursis:tsis;curav:tav;cursan:tsan;
    resunum:word;//mysika:tsija;
    //cutvok,cutav:integer;
    //cut_si,cut_av,cut_lka,cut_san,i,j:integer;
    tc,hakutc:integer;
    luokka:word;//xskipped:string;
     d,heikkomuoto:boolean;
     //hakuakon:string;
     //siat,sikanum,lu:integer;sika:tsija;
     resst:string;
     //eatkon:boolean;
     isverb:boolean;
     vokvex,vokdbl,konvex,kondbl:boolean;
    //procedure checkhit(yht,sanax,hakux:string;sa:integer);
      function red(st:string):string;
        begin result:='<b style="color:red">'+st+'</b>';
        end;
      function blue(st:string):string;
        begin result:='<b style="color:blue">'+st+'</b>';
        end;

      function sijanheikkous(isv:boolean;sika:integer):boolean;
      begin //huikko:=true
      result:=false;
      if isverb then
        if curlka.vahva then begin if  sika in vvahvanheikot then result:=true;end
        else  if  sika in vheikonheikot then result:=true;
      if not isverb then
        if curlka.vahva then begin if  not (sika in nvahvanvahvat) then result:=true;end  //vv hh
      else  if  sika in nheikonheikot then result:=true;
      //writeln('<li>heikko? ',
      end;

      procedure savehit(yht,sanax,hakux:string;sa:integer);
      var thishit:thit;sana,color:string;
      begin
        sana:=sans[sa].san;
        thishit:=thit.Create;
        with thishit.sana do
        begin
          alku:=cursan.san;
          akon:=cursan.akon;
          v:=curav.v;
          h:=curav.h;
          sis:=cursis.sis;
          luokka:=curlka.kot;
          if isverb  then  sloppu:=verbit.lmmids[luokka-52,0] else   sloppu:=nominit.lmmids[luokka,0];
          takvok:=not hakueitaka;
          sananum:=sa;   if d then writeln('xxx:',alku,'.',akon,'.',v,h,'.',sis,'.',luokka);
        end;
        //hitlist.add(thishit);
      end;
      {
      procedure fullhit(sana,sanataulu:string;sa:integer);
      var kokosana,myskip:string;
      begin
        try

        KOKOsana:=reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sana+sans[sa].akon);
        if not (sans[sa].takavok) then kokosana:=etu(kokosana);
       resst:=kokosana;//('<b style="color:green" title="'+inttostr(curlka.kot)+'#'+inttostr(sika.num)+'##'+inttostr(sa)+' '+inttostr(sa)+'">'+KOKOSANA +'</b> ');
       if d=d then writeln('hitti:'+resst);
       hitcount:=hitcount+1;
       hits:=hits+1;
        hitlist[hitcount]:=sa;
       except writeln('failfull');end;
      end;

      procedure shorthit(sana,sanataulu:string;sa:integer);
      var epos:word;kokosana:string;
      begin
        epos:=length(sana)+1;
        kokosana:=sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sans[sa].san+sans[sa].akon;
         if not (sans[sa].takavok) then kokosana:=etu(kokosana);
       sanataulu:=copy(sanataulu,epos-1);
       if (sana<>'') and ((pos(sanataulu[1],vokaalit)>0) and (pos(sanataulu[2],vokaalit)>0) and  (isdifto(sanataulu[2],sanataulu[1]))) then   //if pos(kokosana[2],vokaalit)<1 then
       else //writeln('NOGO:',haku[1],kokosana[1], isdifto(haku[1],kokosana[1]))
       writeln('<b style="color:blue"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">',
       reversestring(kokosana),'/</b>');//,sa,haku);
      end;
     }

    {  procedure longhit(sana,sanataulu:string;sa:integer);
      var epos:word;kokohaku,kokosana:string;i,tc:integer;olivok:string[2];
      begin
      kokohaku:=sanataulu+''+avsopi+''+reversestring(sissopi)+''+reversestring(lkasopi)+''+reversestring(sikasopi);
      kokosana:=sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sans[sa].san+sans[sa].akon;
      if not (sans[sa].takavok) then kokosana:=etu(kokosana);
       epos:=length(sanataulu)+1;
       sanataulu:=copy(sanataulu,epos);
       sana:=copy(sana,epos);
       try               // [u/]usi uusi: [u/]usi       [uo/]husi kuohusi:
       if  (sana<>'') and ((pos(sana[1],vokaalit)>0) and (pos(kokohaku[1],vokaalit)>0) and (isdifto(sana[1],kokohaku[1]))
       and (pos(kokohaku[2],vokaalit)<1))
        then writeln('<!--NOGO:',kokohaku,'?',sana,'-->')
       else
       begin
           tc:=1;//pit‰is olla tavurajalla, eli tavu on aloitettu.. ei ei: saa uurtaa   -> RUU   aie he > ia   kapusta  ja -> SUPA
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
           end;
           if not (sans[sa].takavok) then kokosana:=etu(kokosana);
           if (tc mod 2)= 0 then
           writeln('/<b style="color:#888"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">',  reversestring(kokosana),'/</b>');//,sana,'%',tc,',');//,sa,haku);
       end;
       except writeln('FAIL:',kokohaku,'!');end;
      end;
    }
      function sana_f(san:integer;koita,skipped:string):boolean;
      var i,j:word;hakujatko,sana,kokosana:string;yhtlen,slen,hlen:word;//osataka,osaetu:boolean;
      begin
      try
       try
      //if skipped<>'' then write
      cursan:=sans[san];
      sana:=cursan.san;
      //if san=24567 then
       if d then writeln('<li>',luokka, blue(sana+cursan.akon),'/',red(koita+hakuakon),(skipped+sana+cursan.akon=koita+hakuakon),'/ ',kondbl,konvex,' ',hakusana,(skipped+sana+cursan.akon)<>(koita+hakuakon),'/',san
       ,cursan.takavok,hakueitaka,(cursan.takavok) and (hakueitaka),skipped);

      if konvex then if curlka.kot=60 then  delete(sana,1,1);  //vain "l‰hte‰" monikot l‰ksin
      result:=false;
       if d then writeln('/S:',red(koita),blue(sana+'.'+cursan.akon+'/'),skipped);
      //if xvok<>'' then if length(sana)>0 then delete(sana,1,1);//sana[1]:=xvok[1];
      //if xvok<>'' then writeln('<li>[**',xvok,'/',sana,']');
      //if sana=koita then //if cursan.akon=hakunen.akon then
      if sana+cursan.akon=koita+'' then //if cursan.akon=hakuakon then
      begin
         //fullhit(sana,koita,san);
         hits:=hits+1;
          if d=d then writeln(' <em style="color:green">!!!',reversestring(sikasopi+lkasopi+''+sissopi+''+avsopi+''+sana+cursan.akon) ,san,'</em> ');
          hitcount:=hitcount+1;
          hits:=hits+1;
           hitlist[hitcount]:=san;
           resunum:=san;
         //resst:=' ';
         //writeln('HIT,exiting for now');
         result:=true;
         exit;
      end;
      //else if (sana='') or (pos(sana,koita)=1) then shorthit(sana,koita,san)
      //else if (koita='') or (pos(koita,sana)=1) then longhit(sana,koita,san)
      //if resst<>'' then exit;
      if (skipped+sana+cursan.akon=koita+hakuakon) // then exit;
      or (skipped+sana+cursan.akon='') or // (sana='') and          uull  amdma
       ((pos(skipped+sana+cursan.akon,koita+hakuakon)=1) ) then
      begin          //sikasopi+''+ lkasopi+'' +sissopi+''+avsopi+''+sans[sa].san+sans[sa].akon
          kokosana:=lkasopi+''+sissopi+''+avsopi+''+sana+cursan.akon;
          //resst:=string(' !!'+sikasopi+'.'+lkasopi+'_'+sissopi+'.'+avsopi+''+'+'+koita+hakuakon+' '+inttostr(san));

          //if (skipped+sana+cursan.akon<>koita+hakuakon)  then
          begin
            if ((cursan.takavok) and (hakueitaka)) or (not(cursan.takavok) and (hakueietu)) then
            begin  ///etutakah‰ss‰kk‰:kiirastorstai/t/                                                   eit:FALSE         /eie:TRUE         /t:FALSE kiirastorstai=torstai 1593!2
             if d then writeln('<li>ET:'+reversestring(hakusana),'/',reversestring(sana),cursan.akon,'/eit:',hakueitaka,'/eie:',hakueietu,'/t:',cursan.takavok
             , ' <b>'+reversestring(skipped+sana+cursan.akon)+'!='+reversestring(koita+'.'+hakuakon),'\</b>',san,kokosana,'???',hakukoko );
              if cursan.takavok then for i:=1 to length(kokosana) do if pos(hakukoko[i+length(kokosana)],'‰ˆy')>0 then exit;
              if (cursan.takavok) then for i:=0 to length(kokosana)-1 do if pos(hakukoko[length(hakukoko)-i],'‰ˆy')>0 then exit;// else write(length(hakukoko)-i,hakukoko[length(hakukoko)-i]);
              if not(cursan.takavok) then for i:=0 to length(kokosana)-1 do if pos(hakukoko[length(hakukoko)-i],'aou')>0 then exit;// else write(length(hakukoko)-i,hakukoko[length(hakukoko)-i]);
               if d then        writeln('***</li>')
            end;// else hits:=hits+1;
            if (skipped+sana+cursan.akon<>koita+hakuakon)  then
             hits:=hits+0 //
            else hits:=hits+0;
          end;// else hits:=hits+1;
          if hits>0 then resst:=resst+' '+reversestring(kokosana)+sikasopi;//+'"/'+copy(hakusana+hakuakon,length(kokosana)+1)+'/s:'+inttostr(san)+' '+inttostr(luokka)+'#'+inttostr(sika.num)+'['+skipped+']';
      end;
      if (koita='') or (pos(koita,sana)=1) then if d then writeln('<li>longhit '+reversestring(hakusana),'/',reversestring(skipped+'-'+sana+cursan.akon));
      //else if cursan.san='' then}
      //writeln('<span  style="color:white">%',curlka.kot,'#',sika.num,'/<em><b style="color:blue">',
      //reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[san].san+sanat[san].akon),'/</b></em>',san,'</span>');//,kokohaku[2]);
       except writeln('!failsana');  end;
       finally //writeln('/sana:', result);
       END;
      end;

      function av_f(av:integer;koita,skipped:string):boolean;
      var san,i,j:integer;myav:string;
      begin
        //if skipped<>'' then writeln('<li>skipav:',skipped);
        result:=false;;
        curav:=avs[av];
        myav:=ifs(heikkomuoto,curav.h,curav.v);
        if d then
         writeln('<li>{',blue(myav),'}',curav.v,'/',curav.h,curlka.kot,curlka.vahva,konvex,red('try:'+koita));//+xvok),blue(myav),' :',curav.v,curav.h,'/',curav.ekasana,'-',curav.vikasana);
        //if d then writeln('<li>(',myav,'=',curav.v+'/',curav.h,'\',konvex,')',red(koita),blue(myav),'/hm:',heikkomuoto,'/ver:',isverb,'/vah:',curlka.vahva);
        if konvex then if myav<>'' then begin delete(myav,1,1);end;
        if koita='' then begin avsopi:='';skipped:=skipped+myav;avjatko:='';if d then writeln('<li>AVX:',red(koita),blue(myav)) end else
        begin
          if (myav='') or (pos(myav,koita)=1)  then //result:=true
          else  begin  if pos(myav,koita)=1 then if d then writeln('<li>AVLOPPU:',koita,myav);  exit;
                end;
          avjatko:=copy(koita,length(myav)+1,99);//xvok;
          avsopi:=copy(koita,1,length(myav));//xvok;
        end;
        //avsopi:=myav;

          if d then writeln('/AV:',red(avjatko),blue(avsopi),' ',curav.ekasana,'..',curav.vikasana,heikkomuoto,'<ul>');
          try
          //if d then  for san:=curav.ekasana to min(curav.vikasana,curav.ekasana+50) do write('/',sanat[san].san);
           writeln('?',result);
          for san:=curav.ekasana to curav.vikasana do //!!!
                if sana_f(san,avjatko,skipped) then begin write('Gotsana');result:=true;exit;end;
           if d then writeln('...',result,'</ul>');
        except writeln('faILAV!!!');end;
      end;

      function sis_f(sis:integer;koita,skipped:string):boolean;
      var av,i,j:integer;mysis:string;
      begin
        //  if skipped<>'' then writeln('<li>skipsis:',skipped);
        result:=false;
        cursis:=siss[sis];
        mysis:=cursis.sis;
         if kondbl then if curlka.kot=67 then mysis:=MYSIS[1]+MYSIS;

        if vokdbl then if mysis='' then mysis:='ii' else MYSIS:=MYSIS[1]+MYSIS;  //loppuii vierasp sanoissa lka 5
        if d then writeln('<li>sisu:',red(koita),'/',blue(mysis+'!'),vokvex,'/',cursis.ekaav,'-',cursis.vikaav,vokdbl,'2x:',kondbl);
        //writeln('<li> ', curlka.kot,' ',sis,cursis.sis,'#',cursis.ekaav,'-',cursis.vikaav);
        if koita='' then BEGIN sisjatko:='';skipped:=skipped+mysis; sissopi:='';END     //what the fuck?
        ELSE
        begin
          //while (cut>0) and (mysis<>'') {and(koita<>'')} do
          if vokvex then
          begin if d then write('<li>?/',koita,'/',mysis,vokvex);
           if curlka.kot=64 then
            delete(mysis,2,1) else delete(mysis,1,1);
            //delete(mysis,1,1);
          END;
          //if cutvok=2 then  begin mysis:=mysis[1];END;

          if (mysis='') or (pos(mysis,koita)=1) then //result:=true
          else  begin  if pos(koita,mysis)=1 then if d then writeln('<li>EOW:',curlka.kot,'/',red(koita),'|',blue(mysis));  exit;
          end;
          sisjatko:=copy(koita,length(mysis)+1,99);
          sissopi:=copy(koita,1,length(mysis));
          //writeln(red(koita),'qqq');
          //sissopi:=mysis;
        END;
         if d then writeln('<li>SisHit:',red(koita),'/',blue(mysis+'!'),vokvex);
         if  d then   write('<b>/sovita:',sisjatko,'|sopi:',sissopi,'\</b>');
          //if d then for av:=cursis.ekaav to cursis.vikaav do write('[',avs[av].v,'.',avs[av].h,']');
          if d then writeln('<ul>');
        for av:=cursis.ekaav to cursis.vikaav do
         if av_f(av,sisjatko,skipped) then begin writeln('+++');result:=true;exit;end;
          if d then writeln('</ul>');

      end;
      function lka_f(lka,sija:integer;koita,skipped:string):boolean;  //vain verbille
      var sisus,i,j:integer;mid:string;repeats:integer;
      begin
       //if skipped<>'' then writeln('<li>lka:',skipped);
      luokka:=lka;
        //if lka<>5 then exit;
        curlka:=lks[lka];
        isverb:=lka>51;
        repeats:=1;
        result:=false;
        //if curlka.kot<>62 then exit;
        if isverb then
        begin
          if luokka=68 then repeats:=2;  //kaikilla 68'illa on kaksi taivutustapaa
          if (luokka in [55,57,60]) then if sika.vparad=6 then repeats:=2;
          if (luokka in [76]) then if sika.vparad=5 then repeats:=2;
          if (luokka in [74,75]) then if sika.vparad=9 then repeats:=2;
        end;
       repeat
        if isverb then
          mid:=verbit.lmmids[lka-52,sija] else
          mid:=nominit.lmmids[lka,sija];
         if mid='!' then exit;
        //dbl:=false;    eatkon:=false;

        vokvex:=false;vokdbl:=false;konvex:=false;kondbl:=false;
        //if curlka.vahva then para:=sika.vparad else para:=mysika.hparad ;
        if d then writeln('<li>TRY:',lka,'#',sija,' <b>[',repeats,blue(mid),'/',red(koita), '] </b>');//,curlka.kot,'!',isverb,verbit.lmmids[15,0]);
        if (luokka=71) then { if ((sika.hparad=2) and  (sija>10)) then     //ifs(isverb,verbit.lmmids[lka-52,sija],nominit.lmmids[lka,sija])
        begin IF D THEN writeln('<li>!!!???');//mid:='k'
        end else    }
          if  (sija in [23,28]) then begin IF D THEN writeln('!!!');mid:='k'; end;
        //aint it pretty?
        if isverb then
        begin
        if luokka=68 then if repeats=2 then begin mid:=verbit.lmmids[10,sija];end;
        if repeats=2 then if luokka=55 then if sika.vparad=6 then  begin mid:='';end; //soutaa sousi
        if repeats=2 then if luokka=57 then if sika.vparad=6 then  begin mid:='o';end; //kaatoi kaasi
        if repeats=2 then if luokka=60 then if sika.vparad=6 then  begin mid:='sk';konvex:=true;end; //huom vain luokan 60  - vain "l‰ksin l‰ksit"
        if repeats=2 then if luokka=76 then if sika.vparad=5 then  begin mid:='*nn';;end;  //tiennen, tainnen
        if repeats=2 then if luokka in [74,75] then if sika.vparad=9 then  begin mid:='';end; //katketa nimet‰ katkeisi/katkeaisi
        end;
        //if lu=71 then if (sija in [23,28]) then mid:='-k';
        repeats:=repeats-1;
        result:=false;
        //cutav:=0;cutvok:=0;xvok:='';
       // if mid<>'' then
       // case mid[1] of
       //  '*': dbl
        if (mid<>'') and (mid[1]='*') then
           if luokka=67 then begin delete(koita,1,0);delete(mid,1,1);kondbl:=true;end
           else begin delete(mid,1,1);konvex:=true;end;

        if (mid<>'') and (mid[1]='_') then begin if d then write('????',mid);vokdbl:=true;delete(mid,1,1);end;
        if (mid<>'') and (length(koita)>0) and (mid[1]='-') then
         begin vokvex:=true;delete(mid,1,1);delete(koita,1,0);; end;
         //av-konsonanttia ei vaadita kun on joku vakkari (s) tilalla
        if d then writeln('<li>DOTRY:',vokvex,lka,curlka.esim,' #',sija,'<b>(mid:',blue(mid),')/',//lmmids[lka,sija],
          '/</b>'    ,ifs(curlka.vahva,'v:'+inttostr(sika.vparad),'h'+inttostr(sika.vparad)),'=',' koita:',red(koita),' / ', blue(mid),vokvex,vokdbl,konvex,kondbl,'///',curlka.ekasis,'-',curlka.vikasis,'::',repeats,'</li>');
        //exit;
        if (mid='') OR (pos(mid,koita)=1) then //result:=true
        else
        begin
           // kum+ajaa s+aa   //62naida a / -12-12:: /ei:a-
           if  (koita='') or (pos(koita,mid)=1) then
            begin  if d then writeln('//EOW:',koita,mid);
               skipped:=skipped+copy(mid,length(koita)+1);
               koita:='';
            end else
            begin  if d then write('<li>/ei:',blue(koita),red(mid));
           continue;
           end;
        end;
        if d then for sisus:=curlka.ekasis to curlka.vikasis do writeln('!\',siss[sisus].sis);
        //if pos(koita,mid)=1 then writeln('//EOW:',koita,mid);
        lkajatko:=copy(koita,length(mid)+1,99);
        lkasopi:=copy(koita,1,length(mid));
        //lkasopi:=mid;

        heikkomuoto:=sijanheikkous(isverb,sija);
        if d then   writeln('<li>LK:',lka,red(lkajatko),' / ', blue(lkasopi), curlka.ekasis,'-',curlka.vikasis,koita,'(',mid,')',heikkomuoto,sija,'</li>');
        //if d then for sisus:=curlka.ekasis to curlka.vikasis do writeln('!\',siss[sisus].sis);
        if d then   writeln('<ul>');
        for sisus:=curlka.ekasis to curlka.vikasis do
         if sis_f(sisus,lkajatko,skipped) then begin result:=true;exit;end;
        if d then writeln('</ul>');
       until repeats<=0;
      end;
// tsanasto.etsiyks(
var i,j,lu:word;
begin
 try
try
 writeln('XXX ',hakusana);
d:=false;
resunum:=0;
//d:=true;
sikaloppu:= copy(hakusana,length(sika.ending)+1);
sikasopi:= sika.ending;
resst:='';
//for i:=1 to 58 do writeln(lks[i].kot,lks[i].vahva);
if d then writeln('<li>etsiyksi:',hakusana,'-->',sikaloppu,'+',sika.ending,sika.onverbi,sika.num);
if sika.onverbi then
 begin if sika.num=0 then sikasopi:='a';

    for lu:=52 to 78 do if lka_f(lu,sika.num,sikaloppu,'') then begin writeln('HIOT',resunum);result:=resunum;break;end;
end
else for lu:=1 to 50 do if lka_f(lu,sika.num,sikaloppu,'') then begin result:=resunum;break;end; // skipped vois olls <> ''
//if eitaivu.sexact(hakusana) then writeln('!%%%');
//if resst='' then writeln(' --',reversestring(hakusana+hakuakon));
//if hits>1 then
//result:=resst;
//hitlist[9]:=1;
except writeln('<li>failetsi');end;
  finally result:=resunum;//writeln('<li>res:',resunum);
  end;
end; //etsi


procedure tsanasto.etsimuodot(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
type psika=^tsija;
var sikalauma:tstringlist;passed:string;
     lu,siat,i,j,hits:word;
     sikap:psika;d:boolean;
     sika:tsija;
     sikaloppu,sikasopi,resst:string;
     hakueitaka,hakueietu:boolean;
begin
try
    //vhitlist.clear;
     d:=false;
  //   d:=true;
     sikalauma:=tstringlist.create;

     try
     sikalauma.clear;
     //if isverb then verbit.haesijat(hakunen.loppu,sikalauma)
     //else


     nominit.haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p‰‰te m‰ts‰‰ hakusanaan
     verbit.haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p‰‰te m‰ts‰‰ hakusanaan

     //if d then     for siat:=0 to sikalauma.count-1 do writeln('<li>--',sikalauma[siat],ptrint(sikalauma.objects[siat]),nominit.sijat[ptrint(sikalauma.objects[siat])].ending);
     //if d then   writeln('<li>hae:',hakunen.akon,'|<b>',string(hakunen.koko),'</b>:',sikalauma.count);//,'<ul></li>');
     except writeln('faildosiat');end;
     //resst:='';
     hits:=0;
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
        //sika:=(sikalauma.objects[siat]^);
        //sikap:=psika(sikalauma.objects[siat]);
        sika:=psika(sikalauma.objects[siat])^;
        //sikanum:=sika.num;
        //sikanum:=ptrint(sikalauma.objects[siat]);
        //if sikanum<>0 then continue;
        //if hakunen.isverb then sika:=verbit.sijat[sikanum] else     sika:=nominit.sijat[sikanum];
        sikaloppu:= copy(hakunen.loppu,length(sikalauma[siat])+1);
        if sikaloppu='' then begin continue;passed:=copy(sika.ending,1,length(hakunen.loppu));
           sikasopi:=copy(sika.ending,length(hakunen.loppu),999);writeln('<li>HAKLO:',passed,'/',hakunen.loppu,'/',sikasopi);end
        ;//else continue;
        //sikasopi:=sika.ending;//(sikaloppu,length(sikaloppu)-length(sika.ending)+1);
        sikasopi:=sikalauma[siat];//(sikaloppu,length(sikaloppu)-length(sika.ending)+1);
        //writeln('<li>ss:',sikasopi);
//        hakutc:=tavucount(hakunen.koko);
        //if d then
        //writeln('<li>muoto:',reversestring(sikaloppu),'|',reversestring(sikasopi),' //<b>',reversestring(sika.ending),'#</b>',sika.num,'! ',hakunen.koko,hakutc);
//        hakutc:=hakutc mod 2;
        hakueitaka:=hakunen.eitaka;
        hakueietu:=hakunen.eietu;
        if d then writeln('<li>HAKUNEN:',hakunen.lk,'#',sika.num,'><b>',hakunen.akon,reversestring(sika.ending+'.'+sikaloppu),'</b> {',listsija(sika),'} ');
        //continue;
        if d then writeln('<ul>');

        //exit;
        //resst:=resst+
        etsiyks (HAKUNEN.loppu+hakunen.akon,hakunen.koko,'',hakunen.eietu,hakunen.eitaka,sika,aresu,onjolist,hits);
        //if sika.onverbi then begin for lu:=52 to 78 do lka_f(lu,sikanum,sikaloppu,passed);end
        //else begin for lu:=1 to 50 do lka_f(lu,sikanum,sikaloppu,passed);end;
//4 do
         //???? if (hakunen.lk=0) or (hakunen.lk=lu) then
         //if lu=48 then
          //lka_f(lu,sikanum,sikaloppu,passed);

        if d then writeln('</ul>');
     end;
     if hits>1 then
       writeln('<li>resst::',hakunen.koko,' :',resst,'</li>');//,hakunen.lk,' #',sika.num,'><b>',listsija(sika),'</b> ',sikaloppu,'/ea:',hakueitaka,'/e‰',hakueietu,'</li>');
     if d then writeln('</ul>');

except writeln('<li>failetsi');end;

end; //etsimuodot

end.

