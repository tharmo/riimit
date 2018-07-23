unit taivup;

{$mode objfpc}{$H+}
interface
uses classes, SysUtils,lazutils,LazUTF8,math,strutils,taivubits;
type taste=record
   a:ansichar;
   f,t:ansistring;
end;


var tavucount:word;
type tstarr=class(tobject)
 len:word;
  vals:array OF ansiSTRING;
 procedure commatext(st:ansistring);
 procedure setval(st:ansistring;ind:word);
 constructor create(l:word);
end;

type tstxxarr=class(tobject)
  rows,cols,WLEN:word;
  vals:array of ansichar;
 constructor create(r,c,w:word);
 //procedure setcommarow(st:ansistring);
 procedure setval(r,c:word;st:ansistring);
 function getval(r,c:word):ansistring;
 procedure commarow(st:string;row:word);
 procedure commacol(st:string;col:word);
 Property Items[r,c : word]: ansistring Read GetVAL  Write SetVAL; Default;
end;

type tsija=class(tobject)
  vv,hv:boolean;
  num,vparad,hparad:byte;

  //vmuomids,hmuomids:array[1..12] of byte;
  ending:ansistring;
  constructor create(vahvalka:boolean;tpl,mu:byte);
  constructor createst(str:ansistring);
  procedure list(s:pointer);
  procedure save(u:word;s:pointer);
  function match(tofind:ansistring;rlist:tstringlist):boolean;
 end;

var  lopmat,lkfixes:tstxxarr;
var tavus:tstringlist;

exmat:array[0..100] of ARRAY[0..100] OF ansiSTRING;
//lopvoks:array[0..50] of ansichar;
lopvokst,lopkonst:array[1..30] of ansistring;
exAMPLES:TSTRINGLIST;
//yhtlops:array[0..99] of ansistring;
tpllops:array[1..12] of ansistring;
//  loparr:tstxxarr;
//lkord:word;

type tstemmer=class (tobject)
 instr:tfilestream;
 forms,xxnewforms:tstringlist;
 fixes,xxfixes,xmps:tstringlist;
 eoff:boolean;
 fcount:word;
 prevlka,newlka:ansistring;
 ulos:boolean;
 lops2:ansistring;
 lkaord:word;
 mids:array[0..100] of array[0..80] of ansistring;
 ljouklops:array[0..12] of array[0..30] of ansistring; ljouknums:array[0..12] of array[0..30] of byte;
 ljoukmbrs:array[0..78] of byte;
 ENDINGS:array[0..78] of ANSISTRING;
 sijat:array[0..78] of tsija;
 //sijalista:tstringlist;
 luokat:tlist;
 // procedure listall;
  function matchsijat(tofind:ansistring;rlist:tstringlist):boolean;
  procedure dovahva(inf,av,ah:ansistring;lka:pointer);
  procedure doheikko(inf,av,ah:ansistring;lka:pointer);
  procedure luelista;
  procedure luesijat;
  procedure stemmaa;
  procedure listall;
  procedure findmids;
  procedure createlist;
  procedure testgen;
  procedure generate;
 procedure loppuluokat;
 function explain2(cla:ansistring):ansistring;
 function explain(num:word):ansistring;
 constructor create(fn:ansistring);
 procedure luokkainfo;
 procedure doword;
 procedure liimaamuodot;
 procedure listluokat;
 procedure matrix;
 procedure vertaasana;
 function readline:word;
 procedure findendings;
 procedure findstems;
 procedure oldfindstems;
 procedure endingsbyclass;
 procedure purasanat;
 procedure newmids;
 procedure readmids;
 procedure writemids;
 procedure doluokka;
 procedure luoluokat;
 procedure findmatches(st:string);
 function diag(f:tstringlist;ast:taste;lchar,stem:ansistring;tmuot:word):ansistring;
 //function astevaihtelu(ch:char
end;
 // lausukan teki‰ttˆm‰n heimon  ohi-aikamuoto
type ttavu=class(tobject)
 k1,v:byte;
 k2:array[0..1] of byte;
end;
type tsana=class(tobject)
 alkukoot:ansistring;
 k2:array of byte;
end;
type ttavuvarasto=class(tobject)
  //var1,var2,var3,var4:word; //pseudopointers to beginnings of each compartment of varast0 (1/2/3/4 syllable words)
  varasto:array[1..100000] of byte;
end;
type tmatchmaker=class(tobject)
   //tothits,lkahits, vokhits,avhits,stem
     hits:tstringlist;
     cuts:word;

     taka,debug:boolean;
   constructor create;
end;

type tsmatches=record num:byte;st:ansistring;end;

type t_lopvok=class(tobject)
    vok:ansistring;
    avs:tstringlist;
    function matches(alkuosa,loppuosa:ansistring;vahvako:boolean;mm:tmatchmaker):boolean;
    constructor create(v:ansistring);
    procedure list;
end;


type t_av_osa=class(tobject)//subsection of a ttaivlka
  id:byte;  //kotus-muodossa A,B,..,H? joku oma
  heikko,vahva:ansistring;
  kind:byte; //kaksi vai kolme tyyppi‰.
              //heikiolla muodoilla 62-76:
               //1 ne joissa vaihtotavu muodostuu lopvok+v/h kons (v=h kun  ei astevaihtelua, t/d.., nk,ng)
               //2 :k/-
                  // li-o-ta liu-e-ta vaihtari joko k+lvok tai ''+lvok .. sama kuin tyyppi 1?
                  // koo-ta  vaihtari sulautui runkotavuun  - diftongi
                  //vi-ro-ta vir-ko-an   vaihtarin ja runkotavun konsonantti vaeltaa
              //3:katoava KPT:,
                 //‰-k‰ ‰k-k‰‰n avk poistuu runkotavusta, vaihtari ei vaihdu
                 //
    sanat:ansistring;//array of ttavu;
    procedure list;
    //constructor create;
   function matches(alkuosa,loppuosa:ansistring;vahvako:boolean;mm:tmatchmaker;veks:integer):boolean;
 end;

 type ttaivlka=class(tobject)
 wcount,astecount:word;

 num,kotus:word;
 vahva:boolean;hasav,hasmaft:boolean;
 example,expl:ansistring;
 midsbef,midsaft,xtra:array[1..80] of ansistring;  //make more efficient later
 mids:array[1..12] of ansistring;
 lvoks:tstringlist;
 constructor create(lka:integer);
 procedure list;
 procedure pilko(inf,mid,vahk,heik,sija:ansistring;var stem,loplet,kk:ansistring);
 function match(alkuosa,loppuosa:ansistring;sija:tsija;mm:tmatchmaker):boolean;
 function matchold(alkuosa,loppuosa:ansistring;mm:tmatchmaker):boolean;
 //function match(alkuosa:ansistring;sijat:array of tsmatches;reslist:tstringlist):tstringlist;
end;

procedure doit;

function getastekons(a:ansichar;var vva,hko:ansistring):taste;
function tavut(wrd,pilk:ansistring):ansistring;
var mystems:tstemmer;
implementation
       uses taivuus;

       const vforms:array[0..77] of string=('_','-','VInf1Lat','VPrsActSg1','VPrsActSg2','VPrsActSg3','VPrsActPl1','VPrsActPl2','VPrsActPl3','VPrsActConNeg','VPrsPassConNeg','VPrsPassPe4','VPstActConNeg','VPstActPl1','VPstActPl2','VPstActPl3','VPstActSg1','VPstActSg2','VPstActSg3','VPstPassConNeg','VPstPassPe4','VInf1ActTraSgPxPl1','VInf1ActTraSgPxPl2','VInf1ActTraSgPxSg1','VInf1ActTraSgPxSg2','VInf1ActTraSgPx3','VInf3PassIns','VInf2ActIneSg','VInf2ActIns','VInf2PassIne','VInf3Abe','VInf3Ade','VInf3Ela','VInf3Ill','VInf3Ine','VInf3Man','AgPrcPosAbeSg','AgPrcPosAdeSg','AgPrcPosElaPl','AgPrcPosElaSg','AgPrcPosGenSg','AgPrcPosIllSg','AgPrcPosIneSg','AgPrcPosNomSg','PrfPrcActPosNomSg','PrfPrcPassPosNomPl','PrfPrcPassPosNomSg','PrsPrcActPosNomPl','PrsPrcActPosNomSg','PrsPrcPassPosNomSg','VActInf5Px3','VActInf5PxPl1','VActInf5PxPl2','VActInf5PxSg1','VActInf5PxSg2','VCondActConNeg','VCondActPl1','VCondActPl2','VCondActPl3','VCondActSg1','VCondActSg2','VCondActSg3','VCondPassPe4','VImpvActPl1','VImpvActPl2','VImpvActPl3','VImpvActSg2','VImpvActSg3','VImpvPassPe4','VNNomSg','VNParSg','VPotActPl1','VPotActPl2','VPotActPl3','VPotActSg1','VPotActSg2','VPotActSg3','VPotPassPe4');
         {  $codepage 8859-1}
         type tasteet=array[0..15] of taste;
         const aste: tasteet=((a:'_';f:'';t:''),(a:'A';f:'kk';t:'k'), (a:'B';f:'pp';t:'p'), (a:'C';f:'tt';t:'t'), (a:'D';f:'k';t:'-'), (a:'E';f:'p';t:'v'), (a:'F';f:'t';t:'d'), (a:'G';f:'nk';t:'ng'), (a:'H';f:'mp';t:'mm'), (a:'I';f:'lt';t:'ll'), (a:'J';f:'nt';t:'nn'), (a:'K';f:'rt';t:'rr'), (a:'L';f:'k';t:'j'), (a:'M';f:'k';t:'v'), (a:'N';f:'s';t:'n'), (a:'O';f:'t';t:'-'));
         const muotoja=76;luokkia=28;
       PROCEDURE PIF(cond:boolean;st:string);
       begin
        if cond then writeln(st);
       end;
 function IFs(cond:boolean;st1,st2:ansistring):ansistring;
       begin
        if cond then result:=st1 else result:=st2;
       end;
 constructor tmatchmaker.create;
 begin
 hits:=tstringlist.create;
 //lkahits:=tstringlist.create; vokhits:=tstringlist.create;
 //avhits:=tstringlist.create;stemhits:=tstringlist.create;

 end;
procedure resadd(var res,stl:tstringlist);
 begin
  if res=nil then res:=tstringlist.create;
  if stl<>nil then res.addstrings(stl);
 end;
function matchend(sa,en:ansistring):boolean;
VAR I,J:INTEGER;lendif:integer;
BEGIN
 try
 result:=true;
 if en='' then exit;
 if sa='' then exit;

 lendif:=length(sa)-length(en);  //alet4  t1 -> 3
 for i:=length(en) downto 1 do
  if sa[i+lendif]<>en[i] then begin result:=false;break;end;
 except writeln('###FAILMATCHEND');end;

END;

//function ttaivlka.match(alkuosa:ansistring;sijat:array of tsmatches;reslist:tstringlist):tstringlist;

//**********************************************************
//**********************************************************
function ttaivlka.match(alkuosa,loppuosa:ansistring;sija:tsija;mm:tmatchmaker):boolean;
var s,i,j:integer;resus:tlist;avvahva:boolean;acut,acutcut,loppu,amid,avok:ansistring;
res,debug :boolean;
begin
 mm.debug:=kotus=52;
  //if mm.debug then
  writeln('<span title="',kotus,':'+loppuosa+'">[',kotus);
  if mm.debug then if kotus=62 then writeln('<hr>');
 if mm.debug then writeln('<li>lka:',kotus,'a:',alkuosa,'|L:',loppuosa,' sija:',sija.num,sija.ending,' /v:',sija.vparad,' /h',sija.hparad,'</li><li>');
 if mm.debug then for i:=0 to 10 do writeln(' ',i,mids[i],'|',yhtloput[i]);
 avvahva:=(vahva and sija.vv) or (not vahva and (sija.hv)); //pit‰‰ saada kaikki 75, ei vain n‰‰ 12 sijamuotoa
 //writeln('</li>');
 if vahva then amid:=mids[sija.vparad] else amid:=mids[sija.hparad];
 //if not vahva then delete(loppu,1,mm.cuts);
 //write('[',amid,']');
 mm.cuts:=0;
 while pos('-',amid)=1 do begin delete(amid,1,1);if not debug then writeln('VEX:',alkuosa,'/',acut,'*',amid,s);mm.cuts:=mm.cuts+1;end;
  //write('[',amid,']');
 {///TEST
 for i:=0 to min(lvoks.count-1,0) do
    res:=t_lopvok(lvoks.objects[i]).matches(copy(alkuosa,1,length(alkuosa)-length(amid)),amid+loppuosa,avvahva,mm);
 writeln('</span>');
  exit;}
 if mm.debug then  writeln(alkuosa,'/mid:',amid,' ');
 if not matchend(alkuosa,amid) then exit;//begin writeln('NOMATCH;',kotus,' ',alkuosa,'/',amid);exit;end;
 if debug then writeln(' <b>',copy(alkuosa,1,length(alkuosa)-length(amid))+'|',amid+loppuosa,'</b> ',avvahva);
  acut:=copy(alkuosa,1,length(alkuosa)-length(amid));
  loppu:=amid+loppuosa;//;+mm.cuts-0);//+'!'+loppuosa;
  try  if mm.debug then writeln('<ul><li><b>*',acut,'|',loppu,' ',amid,'</b>');
  for i:=0 to lvoks.count-1 do
    begin
      if mm.debug then writeln('(',lvoks[i],')');
     res:=t_lopvok(lvoks.objects[i]).matches(acut,loppu,avvahva,mm);
    end finally writeln('</ul>');end;
 writeln(']</span>');
end;
function ttaivlka.matchold(alkuosa,loppuosa:ansistring;mm:tmatchmaker):boolean;
var s,i,j:integer;resus:tlist;avvahva:boolean;acut,acutcut,loppu,amid,avok:ansistring;
res:boolean;
begin //nyt mietitty vain heikoille luokille
   loppuosa:='';
   writeln('<li> try:',kotus,alkuosa,length(mids),'/',lvoks.count,lvoks.commatext,':',example,'<li><ul>');
   for s:=0 to length(mids)-1 do write(' [',s,mids[s]+'|'+yhtloput[s]+'] ');
   for s:=0 to length(mids)-1 do
   begin
     //if  yhtloput[s]='' then continue; //Just for debugging, not for real
     //writeln('<li>');
     if not matchend(alkuosa,yhtloput[s]) then begin writeln('//',s,alkuosa,'+',mids[s]+'|'+yhtloput[s],'-');
          continue;end;
     amid:=mids[s];
     mm.cuts:=0;
     mm.debug:=kotus=67;
     while pos('-',amid)=1 do begin delete(amid,1,1);writeln('<li>svex:',alkuosa,'/',acut,'*',amid,s);mm.cuts:=mm.cuts+1;end;

      //acut:=copy(alkuosa,1,length(alkuosa)-length(yhtloput[s])-1);  //pit‰isi ottaa huomioon myˆs miinuksen j‰keiset
        //lyps‰‰ -s lyp-s+s|i  huutaa huu-t+s|i  (poista av-kons)
        //naida -  nai-i+i|   nai-i+|isi  (poista tutkittavan sanan lvok-lopusta
     //if mm.cuts=0 then  continue; //testing just be abbr. endings  HAISI  NAI-SI
     //********************remember to comment out row above
     acut:=copy(alkuosa,1,length(alkuosa)-length(yhtloput[s]));
     //if not vahva then delete(loppu,1,mm.cuts);
     writeln('<li>!!',s,acut,'?',amid,'+',loppu,'_[',yhtloput[s],']<li>');
     //if mm.cuts>0 then if begin end;
     if not matchend(acut,amid) then continue;
     avvahva:=(vahva and (not (s in [2,4,7]))) or (not vahva and (s in [2,3,6,9])); //pit‰‰ saada kaikki 75, ei vain n‰‰ 12 sijamuotoa
      //[1aa] [2an] [3aa] [4eta] [5anut] [6i] [7ettu] [8aen] [9aisi] [10akaa] [11anemme]
     writeln(mm.cuts,'<B>Z:',s,'_',amid,'.',yhtloput[s],'?',acut,'/',lvoks.count,'?</B> ',avvahva,vahva);//,s  in [2,4,7],(vahva and (not (s in [2,4,7]))));
         //mm.vokhits.clear;
      acutcut:=copy(acut,1,length(acut)-length(amid));
      loppu:=copy(alkuosa,length(acutcut)+1);//;+mm.cuts-0);//+'!'+loppuosa;
     //if not vahva then   delete(acutcut,length(acutcut)-mm.cuts+1,mm.cuts);
     //if not vahva then delete(loppu,1,mm.cuts);
     //if not vahva then delete(loppu,length(acutcut)-mm.cuts+1,mm.cuts);
      //if not vahva then
     //if not vahva then delete(acutcut,length(acutcut),mm.cuts);
        //writeln(' ?:',s,mids[s]);
      try writeln('<ul><li><b>',acutcut,'|',loppu,' ',amid,'</b>');

      for i:=0 to lvoks.count-1 do
         res:=t_lopvok(lvoks.objects[i]).matches(acutcut,loppu,avvahva,mm);
        finally writeln('</ul>');end;
     end;// else writeln('\',mids[s],'%');
   //end;
   writeln('</ul><hr>');
       //if mm.kahits.count>0 then writeln('<li>lkahits:',mm.lkahits.commatext);
end;
constructor t_lopvok.create(v:ansistring);
begin
  try
   vok:=v;
  avs:=tstringlist.create;
  except writeln('<h1>EIVOK</h1>');end;
  //if length(vok)>1 then writeln('<h1>longvok',vok,'</h1>');
end;
procedure t_lopvok.list;
var i:word;
begin
   writeln('<li><b>',vok,':</b><ul>');
   for i:=0 to avs.count-1 do begin write('{',avs[i],'}');t_av_osa(avs.objects[i]).list;end;
   WRITELN('</UL>');
end;

function t_lopvok.matches(alkuosa,loppuosa:ansistring;vahvako:boolean;mm:tmatchmaker):boolean;
var mv,mh,runkolop:ttavu;i,j,hits,veks:integer;
  avok,acut,loppu:ansistring;res:boolean;
  vsijako:boolean; //this should come as parameter. tells whether we are looking for heikko or vahva sijamuoto
begin
   // mm.vokhits.clear;
   // mm.avhits.clear;
    try
    avok:=vok;
    veks:=mm.cuts;
    for i:=1 to mm.cuts do if avok<>'' then begin //write('DEL',mm.cuts,avok);delete(avok,length(avok),1);
      veks:=veks-1;end;

    if mm.debug then writeln('<ul><li>?<b>',alkuosa,' </b>AVOK:',avok,'>',loppuosa,mm.hits.count,'<ul><li>',avok+loppuosa);
      //writeln('<ul><li><b>_',avok,'_ </b> :::alku:<b>',alkuosa,  '|_',avok,'_</b>loppu:',loppuosa,mm.hits.count);
   //list;
   {///***************TEST
   hits:=0;
   for i:=0 to avs.count-1 do

    if (pos('_',avs[i])<1) or (i=avs.count-1) then
    begin t_av_osa(avs.objects[i]).matches(copy(alkuosa,1,length(alkuosa)-length(aVOK)),avok+loppuosa,vahvako,mm,veks);
         hits:=hits+1;
         if hits>3 then break;
   end;
  // writeln('<li>',avs.commatext,'</ul>');
   exit;}
   result:=false;
   if matchend(alkuosa,avok) then
   begin
     acut:=copy(alkuosa,1,length(alkuosa)-length(aVOK));
     loppu:=avok+loppuosa;
     if mm.debug then writeln('<li>VV:',avok,':',acut,'|',loppu,'<ul>');
     for i:=0 to avs.count-1 do
     begin
         // loppu:=copy(alkuosa,length(alkuosa)-length(acut))+loppuosa;
         //writeln('<li>(+',avs[i],')',mm.hits.count);
         res:=t_av_osa(avs.objects[i]).matches(acut,loppu,vahvako,mm,veks);
  //       if (ktofind)='' or (ktofind=(alkuosa[length(alkuosa)]) then
   //       result.addstring(
      //for j:=0 to mm.avhits.count-1 do
      //     mm.vokhits.add(mm.avhits[j]+'|'+vok);
       //if mm.vokhits.count>0 then writeln('<li>HITTEJƒ:',mm.vokhits.commatext);
       //mm.avhits.clear;

     end;
      //if res then

   end;
    //if mm.vokhits.count>0 then writeln('<li>HITVOK',mm.vokhits.commatext);
    if mm.debug then writeln('</ul>');
    finally writeln('</ul>');
    end;
end;

function matchw(alkuosa,sana,loppuosa:ansistring;cutkon:boolean;mm:tmatchmaker):boolean;
var s,i,j,len,ldif,ask,apos,aapos:integer;acut:ansistring;hit,inko,pastvo,taka:boolean;
begin
   hit:=true;inko:=true;//asana:='';
   //if mm.debug then
   //write(' ??',alkuosa,'_',sana+'?');
    ldif:=length(sana)-length(alkuosa);
    result:=true;hit:=true;
    i:=length(sana)+1;
    while i> 1 do
    begin
     i:=i-1;
     if i-ldif<1 then break;  //all the way, match!
     //writeln(' -', sana[i],alkuosa[i-ldif]);
     if sana[i]<>alkuosa[i-ldif] then
     begin
       //writeln('<li>check the ',copy(sana,1,i),' of ', sana);
       for j:=i downto 1 do if pos(sana[j],vokaalit)>0 then begin result:=false;
         //write(' outch,',sana[j]);
        break;end;// else write('ok:',sana[j]);
       //if result then write('  ok');
       if not result then
       begin result:=true;
        //writeln('<li>check the ',copy(alkuosa,1,i-ldif),' of ', alkuosa);
       for j:=i-ldif downto 1 do
        if pos(alkuosa[j],vokaalit)>0 then begin result:=false;break;end;// else write(' ok:',ALKUOSA[J]);
       end;
       break;
     end;
   end;
   //writeln(result,'</ul>');
 if sana='' then result:=true;
 if alkuosa='' then result:=true;
 if result then mm.hits.add(sana+loppuosa+' ');
 if result then
   if mm.debug then writeln('<b>++++++</b>',sana+'|'+loppuosa);
   //  if mm.debug then writeln(acut,'/',alkuosa,'</small> ');
end;


procedure t_av_osa.list;
var i:word;
begin
   writeln('<li><b>',kind,' [',vahva,'/',heikko,']</b>',sanat,'</li>');
end;


function t_av_osa.matches(alkuosa,loppuosa:ansistring;vahvako:boolean;mm:tmatchmaker;veks:integer):boolean;
var mv,mh,runkolop:ttavu;ff,sana:ansistring;i,j:integer;
 sanal:tstringlist;hit,takako:boolean;wlen:word;
begin         //nyt mieetitty vain heikoille luokille
  //list;
   //if kind<>3 then exit;
    //  mm.debug:=true;
   sanal:=tstringlist.create;
   try
   sanal.commatext:=sanat;
   if sanal.count<1 then exit;
   //if length(alkuosa)=1 thenbegin   writelm n('<li>ALKU:',alkuosa,'| end;
   //if kind=3 then  begin heikko:=vahva;vahva:=vahva+vahva;end;
   ff:=ifs(vahvako, vahva,heikko);
   if ff='_' then ff:=heikko;
   if mm.debug then writeln('<li>AV:<b>',kind,ff,'[', vahva,'|',heikko,']</b>',alkuosa[length(alkuosa)],' ::',sanat+'</li>');
   //if kind=3 then     //                  ff:=ifs(vahvako, vahva+vahva,vahva);
   //  if alkuosa[length(alkuosa)]<>vahva then exit;
   { Ei saa luovuttaa vaikkei konsonantit mats‰‰ -- se konsonantti voi olla sanan alkukirjain. Paitsi jos

   if vahvako then if alkuosa[length(alkuosa)]<>vahva then exit;
   else if heikko<>'' then if alkuosa[length(alkuosa)]<>heikko then exit;
   }
   if veks>0 then begin veks:=veks-1;ff:='';end;
   {///***************TEST
   try for i:=0 to min(sl.count-2,1) do
   if sl.count>0 then
     if  sl[i][1]='1' then writeln(('<span> <b>'+copy(sl[i],3)+'</b>'+ff+'<b>'+loppuosa+'</b></span>'))
   else writeln(etu('<span> <b>'+copy(sl[i],3)+'</b>'+ff+'<b>'+loppuosa+'</b></span>'));
   except writeln('>>',sanat,sl.count);end;
   exit;}
   //mm.stemhits.clear;
   //mm.avhits.clear;
   //try writeln('<ul><li><b title="',copy(sanat,length(sanat)-55,55)+'">[',vahva,'|',heikko,']</b><span>');//AV:',kind,alkuosa,'/',loppuosa,' ',  vahvako,'{',ff,'/',kind,',',vahva,heikko,'}',sl.count,ff=alkuosa[length(alkuosa)],'</span>');
   try //if mm.debug then writeln('<em title="',copy(sanat,length(sanat)-55,55)+'">|',ff,'[',vahva,'|',heikko,']</em>');
    //HAISI SAISI (''+s+aa-1+ (
   //writeln('<ul>');
   //if pos(
     try
   for i:=0 to sanal.count-2 do
   begin
    //taka:=
    if mm.debug then writeln('<li>KKK',sanal[i],'&nbsp;&nbsp;&nbsp;&nbsp; ',alkuosa,'[',vahva,'|',heikko,' ',loppuosa,'&nbsp;&nbsp;&nbsp;&nbsp; ',vahvako);
    //continue;
     takako:=sanal[i][1]='2';  //takavokaali-indikaattori sanan alussa 0/1
     if mm.taka<>takako then continue;
     wlen:=strtointdef(sanal[i][2],0);
     sana:=copy(sanal[i],3,length(sanal[i]));
     if mm.debug then   writeln('>',sana);
     if length(alkuosa)<2 then begin mm.hits.add(sana+ff+loppuosa+' '); if mm.debug then writeln('!!!+++'+sana+ff+loppuosa);continue;end;
       //if pos(copy(alkuosa,1,length(alkuosa)-0),konsonantit)>0
       if length(alkuosa)<2 then if pos(alkuosa,konsonantit)>0 then
       begin
            if length(alkuosa)=0
             then mm.hits.add(loppuosa) else
            mm.hits.add(sana+ff+loppuosa);
           // mm.hits.add(ifs(takako,etu(sana+ff+loppuosa),sana+ff+loppuosa)+' ');
            if mm.debug then writeln('<b>+++!!</b>',sana+ff+loppuosa);
           //writeln('/x\');
           continue;
       end;
       if sana='' then begin mm.hits.add(sana+ff+loppuosa+' ');writeln('X+++');continue;end;

       //if mm.cuts>0 then begin //
       //writeln('/*/',sl[i],' ');
       // hit:=matchw(alkuosa,sl[i],loppuosa,false,mm);writeln('zzzz');continue;end;
     hit:=false;
    case kind of
      0: begin //ei astevaihtelua, mutta mahd. konsonantin pit‰‰ mats‰t‰
         if heikko='' then  // tavu vokaalien keskell‰
           hit:=matchw(alkuosa,sana,loppuosa,false,mm)
            //writeln('<li>hit:',mm.stemhits.commatext);
         else if alkuosa[length(alkuosa)]=heikko then
           hit:=matchw(copy(alkuosa,1,length(alkuosa)-1),sana,heikko+loppuosa,false,mm);
           //writeln('(',sana,'/'')');
       end;
     1: begin //katoava K
        if not VAHVAKO then
          hit:=matchw(alkuosa,sana,loppuosa,false,mm)  // then
        else
        if alkuosa[length(alkuosa)]='k' then
          hit:=matchw(copy(alkuosa,1,length(alkuosa)-1),sana,'k'+loppuosa,false,mm);
          writeln('KKKKKK'+alkuosa,loppuosa);
       end;
     2,4: begin
          //write('_',ff,ifs(alkuosa[length(alkuosa)]=ff,'+','-'),sana);
          if alkuosa[length(alkuosa)]=ff then
          begin
             hit:=matchw(copy(alkuosa,1,length(alkuosa)-1),sana,ff+loppuosa,false,mm);
          end;
        end;
     3:  begin  //kk/k, pp/p,
            if vahvako then
            begin
                 //if alkuosa[length(alkuosa)]=ff then  //t‰‰ oli jo tutkittu
            hit:=matchw(copy(alkuosa,1,length(alkuosa)-length(ff)),sana,ff+loppuosa,false,mm)
            //hit:=matchw(alkuosa,sana,ff+loppuosa,false,mm)
            end else //resadd(result,matchstem(copy(alkuosa,1,length(alkuosa)-1),sana,true)); //true = ignore last kon in stem
            hit:=matchw(alkuosa,sana,loppuosa,true,mm);
            //hit:=matchw(copy(alkuosa,1,length(alkuosa)-1),copy(sana,1,length(sana)-length(ff)),ff+loppuosa,true,mm);
            if mm.debug then writeln('<li>=',ff,'!',alkuosa,'-',sana,hit,vahvako);
         end
     else writeln('NOCASE:',kind,',');
     end;
     //if hit then     writeln('<li>hitti: ',ifs(hit,':','-'),sana,'_');
   end;
     except writeln('################',kind);end;
   //for i:=0 to mm.stemhits.count-1 do
   // mm.avhits.add(MM.STEMHITS[I]+ff);
   //if mm.avhits.count>0 then writeln('<li>HITAV',mm.AVHITs.COMMAtext);
   //mm.stemhits.clear;
     finally //writeln('</ul>');
     end;
     try
   finally sanal.free; end;
   except writeln('failfreeslist');end;
end;
function tavut(wrd,pilk:ansistring):ansistring;
var i,o,pc:integer;color:string;tavutettu:ansistring;tavupala:byte;
begin

 tavutettu:=hyphenfi(wrd,tavus);
 o:=length(tavutettu)+1;color:='blue';result:='</span>';
 result:=''; pc:=0;//tavus.count;
 //writeln('<span style="color:red">',tavutettu,': ');
 if pilk[i]<>'|' then begin o:=o-1;end else begin pc:=pc+1;end;
 tavupala:=3;
 //writeln('<li style="color:gray">');
 for i:=length(pilk) downto 1 do
 begin
    //write('&nbsp;&nbsp;&nbsp ',pilk[i],tavutettu[o]+' ');
   // writeln('&nbsp;',pilk[i],tavupala);
    if tavutettu[o]=',' then
    begin
      //if color='blue' then color:='green' else if color='green' then color:='black' else if color='black' then color:='red' else color:='blue';
      // if pc=0 then color:='green' else if pc=1 then color:='black' else if pc=2 then color:='red' else if pc=3 then color:='blue' else color:='brown';
     //result:='</span>'+'<span style="color:'+color+'" title="'+inttostr(pc)+'"> '+result;//+inttostr(pc)+result+' ' ;
     result:=' <span style="color:green">'+result; tavupala:=3;
     o:=o-1;
    end;
    if pilk[i]<>'|' then begin o:=o-1;end else begin pc:=pc+1;end;
    //result:=pilk[i]+result;
    //result:='</span>';

    //for j:=length(pilk[i]) downto 1 do
     if pilk[i]='|' then result:='|'+result else
     case tavupala of
     3:if pos(pilk[i],vokaalit)>0 then begin result:=pilk[i]+'</span><span style="color:blue">'+result;tavupala:=2;end else result:=pilk[i]+result;
     2:if pos(pilk[i],vokaalit)<1 then begin result:=pilk[i]+'</span><span style="color:red">'+result;tavupala:=1;end else result:=''+pilk[i]+''+result;
     1:if (pos(pilk[i],vokaalit)>0) or (pilk[i]='|')  then begin result:=pilk[i]+'?</span><span style="color:green">'+result;tavupala:=3;end else result:=pilk[i]+'!'+result;
     else result:=result+'!!';
     end;
 end;
 result:='<span style="color:black"> '+result+'&nbsp;';
 //writeln('</span>]');
end;

function tavutx(wrd,pilk:ansistring):ansistring;
var i,j,o,pc:integer;color:string;tavutettu,st:ansistring;
 tavupala:byte;
begin
 st:=' style="color:'  ;//margin-left:0.2em;xdisplay:inline-block;xwidth:2em;color:';
 result:=''; pc:=0;
 o:=0;color:='blue';result:='<span '+st+'green">';
 tavus.clear;
 tavutettu:=hyphenfi(wrd,tavus);
 //writeln('<span style="color:red">',tavutettu,': ');
 for i:=1 to length(pilk) do
 begin
  if pilk[i]<>'|' then begin o:=o+1;end else pc:=pc+1;
  //if wrd=write('&nbsp;&nbsp;&nbsp ',pilk[i],tavutettu[o]+' ');
  if tavutettu[o]=',' then
  begin
    //if color='blue' then color:='green' else if color='green' then color:='black' else if color='black' then color:='red' else color:='blue';
     //if pc=0 then color:='green' else if pc=1 then color:='black' else if pc=2 then color:='red' else if pc=3 then color:='blue' else color:='brown';
     if pilk[i]='|' then result:=result+'!?';
   result:=result+'</span>'+'<span '+st+color+'" title="'+inttostr(pc)+'"># ';//+;
   o:=o+1;
  end;
  result:=result+pilk[i];

 end;
 result:=' '+result+'&nbsp;&nbsp;</span>';
 //writeln('</span>]');
end;
{
 tluokka
  etutaka
   lopvoks
     av
       pituus
}

function matchalkutavu(s1,s2:ansistring):boolean;
var i,j:integer;
begin
try
  result:=true;
  if (s1='') or (s2='') then exit;
  while pos(s1[1],konsonantit)>0 do delete(s1,1,1);
  while pos(s2[1],konsonantit)>0 do delete(s2,1,1);
  result:=s1=s2;
  //writeln(result,s1,s2);
  except   writeln('!!FAILEN:',s1,s2);end;
end;

function matchtavut(s1,s2:tstringlist):boolean;
var i,j,ldif,end1:integer;
begin
  RESULT:=TRUE;
  ldif:=s1.count-s2.count;
    for j:=(s1.count-1) downto 2 do
      if j-ldif<2  then
      begin //writeln('(',j-ldif,')');
        break;
      end else
      begin
         if s1[j]<>taka(s2[j-ldif]) then
           begin //write('{',J,s1[j],'!=',J-LDIF,taka(tavus[j-ldif]),'}');
             result:=fALSE;EXIT;end;
           //write(' [',J,s1[j],'=',J-LDIF,taka(s2[j-ldif]),']');
          end1:=j;
      end;
    try
     if (end1>1) and (end1-ldif-1>0) then
      result:=matchalkutavu(s1[end1-1],s2[end1-ldif-1]);
    //writeln('((',end1, s1[end1-1],'/',s2[end1-ldif-1],'))');
    except   writeln(end1-1,'[[',end1, ldif,']]',end1-ldif-1);
end;
    //FOR J:=LENGTH(S1[)
end;
procedure tstemmer.luelista;
var winfo,parts:tstringlist;ofi,ifi:textfile;
     curlka:ttaivlka;
     curvok:t_lopvok;
     curav:t_av_osa;

     lknum,TAVUJA,SANOJA:integer;
     hAKU,line,av,ah,lksx,stends,lopvoks,psim,newid,mymid,xpart,lkon,sharedb,stem,form,color,paddedform,thisav,pilkottu,sv,sh,mv,mh,myvai,vr,hr:ansistring;
     i,j,k,s,sims,changelev,ldif:integer;
     ast:taste;
     sijatavut:array[1..76] of tstringlist;
     curblock,curw,prevw,fres:tstringlist;
     stav,tofind,sijalist:tstringlist;
     mux:word;
     avlen,inflen,tavucount:byte;
     mm:tmatchmaker;
     mismat:boolean;
    procedure testaasijat;
    var x,lu,s1,s2:integer;sims:array[0..11] of array[0..11] of integer;
    begin
      fillchar(sims,sizeof(sims),0);
      writeln('<h3>listaamuodot</h3>');
      for lu:=0 to luokkia do
       for s1:=0 to 11 do
        for s2:=0 to 11 do
        begin
        if mids[lu,s1]<>mids[lu,s2] THEN sims[s1,s2]:=sims[s1,s2]+1;// else sims[s1,s2]:=sims[s1,s2]+1;
        //write(' .',s1,s2);
        end;
      WRITELN('<TABLE border="1"><tr><td>X</td>');
      for s1:=0 to 11 do     WRITELN('<TD><B>',S1,'</B></TD>');
      WRITELN('</TR>');
      for s1:=0 to 11 do
      BEGIN
        WRITELN('<TR><TD><B>',S1,'</B></TD>');
        for s2:=0 to 11 do
        WRITELN('<TD>',sims[s1,s2],'</TD>');
        WRITELN('</TR>')
      END;
            WRITELN('</Table>')

    end;
  begin
    //testaasijat;    exit;
    tofind:=tstringlist.create;
    curblock:=tstringlist.create;
    curw:=tstringlist.create;
    prevw:=tstringlist.create;

   // tofind.commatext:='us,kom,me';
    for i:=1 to muotoja-2 do
    begin
     sijatavut[i]:=tstringlist.create;
     //writeln('<li>',i,hyphenfi(yhtlopsall[i],tavus));
     sijatavut[i].assign(tavus);
     //writeln(sijatavut[i].commatext);
    end;
    {writeln('<h3>listaatavut</h3>');
    for i:=1 to muotoja-2 do
    begin
     writeln('next:',i);
     for j:=sijatavut[j].count-1 downto 0 do
     writeln('<li>',i,':',sijatavut[i].commatext);
    end;}
    assign(ifi,'vsort.csv');
    reset(ifi);
    lknum:=-1;
    lksx:='xxx';
    prevw.commatext:='x,x,x,x,x';
    //parts:=tstringlist.create;
    //writeln('<hr>LISTAA',hyphenfi('arvioida',tavus),hyphenfi('reiitt‰‰',tavus),hyphenfi('kooissa',tavus),hyphenfi('oieta',tavus));   exit;
    curw.StrictDelimiter := true;
    curw.Delimiter:= ',';
     //  for i:=1 to 4 do readln(ifi,line);; //skip rubbish
     writeln('<ul><li>START</li><li>');
    while not eof(ifi) do
    begin
       readln(ifi,line);
       curw.commatext:=line;
       curw[0]:=copy(curw[0],1,2);
       //writeln('<li>',parts.commatext);
       if strtointdef(copy(curw[0],1,2),0)>61 then inflen:=5 else inflen:=4;
        //inflen:=5;
        //try write(curw[0],curlka.kotus,'| ');except end;
        if strtointdef(curw[0],999)=999 then continue;
       changelev:=6;
       for i:=0 to inflen do
       begin
          if curw[i]=prevw[i] then continue else
          begin changelev:=i;break;end;
       end;
       for i:=inflen downto changelev do
       begin
          //writeln('</li></ul>');
       end;
       for i:= changelev to inflen do
       begin
          //writeln('<ul><li>',curw[i],': ');
       end;
       //if changelev=0 then //writeln('<h1>uusilka:',prevw.commatext,' // ',curw.commatext,'</h1>');
       if changelev<inflen+1
       then
       begin
        prevw.assign(curw);
       end;
       //write(' / ');
       //for j:=inflen+1 to curw.count-1 do write(curw[j]);

       if changelev=0 then  begin lknum:=lknum+1;  curlka:=ttaivlka(luokat[lknum]);end;

       if changelev<=1 then  begin curvok:=t_lopvok.create(curw[1]);curvok.vok:=curw[1];try curlka.lvoks.addobject(curw[1],curvok) ;
       except writeln('<h1>failvok:',changelev,curlka.kotus,curlka.lvoks=nil,  curlka.lvoks.commatext,'</h1>');end;
       end;

       if changelev<=4 then
        begin curav:=t_av_osa.create;  curav.vahva:=curw[3];curav.heikko:=curw[4];
         curav.kind:=strtointdef(curw[2],0);
        try     curvok.avs.addobject(curw[3]+curw[4],curav) ;
        //if curw[1]='' then writeln('<li>',curlka.kotus,'#',curvok.avs.count,'NOVO:',curw.commatext);
        except writeln('<h1>failav:',curlka.kotus,curvok.vok,' ' ,changelev,'/',curvok.avs=nil,'</h1>');end;
        end;
      try
        curav.sanat:=curav.sanat+curw[5]+inttostr(curw.count-8);
        for i:=7 to curw.count-1 do
        CURAV.sanat:=curav.sanat+curw[i];
        CURAV.sanat:=curav.sanat+',';
        //curav.vokso:=curav.vokso+cur
        //if curw.count<10 then writeln(' ==',curav.sanat);
       except writeln('<h1>failsanat:',changelev,'</h1>');end;
    end;
    writeln('</ul></ul></ul></ul><hr><hr><hr><hr><h1>HAE :',LUOKAT.COUNT,':</h1><ul>');
    //for i:=1 TO LUOKAT.COUNT-1 do if ttaivlka(luokat[i]).kotus<>772 then TTAIVLKA(LUOKAT[I]).LIST;
    //fres:=tstringlist.create;
    mm:=tmatchmaker.create;
     if paramstr(1)='' then haku:='haisi' else haku:=(paramstr(1));
     if pos('.',haku)=1 then
     begin  haku:=copy(haku,2);
      mm.taka:=true;
     end;
     if etu(haku)=taka(haku) then mm.taka:=true;
     hyphenfi(haku,tavus);
     tavucount:=tavus.count;
     tofind.addstrings(tavus);
     //for j:=1 to length(haku) do if pos(haku[j],'aou')>0 then mm.taka:=true;
     writeln('<h1>findsijat ',paramstr(1),haku,taka(haku),mm.taka,'</h1><hr>',mm.hits.commatext);
     sijalist:=tstringlist.create;
     //haku:='';
      matchsijat(haku,sijalist);
      writeln('<li>TEST sijat:',sijalist.count,sijalist.commatext);
      for i:=0 to sijalist.count-1 do tsija(sijalist.objects[i]).save(i,self);
      writeln('<hr>xxx');
     {//**TEST
     for s:=0 to sijalist.count-1 do
     begin
      //if (s<>26) AND (s<>73) then continue;
      writeln('<h3>');
      tsija(sijalist.objects[s]).save(s,self);
      writeln( '</h3>');
      for i:=0 TO LUOKAT.COUNT-1 do //if ttaivlka(luokat[i]).kotus=72 then
       // if ttaivlka(luokat[i]).kotus=69 then
       TTAIVLKA(LUOKAT[I]).match(sijalist[s],tsija(sijalist.objects[s]).ending,tsija(sijalist.objects[s]),mm);
     end;
      writeln('<li>findsanat sijat:',sijalist.count);
     exit;}
     for s:=0 to sijalist.count-1 do
      for i:=0 TO 25 do //if ttaivlka(luokat[i]).kotus=72 then
       TTAIVLKA(LUOKAT[I]).match(sijalist[s],tsija(sijalist.objects[s]).ending,tsija(sijalist.objects[s]),mm);
      writeln('<h1>found ',haku,mm.hits.count,'</h1><hr>',mm.hits.commatext);
      for i:=0 to mm.hits.count-1 do
      begin
        hyphenfi(trim(mm.hits[i]),tavus);   //tavus pit‰is olla k‰‰nt.j‰rj. ja pakattuina ttavuiksi. myˆhemmin
        if abs(tavus.count-tavucount) mod 2=0 then
        begin
          mismat:=false;
          //writeln('<li>::');
          if  matchtavut(tavus,tofind) then
          if not mm.taka then writeln('<li>',tavus.commatext)
          else writeln('<li>',etu(tavus.commatext));
          //writeln(';; ',tavus.commatext,tavus.count,'/',tavucount,' ',abs(tavus.count-tavucount) mod 2)
        end;//         else writeln(' ZZZZZ',tavus.commatext,tavus.count,'/',tavucount,' ',abs(tavus.count-tavucount) mod 2)
      end;
      //johtaa, kohdata  johtaisi kohtaisi
end;

function tsija.match(tofind:ansistring;rlist:tstringlist):boolean;
var i,p:integer;
begin
 //for i:=0 to 78 do
  //writeln('<li>match:',tofind,' to ', num, ending,'/',tofind);
  result:=false;
  //writeln('testzyxx!!!!!!!!!!!!!!!!!!!!');
  //if length(ending)>=length(tofind) then exit;
  if copy(tofind,length(tofind)-length(ending)+1)=ending then result:=true else exit;
  write('<li>[[',ending,'!',tofind,num,' ');
  rlist.add(copy(tofind,1,length(tofind)-length(ending)));
  rlist.objects[rlist.count-1]:=(self);
  //writeln('<li>sija: ',num,ending, result,' [',copy(tofind,1,length(tofind)-length(ending)),'|');
  //self.save(rlist.count-1,mystems);
  writeln('tmp!!!');//now we are listing all, not just matches
end;
function tstemmer.matchsijat(tofind:ansistring;rlist:tstringlist):boolean;
var i,j:integer;
begin
writeln('<li>m‰ts‰‰ ',tofind);
//for i:=1 to 10 do tsija(sijat[i]).save(self);
for i:=0 to 65 do
 begin
 try
 if tsija(sijat[i]).match(tofind,rlist) then
 tsija(rlist.objects[rlist.count-1]).save(i,mystems);
 except writeln('<li>',i);end;
 end;
writeln('<hr><hr><hr>',rlist.commatext,'<hr><hr><hr>');
//for i:=0 to 77 do tsija(sijat[i]).save(self);

end;
var slist,sslis:tstringlist;
 function CompareString(List : TStringList; Index1, Index2 : integer) : integer;
 var r:boolean;i1,i2:integer;
 begin
 result:=0;
 i1:= strtointdef(tstringlist(List.objects[Index1])[1],0);
 i2:=strtointdef(tstringlist(List.objects[Index2])[1],0);
 if i1>i2 then result:=1 else
 if i1<i2 then result:=-1 else
 begin
   result:=0;
   i1:= strtointdef(tstringlist(List.objects[Index1])[3],0);
   i2:=strtointdef(tstringlist(List.objects[Index2])[3],0);
   if i1>i2 then result:=1 else
   if i1<i2 then result:=-1 else
   begin
     result := AnsiCompareText(tstringlist(List.objects[Index1])[5], tstringlist(List.objects[Index2])[5]);
     //writeln('<li>',result,(tstringlist(List.objects[Index1])[5]), ' ',tstringlist(List.objects[Index2])[5]);

   end;
 end;
end;
procedure tstemmer.luesijat;
var i,j:integer;
begin
WRITELN('ZZZZZZZZZZZZZZZZZZZZZZZZZ<HR>!');
slist:=tstringlist.create;
slist.loadfromfile('vsijat3.lst');
//for i:=1 to 30 do lvokcounts[i]:=0;
//writeln('<pre>');
for i:=0 to slist.count-1 do
begin
 //writeln('<li>');
 sslis:=tstringlist.create;
 sslis.commatext:=slist[i];
 slist.objects[i]:=sslis;
 //sijat[i].save(self);
end;
slist.customsort(@comparestring);
for i:=0 to slist.count-1 do   //writeln(sslis[j],',');
 sijat[i]:=tsija.createst(slist[i]);
//for i:=0 to slist.count-1 do    tsija(sijat[i]).save(self);
for i:=1 to 11 do
 begin
   writeln('<li>',i,yhtloput[i],':');
  for j:=1 to slist.count-1 do
    if (sijat[j].vparad=i) or (sijat[j].hparad=i) then write('*');
  end;
//writeln('<li>',tstringlist(slist.objects[I]).commatext);
WRITELN('ZZZZZZZZZZZZZZZZZZZZZZZZZ<HR>!');
//for i:=1 to 13
  for j:=0 to slist.count-1 do
   sijat[j].save(j,self);

slist.free;
end;
procedure tstemmer.listall;
var winfo,parts:tstringlist;ofi,ifi:textfile;
     curlka:ttaivlka;
     lknum:integer;
     line,av,ah,lksx,stends,lopvoks,psim,newid,mymid,xpart,lkon,sharedb,stem,form,color,paddedform,thisav,pilkottu,sv,sh,mv,mh,myvai,vr,hr:ansistring;
     i,j,k,sims:integer;
     ast:taste;
     ends:tstringlist;
     mux:word;
     avlen,tc:byte;
     voksoi:string;

    begin
    ends:=tstringlist.create;
    winfo:=tstringlist.create;
    parts:=tstringlist.create;
     assign(ofi,'vtest.csv');
     rewrite(ofi);
    ///assign(ifi,'verbsall.lst');    //rewrite(ofi);
    assign(ifi,'verbsall.lst');
    reset(ifi);
    lknum:=-1;
    lksx:='xxx';
    //writeln('<hr>LISTAA',hyphenfi('arvioida',tavus),hyphenfi('reiitt‰‰',tavus),hyphenfi('kooissa',tavus),hyphenfi('oieta',tavus));   exit;
    parts.StrictDelimiter := true;
       parts.Delimiter:= ',';
     //  for i:=1 to 4 do readln(ifi,line);; //skip rubbish
    while not eof(ifi) do
    begin
       readln(ifi,line);
       //writeln('<li>',line);
       parts.cleaR;
       parts.commatext:=line;
       if parts.count<2 then continue;
       if pos(lksx,line)<>1 then
       begin
        writeln('</ul><li>',line,' (',lksx,')');
         mux:=0;
         sims:=0;
          lknum:=lknum+1;
          stends:=',';
          lopvoks:=',';
          curlka:=ttaivlka(luokat[lknum]);
          writeln(' <b>',curlka.mids[1],'</b>',ifs(curlka.vahva,'vahva','heikko'));
          writeln('<ul>');
          //curlka.example:=parts[2];
       end;
      newid:=inttostr(lknum);
     lksx:=parts[0];//copy(parts[0],1,4);
     //ast:=getastekons(parts[0][5],av,ah);
     ast:=getastekons(parts[1][1],av,ah);
     //writeln('<LI>',LINE,PARTS.COUNT,'-',AV,AH,PARTS[1]);
     //if  length(ast.f+ast.t)<>2 then
     //    if length(ast.f+ast.t)<>4 then
     if psim<>lksx+ast.a then begin writeln('</ul><li>a::<b>',ast.f,'/',ast.t,'</b></li><ul>');sims:=0;end;
     sims:=sims+1;
     avlen:=length(ast.f+ast.t);
     psim:=lksx+ast.a;
     //if not ((ast.f='kk') or (ast.f='k')) then   continue;
      //if (sims>555) //and (parts[0]<>'73')
      //then continue;
      lopvoks:='';
     //if avlen<>1 then
     //continue;
     newid:=(parts[0]);
     mymid:=curlka.mids[1];
     voksoi:=ifs(parts[2][length(parts[2])]='a','1','2');//+parts[2][length(parts[2])];
     if pos('#',mymid)>0  then  lkon:=parts[2][length(parts[2])-1] else lkon:=''; //ad hoc. only for V067
      try
     if CURLKA.VAHVA then
     begin

         if parts[0]='52' then newid:=newid+taka(parts[2][length(parts[2])-1]);
            //lopvoks:=taka(parts[2][length(parts[2])-1]);
         color:='green';
         stem:=taka(copy(parts[2],1,length(parts[2])-length(mymid+av+'a')));
         //writeln('<li>',stem, '.',lopvoks,' ',hyphenfi(stem+lopvoks,tavus));
         if av='' then for j:=length(stem) downto length(stem)-2 do if pos(stem[j],vokaalit)<1 then begin av:=stem[j];ah:=av;delete(stem,j,1);break;end;
         xpart:=copy(parts[0],length(stem)+1);
         ///VAHVAAA
         xpart:=copy(xpart,1,length(xpart)-length(mymid)-1);
         hyphenfi(stem+lopvoks,tavus);
         //winfo.commatext:=newid+','+inttostr(length(ast.f+ast.t))+','+av+ah+','+inttostr(tavucount);
         //winfo.commatext:=newid+','+ifs(ast.f='',av,ast.f)+','+ifs(ast.f='',av,ast.t)+','+inttostr(tavus.count);
         //winfo.commatext:=newid+','+inttostr(length(ast.f+ast.t))+','+ifs(ast.t+ast.f='','_,'+av,av+','+ah)+','+inttostr(tavus.count-1);
         winfo.commatext:=newid+','+lopvoks+','+inttostr(length(ast.f+ast.t))+','+ifs(ast.t+ast.f='','_,'+av,av+','+ah)+','+voksoi+','+inttostr(tavus.count-1);
         for i:=0 to tavus.count-1  do winfo.add(tavus[i]);
         writeln(ofi,winfo.commatext);
         continue;
         form:='';
         for j:=4 to winfo.count-1  do form:=form+winfo[j];
         if (taka(parts[2])=form+av+mymid+yhtloput[1]) then color:='green' else color:='red';
         mux:=0;
         VR:=form+av+lopvoks;
         HR:=form+ah+lopvoks;
         writeln('<li style="color:',color,'">{',winfo.commatext,'} ');//,parts[2],'(<b>',lopvoks,'</b>) :',form+'.',av+'.'+mymid+'a',':',vr,':',hr);
         //if tavus.count>2 then continue;
         for i:=1 to 11 do //if pos(yhtloput[i],vokaalit)>0 then
          //if i<>9 then continue else
          if not (i in [2,4,7]) then
          begin
                //if pos(vr[length(vr)],vokaalit)>0 then if pos((curlka.mids[i]+yhtloput[i])[1],vokaalit)>0 then
                // if not isdifto(vr[length(vr)],(curlka.mids[i]+yhtloput[i])[1]) then
           writeln('<span style="color:blue"> ',//vr+'.'+curlka.mids[i]+yhtloput[i],'</span>');
           tavut(vr+curlka.mids[i]+yhtloput[i],vr+'|'+curlka.mids[i]+'|'+yhtloput[i]),'</span>');
          end
          else
           //if pos(hr[length(hr)],vokaalit)>0 then if pos((curlka.mids[i]+yhtloput[i])[1],vokaalit)>0 then
           //if not isdifto(vr[length(vr)],(curlka.mids[i]+yhtloput[i])[1]) then
              writeln('&nbsp;&nbsp; <span style="color:black">', //hr+'.'+curlka.mids[i]+yhtloput[i],'</u>');
              tavut(hr+curlka.mids[i]+yhtloput[i],hr+'|'+curlka.mids[i]+'|'+yhtloput[i]),'</span>');
                   ///HEIKOnvahvat     [2,3,6,9] vahvan heikot  [2,4,7]

   end
   else  //HEIKOT MUODOT >62
   begin
       xpart:='';
      stem:=taka(copy(parts[2],1,length(parts[2])-length(mymid+'a')));
      mymid:=curlka.mids[1];
      if parts[0]='67' then newid:=newid+parts[2][length(parts[2])-1];
      if pos(stem[length(stem)],vokaalit)>0 then
       if (isdifto(stem[length(stem)-1],stem[length(stem)])) then j:=2 else j:=1 else j:=0;
         if j=2 then if isdifto(stem[length(stem)-2],stem[length(stem)-1]) then j:=1;
       if j=2 then if length(ast.t+ast.f)=1 then  j:=1;
           //OI E TA
             //if pos(stem[length(stem)-1],vokaalit)>0 then j:=2 else j:=1 else j:=0;
      if j>0 then
      begin
              lopvoks:=copy(stem,length(stem)-j+1);
            if av='' then if pos(stem[length(stem)-j],vokaalit)<1 then begin av:=stem[length(stem)-j];ah:=av;end;
            stem:=copy(stem,1,length(stem)-length(ah)-LENgth(lopvoks));
           //if av='' then begin ah:=stem[length(stem)];av:=ah;end;// else
      end;
      hyphenfi(stem+av+lopvoks,tavus);
      //winfo.commatext:=newid+','+ast.f+','+ast.t+','+inttostr(tavus.count);
      //winfo.commatext:=newid+','+inttostr(length(ast.f+ast.t))+','+av+','+ah+','+inttostr(tavus.count);
    winfo.commatext:=newid+','+lopvoks+','+     inttostr(length(ast.f+ast.t))+','+ifs(ast.t+ast.f='','_,'+av,av+','+ah)+','+VOKSOI+','+inttostr(tavus.count-1);
    //  winfo.commatext:=newid+','+lopvoks+','+inttostr(length(ast.f+ast.t))+','+ifs(ast.t+ast.f='','_,'+av,av+','+ah)+','+inttostr(tavus.count-1);
      //     winfo.commatext:=newid+','+inttostr(length(ast.f+ast.t))+','+ifs(ast.t+ast.f='','a,'+av,av+','+ah);

      //winfo.commatext:=newid+','+ifs(ast.f='',av,ast.f)+','+ifs(ast.f='',av,ast.t)+','+inttostr(tavus.count);
      //winfo.commatext:=newid+','+inttostr(length(ast.f+ast.t))+','+av+ah+','+inttostr(tavus.count);
      for i:=0 to tavus.count-2 do winfo.add(tavus[i]);
      writeln(ofi,winfo.commatext);
      writeln('<li>',winfo.commatext,'#',parts[2],'#',tavus.commatext,' \',stem+av+'(',ast.f[length(ast.f)],'|',lopvoks,')');
      if tavus[tavus.count-1]<> ast.f[length(ast.f)]+lopvoks then write('zxc');
      continue;
      form:='';
      for i:=0 to tavus.count-2 do form:=form+tavus[i];
      //if pos(lopvoks,winfo[winfo.count-1])=length(winfo[winfo.count-1])-length(lopvoks)+1 then continue; //debu
     if (taka(parts[2])=form+ah+lopvoks+mymid+yhtloput[1]) then color:='green' else color:='red';
      //WRITELN(ofi,winfo.commatext);
      if ast.f='' then
      begin
          vr:=form+winfo[winfo.count-1];hr:=vr;
      end else
      begin
      VR:=form+av+lopvoks;
      HR:=form+ah+lopvoks;
      end;
      writeln('<li>',winfo.commatext,'#',parts[2],'#',tavus.commatext,' \',stem+av+'(',lopvoks,') =',form, ':',vr, ':',hr);
      form:='';
      for i:=length(winfo[winfo.count-1]) downto 1 do
       if pos(winfo[winfo.count-1][i],vokaalit)<1 then break else form:=winfo[winfo.count-1][i]+form;
      if lopvoks<>form then writeln('<h3>LOP:',form,'/',lopvoks,'</h3>');
     if tavus.count>2 then continue;
     //if (pos(vr[length(vr)],vokaalit)>0) and (pos(hr[length(hr)],vokaalit)>0) then continue;
      writeln('<li title="',parts[2],'" style="color:',color,'">[<b>',winfo[0],hr,'/',vr,': </b>');//winfo.commatext,'</b>] &nbsp;&nbsp;&nbsp;&nbsp; {',form+'}',ah,'<b> ',lopvoks,'</b>|',mymid,'a *'+stem);//,form+ah+lopvoks+mymid+yhtloput[1]+' /'+stem);
      for i:=1 to 11 do //if pos(yhtloput[i],vokaalit)>0 then
       //if (not isdifto(hr[length(hr)],(curlka.mids[i]+yhtloput[i])[1]) or
       begin //if (pos((curlka.mids[i]+yhtloput[i])[1],vokaalit)<1) then continue else
        if i in [2,3,6,9] then
        begin
              //if pos(vr[length(vr)],vokaalit)>0 then if pos((curlka.mids[i]+yhtloput[i])[1],vokaalit)>0 then
              // if not isdifto(vr[length(vr)],(curlka.mids[i]+yhtloput[i])[1]) then
         writeln('<span style="color:blue"> ', //vr+'.'+hyphenfi(curlka.mids[i]+yhtloput[i],tavus),'</span>');
         tavut(vr+curlka.mids[i]+yhtloput[i],vr+'|'+curlka.mids[i]+''+yhtloput[i])   ,'</span>');
         //writeln('#',hr[length(hr)],(curlka.mids[i]+yhtloput[i])[1],isdifto(hr[length(hr)],(curlka.mids[i]+yhtloput[i])[1]));
        end
        else
         //if pos(hr[length(hr)],vokaalit)>0 then if pos((curlka.mids[i]+yhtloput[i])[1],vokaalit)>0 then
         //if not isdifto(vr[length(vr)],(curlka.mids[i]+yhtloput[i])[1]) then
            writeln('&nbsp;&nbsp; <span style="color:black">',//hr+'.'+hyphenfi(curlka.mids[i]+yhtloput[i],tavus),'</u>');
            tavut(hr+curlka.mids[i]+yhtloput[i],hr+'|'+curlka.mids[i]+''+yhtloput[i]),'</span>');
         //if (not isdifto(hr[length(hr)],(curlka.mids[i]+yhtloput[i])[1])) then writeln('xxx') else writeln('yyy');
      end;
                 ///HEIKOnvahvat     [2,3,6,9] vahvan heikot  [2,4,7]

  end;
   //for i:=4 to winfo.count-2 do write('-',winfo[i]);
   {if curlka.vahva then
     begin  if (length(ast.f+ast.t) mod 2 = 0) or (ast.t='') then write('<b>!',winfo[winfo.count-1],'</b>-',ah)
       else write('-'+copy(winfo[winfo.count-1],1));
   end else    if (length(ast.f+ast.t) mod 2 = 0) or (ah='') then write('=',winfo[winfo.count-1])
       else write(av+'-'+copy(winfo[winfo.count-1],1));
   writeln('_',curlka.mids[2],'-',yhtloput[2]);
   }
  except writeln('<li style="color:',color,'"><b>!!!',stem,'/',form,j,'</b>');  end;
  end;
 closefile(ofi);closefile(ifi);
end;

procedure tstemmer.luoluokat;
var lk,mu:integer;mm:word;curlka:ttaivlka;
begin
  //curlka:=tluokka.create(i+51); //luokat.add(curlka);  //one empty to get 1-base .. no,  there is a unneeded 009-class
 writeln('luoluokat');
 writeln('<table>');
 for lk:=0 to 28 do
 begin

   curlka:=ttaivlka.create(lk+52);
   curlka.expl:=explain(lk+52);
   luokat.add(curlka);
   curlka.num:=lk;
   curlka.kotus:=lk+52;
   if lk+52<62 then curlka.vahva:=true else  curlka.vahva:=false;
   if lk+52>=76 then curlka.vahva:=true;
   //if lk+50>=71 then curlka.vahva:=true;
   //if lk+50>=71 then curlka.vahva:=true;

   if (lk+52  in [59,60,62,63,64,65,68,69,70,71,77]) then curlka.hasav:=false else curlka.hasav:=true;
   if lk+52 in [66,67,72,74,75] then curlka.hasmaft:=true else curlka.hasmaft:=false;
   mm:=0;
   writeln('<tr><td>',lk+52,'</td>');
   for mu:=1 to 12 do    //if not (mu+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
   begin      //mm:=mm+1;
     curlka.mids[mu]:=mids[lk,mu];
     writeln('<td>',curlka.mids[mu],'</td>');
   end;
   curlka.expl:=mids[lk+1,13];
   //writeln('<h2>explain ',curlka.expl,'</h2>');
  end;
 writeln('</table>');
end;
//curlka.mids[mu]:=mids[lk+1,mu];

//  2,21,22,23,24,25
constructor tsija.create(vahvalka:boolean;tpl,mu:byte);
var i:word;
begin

 num:=mu;                      //in [2,4,7]
 if (vahvalka) and (tpl in [2,4,6,8]) then vv:=false else vv:=true;
 if (not vahvalka) then if (tpl in [2,3,6,7,10]) then hv:=true else hv:=false;
 ending:=yhtlopsall[num];
 vparad:=tpl;

end;
constructor tsija.createst(str:ansistring);
var i:word;pars:tstringlist;
begin
 //1,1,v1,1,h0,a
 //2,2,v0,2,h1,n

pars:=tstringlist.create;
pars.commatext:=str;
num:=strtointdef(pars[0],3);
vparad:=strtointdef(pars[1],3);
if pars[2]='v1' then vv:=true else vv:=false;
hparad:=strtointdef(pars[3],3);
//if hparad>7 then hparad:=hparad-1;
//if vparad>7 then vparad:=vparad-1;
if pars[4]='h1' then hv:=true else hv:=false;
ending:=pars[5];
 pars.free;

end;
procedure tsija.list(s:pointer);
var i:byte;
begin
 write('<td>',num,'>',vparad,'/',hparad,'|',ending,'</td>');
 for i:=1 to luokkia-3 do
  if (i+51<63) then write('<td>'+tstemmer(s).mids[i,vparad],'|',ending,'</td>')
 else write('<td>',tstemmer(s).mids[i,hparad],'|',ending,'</td>');

end;

procedure tsija.save(u:word;s:pointer);
var i:byte;ss:tstemmer;
begin
 ss:=tstemmer(s);
 try
 write('<li>',u,',',vparad,',v',ifs(vv,'1','0'),',',hparad,',h',ifs(hv,'1','0'),',',ending);//,' [',ss.mids[0][vparad]+yhtloput[vparad],'| ',ss.mids[0][hparad],yhtloput[hparad]+']' );
//if hparad<>vparad then writeln('***');
//if vv<>hv then writeln('!!!');
  except writeln('invalid sija');end;
end;
function lastkons(st:ansistring;var posi:integer):ansistring;
var i:word;passedone:boolean;
begin

result:='?';
 for i:=length(st) downto 1 do
  if pos(st[i],konsonantit)>0 then begin posi:=i;result:=st[i]; break;end;
  if result='!' then writeln('<li>XX:',st);
end;
function lastvowel(st:ansistring;var posi:integer):ansichar;
var i:word;
begin
result:='!';
//had:=true;
 for i:=length(st) downto 1 do
  if pos(st[i],vokaalit)>0 then begin result:=st[i];posi:=i; break;end;
end;

function getsim(new,old:ansistring):string;
var i:word;
begin
  try
  //result:=new;exit;
   //write(new,'#');
   IF (OLD='') OR (NEW='') THEN begin write('?');result:=old;exit;end;
    for i:=0 to min(length(old),length(new))-1 do
     if old[length(old)-i]<>new[length(new)-i] then
     begin
      result:=copy(old,length(old)-i+1);
      //result:=result+'['+old[length(old)-i]+new[length(new)-i]+']';//,new,'_',result,luok,' ');
      exit;
     end;
     //result:=old;
    result:=copy(old,length(old)-min(length(old),length(new))-1);
    finally
    //write('<td>=',result,'\',old,'/',new,'/</td>');//,result,luok,' ');

    end;
end;
function getalku(old,new,rest:ansistring):word;
var i,cut:word;
begin
  try
  //IF (OLD='kimmo') then
   //writeln('<td><b>',old,'</b>|',new,'+',rest,'</td>');
  //result:=new;exit;
   //write(new,'#');
   //IF (OLD='') OR (NEW='') THEN begin write('?');result:=old;exit;end;
   //writeln('<td>',old,'_',new,'</td>');
    cut:=1;
    for i:=1 to min(length(old),length(new)) do
     if old[i]<>new[i] then
     begin
      break;
      //result:=copy(old,1,i-1);
      //result:=result+'['+old[length(old)-i]+new[length(new)-i]+']';//,new,'_',result,luok,' ');
      //exit;
     end else cut:=cut+1;
     //result:=old;
    result:=cut-1;//copy(old,1,cut-1);
    finally
    //write('<td>=',cut,result,'\',old,'/',new,'/</td>');//,result,luok,' ');

    end;
end;

function getaste(a:ansichar):taste;
var i,hit:byte;
begin
  hit:=16;
  //result:='';
  for i:=1 to 15 do if aste[i].a=a then hit:=i;
  if hit=16 then result:=aste[0] else result:=aste[hit];
end;

function getastekons(a:ansichar;var vva,hko:ansistring):taste;
var i,hit:byte;
begin try
  hit:=16;
  //result:='';
  for i:=1 to 15 do if aste[i].a=a then hit:=i;
  //WRITELN(':',A,'|',HIT,';');
  if hit=16 then result:=aste[0] else result:=aste[hit];
  if result.t='-' then result.t:='';
  hko:=result.t;vva:=result.f;
  if result.f='' then exit;
  if length(result.f)=2 then
  begin
    vva:=result.f[2];
    if length(result.t)=2 then hko:=result.t[2]  // 2/2 tapauksissa eka kons aina sama (ng/mm, mp,mm,..)
    else hko:='';  // 2-1 tapauksissa eka kons aina sama (kk/k, pp,p,..)
    exit;
  end;{ else if length(result.f)=1 then //always true at this point
  begin
    if length(result.t)=heikko:='';

  end; }
  except writeln('<tr><td><em>GETASTE (',a,'/',vva,'/',hko,')</em></td></tr>');end;
end;

procedure tstemmer.findendings;
 var i,j,k,m,times:word;st:ansistring;
 ends: array[0..80] of array[1..32] of ansistring;//tstringlist;
  len:byte;xe,xf:ansistring;
begin
//endings:=tstringlist.create;
  readline;
  writeln('didread‰');
  for i:=2 to forms.count-1 do //pes‰muna.. k‰‰nteinen j‰rjestys
  begin
     len:=length(forms[i]);
      //write(i,forms[i],len);
      for j:=1 to 32 do if len<j then break else
      begin
      // write(j,'#');
       ends[i][j]:=forms[i][len-j+1];
      end;
      writeln('  *',i);
      for k:=12 downto 1  do write('-',ends[i][k]);
  end;
  times:=0;
  write('<li>f1<table border="1">');//,forms[1]);
  while not eof do
  begin
      try
      TRY
       forms.clear;
       readline;
       //if times>200 then break;
       if eof then break;
       IF COPY(forms[0],3,2)='77' then break;
       times:=times+1;
      writeln('<tr><td>',forms[1],'</td>');EXCEPT WRITELN('<TR><TD>FAILEDREAD?',FORMS.COUNT,'</TD>');END;
      for i:=2 to forms.count-1 do
      begin
        writeln('<td>');
        forms[i]:=taka(forms[i]);
        len:=length(forms[i]);
         if pos('#',forms[i])<1 then
        for j:=1 to min(32,len) do if ends[i][j]=#0 then begin break end else if forms[i][len-j+1]<>ends[i][j] then
        begin ends[i][j]:=#0;write('!',len-j);//write(j,ends[i][j-1],' |',copy(forms[i],len-j+1),j+1,':');
          //for k:=1 to 8 do write(k,ends[i][k]);
          break;
        end;// else
        for k:=1 to 32 do if ends[i,k]=#0 then break else
        write(ends[i][k]);
        //write(ends[i,j],',',forms[i][len-j+1],' ');
        writeln('</td>');
      end;
      writeln('<td>did</td></tr>');except  writeln('</td><td>DidNOT</td></tr>')end;
  end;
  writeln('</table><hr><h1>DID<h1>');
  for i:=2 to muotoja do
  begin
     st:='';
    for j:=1 to 12 do
      if ends[i,j]=#0 then break else st:=ends[i,j]+st;
    write('''',st,''',');
  end;
end;
procedure td(st,ats:ansistring);
begin writeln('<td '+ats,'>',st,'</td>');
end;
procedure tstemmer.purasanat;
var  ast:taste;mu,lu,lknum:word; prevtunnus,lktunnus:ansistring;
begin
  prevtunnus:='0';lknum:=0;
  WRITELN('<table>');
 while not eof do
 begin
    forms.clear;readline;
    if eof tHen breAK;
    lktunnus:=copy(forms[0],3,2);
    if lktunnus<>prevtunnus then
    begin
      WRITELN('</table>');
     prevtunnus:=lktunnus;lknum:=lknum+1;
     writeln('<li>',lktunnus,'(',lknum,')');
      WRITELN('<table>');

    end;
     ast:=getaste(forms[0][5]);
     writeln('<tr><td>',ast.f,'.',ast.t,'</td>');
     for mu:=1 to 5 do
     writeln('<td>',forms[mu],'+',yhtlopsall[lknum,mu],'</td>');
     writeln('</tr>');
     //exit;
  end;

end;
const perussijat =   [1,2,4,09,11,17,18,27,54,63,70,78];
     // if not (i in [1,2,4,09,11,17,18,27,54,63,70,78]) then continue;// else


procedure tstemmer.newmids;
var i,j,a,lu,mu,mux,hits,elen:word;
 stl,all:tstringlist;yhtalku:ansistring;
 stpl,splex:ansistring;
 esims:tstringlist;
 es:array[1..50] of tstringlist;
begin
  esims:=tstringlist.create;
  esims.loadfromfile('verbesim.csv');
  for i:=0 to esims.count-1 do
  begin
     es[i]:=tstringlist.create;
     es[i].commatext:=esims[i];
     //writeln('<li>ESIMERKS:',es[i].commatext);
  end;
  all:=tstringlist.create;
  writeln('<h1>endingx</h1><hr>');
  all.loadfromfile('vmids2.csv');
  //writeln(all.commatext);
  //!all.loadfromfile('vmids.csv');
  //all.delete(all.count-1);
  stl:=tstringlist.create;
  for lu:=0 to all.count-1 do
  begin
     //writeln('<li>X',lu,' ',stl.count,':');
     stl.clear;
     stl.commatext:=all[lu];
     mux:=0;
     write('<li>WW',stl[0]);
    for mu:=1 to stl.count-1 do
    begin
       try
        mids[lu,mu]:=stl[Mu];
        write(',!',mids[lu,mu]);//,' -['+yhtlopsall[mu-1],'] =',copy(mids[lu,mu],1,length(mids[lu,mu])-length(yhtlopsall[mu-1])));
       except end;
    end;
  end;
  writeln('<table border="1">');
  for i:=0 to all.count-1 do
  begin
   writeln('<tr><td>',i,'</td>');
   for j:=0 to 12 do
   begin
     writeln('<td>',j,' ',es[i][j],' <b>',mids[i,j],'</b>',yhtloput[j],'</td>');
   end;
   writeln('</tr>');
  end;
  writeln('</table>didmids');
end;
procedure tstemmer.readmids;
var i,j,a,lu,mu,mux,hits,elen:word;
 stl,all:tstringlist;yhtalku:ansistring;
 stpl,splex:ansistring;
 esims:tstringlist;
 es:array[1..50] of tstringlist;
begin
  esims:=tstringlist.create;
  esims.loadfromfile('verbesim.csv');
  for i:=0 to esims.count-1 do
  begin
     es[i]:=tstringlist.create;
     es[i].commatext:=esims[i];
     //writeln('<li>ESIMERKS:',es[i].commatext);

  end;

   writeln('<h1>READmids</h1>');
   stl:=tstringlist.create;
   all:=tstringlist.create;
   //all.loadfromfile('verbmids2.csv');
   all.loadfromfile('vmidosa.lst');
   //all.delete(all.count-1);
   writeln('<h1>endings</h1><hr>');
  for lu:=0 to all.count-3 do
  begin
     stl.clear;
     stl.commatext:=all[lu];
     //writeln('<li>X',lu,' ',stl.commatext);
     mux:=0;
     write('<li>',stl[0]);
    for mu:=1 to stl.count-1 do
    begin
       try
        if mu=7 then if lu<>2 then continue;
        mux:=mux+1;
        mids[lu,mux]:=stl[Mu];
        write(',',mids[lu,mux]);//,' -['+yhtlopsall[mu-1],'] =',copy(mids[lu,mu],1,length(mids[lu,mu])-length(yhtlopsall[mu-1])));
       except end;
    end;
  end;
  writeln('<hr>');
  writeln('SOOOOOOOFAAARINHOUSU<ul><LI>');
  //exit;
  mux:=0;
  for mu:=1 to 78 do
  begin
     if (mu in perussijat) then begin mux:=mux+1;writeln('<li><b>',mux,yhtloput[mux],'</b>/',mu,yhtlopsall[mu],'/');end else
   writeln(mu,yhtlopsall[mu],' ');
   end;
  writeln('</ul><li>',yhtloput[12],'<table border="1"><tr><td>x</td>');
  mux:=0;
  for mu:=1 to 78 do
    //if not (mu+1 in [2,3,5,10,12,15,18,19,28,55,64,71]) then continue else
    //if not ( (mu in [1,2,4,09,11,17,18,27,54,63,70,78])) then continue  else
    //if not (mu in   [1,2,4, 9,11,17,18,27,54,63,70]) then continue else
    //if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue;// else
    //if not ( (mu in [1,2,4,09,11,17,18,27,54,63,70,78])) then continue  else
    //if not ( (mu in [1,2,4,09,11,17,18,27,54,63,70,78])) then continue  else
    if not ( mu in perussijat) then continue  else
  begin
   mux:=mux+1;
   write('<td>',mu,yhtlopsall[mu],'|',mux,yhtloput[mux],'</td>');
  end;
  mux:=0;
  write('</tr><tr><td>y</td>');
  for mu:=1 to 78 do
    //if not (mu+1 in [2,3,5,10,12,15,18,19,28,55,64,71]) then continue else
  //if not (mu+1 in     [2,3,5,10,12,13,18,19,28,55,64,71]) then continue else
    //if not (mu in     [1,2,4, 9, 11,17,18,27,54,63,70]) then continue else
    //if not ( (mu in [1,2,4,09,11,17,18,27,54,63,70,78])) then continue else
    if not ( (mu in perussijat)) then continue else
  begin
   mux:=mux+1;
   write('<td>',mu,yhtlopsall[mu],'|x',mux,yhtloput[mux],'</td>');
  end;
  write('</tr>');
  for lu:=3 to luokkia-1  do
  begin
    yhtalku:=mids[lu,1];
    //for mu:=1 to muotoja do if mids[lu,mu]);
    writeln('<tr><td style="border-top:3px solid black">{',lu+49,'-',lu-2,'}',exples[lu],'</td>');//<td>',ttaivlka(luokat[lu]).example,'</td>');
    for mu:=1 to 12 do //muotoja do
       //if (mu=1) and (mids[lu,1]=mids[lu,2]) then writeln('<td>',mids[lu,mu],'=</td>') else
       writeln('<td  style="border-top:3px solid black">',mu,mids[lu,mu],'|',yhtloput[mu],'</td>');
    writeln('</tr>');
    writeln('<tr><td></td>');//<td>',ttaivlka(luokat[lu]).example,'</td>');
    for mu:=1 to 11 do //muotoja do
    begin   //if (mu=1) and (mids[lu,1]=mids[lu,2]) then writeln('<td>',mids[lu,mu],'=</td>') else
     elen:=length(mids[lu,mu]+yhtloput[mu]);
     splex:=copy(es[lu-2][mu],1, length(es[lu-2][mu])-elen)
       +'<b>'+copy(es[lu-2][mu],length(es[lu-2][mu])-elen+1)+'</b>';
       writeln('<td>',splex,'</td>');
    end;
    writeln('</tr>');
  end;
  //for i:=1 to 12 do write
  writeln('</table><h1>Koocs</h1>');
  try for a:=1 to 2 do
  begin
     writeln('<table border="',a,'">');
    for i:=1 to 12 do
    begin
     writeln('<tr><td>',i,'</td>');
     try
     for j:=1 to 12 do
     begin
      hits:=0;
      for lu:=3 to luokkia-1 do
        if ((lu+50<=62) or (lu+50>76) or (lu+50=71))=(a=1) then
        if mids[lu,i]= mids[lu,j] then hits:=hits+1;
      if i<>j then writeln('<td>',hits,'</td>') else writeln('<td><b>',hits,'</b></td>');
     end;
     except writeln('<td>err</td>');end;
     writeln('</tr>');
    end;
    writeln('</table><hr/>');
  end;
  except writeln('<td>err</td>');end;
//  stl.free;
  writeln('dddddddddddddddd<hr/>');

end;
function endpos(needle,stack:ansistring):integer;
var i,posi:integer;
begin
 // result:=pos(needle,stack);exit;
  result:=-1;
 // writeln('<li>endpos:',needle,' ',stack);
 // while pos(needle,stack)>0 do
 repeat
    posi:=pos(needle,stack);
    //writeln('#',posi,'/',result);
    if posi<1 then break;
    result:=posi+result;
    stack:=copy(stack,posi+length(needle));
 until false;
 result:=result+length(needle);
end;
procedure tstemmer.writemids;
var lu,mu:word;stl:tstringlist;
begin
   writeln('<h1>savemids</h1>');

  stl:=tstringlist.create;
  for lu:=1 to luokkia do
  begin
     stl.add(inttostr(lu+51));
    for mu:=2 to muotoja do
    begin
       try
        stl[stl.count-1]:=stl[stl.count-1]+','+copy(mids[lu,mu],1,length(mids[lu,mu])-length(yhtlopsall[mu-1]));
        //writeln('<li>',lu,':',mu,':',mids[lu,mu],' -['+yhtlopsall[mu-1],'] =',copy(mids[lu,mu],1,length(mids[lu,mu])-length(yhtlopsall[mu-1])));
       except end;

    end;
  end;
  stl.savetofile('verbmids.csv');
  writeln('<pre>');
  for lu:=1 to luokkia do try writeln(stl[lu]);except end;
  writeln('</pre>DIDSAVE');
  stl.free;
end;

procedure ttaivlka.list;
var i,mu:INTEGER;color,bkg,av,x:ansistring;
begin
  writeln('<li>',kotus,'  #',LVOKS.COUNT,lvoks.commatext,'<ul>');
  for i:=0 to lvoks.count-1 do
         t_lopvok(lvoks.objects[i]).list;
  writeln('</ul>');exit;
  if hasav then color:='#007' else color:='#700';
  if hasmaft then bkg:='#ffa' else bkg:='#aaf';
  if hasmaft then bkg:='#ffa' else bkg:='#aaf';
  writeln('<tr  title="',expl,'" style="background:',bkg,';color:',color,'">');
  writeln('<td><b>',num,'/',kotus,':',ifs(hasav,'A',''),ifs(hasmaft,'X',''),'</td><td>',mids[1],'/',midsbef[3],'</td><td>',midsaft[1] ,'</td><td>',example,'</b>','</b></td><td>''','<small> ',expl, '</small></td><td>');//,'</td></tr><tr>');//<td colspan="3"><small>beforeav:');
  for mu:=1 to 12 do
  begin
    //writeln(' ',midsbef[mu],':',midsaft[mu],' ');
    writeln('<td>',mu,mids[mu],'</td> ');
  end;
  writeln('</small></td></tr>');
end;

procedure tstemmer.listluokat;
var lu:word;lka:ttaivlka;
begin
writeln('<table border="1">');
for lu:=1 to 27 do
    ttaivlka(luokat[lu]).list;
    writeln('</table>');
end;
function etutaka(st:ansistring):word;
var i:word;
begin
 //verbeille t‰‰‰ onkin helppo katsoa perusmuodon vikaa kirjainta a tai ‰, ei tartte tehd‰ funktiota
 result:=0;
 if st[length(st)]='a' then
 //for i:=1 to length(st) do if pos(st[i],'aou')>0 then begin result:='T';end;

end;
procedure tstemmer.dovahva(inf,av,ah:ansistring;lka:pointer);
 var i,j,mu,lu,smu:integer;p1,stem,me,myalku,mymid,mylop,color,lopvok,lopkon,newid:ansistring;curlka:ttaivlka;
 begin
   //for mu:=1 to 12 do
   //if av='' then begin av:=lopvok;ah:=lopvok; end;  //temp... vain vahvoille
   curlka:=ttaivlka(lka);
   //if lka=13 then begin ah:='';end;
   smu:=0;
     //if curlka.kotus=52,61 then lopvok:=taka(copy(inf,length(inf)-1,1));
     mymid:=curlka.mids[1];
   if pos('*',mymid)>0 then
   begin lopvok:=taka(copy(inf,length(inf)-length(mymid),1));
     mymid:=stringreplace(mymid,'*',lopvok,[rfReplaceAll]);
   end
   else lopvok:='';

     //lopvok:=copy(inf,length(inf)-length(curlka.mids[1])-1,1);
     //if pos(lopvok,vokaalit)<1 then lopvok:='';
     //if curlka.kotus=52 then newid:=newid+lopvok;
     stem:=taka(copy(inf,1,length(inf)-1-length(av)-length(mymid)));
     //while pos(stem[length(stem)],vokaalit)
    if av='' then if ah='' then
    if pos(stem[length(stem)], vokaalit)<1 then
    writeln('<h1>KLOP</h1>') else
    writeln('<h1>VLOP</h1>');
     writeln('<li>',stem,'');
     //if (av<>'') and (ah='') then for i:=1 to 1 do
     //stem:=taka(copy(inf,1,length(inf)-length(av+curlka.mids[1])-1));
     //if av='' then begin av:=copy(inf,length(inf)-2,1);ah:=av;end;  //EI TOIMI PITƒƒ ETSIƒ KONSONANTTI
     //if av<>'' then if ah='' then begin av:=copy(inf,LENGTH(STEM)+1,1);{if pos(av,vokaalit)>0 then} av:=copy(inf,LENGTH(STEM),1);ah:=av;delete(stem,length(stem),1);
     //end;  //EI TOIMI PITƒƒ ETSIƒ KONSONANTTI
     lopkon:='';
     //if (pos(inf[length(stem)],vokaalit)<1 ) and (pos(stem[length(stem)-1],vokaalit)<1 )then
     //if //(av='') then //and (pos(stem[length(stem)],vokaalit)<1 ) then //and (pos(stem[length(stem)-1],vokaalit)<1 )then
     {if av<>'' then if ah='' then lopkon:=
     begin
      color:='green';
      lopkon:=stem[length(stem)];delete(stem,length(stem),1);
     end else  color:='red';}
     //p1:=stem;
     //if length(av)>length(ah) then delete(p1,length(p1),1);
     //p1:=p1+ah+curlka.mids[2]+'n';
     if (stem+lopkon+av+mymid+'a'=taka(inf))  then color:='green' else  color:='red';
     //if color='red' then
     writeln(ifs(color='red','xxx',''), inf,'[',av,'/',ah,']',curlka.kotus,'!',length(inf),length(stem),' ');
     //if color='red' then
     writeln('<b style="color:',color,';margin-left:3em">',curlka.kotus,',',ifs(inf[length(inf)]='a','T','E'),',',stem,',|<b>',lopkon,'|</b>',av,',',ah,',',lopvok,'</b> ',p1);

 end;


procedure tstemmer.doheikko(inf,av,ah:ansistring;lka:pointer);
 var mu,lu,smu:integer;stem,me,myalku,mymid,mylop,color,lopvok,lopkon,newid:ansistring;curlka:ttaivlka;
 begin
   lopvok:='';
   curlka:=ttaivlka(lka);
   writeln('<li>H:',inf,'[',av,'/',ah,']',curlka.kotus,curlka.mids[1],'!');
   //  if pos(curlka.mids[1][1],vokaalit)<1 then
   //begin lopvok:=copy(forms[1],length(forms[1])-length(curlka.mids[1])-2,2);
   //  if pos(lopvok[1],vokaalit)<1 then delete(lopvok,1,1)
   //  else if ah='' then  delete(lopvok,1,1)
   mymid:=curlka.mids[1];
   if pos('#',mymid)>0 then
   begin lopkon:=inf[length(inf)-1];
     mymid:=stringreplace(mymid,'#',lopkon,[rfReplaceAll]);
   end
 else lopvok:='';
   if pos(mymid[1],vokaalit)<1 then
   begin
    lopvok:=taka(copy(inf,length(inf)-length(curlka.mids[1])-2,2));
    //writeln('<b>@',lopvok,'</b>|');
     if pos(lopvok[1],vokaalit)<1 then   delete(lopvok,1,1)
     else if ah='' then if pos(lopvok[2],vokaalit)<1 then
     delete(lopvok,2,1);
     //writeln('<b>-',lopvok,'</b>|');
     //writeln('<b>--',lopvok,'</b>|');
   end;
   stem:=taka(copy(inf,1,length(inf)-length(lopvok+ah+mymid)-1));
   //if stem+ah+lopvok+mymid+'a'=taka(inf) then color:='green' else  color:='red';
   if (pos(stem[length(stem)],vokaalit)<1 ) and (pos(stem[length(stem)-1],vokaalit)<1 )then color:='green' else  color:='red';
   //if color='red' then
   //if lka=13 then begin ah:='';end;
   smu:=0;
   //  stem:=taka(copy(inf,1,length(inf)-length(av+curlka.mids[1])-1));
        writeln('<b style="color:',color,';margin-left:3em">',ifs(color='red','xxx',''),
          curlka.kotus,',',ifs(inf[length(inf)]='a','T','E'),',',stem,',',av,',',ah,',',lopvok,'|'+mymid+'a</b>');

end;
{
if pos(curlka.mids[1][1],vokaalit)<1 then begin lopvok:=copy(forms[1],length(forms[1])-length(curlka.mids[1])-2,2);
if pos(lopvok[1],vokaalit)<1 then delete(lopvok,1,1)
else if ah='' then  delete(lopvok,1,1)
end;
if nkot=67 then newid:=newid+copy(forms[1],length(forms[1])-1,1)+'!';
mystem:=taka(copy(forms[1],1,length(forms[1])-length(lopvok+ah+curlka.mids[1])-1));
if mystem<>stem then writeln('<li>!!!',forms[1],' ',stem,' ',ah,'/ ',mystem,' |',ah+'(',lopvok+')'+curlka.mids[1],' ')
 else  writeln('<li>===',forms[1],' ',stem,'|',ah,'|',lopvok,'|',curlka.mids[1],'a ',' ?',ah,' ',lopvok,' ');//,length(av+curlka.mids[1])+1,' ');

procedure tstemmer.doheikko(f:tstringlist);
 var mu,lu,smu:integer;mylop,mymid,myalk,mystem,kkk,color:ansistring;
 begin
   //for mu:=1 to 12 do
  smu:=0;
   for mu:=1 to 72 do
     //if not (mu+1 in [2,3,5,10,12,13,18,19,28,55,64,71]) then continue else
     begin
      smu:=mu;
      //smu:=smu+1;
      si:=tsija(sijat[smu]);
      mystem:=stem;
      mymid:=stringreplace(curlka.mids[si.hparad],'*' ,alopv,[rfReplaceAll]);  // --o
        //if lknum=14 then mymid:=stringreplace(curlka.mids[si.vparad],'*' ,alopv,[rfReplaceAll]);
     //mymid:=mids[lknum+1,smu];
     if tsija(sijat[mu]).hv then kkk:=av else kkk:=ah;
     myALK:=stem+kkk;//+lopvok;  //lu++o
     //if pos('*',mymid)>0
     //mymid:=stringreplace(mymid,'*',lopvok,[rfReplaceAll]);
     mymid:=stringreplace(mymid,'#',lopkon,[rfReplaceAll]);
     while pos('-',mymid)>0 do begin delete(mymid,1,1);delete(myalk,length(myalk),1);writeln(' X',mymid,'/',myalk);end; //luo ->lu ->l
     myalk:=myalk+lopvok+mymid+yhtlopsall[mu];   //l+'o+imme
     //if (lknum=13) or                          cd
     if (taka(f[mu+1])<>myalk)
     then color:='red' else color:='black';
     if pos('/',f[mu+1])>0 then color:='green';
     writeln(' ',smu,'/',si.hparad,f[mu+1],'=<em  style="color:',color,'">',myalk,' </em>(',stem,'|',kkk,'|',lopvok,'|',mymid,'|',yhtlopsall[mu],') ');end;
                                               //    loimme=                limme        (  lu    |       |   o      |--*                       |  imme)
       //lu
   //writeln(' ',stem,'(',lopvok,')',av,ah,'!<b>',mids[lknum,mu],'</b>|',yhtloput[mu]);
 end;
 }
procedure tstemmer.stemmaa;
        vAR winfo,parts:tstringlist;ofi,ifi:textfile;
         curlka:ttaivlka;
         lknum:integer;
         line,av,ah,lksx,stends,lopvoks,psim,newid,mymid,xpart,lkon,sharedb,stem,form,color,paddedform,thisav,pilkottu,sv,sh,mv,mh,myvai:ansistring;
         i,j,k,sims:integer;
         ast:taste;
         ends:tstringlist;
         mux:word;
         avlen:byte;
        begin
        ends:=tstringlist.create;
        writeln(hyphenfi('strategia',ends),' ', ends.commatext);exit;
        winfo:=tstringlist.create;
        parts:=tstringlist.create;
         assign(ofi,'vtest.csv');
         rewrite(ofi);
        ///assign(ifi,'verbsall.lst');    //rewrite(ofi);
        assign(ifi,'sanatansi.lst');
        reset(ifi);
        lknum:=-1;
        lksx:='xxx';
        writeln('<hr>STEMMAA');
        parts.StrictDelimiter := true;
           parts.Delimiter:= ',';
           for i:=1 to 4 do readln(ifi,line);; //skip rubbish
        while not eof(ifi) do
        begin
           readln(ifi,line);
           parts.clear;
           parts.delimitedtext:=line;
           //writeln('<li>',parts.count);
           if parts.count<2 then continue;
           if pos(lksx,line)<>1 then
           begin
             mux:=0;
             sims:=0;
             writeln('</table><li>yhtlops:',lksx,'/',ends.count,'</li>');
             if curlka<>nil then
             begin
             try
             //write(ofi,lksx);//,',',curlka.example);
              if ends.count>1299 then for i:=0 to ends.count-1 do
              begin
                if not (i+1 in  [1,2,4,09,11,17,18,27,54,63,70,78]) then continue else
                begin
                   //write(ofi,',',copy(ends[i],1,length(ends[i])-length(yhtlopsall[i+1])));
                   mux:=mux+1;
                   if copy(ends[i],1,length(ends[i])-length(yhtlopsall[i+1]))+yhtlopsall[i+1]=
                   curlka.mids[mux]+yhtloput[mux] then color:='green' else color:='red';
                   writeln('<li style="color:',color,'">',ends[i],' <b>'
                   ,copy(ends[i],1,length(ends[i])-length(yhtlopsall[i+1])),'</b>',yhtlopsall[i+1],
                   ' <b>',curlka.mids[mux], '</b>',yhtloput[mux],'</li>');

                 end;
              end;
              //writeln(ofi,',',curlka.expl);
              except writeln('<li>nilluokka');end;
              end;
              lknum:=lknum+1;
              //if lknum>=luokat.count then exit;
              //writeln('<li>runkoj‰m‰t:',stends);
              //writeln('<li>lopvoks:',lopvoks);
              stends:=',';
              lopvoks:=',';
              curlka:=ttaivlka(luokat[lknum]);
              //curlka.example:=parts[2];
              writeln('</ul><div style="background:#ddd"><h4>###',parts[0],' ',parts[1],' @',lknum,' ',ifs(curlka.vahva,'vahva','heikko'),ifs(curlka.hasav,' ','Ei-AV'),'</h4><ul><li>');
             //writeln('<h3>',parts[0],lks,'|',lknum,'/kot:',curlka.kotus,'  1:',parts.count,'</h3>');//,curlka.mids[1]);//,' <li><b>',curlka.expl,'</b></li>');
              //if lks='V065' then     for i:=1 to 12 do curlka.mids[i]:=copy(curlka.mids[i],3);
               writeln('<table border="1"><tr>');
                 for i:=1 to parts.count do  if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
                 writeln('<td>',i,'/',yhtlopsall[i],'</td>');
                 writeln('</tr><tr>');
                   for i:=1 to 12 do    //if not (mu+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
                 writeln('<td>',i,'/',curlka.mids[i],'|',yhtloput[i],' </td> ');
                 writeln('</tr></table></div>');

                   ends.clear;
                   for i:=2 to parts.count-1 do ends.add(taka(parts[i]));
              writeln('<table border="1">');
           end;
         lksx:=copy(parts[0],1,4);
         ast:=getastekons(parts[0][5],av,ah);
         sims:=sims+1;
         avlen:=length(ast.f+ast.t);
         //write('%',psim,'/',sims,' ');
         //if av<>'' then continue;

       //***************
        //if  length(ast.f+ast.t)<>1 then continue;
        //if  length(ast.f+ast.t)<>4 then continue;
         //if (av='') or (ah<>'') then
         if (lksx+ast.a<>psim) then  sims:=0 else if sims>3 then begin if sims<3 then writeln('>');continue;end;
         psim:=lksx+ast.a;
         parts.delete(0);
         parts.delete(0);
         //writeln(parts.commatext);
         ends.clear; //cheating, ends should be forms
         for i:=1 to parts.count do  if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
           ends.add(parts[i]);

         newid:=(parts[0]);
         mymid:=curlka.mids[1];
         if pos('#',mymid)>0  then  lkon:=parts[2][length(parts[2])-1] else lkon:=''; //ad hoc. only for V067
         //writeln(parts[0]);
         //if lks='V067' then  writeln('<li>',parts[0]);
          try

         //write('---> ', stem,'<b>',mymid,'</b>',curlka.mids[1],'_a');
         if curlka.vahva then
         begin
            // - - --> stem loppukons toimii kuten pv td (mutta sama kuin vaihdokin alkuk) LYP -S* ja vaihtelu s/s
            // k/- lis‰t‰‰n vaihtariin, poistetaan heikoissa
           //  pv,td -> vaihdokkiin vahva alkuun, vaihdetaan heikoissa heikkoon
            // kk/k , pp/p ttt ->  runkoon vahva loppuun, poistetaan heikoissa
            //nk/ng, lt/ll,mp/mm -> vaihdokkiin vahva alkuun, vaihdetaan heikkoon heikoissa
            //TALLETETTAVAA: AV-PITUUS/tyyppi, AV-KONSONANTTI (vain yksi. vaihtelemattomissa rungon vika on av-konsonantti)
            //  LOPUUVOkAAli erikseen talteen - vaiko sen mukaan sortaten/indeksoiden
            //  vaihtelemaattomissa tarvitaan myˆs kons, silloin se on vaihtaritavun eka (eik‰ tallettuisi muuten kun k‰ytet‰‰n tavu-talletusta)
             //if ah='' then begin av:=end:
            //tyypit/pittuden mukaan:
               //0:ei vaihtelua: lis‰t‰‰n vaihtariin aina sama loppukons joka talletettu erikseen (4 bit)
               //1 (vain k/) lis‰‰‰n vaihtariin
               //2: p/v,t/d, k/j, k/v - vaihto vaihtarin alussa - vaatii kukin omat tyyppins‰, muuten kummatkin kons ei talletu mihink‰‰n
               //3: kk/k , pp/p ttt - tallettuneena rungon lopussa
               //4   G ( nk : ng )  H ( mp : mm )  I ( lt : ll )  J ( nt : nn )  K ( rt : rr ) kun ekat kirj unohdetaan, toimii kuten 2)
             lopvoks:='';
             color:='green';
             if av<>'' then color:='blue';
             if ah<>'' then   color:='black';
             if length(ast.f)=2 then color:='purple';
             stem:=taka(copy(parts[0],1,length(parts[0])-length(mymid+av+'a')));
             if av='' then for j:=length(stem) downto length(stem)-2 do if pos(stem[j],vokaalit)<1 then begin av:=stem[j];ah:=av;delete(stem,j,1);break;end;
             xpart:=copy(parts[0],length(stem)+1);
             ///VAHVAAA
             xpart:=copy(xpart,1,length(xpart)-length(mymid)-1);
             hyphenfi(stem+lopvoks,tavus);
             winfo.commatext:=inttostr(curlka.kotus)+','+inttostr(length(ast.f+ast.t))+','+av+','+inttostr(tavucount);
             //if taka(parts[0])=taka(stem+av+mymid+'a') then color:='green' else color:='red';
             writeln('<tr><td style="color:',color,'"> ',parts[0],' ',stem,' <b>',lopvoks,' </b>',ast.f,ast.t,'</td><td>',winfo.commatext,'</td>');//,'  <span>',' [',ast.f,'\'+ifs(ast.t='',' ',ast.t),']  ',parts[0]);
             //for i:=tavus.count-1 downto 0 do winfo.add(tavus[i]);
             for i:=0 to tavus.count-1  do winfo.add(tavus[i]);
             writeln(ofi,winfo.commatext);
             //write('<li  style="color:',color,'"> ',sims,' ', stem,'|'+av+'|<b>',mymid,'</b>|a','   :',taka(stem+av+mymid+'a'),' ',taka(parts[0]),' /',mymid,' [',av,ah,']  </li>');
             mux:=0;
            for i:=1 to  min(72,parts.count-1) do if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
            begin
            ///VAHVASIJAT
             mux:=mux+1;
             myvai:=tavus[tavus.count-1]+ifs(mux in [2,4,7],ah,av);//ifs(mux in [2,4,7],mv,mh);
             mymid:=curlka.mids[mux];
             while pos('-',mymid)=1 do begin delete(mymid,1,1);delete(myvai,length(myvai),1);writeln('<td>!-</td>');end;
             form:='';
             for j:=4 to winfo.count-2  do form:=form+winfo[j];
             begin
             color:=ifs(taka(parts[i-1])=form+myvai+{ifs(mux in [2,4,7],ah,av)+}mymid+yhtloput[mux],'green','red');
             writeln('<td style="color:',color,'">','[',form,']',myvai,'.',',',mymid
             ,yhtloput[mux],ifs(color='red',' '+parts[i-1],''),'</td>');
             end;
            end;
             {   case avlen of
                   //0: begin for j:=4 to strtointdef(winfo[3],0) to tavus.count-2 do form:=form+tavus[j];
                 0: begin
                 writeln('<td>',winfo[3],'[',form,']',tavus[tavus.count-1],'.',av,',',curlka.mids[mux]
                 ,yhtloput[mux],'</td>');
                 //writeln('<td>',form,'.',tavus[tavus.count-1],'.',av,',',curlka.mids[mux]
                 //,yhtloput[mux],'</td>');
                 end;
                 1: begin
                 color:=ifs(taka(parts[i-1])=form+tavus[tavus.count-1]+ifs(mux in [2,4,7],ah,av)+curlka.mids[mux]+yhtloput[mux],'green','red');
                 writeln('<td style="color:',color,'">','[',form,']',tavus[tavus.count-1],'.',ifs(mux in [2,4,7],ah,av),',',curlka.mids[mux]
                 ,yhtloput[mux],ifs(color='red',' '+parts[i-1],''),'</td>');
                 end;
                 2: begin
                  color:=ifs(taka(parts[i-1])=form+tavus[tavus.count-1]+ifs(mux in [2,4,7],ah,av)+curlka.mids[mux]+yhtloput[mux],'green','red');
                  writeln('<td style="color:',color,'">[',form,']',tavus[tavus.count-1],'.',ifs(mux in [2,4,7],ah,av),',',curlka.mids[mux]
                  ,yhtloput[mux],ifs(color='red',' '+parts[i-1],''),'</td>');
                 end;
                 3: begin
                  color:=ifs(taka(parts[i-1])=form+tavus[tavus.count-1]+ifs(mux in [2,4,7],ah,av)+curlka.mids[mux]+yhtloput[mux],'green','red');
                  writeln('<td style="color:',color,'">[',form,']',tavus[tavus.count-1],'.',ifs(mux in [2,4,7],ah,av),',',curlka.mids[mux]
                  ,yhtloput[mux],ifs(color='red',' '+parts[i-1],''),'</td>');
                 end;
                 4: begin
                  color:=ifs(taka(parts[i-1])=form+tavus[tavus.count-1]+ifs(mux in [2,4,7],ah,av)+curlka.mids[mux]+yhtloput[mux],'green','red');
                  writeln('<td style="color:',color,'">[',form,']',tavus[tavus.count-1],'.',ifs(mux in [2,4,7],ah,av),',',curlka.mids[mux]
                  ,yhtloput[mux],ifs(color='red',' '+parts[i-1],''),'</td>');
                 end;
                end;}
            write('</tr>');continue;
             writeln('</tr><tr><td style="color:',color,'"> ',winfo.commatext,'</td>');//,'  <span>',' [',ast.f,'\'+ifs(ast.t='',' ',ast.t),']  ',parts[0]);
             mux:=0;
            for i:=1 to  min(12,parts.count-1) do if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
            begin
            ///VAHVASIJAT
             mux:=mux+1;
              if pos('/',parts[i-1])>0 then parts[i-1]:=trim(copy(parts[i-1],1,pos('/',parts[i-1])-1));
              thisav:=ifs(mux in [2,4,7],ah,av);
              pilkottu:=stem+'|'+thisav+'|'+lopvoks+'|'+curlka.mids[mux]+'|'+yhtloput[mux];
              if taka(stem+thisav+lopvoks+taka(curlka.mids[mux]+yhtloput[mux]))=taka(parts[i-1]) then color:='#fff' else  color:='yellow';
              if pos('/',parts[i-1])>0 then color:='blue';
              //taka(parts[i-1])=taka(stem+ifs(not (mux in [2,4,7]),ah,av);
              //writeln('<td>',stem, '!</td>');//, pilkottu,'_',parts[i-1],'#</td>');
              writeln('<td style="background:',color,'"> ',' ');//,parts[i-1],' ');//stem+'['+thisav+']'+lopvoks+'|'+curlka.mids[mux]+'<u>',yhtloput[mux]+'</u>:');
              //if color<>'green' then
              writeln('',tavut(parts[i-1],pilkottu));
              if taka(parts[i-1])<>             stem+thisav+lopvoks+curlka.mids[mux]+yhtloput[mux] then
               writeln(parts[i-1],'<br> <b style="color:magenta">MISS: ',stem+'\',thisav+'/',lopvoks+'|',curlka.mids[mux]+'|',yhtloput[mux],'!</b>' );
              writeln('</td>');
               //kaataaTRUE1 kaataa kaatanFALSE2 kaadan kaataaTRUE3 kaataa 4kaatetaFALSE4 kaadeta 5kaatanutTRUE5
               //kaatanut kaatoiFALSE6 kaasi /kaatoi 8kaatettuFALSE7 kaadettu kaataenTRUE8 kaataen kaataisiTRUE kaataisi kaatakaaTRUE kaatakaa kaatanemmeTRUE kaatanemme

            end;    writeln('</tr>')

             {for i:=199 to  parts.count-1 do if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
             begin mux:=mux+1;
               thisav:=ifs(mux in [2,4,7],ah,av);
               if taka(stem+thisav+curlka.mids[mux]+yhtloput[mux])=taka(parts[i-1]) then color:='green' else  color:='red';
               //taka(parts[i-1])=taka(stem+ifs(mux in [2,4,7],ah,av);
               //writeln('<span style="color:',color,'"> ',stem+thisav+curlka.mids[mux]+'<u>',yhtloput[mux]+'</u>\',
               // parts[i-1],'</span>');
                //kaataaTRUE1 kaataa kaatanFALSE2 kaadan kaataaTRUE3 kaataa 4kaatetaFALSE4 kaadeta 5kaatanutTRUE5
                //kaatanut kaatoiFALSE6 kaasi /kaatoi 8kaatettuFALSE7 kaadettu kaataenTRUE8 kaataen kaataisiTRUE kaataisi kaatakaaTRUE kaatakaa kaatanemmeTRUE kaatanemme

             end;}
        end
         else  //HEIKOT MUODOT >62
       begin

          {
           halutaan rungoksi kaikki vahvaan av-konsonantti asti.
           jos ei ole astevaihtelua,
           OSIA:
           -runkotavut joihin astevaihtelu ei koske
           -tavu jota av-koskee. Sis‰lt‰‰:
              sanakohtainen osa
          leikell‰ = lei/k lei-kel-l‰             |k/e  leik-ke-len
          jyrket‰    jyr-ke-t‰  jyrk-ke-nen

          Keret‰ KE RE  KER KE   ker e
          laota  LA O   LA  KO   la  o

          kk/k pp/p >k/p mukana rungossa, ja lis‰t‰‰n vahvoissa muodoissa vaihtotavun alkuun
          k /-> mukana  vaihtarin alussa.
            Edelt‰v‰ konsonantti poistetaan alkuvatavusta heikoissa muodoissa,
            itse K poistetaan vaihtarista vahvoissa
            huom: usein ed. on vokaali. Kons-loppuisista vois tehd‰ oman av-tyypin
            jos runko loppuu konsoNanttiin
          p/v  t/d ->  vahva rungossa, vaihdetaan heikkoon heikoissa
          ng/nk rt/rr jne sama kuin ed (/p/v jne)

          p‰tkimiset kun tiedet‰‰n av-tyyppi ja infinitiivi
           * kk/k  -> etsi stemmist‰ viimeinen K, sen j‰lkeen p‰tk‰isy (K siis j‰‰ runkotavujen puolelle)
           * p/v t/d nt/nn ng/nk (muuttuu-> g/k) yms: p‰tk‰sy stemmin vikan (heikon ) K:n (p,t,g) edelle
           * k/-  p/- ennen vikaa vokaalia, tai jos sit‰ edelt‰‰ konsonantti, niin ennen sit‰
                huom si'it‰ pi'et‰ (hyv‰)poikkeustavutus .

            //0:ei vaihtelua: lis‰t‰‰n vaihtariin aina sama loppukons joka talletettu erikseen (4 bit)
            //1 (vain k/) lis‰‰‰n vaihtariin
            //2: p/v,t/d, k/j, k/v - vaihto vaihtarin alussa - vaatii kukin omat tyyppins‰, muuten kummatkin kons ei talletu mihink‰‰n
            //3: kk/k , pp/p ttt - tallettuneena rungon lopussa, vaihtelee vaihtarin alussa
            //4   G ( nk : ng )  H ( mp : mm )  I ( lt : ll )  J ( nt : nn )  K ( rt : rr )
               //kun ekat kirj unohdetaan, toimii kuten 2)




          73:at pi e [k|] piet‰ 1k pi|eta: 2k pik|ean: 3k pik|eaa: 4k pi|eta: 5k pi|ennut: 6k pik|esi: 7k pi|ettu: 8k pi|eten: 9k pik|eaisi: 10k pi|etkaa: 11k pi|ennemme:
          74:a jo i [k|] joiata 1k jo|iata: 2k jok|iaan: joikaan2 3k jok|iaa: joikaa3 4k jo|iata: 5k jo|iannut: 6k jok|iasi: joikasi6 7k jo|iattu: 8k jo|iaten: 9k jok|iaisi: joikaisi9 10k jo|iatkaa: 11k jo|iannemme:
          }
          //stem:=taka(copy(parts[2],1,length(parts[2])-length(lvok+ah+mymid)-1));
          //if av<>'' then begin writeln('');continue;end;
          //if ah<>'' then write('<h3>',parts[0],' ',av,'\',ah,'</h3>');
          // writeln('*',ast.a,ast.f,':',ast.t,'_',av,ah);
           //if pos(ast.a,'ABC')<1 then continue;
           //if length(ast.f)<2 then continue;
           xpart:='';
//           if lks='V067' then xpart:='L';
          // if lks='V068' then xpart:='i';
          stem:=taka(copy(parts[0],1,length(parts[0])-length(mymid+'a')));
           if curlka.hasav=false then
           begin
             writeln(parts[0]);
             color:='magenta';
             lopvoks:='';
           end
           //HEIKKOA
           else
           begin
                   // halveta      1,    7           -        v    t  a
             //if av='' then for j:=length(stem) downto length(stem)-2 do if pos(stem[j],vokaalit)<1 then begin av:=stem[j];ah:=AV;delete(stem,j,0);break;end;
            lopvoks:='';
            writeln('<tr><td colspan="10">',stem,' <u>','</u> ',parts[0]);
            WHILE POS(stem[length(stem)],vokaalit)>0 do
             begin //write('*',stem[length(stem)],'/');

             lopvoks:=stem[length(stem)]+lopvoks;
             delete(stem,length(stem),1);
             //if isdifto(stem[length(stem)],lo
             if ah='' then break;
             end;
            //stem:=copy(stem,1,length(stem)-length(ah)-LENgth(lopvoks));
            stem:=copy(stem,1,length(stem)-length(ah)-LENgth(''));
            //writeln('?',stem,' </td></tr>');
            color:='green';
            if av<>'' then color:='blue';
            if ah<>'' then   color:='black';
            if length(ast.f)=2 then color:='purple';
          end;
          hyphenfi(stem+av+lopvoks,tavus);
          writeln('<tr><td style="color:',color,'"> ',parts[0],' ',stem,' <b>',lopvoks,' </b>',ast.f,ast.t,'</td><td>');//,'  <span>',' [',ast.f,'\'+ifs(ast.t='',' ',ast.t),']  ',parts[0]);
          winfo.commatext:=inttostr(curlka.num)+','+inttostr(length(ast.f+ast.t))+','+ah+','+inttostr(tavucount);
          //for i:=tavus.count-1 downto 0 do winfo.add(tavus[i]);
          for i:=0 to tavus.count-1  do winfo.add(tavus[i]);
          writeln(winfo.commatext);
          writeln(ofi,winfo.commatext);
          writeln('</td><td>');
          //xpart:=copy(xpart,1,length(xpart)-length(mymid)-1);
          xpart:='';
          //if pos(av,stem)>length(stem)-1 then writeln(' AVX');
          //if pos(ah,stem)>length(stem)-1 then writeln(' AHX');
          //continue;
          if taka(parts[0])=taka(stem+lopvoks+xpart+mymid+'a') then color:='black' else color:='blue';
          //write('<li  style="color:',color,'"> ',lopvoks,av,ah,' ', stem,'|',lopvoks,'|'+'<b>',mymid,'</b> ',parts[0],': &nbsp; &nbsp; &nbsp;');
          mux:=0;
          form:='';
          for j:=4 to winfo.count-3  do form:=form+winfo[j];
          sv:=winfo[winfo.count-2];
          mv:=winfo[winfo.count-1];
          if winfo.count<6 then sv:='';
          mh:=mv;sh:=sv;
          CASE AVLEN OF
           1: begin mh:=copy(mH,2);end;
           2: begin Mh:=winfo[2]+copy(MH,2);end;
           3: begin sh:=copy(sH,1,length(sH)-1);end;
           4: begin Mh:=winfo[2]+copy(MH,2);end;
          END;
          for i:=1 to  min(72,parts.count-1) do if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
           begin
           ///HEIKOTSIJAT     [2,3,6,9] vahva  [2,4,7]
            mux:=mux+1;
            mymid:=curlka.mids[mux];
            myvai:=ifs(mux in [2,3,6,9],mv,mh);
            while pos('-',mymid)=1 do begin delete(mymid,1,1);delete(myvai,length(myvai),1);writeln('<td>!-</td>');end;
             if pos('/',parts[i-1])>0 then parts[i-1]:=trim(copy(parts[i-1],pos('/',parts[i-1])+1));
            //if not (mux in [2,3,6,9] then
            begin
            //thisav:=;
             //ifs(mux in [2,3,6,9],av,ah);
             color:=ifs(taka(parts[i-1])=               form+    ifs(mux in [2,3,6,9],      sv,sh)+myvai+        mymid+yhtloput[mux],'green','red');
             writeln('<td style="color:',color,'">',mymid,'(',form,')',ifs(mux in [2,3,6,9],sv,sh),'.',myvai,'!',mymid,yhtloput[mux],ifs(color='red',' ['+parts[i-1],''),']</td>');
             //color:=ifs(taka(parts[i-1])=               form+    ifs(mux in [2,3,6,9],sv+    mv,sh+    mh)+    mymid+yhtloput[mux],'green','red');
             //writeln('<td style="color:',color,'">',mymid,'(',form,')',ifs(mux in [2,3,6,9],sv+'_'+mv,sh+'-'+mh),'.',mymid,yhtloput[mux],ifs(color='red',' ['+parts[i-1],''),']</td>');
             //writeln('<td style="color:',color,'">','(',form,')',tavus[tavus.count-1],'.',curlka.mids[mux]
             //,yhtloput[mux],ifs(color='red',' '+parts[i-1],''),'</td>');
            end;
           end;
          continue;
          begin
           for i:=1 to  min(24,parts.count-1) do if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
             mux:=mux+1;
              if pos('/',parts[i-1])>0 then parts[i-1]:=trim(copy(parts[i-1],1,pos('/',parts[i-1])-1));
              thisav:=ifs(mux in [2,3,6,9],av,ah);
              pilkottu:=stem+'|'+thisav+'|'+lopvoks+'|'+curlka.mids[mux]+'|'+yhtloput[mux];
              //writeln('\',pilkottu,'_',parts[i-1],'#');
              if taka(stem+thisav+lopvoks+taka(curlka.mids[mux]+yhtloput[mux]))=taka(parts[i-1]) then color:='green' else  color:='red';
              if pos('/',parts[i-1])>0 then color:='blue';
              //taka(parts[i-1])=taka(stem+ifs(not (mux in [2,4,7]),ah,av);
              writeln('<td style="color:',color,'"> ',' ');//,parts[i-1],' ');//stem+'['+thisav+']'+lopvoks+'|'+curlka.mids[mux]+'<u>',yhtloput[mux]+'</u>:');
              //if color<>'green' then
              writeln('',tavut(parts[i-1],pilkottu));
              writeln('</td>');
               //kaataaTRUE1 kaataa kaatanFALSE2 kaadan kaataaTRUE3 kaataa 4kaatetaFALSE4 kaadeta 5kaatanutTRUE5
               //kaatanut kaatoiFALSE6 kaasi /kaatoi 8kaatettuFALSE7 kaadettu kaataenTRUE8 kaataen kaataisiTRUE kaataisi kaatakaaTRUE kaatakaa kaatanemmeTRUE kaatanemme

          end;    writeln('</tr>')
      end
      except writeln('<li style="color:',color,'"><b>!!!',stem,'/',form,j,'</b>');  end;
  end;
 closefile(ofi);closefile(ifi);
end;


procedure tstemmer.findmids;  //copy of stemmaa, maybe have to use/rewrite this later. stemmaa was originally used for finding stems, foolishly I twisted it forother purps
vAR parts:tstringlist;ofi,ifi:textfile;
 curlka:ttaivlka;
 lknum:integer;
 line,av,ah,lks,stends,lopvoks,psim,newid,mymid,xpart,lkon,sharedb,stem,form,color,paddedform:ansistring;
 i,j,k,sims:integer;
 ast:taste;
 ends:tstringlist;
 mux:word;
begin
ends:=tstringlist.create;
parts:=tstringlist.create;
 assign(ofi,'vmids2turha.csv');
 rewrite(ofi);
///assign(ifi,'verbsall.lst');    //rewrite(ofi);
assign(ifi,'sanatansi.lst');
reset(ifi);
lknum:=-1;
lks:='xxx';
writeln('<hr>STEMMAA');
parts.StrictDelimiter := true;
   parts.Delimiter:= ',';
   for i:=1 to 4 do readln(ifi,line);; //skip rubbish
while not eof(ifi) do
begin
   readln(ifi,line);
   parts.clear;
   parts.delimitedtext:=line;
   //writeln('<li>',parts.count);
   if parts.count<2 then continue;
   if pos(lks,line)<>1 then
   begin
       mux:=0;
       writeln('<li>yhtlops:',lks,'/',ends.count,'</li>');
       if curlka<>nil then
       begin
       try
       write(ofi,lks);//,',',curlka.example);
        if ends.count>12 then for i:=0 to ends.count-1 do
        begin
          if not (i+1 in  [1,2,4,09,11,17,18,27,54,63,70,78]) then continue else
          begin
             write(ofi,',',copy(ends[i],1,length(ends[i])-length(yhtlopsall[i+1])));
             mux:=mux+1;
             if copy(ends[i],1,length(ends[i])-length(yhtlopsall[i+1]))+yhtlopsall[i+1]=
             curlka.mids[mux]+yhtloput[mux] then color:='green' else color:='red';
             writeln('<li style="color:',color,'">',ends[i],' <b>'
             ,copy(ends[i],1,length(ends[i])-length(yhtlopsall[i+1])),'</b>',yhtlopsall[i+1],
             ' <b>',curlka.mids[mux], '</b>',yhtloput[mux],'</li>');

        end; end;
        writeln(ofi,',',curlka.expl);
        except writeln('<li>nilluokka');end;
        end;
        lknum:=lknum+1;
        //if lknum>=luokat.count then exit;
        //writeln('<li>runkoj‰m‰t:',stends);
        //writeln('<li>lopvoks:',lopvoks);
        stends:=',';
        lopvoks:=',';
        psim:='';
        curlka:=ttaivlka(luokat[lknum]);
        //curlka.example:=parts[2];
        writeln('</ul><div style="background:#ddd"><h4>###',parts[0],' ',parts[1],' @',lknum,' ',ifs(curlka.vahva,'vahva','heikko'),ifs(curlka.hasav,' ','Ei-AV'),'</h4><ul><li>');
    writeln('<h3>',parts[0],lks,'|',lknum,'/kot:',curlka.kotus,'  1:',parts.count,'</h3>');//,curlka.mids[1]);//,' <li><b>',curlka.expl,'</b></li>');
    writeln('<table border="1"><tr>');
           for i:=1 to parts.count do  if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
           writeln('<td>',i,'/',yhtlopsall[i],'</td>');
           writeln('</tr><tr>');
             for i:=1 to 12 do    //if not (mu+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
           writeln('<td>',i,'/',curlka.mids[i],'|',yhtloput[i],' </td> ');
           writeln('</tr></table></div>');

             ends.clear;
             for i:=2 to parts.count-1 do ends.add(taka(parts[i]));

     end;
     lks:=copy(parts[0],1,4);
     ast:=getastekons(parts[0][5],av,ah);
     parts.delete(0);
     parts.delete(0);
     //writeln(parts.commatext);
     ends.clear; //cheating, ends should be forms
     for i:=1 to parts.count do  if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
       ends.add(parts[i]);

     //writeln('<li>',curlka.kotus,mymid,'\',curlka.mids[1],'\',lvok,'\',lkon);//line,'!',av,ah,'!',lknum,'/',newid);
     //stl:=tstringlist.create;
     //if ah<>'' then continue;  //DEBUG
     //sijapaa:=yhtlopsall[lknum];
     newid:=(parts[0]);
     mymid:=curlka.mids[1];
     //ls:=hyphenfi(parts[2],stl);
     //if psim<>parts[1] then sims:=0;
     {sims:=sims+1;
     psim:=parts[1];
     if sims>5 then if parts[2]<>'panna' then continue;  //don't always wish to see whole list
     sims:=sims+1;}
     //writeln('<li>',mymid,'%',line,'!',av,ah,'!',lknum,'/',newid);
     if pos('#',mymid)>0  then  lkon:=parts[2][length(parts[2])-1] else lkon:=''; //ad hoc. only for V067
     stem:=parts[0];
     //if lks='V067' then  writeln('<li>',parts[0]);
     // try
     //writeln('<li>@',stem,': ');
     for i:=0 to //12 do //
     parts.count-1 do
     begin
       if length(parts[i])>=length(ends[i]) then paddedform:=taka(copy(parts[i],length(parts[i])-length(ends[i])+1))
       else paddedform:=taka(''+copy('123456789',1,length(ends[i])-length(parts[i]))+parts[i]);
       //if i=3 then writeln('<li>',length(ends[i]),ends[i],'\',paddedform,'#',length(parts[i]),' ');
         for j:=length(ends[i]) downto 1 do
         if ends[i][j]<>paddedform[j] then
         begin
            //if lks='V067' then  writeln('=',ends[i]);
             ends[i]:=copy(ends[i],j+1);
             break;
         end;// else write('+',paddedform[j]);
     end;
     //writeln(' ',parts[3]);

 end;
end;

procedure  tstemmer.createlist;
var ofi,ifi:textfile;
  line,prevline,lks,avs:ansistring;
  i,j,mu,lk,sims:integer;
  av,ah,psim:ansistring;
  ast:taste;parts:tstringlist;
  lknum:word;talkpos,tkircount,keskitavu:integer;
  curlka:ttaivlka;
  stem,sijapaa,lvok,lkon,newid,mymid,stend,stends,lopvoks,tstem,pform,recon,keskonen:ansistring;
  lens:array[0..20] of word;
  tc,lc,max1,max2,max3:word;
  max1w,max2w,max3w,ls,color:ansistring;
  //stl:tstringlist;
  etuko:boolean;

function tavuta(wrd,stem:string):string;
var i,j,tp:integer;
begin
tavus.clear;
ls:=hyphenfi(wrd,tavus);
 exit;
//if tavucount<1 then
 talkpos:=0;i:=0;
 keskitavu:=0;

 i:=0;tkircount:=0;tp:=0;
 for j:=1 to length(ls) do if i>=length(stem) then begin talkpos:=i;break;end
 else if ls[j]=',' then begin tp:=j;talkpos:=i; keskitavu:=keskitavu+1;end else begin i:=i+1;tp:=j;writeln('*',ls[j],j);end;
 //write('a:',tavup,';');
 ls:=ls+',';
 if parts[0]='66' then writeln('<li>;;;',stem,length(stem),'/',copy(wrd,1,talkpos),tp,'{',copy(wrd,1,talkpos),' ',copy(wrd,talkpos+1),'\',copy(ls,tp+1),'}');
 i:=0;
 for j:=tp+2 to length(ls) do
   begin if parts[0]='66' then writeln('!!',ls[j],j);if ls[j]=',' then begin keskitavu:=keskitavu+1;tkircount:=i;break;end else begin i:=i+1; end;//write('_',i,ls[j]);end;
 end;//if tavup<=length(stem) then //if pos(',',copy(stem+',',tavup))<1 then
 //write('#',tavup,tavupend,'#');
 if talkpos<=length(stem) then stend:=copy(stem,talkpos+1) else stend:='_';
 //if tavup=0 then stend:='_';
 if talkpos>0 then if pos(','+stend+',',stends)<1 then
 stends:=stends+stend+',';
 //if stend='si' then writeln('ssss');
 //writeln('<li>tavut:',wrd,' ',ls,' ',stem,'===',tavus.commatext,tavus.count,tavucount);

 lens[keskitavu]:=lens[keskitavu]+1;
 if keskitavu>max1 then begin max3:=max2;max2:=max1;max1:=keskitavu;max3w:=max2w;max2w:=max1w;max1w:=ls;end else
 if keskitavu>max2 then begin max3:=max2;           max2:=keskitavu;max3w:=max2w;max2w:=ls;end;// else
 //if talkpos<=length(stem) then if talkpos>0  then insert('*',stem,talkpos+1);

 result:=stem;
end;

begin
fillchar(lens,sizeof(lens),0);
 writeln('<hr>createlist');
 assign(ofi,'verbs.csv');

 rewrite(ofi);
 writeln(ofi,'miksei skulaa');
assign(ifi,'verbsall.lst');
reset(ifi);

lknum:=1;
lks:='xxx';
lc:=0;tc:=0;
parts:=tstringlist.create;
max1:=0;max2:=0;max3:=0;
while not eof(ifi) do
begin
 readln(ifi,line);
 parts.clear;
 parts.commatext:=line;
 if pos(lks,line)<>1 then
 begin
  lknum:=lknum+1;
  //if lknum>=luokat.count then exit;
  writeln('<li>runkoj‰m‰t:',stends);
  writeln('<li>lopvoks:',lopvoks);
  stends:=',';
  lopvoks:=',';
  psim:='';
  lc:=0;
  writeln(lknum, '?????????');
  curlka:=ttaivlka(luokat[lknum]);
  curlka.example:=parts[2];
  writeln('<li>sanoja:',lc,'</li> </ul><h4>###',line,'@',lknum,' ',ifs(curlka.vahva,'vahva','heikko'),ifs(curlka.hasav,' ','Ei-AV'),'</h4><ul>');
       for i:=1 to 12 do    //if not (mu+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
     writeln(i,'/',curlka.mids[i],'|',yhtloput[i],' /// ');
    writeln('<li>',lknum,'',curlka.kotus,'  1:',curlka.mids[1]);//,' <li><b>',curlka.expl,'</b></li>');
 end;
 lks:=parts[0];
 //writeln('<li>',curlka.kotus,mymid,'\',curlka.mids[1],'\',lvok,'\',lkon);//line,'!',av,ah,'!',lknum,'/',newid);
 //stl:=tstringlist.create;
 lc:=lc+1;
 tc:=tc+1;
 ast:=getastekons(parts[1][1],av,ah);
 //if ah<>'' then continue;  //DEBUG
 //sijapaa:=yhtlopsall[lknum];
 newid:=(parts[0]);
 mymid:=curlka.mids[1];
 //ls:=hyphenfi(parts[2],stl);
 if psim<>parts[1] then sims:=0;
 sims:=sims+1;
 psim:=parts[1];

 if sims>5 then if parts[2]<>'panna' then continue;  //don't always wish to see whole list
 sims:=sims+1;
 //writeln('<li>',mymid,'%',line,'!',av,ah,'!',lknum,'/',newid);
 if pos('#',mymid)>0  then  lkon:=parts[2][length(parts[2])-1] else lkon:=''; //ad hoc. only for V067
 if curlka.vahva then
 begin
  continue;
   if lknum=2 then lvok:=taka(copy(parts[2],length(parts[2])-1,1))else lvok:='';//taka(lopvok);
   mymid:=stringreplace(mymid,'*',lvok,[rfReplaceAll]);
   //writeln(lknum,'*****',mymid,curlka.kotus);
   if mymid<>'' then if pos(mymid[1],vokaalit)>0 then begin lvok:=mymid[1];delete(mymid,1,1);end;
   if lknum=2 then newid:=newid+lvok;
   if av='' then begin av:=copy(parts[2],length(parts[2])-length(mymid)-length(lvok)-1,1);ah:=av;end;  //temp... vain vahvoille
   if pos(av,vokaalit)>0 then begin av:='';ah:='';end;
   stem:=taka(copy(parts[2],1,length(parts[2])-length(av+mymid+lvok)-1));
    //if lknum<>2 then lvok:='';
    ls:=tavuta(parts[2],stem);
    //i:=0;
    //for j:=tavup+1 to length(parts[2]) do  write('!?',parts[2][j]);
    //writeln('<li>XXX',copy(parts[2],tavup+1,tavupend-tavup),tavup,tavupend,tavup-tavupend);
    pform:=taka(parts[2]);
    if stem+av+lvok+mymid+'a'=taka(parts[2]) then color:='black' else color:='red';
    //if color='red' then writeln('<li style="color:',color,';margin-left:3em">',tavuta(parts[2],stem)+'<b>',av,'</b><sub>',ah,'</sub><span style="color:red">',lvok,'</span>|',lkon,'_',mymid,'a  --',ifs(color='red','!='+parts[2],''),' ',stem+av+lvok+mymid+'a','! ',ls,tavup,length(stem),'</li>');
 end else
 begin
    //while pos(mymid[1],vokaalit)>0 do delete(mymid,1,1);
     lvok:='';
     if 1=0 then
     if pos(mymid[1],vokaalit)<1 then
     begin
       lvok:=copy(parts[2],length(parts[2])-length(mymid)-2,2);   //ahm.ai-sta
       writeln('#',copy(parts[2],1,length(parts[2])-length(mymid)-3),'#'+lvok);

       //
       //if pos(lvok[1],vokaalit)<1 then begin if av='' then lkon:=lvok[1];delete(lvok,1,1);end  //should we include the xtra vows in the mids-list. Now they are removed here
       //else if ah='' then  begin delete(lvok,1,1);end;
       //else if av='' then begin av:=copy(parts[2],length(parts[2])-length(mymid)-length(lvok)-1,1);ah:=av;end;  //temp... vain vahvoille
       if parts[0]='67' then lkon:=parts[2][length(parts[2])-2];
     end;
     //if length(lvok)>1 then writeln('<h1>XXXXXXXXXXXXXXXXXXXXXxxx</h1>');
     if lknum+50=67 then newid:=newid+copy(parts[2],length(parts[2])-1,1);
     mymid:=stringreplace(mymid,'#',lkon,[rfReplaceAll]);
     //writeln('% ');
     //if av='' then begin av:=copy(parts[2],length(parts[2])-length(mymid)-length(lvok)-1,1);ah:=av;end;  //temp... vain vahvoille
     stem:=taka(copy(parts[2],1,length(parts[2])-length(lvok+ah+mymid)-1));
     //writeln('<li>',stem,':::');
     //if pos(lvok[1],vokaalit)<1 then begin if av='' then lkon:=lvok[1];delete(lvok,1,1);end;  //should we include the xtra vows in the mids-list. Now they are removed here
                 //                 5                     0   0  2
     try
     //writeln('<li>',stem, ' (',av,ah,')');
    //if (av='') then if pos(stem[length(stem)],vokaalit)<1 then begin av:=stem[length(stem)];ah:=av;delete(stem,length(stem),1);end;
     //if pos(stem[length(stem)],vokaalit)<1 then writeln('<li style="color:green">',parts[2],'=',
     //copy(stem,1,length(stem)-1),'|',stem[length(stem)]+'-',ah+'\'+mymid,'|',yhtloput[1],' ',
     //copy(stem,1,length(stem)-1),stem[length(stem)],'|',av+'\'+mymid,'|',yhtloput[1],' [',av,ah
     // );
     //continue;
     except writeln('!!!!',stem,length(stem),line);end;
      //????pform:=taka(stem+av+lvok+mymid)+'a'; //pseudostem with AV instead of AH
      pform:=taka(parts[2]);
      // pform:=taka(stem+ah+lvok+'a');
      recon:='';
      ls:=tavuta(pform,stem);
      for i:=0 to tavus.count-1 do
      begin
          if length(recon+tavus[i])>=length(stem) then begin keskitavu:=i;break;end else recon:=recon+tavus[i];
          //writeln(tavus[i],'-(',recon,length(recon),')')
      end;
      //writeln(': ',keskitavu,recon,'(');

     //if pos(lvok[1],vokaalit)<1 then begin if av='' then lkon:=lvok[1];delete(lvok,1,1);end;  //should we include the xtra vows in the mids-list. Now they are removed here
     //writeln(': ',recon,'(',av,ah,')');
     //writeln('<li>:',recon,'(',av,ah,')');
      //if tavus.count>2 then continue;///DEBUG
     if taka(stem+ah+lvok+mymid)+'a'=taka(pform) then color:='blue' else color:='red';
     if length(mymid)>0 then while pos(mymid[1],vokaalit)>0 do  delete(mymid,1,1);
 end;

 //if pos(','+ifs(lvok<>'',lvok,'_')+',',lopvoks)<1 then
 //lopvoks:=lopvoks+ifs(lvok<>'',lvok,'_')+',';
 //if  then //if pos(',',copy(stem+',',tavup))<1 then
 //writeln('<span style="color:red"> ');
 //writeln(newid,',',lvok,',',av,',',ah,',',stem,',',lkon,',',ifs(pos(parts[2][length(parts[2])],'aeu')>0,'T','E'),'</span>');
 //tstem:=tavuta(pform,stem);


 //if (tavup=length(stem)) then color:='green' else color:='red';
 //if (tavup<length(pform)) or (sims<3) then  writeln('<li style="color:',color,';margin-left:3em"><b>',lkon,'</b>  ',stem+'|<b>',av,'</b><sub>',ah,'</sub><span style="color:blue">',lvok,'</span>|',mymid,'a',' ',
 //  ifs(color='red','!=','')+pform,' <b>',lvok,'</b> ',ls,' ',tavup,length(stem),';',pform,' <b>',copy(pform,tavup+1,tavupend),'</b> ',tavus.commatext);
   //,' ',ls,':',tavup,'/',length(stem),' >',stend,' ',parts[2]);
 if (pos(av,vokaalit)>0) or (pos(ah,vokaalit)>0) then writeln('<h3>huonojuttu</h3>');
 recon:=''; //660900119
 etuko:=pos(parts[2][length(parts[2])],'aeu')<1;
 keskonen:=copy(pform,talkpos+1,tkircount);
  recon:='';
 try
{!!!! for i:=0 to tavus.count-1 do
 begin
     if length(recon+tavus[i])>length(stem) then begin keskitavu:=i;break;end else recon:=recon+tavus[i];
     //writeln(tavus[i],'-(',recon,length(recon),')')
 end;

 try if keskitavu>1 then for i:=0 to keskitavu-1 do recon:=recon+ifs(etuko,etu(tavus[i]),tavus[i]);
 recon:=recon+keskonen+mymid+'a';except writeln('???',tavus.commatext,'!!!');end;
 if etuko then recon:=etu(recon);
 //if recon=parts[2] then color:='green' else color:='blue';
 if (av<>'') and (ah='') then color:='green' else color:='blue';
 try
  if  (av<>tavus[keskitavu][1]) then color:='green' else color:='blue';
 except writeln('<li>!!!',keskitavu);color:='red';end;
 }
 //if av='' then begin av:=tavus[keskitavu][1];ah:=av;end;
 writeln('<li style="color:',color,'">',parts[2],'? <small>',stem,'</small><span style="color:red">(',av,'.',ah,')</span> ');//,newid,',',parts[2],'=',recon, ' <b>[',keskonen,']</b><span style="color:red">(',av,ah,')</span><small>,'
 //  , '  t:',keskitavu,' k:',talkpos, '</small>  a:',talkpos,' l:',tkircount, ':');
 //if keskitavu>1 then for i:=0 to  keskitavu-1 do writeln('<b>[',tavus[i],']</b>');
 //if keskitavu>0 then
 writeln('<b>',tavus[keskitavu],'</b>:');//,'-(',recon,length(recon),')')
 for  i:=keskitavu-1 downto 0 do
  writeln('*',tavus[i]);//(',recon,length(recon),')')
 writeln('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');

  for  i:=0 to keskitavu-1  do
    write('_',tavus[i]);//(',recon,length(recon),')')
  //if (av<>'') and (ah='')
  if (av=copy(tavus[keskitavu],1,1)) or (pos(tavus[keskitavu][1],vokaalit)>0) then write(av,'*');
  if av='' then writeln('-<b>',tavus[keskitavu],'</b>')
  else writeln('-<b>',av,copy(tavus[keskitavu],2),'</b>');
  //for  i:=keskitavu+1 to tavus.count-1 do
   write('\',curlka.mids[2],yhtloput[2]);//(',recon,length(recon),')')
  writeln('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');

 writeln(keskitavu,' <small> ',tavus.commatext,'</small>');
 except writeln('FAIL',tavus.count,' ',stem,keskitavu,' ',tavus.count,'!!');end;
 //writeln(' ',recon,' /',mymid,'a','\',av,ah);//,pos(mymid[length(mymid)],vokaalit));
 //for i:=0 to tavus.count-tavucount do writeln(',',tavus[i]);
 //if curlka.vahva=false then if stend<>'' then if not length(av)>length(ah) then writeln('-outotavuraja');
 //if curlka.vahva=false then if stend='' then if length(av)>length(ah) then writeln(' -rajaton');
  //if tavucount>max3 then begin max3:=max2;max3w:=ls;end;
  //writeln(' ',ls);
 //lens[length(stem)]:=lens[length(stem)]+1;
  //if tavucount>5 then writeln('<li>PITKULA:',tavucount,' ', stem,' ',ls);
  //if tavucount<1 then writeln('<li>PƒTKYLƒ:',tavucount,' ', stem,' ',ls, '::', line);

 //if curlka.vahva then dovahva(parts[2],av,ah,curlka) else doheikko(parts[2],av,ah,curlka);
 //procedure tstemmer.dovahva(inf:tstringlist;av,ah:ansistring;lka:byte);
end;
writeln('<li>sanoja:',lc,'</li> </ul><h1>kaikkiaan;',tc,'</h4>');
closefile(ofi);
close(ifi);
writeln('<table>');
for i:=0 to 20 do
begin
 writeln('<tr><td>',i,'</td><td>',lens[i],'</td><td>');
 for j:=1 to lens[i] do //if j mod 10=1 then
 write('*');
 writeln('</td></tr>');
end;
writeln('</table>');
writeln('<li>',max1w,'<li> ',max2w,'<li> ',max3w,'<li>');
for i:=1 to luokat.count-1 do write('''',ttaivlka(luokat[i]).example,''''',');
end;

procedure ttaivlka.pilko(inf,mid,vahk,heik,sija:ansistring;var stem,loplet,kk:ansistring);
var i:word; s2,lkx,color:ansistring;
begin
  try
   //if kotus=71 then begin stem:=copy(inf,1,length(inf)-3);loplet:='';kk:='';  writeln('<li>w:'+inf,'/st:',stem,'/ko:',kotus);exit;end;
   {if pos('-',mid)=1 then
   begin
     delete(mid,1,1);
    writeln('<li>w:'+inf,'/st:',mid,'/ko:',kotus);
    //stem:=stem+'hd';  //tricstery .. vain n‰hd‰ tehd‰ syˆd‰‰n inf'ist‰
   end;}
    stem:=copy(inf,1,length(inf)-length(mid)-1);  //nahda - -hd -> na
    if vahva then
    begin
     loplet:='';
     kk:=vahk;
     if kk='' then begin if pos(stem[length(stem)],vokaalit)>0 then writeln('<h3>VVV:',inf,' ',stem,'</h3>');end;
     //if vahk<>'' then delete(stem,length(stem),1);
     delete(stem,length(stem),length(vahk));
     i:=length(inf)-length(mid);
     while i>1 do
      if pos(inf[i],vokaalit)<1 then
      begin
        //if length(vahk)>length(heik) then i:=i-1;
        loplet:=inf[i];
        i:=i-1;
        //if vahk<>'' then i:=i-1;
        //writeln('<li>',inf,' ',stem,' / ');
        s2:=copy(inf,1,i);
        //writeln('',stem,' / ',loplet);
        break;
      end else begin i:=i-1;end;
     //if stem<>s2+loplet then color:='red' else
     color:='blue';
     //if pos(s2,
//     writeln('<li style="color:',color,'">',inf,'  ',stem,'!=',s2,' <b> [',loplet,']</b> <small> ',vahk,heik,'</small></li>');
     stem:=s2;
     //if num=1 then lopvok:=inf[length(inf)-1];  //lka 1 ois luentevasti kaksi eri luokkaa, mutta nyt pelataan rumasti t‰ll‰ loppuvokaalilla
     exit;
    end;
//    writeln('<li>',stem,' (',pos(stem[length(stem)],vokaalit),')');
   loplet:='';
   kk:=heik;
   // if kotus=71 then
   //  writeln('<li>w:'+inf,'/mid:',mid,' /st:',stem) else
   if pos(mid[1],vokaalit)<1 then  //jos p‰‰te alkaa kons, poistetaan stem loppuvokaaleja
     for i:=1 to min(length(heik)+1,2) do  if pos(stem[length(stem)],vokaalit)<1 then break else begin loplet:=stem[length(stem)]+loplet;delete(stem,length(stem),1);//write(' <b>',loplet,'_</b>_',stem);
     end;

   delete(stem,length(stem),length(heik));
//    write('<em style="color:blue"> {',stem,' }<b  style="font-size:1.5em"> ',loplet,' ',vahk,heik,' </b>! ',mid,'</em>: ');//length(inf)-length(mid)-length(kk)-1,'/',length(mid),'/',length(kk));
  except stem:='vitura';WRITELN('VITUROILLAAN');end;
end;


procedure tstemmer.testgen;  //lopussa versio jolla laskettiin n‰‰, nyt raaka toteutus
var lknum,nkot,ckot:word;lvokas,lkons:ansistring;
var curlka:ttaivlka;mm:word;myforms:array[1..12] of ansistring;

procedure teeluokat;
var lk,mu:integer;mm:word;
begin
  //curlka:=tluokka.create(i+51); //luokat.add(curlka);  //one empty to get 1-base .. no,  there is a unneeded 009-class
 for lk:=0 to 28 do
 begin
   curlka:=ttaivlka.create(lk+50);
   curlka.expl:=explain(lk+50);
   luokat.add(curlka);
   curlka.num:=lk;
   curlka.kotus:=lk+50;
   if lk+50<62 then curlka.vahva:=true else  curlka.vahva:=false;
   if lk+50>=76 then curlka.vahva:=true;
   //if lk+50>=71 then curlka.vahva:=true;
   //if lk+50>=71 then curlka.vahva:=true;

   if (lk+50  in [59,60,62,63,64,65,68,69,70,71,77]) then curlka.hasav:=false else curlka.hasav:=true;
   if lk+50 in [66,67,72,74,75] then curlka.hasmaft:=true else curlka.hasmaft:=false;
   mm:=0;
   writeln('<li>');
   for mu:=1 to 12 do    //if not (mu+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
   begin      //mm:=mm+1;
     curlka.mids[mu]:=mids[lk+1,mu];
     writeln(mu,curlka.mids[mu],'/ ');
   end;
  end;
end;
procedure uusluokka;
 var ii,len,mm:word;outo:boolean;
      begin  try
       if lknum>0 then lopvokst[lknum]:=lvokas;
       if lknum>0 then lopkonst[lknum]:=lkons;
        lknum:=lknum+1;
        if lknum>=luokat.count then exit;
        curlka:=ttaivlka(luokat[lknum]);
        curlka.example:=forms[1];
        curlka.expl:=explain2(forms[0]);
        writeln('</ul></div><h5>',lknum,'   ',forms[0],' ',forms[1],': ',copy(lopvokst[lknum-1],lknum,1),'',lvokas,'');
        writeln(':',ifs(curlka.vahva,'vahva','heikko'), ' /av:',curlka.hasav,' xvoks:',curlka.hasmaft,'</h5>');
        writeln(' <div class="muoto" style="background:',ifs(curlka.vahva,'#aff','#faa'),'"><ul style="color:',ifs(curlka.hasav,'blue','black'),'">');
        writeln('<li>');

        for ii:=1 to 12 do
        writeln('<b>',ii,' ',curlka.mids[ii],' </b>');
        mm:=0;
        writeln('<li>');
        for ii:=1 to 12 do
         writeln(ii,'+',yhtloput[ii]);
        writeln('<li>');
        for ii:=199 to 77 do
        if not ( (ii in [1,2,4,09,11,17,18,27,54,63,70,78])) then continue else
        begin
          mm:=mm+1;
          writeln(mm,forms[ii+1],'|',curlka.mids[mm],'|',yhtlopsall[ii]);
        end;
//!        writeln('<table border="1">');
except writeln('failuusluokka');      end;
 end;

var slist:tstringlist;
 i,j,inlka:word;
 si:tsija;
 asija,aloppu,aalku,av,ah,wmid,lopvok,alopv,lopkon,kk,sijapaa,stem,astem,color:ansistring;
 lvokcounts,lkoncounts,wcount:array[1..30] of word;
 ast:taste;db:boolean;
 dbls,errs:array [1..30] of array[1..78] of byte;

procedure dovahvax(f:tstringlist);
 var mu,lu,smu:integer;me,myalku,mymid,mylop:ansistring;
 begin
   //for mu:=1 to 12 do
   //if av='' then begin av:=lopvok;ah:=lopvok; end;  //temp... vain vahvoille
    //writeln('<li>vahvamuoto:');//,f.commatext);
   if lknum=13 then begin ah:='';end;
   smu:=0;
   for mu:=1 to 72 do
     if not (mu in [1,2,4,09,11,17,18,27,54,63,70,78]) then continue else
     begin
      //smu:=mu;//
      smu:=smu+1;
      mymid:=stringreplace(mids[lknum+1,smu],'*',taka(f[1][length(f[1])-1]),[rfReplaceAll]);  //just for 52: -oa or  -ua
      if tsija(sijat[mu]).vv then mylop:=av else mylop:=ah;
      myalku:=stem+mylop;
      while pos('-',mymid)>0 do begin delete(mymid,1,1);delete(myalku,length(myalku),1);end;
      me:=myalku+mymid+yhtlopsall[mu];
      //mymid:=stringreplace(mymid,'#',lopvok,[rfReplaceAll]);
     if (taka(f[mu+1])<>me) then
       color:='red' else color:='black';

     //writeln(smu,'/',f[mu+1],'=',me, ' /stem:',stem,'<b>|',mylop,'\',mymid,'</b>+',yhtlopsall[mu],'(<em style="color:',color,'">',stem+mylop+mymid+yhtlopsall[mu],'</em>)',lopvok,'/',av,ah,' ');
     end;
   //writeln(' ',stem,'(',lopvok,')',av,ah,'!<b>',mids[lknum,mu],'</b>|',yhtloput[mu]);
 end;
procedure doheikkox(f:tstringlist);
 var mu,lu,smu:integer;mylop,mymid,myalk,mystem,kkk,color:ansistring;
 begin
   //for mu:=1 to 12 do
  smu:=0;
   for mu:=1 to 72 do
     if not (mu in [1,2,4,09,11,17,18,27,54,63,70,78]) then continue else

     begin
      smu:=mu;
      //smu:=smu+1;
      si:=tsija(sijat[smu]);
      mystem:=stem;
      mymid:=stringreplace(curlka.mids[si.hparad],'*' ,alopv,[rfReplaceAll]);  // --o
        //if lknum=14 then mymid:=stringreplace(curlka.mids[si.vparad],'*' ,alopv,[rfReplaceAll]);
     //mymid:=mids[lknum+1,smu];
     if tsija(sijat[mu]).hv then kkk:=av else kkk:=ah;
     myALK:=stem+kkk;//+lopvok;  //lu++o
     //if pos('*',mymid)>0
     //mymid:=stringreplace(mymid,'*',lopvok,[rfReplaceAll]);
     mymid:=stringreplace(mymid,'#',lopkon,[rfReplaceAll]);
     while pos('-',mymid)>0 do begin delete(mymid,1,1);delete(myalk,length(myalk),1);writeln(' X',mymid,'/',myalk);end; //luo ->lu ->l
     myalk:=myalk+lopvok+mymid+yhtlopsall[mu];   //l+'o+imme
     //if (lknum=13) or                          cd
     if (taka(f[mu+1])<>myalk)
     then color:='red' else color:='black';
     if pos('/',f[mu+1])>0 then color:='green';
     //writeln(' ',smu,'/',si.hparad,f[mu+1],'=<em  style="color:',color,'">',myalk,' </em>(',stem,'|',kkk,'|',lopvok,'|',mymid,'|',yhtlopsall[mu],') ');
     end;
                                               //    loimme=                limme        (  lu    |       |   o      |--*                       |  imme)
       //lu
   //writeln(' ',stem,'(',lopvok,')',av,ah,'!<b>',mids[lknum,mu],'</b>|',yhtloput[mu]);
 end;
//var tavus:tstringlist;
var mystem,newid:ansistring;fo:text;
begin

assign(fo,'verbs.csv');
rewrite(fo);
fillchar(dbls,sizeof(dbls),0);
fillchar(errs,sizeof(errs),0);
FOR I:=1 TO 30 DO wcount[i]:=0;
 writeln('read vsijat.csv');
 //for i:=1 to 13
  // for j:=1 to 78

 teeluokat;
 while not(eoff) do
 begin
   forms.clear;
   readline;
   if eoff then break;
   //writeln(forms[1]);break;   eoff:=true;   break;
   //if newforms.count<10 then continue;
   if forms[2]='kerit‰/kerit‰' then continue;
   nkot:=strtointdef(copy(forms[0],3,2),0);
   //if nkot>52 then break;
   try
   if nkot<>ckot then
    begin //writeln('<hr><li>old:',forms.commatext,'<hr><li>new',newforms.commatext,'<hr>');
     //if curlka.vahva then dovahva(forms) else doheikko(forms);
     //writeln('<hr><li>lopvoks:',lvokas,lvokcounts[lknum],'</li><li>',curlka.hasav,curlka.hasmaft,'');
     uusluokka;inlka:=0;lvokas:=',';lkons:=',';end;
   except writeln('<h1>failforms</h1>');end;
   //forms.clear;
   //forms.addstrings(newforms);
   wcount[lknum]:=1+wcount[lknum];
   ckot:=nkot;
   inlka:=inlka+1;
   //if inlka>2 then continue;
   try
   sijapaa:=yhtlopsall[lknum];
   ast:=getastekons(forms[0][5],av,ah);
   newid:=copy(forms[0],3,2);
   //if  (ckot=71) then begin av:='';ah:='';curlka.vahva:=false;end;
     //71, hd,e,kee,hd,hn,,ke,h,hd,k,h,hn,
     //71, hd,e,kee,hd,hn,,ke,h,hd,k,h,hn,ke
   if pos('#',curlka.mids[1])>0  then  lopkon:=forms[1][length(forms[1])-1] else lopkon:=''; //ad hoc. only for V067
   except writeln('<h1>EILOPK',LKNUM,SIJAPAA,'</H1>');end;
   TRY
     curlka.pilko(taka(forms[1]),curlka.mids[1],av,ah,sijapaa,stem,lopvok,kk);
   if lopvok<>'' then lvokcounts[lknum]:=lvokcounts[lknum]+1;
   if lopvok<>'' then if pos(','+lopvok+',',lvokas)<1 then lvokas:=lvokas+lopvok+',';
   if lopkon<>'' then if pos(','+lopkon+',',lkons)<1 then lkons:=lkons+lopkon+',';
   hyphenfi(forms[1],slist);
   if curlka.vahva then
   begin
     if lknum=2 then
     //if nkot<>62 then
     lopvok:=taka(copy(forms[1],length(forms[1])-1,1))else lopvok:='';//taka(lopvok);
     if nkot=52 then newid:=newid+lopvok;
     //if curlka.hasav then
     //if av='' then begin av:=copy(forms[1],length(forms[1])-2,1);ah:=av;end;  //temp... vain vahvoille
     if av='' then begin av:=copy(forms[1],length(forms[1])-length(curlka.mids[1])-1,1);ah:=av;end;  //temp... vain vahvoille
     mystem:=taka(copy(forms[1],1,length(forms[1])-length(av+curlka.mids[1])-1));
     if mystem<>stem then writeln('<li>!!!',forms[1],' ',stem,' ',length(av+curlka.mids[1])+1,' ',mystem,' ')
    ;//  else  writeln('<li>===<b>',av,ah,'</b> ',forms[1],' ',stem,' ',av,' ',curlka.mids[1],'a '  );//,length(av+curlka.mids[1])+1,' ',mystem,' ');
     //if length(slist[0])=length(av+curlka.mids[1]+'a') then color:='green' else if length(slist[1]+slist[0])<=length(av+curlka.mids[1]+'a') then color:='blue' else color:='red';
     //writeln('<b style="color:',color,'">',slist[0],'</b>/',av+curlka.mids[1]+'a');
//     writeln('<li style="color:red;margin-left:3em">',newid,',',lknum,',',av,',',ah,',',mystem,',',lopvok,'/',lopkon,'</li>');
   end else
   begin
    lopvok:='';
     if pos(curlka.mids[1][1],vokaalit)<1 then
     begin
     lopvok:=copy(forms[1],length(forms[1])-length(curlka.mids[1])-2,2);
     if pos(lopvok[1],vokaalit)<1 then delete(lopvok,1,1)
     else if ah='' then  delete(lopvok,1,1)
     end;
     if nkot=67 then newid:=newid+copy(forms[1],length(forms[1])-1,1)+'!';
     mystem:=taka(copy(forms[1],1,length(forms[1])-length(lopvok+ah+curlka.mids[1])-1));
 //if mystem<>stem then writeln('<li>!!!',forms[1],' ',stem,' ',ah,'/ ',mystem,' |',ah+'(',lopvok+')'+curlka.mids[1],' ')
 //     else  writeln('<li>===',forms[1],' ',stem,'|',ah,'|',lopvok,'|',curlka.mids[1],'a ',' ?',ah,' ',lopvok,' ');//,length(av+curlka.mids[1])+1,' ');
     //writeln('<b style="color:',color,'">',slist[0],'</b>',taka(slist[1]+slist[0]));
     //mystem:=ah+lopvok+curlka.mids[1]+'a';
     //if taka(slist[0])=ah+lopvok+curlka.mids[1]+'a' then color:='green' else if taka(copy(slist[1],2)+slist[0])=ah+lopvok+curlka.mids[1]+'a' then color:='blue' else color:='red';
     //writeln(' [',taka(slist[1]+slist[0]),'=',lopvok+curlka.mids[1]+'a //');
     //writeln(copy(mystem,1,length(mystem)-length(slist[0])),'<b style="color:',color,'">',slist[0],'</b>');
     if curlka.vahva then if nkot<>52 then lopvok:='';
//     writeln('<li><b style="color:red;margin-left:3em">PROTO:',newid,',',lknum,',',av,',',ah,',',mystem,',',lopvok,'</b>');

   end;
   writeln('<span style="color:green">',newid,',',lopvok,',',av,',',ah,',',mystem,' </span>');
   writeln(fo,newid,',',lopvok,',',av,',',ah,',',mystem,',');
   //writeln(
   slist.clear;
   //if nkot<>61 then continue;
   {if curlka.vahva then
   writeln(' <li>',forms[1],' ',length(forms[1])-length(stem),'/',length(av+curlka.mids[1])+1,'_[',av,ah,']_(<b>',lopvok,'/',lopkon,'</b>) &nbsp;&nbsp;')
   else writeln(' <li>',forms[1],' ',length(forms[1])-length(stem),'/',length(lopvok+ah+curlka.mids[1])+1,'_[',av,ah,']_(<b>',lopvok,'/',lopkon,'</b>) &nbsp;&nbsp;',lopvok,ah);
   }//if lknum=2 then lopvok:=taka(copy(forms[1],length(forms[1])-1,1));
   //if  (ckot=71) then begin av:='';ah:='';curlka.vahva:=true;end;
   except writeln('<h1>EIPIKO',LKNUM,SIJAPAA,'</H1>');end;
//   writeln(lknum,'  ',forms[1],'/<b>',stem,' </b><u>',av,ah,'</u>_',lopvok,' ');
   //writeln('<li>');
   //if nkot<>666 then
   if curlka.vahva then dovahvax(forms) else doheikkox(forms);
   //continue;
   //writeln('xxxxxxxxxxxxxxxxxxxxxxxxxxxx<hr>');


 for i:=1 to //20 do
 75 do
   begin
     //writeln(i,'-');
     if not (i in [1,2,4,09,11,17,18,27,54,63,70,78]) then continue;// else
     try
      alopv:=lopvok;
     db:=false;
     if pos('/',forms[i+1])>0 then
     begin db:=true;//writeln('<li style="color:green">',taka(forms[i+1]),'*');
      if pos('/',forms[i+1])<1+length(forms[i+1]) div 2 then forms[i+1]:=copy(forms[i+1],1,pos('/',forms[i+1])-1) //+inttostr(pos('/',forms[i+1]))
      else forms[i+1]:=copy(forms[i+1],pos('/',forms[i+1])+1);//writeln('</li>');
      //continue;
     end;//continue;  //temp
     si:=tsija(sijat[i]);astem:=stem;

    if curlka.vahva then wmid:=stringreplace(curlka.mids[si.vparad],'*' ,alopv,[rfReplaceAll])  //* vain 52
    else                 wmid:=stringreplace(curlka.mids[si.hparad],'*' ,alopv,[rfReplaceAll]);
    wmid:=stringreplace(wmid,'#',lopkon,[rfReplaceAll]);

     if curlka.vahva then  if si.vv then kk:=av else  kk:=ah;
     if not curlka.vahva then  if si.hv then kk:=av else  kk:=ah;
     if db then //if pos('-',wmid)<1 then
      dbls[lknum,i]:=dbls[lknum,i]+1;
     //if  not ((i=2) or (i=7)) then
    // if nkot=71 then begin write('');if si.vv then if si.hv then wmid:='k'+wmid;end;
    while pos('-',wmid)=1 do
     begin delete(wmid,1,1);if kk<>'' then begin kk:='';end//writeln('<small style="color:blue">',forms[i],'-',av,ah,' </small>');
      else
       if alopv<>'' then
       begin delete(alopv,length(alopv),1);//writeln('<small style="color:red">',forms[i],'-',lopvok,' </small>');
       end
       else begin delete(astem,length(astem),1);//writeln('<small style="color:green">',forms[i],'-',astem,'</small> ');
      end;
      //writeln('<b style="color:red">',forms[i],'_</b>',astem,'|',kk,lopvok,wmid,'_',si.ending);
     end;
    // continue;
    if curlka.vahva then aloppu:=kk+''+wmid+''+si.ending
    else aloppu:=kk+''+alopv+wmid+''+si.ending;
    aalku:=taka(copy(forms[i+1],1,length(forms[i+1])-length(wmid)-length(kk)-length(si.ending)-length(ifs(lknum<>2,alopv,''))));
    if not db then
    if (taka(FORMS[I+1])<>astem+kk+ifs(lknum<>2,alopv,'')+wmid+si.ending) then   begin errs[lknum,i]:= errs[lknum,i]+1;end;//
     //if nkot<>70 then continue;
     //if (i<35) or (i>36)  then continue;
     //if (taka(FORMS[I+1])<>astem+kk+wmid+si.ending) then color:='red' else color:='black';//
     //if (taka(FORMS[I+1])<>astem+kk+wmid+si.ending) then color:='red' else color:='black';//
     //if (si.hv) then if  (forms[i+1][3]='k') then color:='red' else color:='green';
     //if (si.vv) then if (forms[i+1][3]<>'k') then color:='black' else color:='blue';
  //if (taka(FORMS[I+1])<>astem+kk+ifs(lknum<>2,alopv,'')+wmid+si.ending) or (ckot=71) then //
     // if (taka(FORMS[I+1])<>aalku+kk+ifs(lknum<>2,lopvok,'')+wmid+si.ending) then color:='red' else color:='black';//
     //  if (taka(FORMS[I+1])<>aalku+kk+ifs(lknum<>2,lopvok,'')+wmid+si.ending) or (ckot=68) then //
     if (taka(FORMS[I+1])<>taka(astem+kk+ifs(curlka.vahva=false,alopv,'')
     +wmid+si.ending)) then color:='red' else color:='green';//
     if (NKOT=68) OR (color='red') then writeln(alopv,'\\' //'<span>'// [',i,si.vv,si.hv
      ,') &nbsp;&nbsp;<b style="color:',color,'"> ',forms[i+1],'&nbsp;&nbsp;[',
      astem+kk+ifs((curlka.vahva=false),alopv,'')+wmid+si.ending+']</b>&nbsp;&nbsp; </b>');
     if (NKOT=68) OR (color='red') then
      writeln('=?',stem,'!',astem,' [',kk,']</b>?',alopv,'?(',wmid,')[',si.ending,']_',lopvok,
      ' {',i,'/',inttostr(si.vparad), '<b>[',curlka.mids[si.vparad],']</b>''/',inttostr(si.hparad), '<b>[',curlka.mids[si.hparad],']</b>} ');
      {writeln('<span style="color:',color,'">'// [',i,si.vv,si.hv
       ,' (',inttostr(si.vparad),'/',inttostr(si.hparad),
       ') &nbsp;&nbsp;<b> ',forms[i+1],'&nbsp;&nbsp; </b><em>',astem+kk+ifs(lknum<>2,alopv,'')+wmid+si.ending+'&nbsp;&nbsp; </em><b> ',
       '=',stem,'/',astem,' [',kk,']</b>',ifs(lknum<>2,alopv,''),'|(',wmid,')+',si.ending,']_',lopvok)
       // else   if astem<>aalku then  writeln(' <em>',i,'?',stem,'</em>/',astem,'[',kk,']'+ifs(lknum<>2,'|'+alopv,'')+wmid+si.ending)
       }
    except write('<h1>fail!</h1>',i);raise;end;
   end;
   writeln('<b>! </b>');
 end;
 close(fo);
 writeln('<hr>lopvoks');
 for i:=1 to luokkia do
 if not ttaivlka(luokat[i]).vahva then writeln('<li>',i+50,' <b>',ttaivlka(luokat[i]).mids[1],'</b> ',lopvokst[i],' ',lopkonst[i],ttaivlka(luokat[i]).hasav,'/',ttaivlka(luokat[i]).hasmaft);
 writeln('<table border="1">');
 for i:=1 to 78 do
 begin
   writeln('<tr><td>',yhtlopsall[i],'</td>');
   for j:=1 to 30 do
   begin
      writeln('<td title="',j+50,'">',100*errs[j,i] div (wcount[j]+1),' ');
      //if j mod 10=1 then writeln('<b>',j+50,'</b>');
      writeln('</td>');
   end;
   writeln('</tr>');
 end;
end;
procedure tstemmer.generate;  //lopussa versio jolla laskettiin n‰‰, nyt raaka toteutus

var curlka:ttaivlka;i,mm:word;myforms:array[1..12] of ansistring;

procedure teeluokat;
var lk,mu:integer;mm:word;
begin
  //curlka:=tluokka.create(i+51); //luokat.add(curlka);  //one empty to get 1-base .. no,  there is a unneeded 009-class
 for lk:=0 to 28 do
 begin
   curlka:=ttaivlka.create(lk+50);
   curlka.expl:=explain(lk+50);
   luokat.add(curlka);
   curlka.num:=lk;
   curlka.kotus:=lk+51;
   if lk+51<64 then curlka.vahva:=true else  curlka.vahva:=false;
   if lk+51>=76 then curlka.vahva:=true;

   if (lk+51  in [59,60,62,63,64,65,68,69,70,71,77]) then curlka.hasav:=false else curlka.hasav:=true;
   if lk+51 in [66,67,72,74,75] then curlka.hasmaft:=true else curlka.hasmaft:=false;
   mm:=0;
   writeln('<li>');
   for mu:=1 to 12 do    //if not  (mu in [1,2,4,09,11,17,18,27,54,63,70,78]) then continue else
   begin      //mm:=mm+1;
     curlka.mids[mu]:=mids[lk+1,mu];
     writeln(mu,curlka.mids[mu],'/ ');
   end;
  end;
end;

var nkot,ckot,lknum:word;

procedure uusluokka;var ii,len,mm:word;outo:boolean;
      begin  try
        lknum:=lknum+1;
        writeln('</table><h1>',nkot,'   ',forms[0],forms[i],':',copy(lopvokst[lknum],lknum,1),'!</h1>');
        if lknum>=luokat.count then exit;
        curlka:=ttaivlka(luokat[lknum]);
        curlka.example:=forms[1];
        curlka.expl:=explain2(forms[0]);
//!        writeln('<table border="1">');
      finally
      end;
 end;

var mu,te,maksiv,maksih:word;sijapaat: array[1..12] of ansistring;
 color,style,av,ah,stem,mystem,lopvok,kk,wmid,lkon,xvok,hits,misses,atpl:ansistring;
 ast:taste;
 templates:tstringlist;simmuodotv,simmuodoth: array[1..3] of array[1..78] of array[1..12] of word;vmuoto2tpl,hmuoto2tpl:array[1..78] of byte;
 a:word;olijo,muva,ishit:boolean;
begin
 for i:=1 to luokkia do
   begin writeln('<li>',i+50,',');
   for mu:=1 to 11 do
     write(mids[i,mu],',',ifs(mu=6,'X,',''));
   end;
 writeln('<hr>');
 templates:=tstringlist.create;
 teeluokat;
 fillchar(simmuodotv,sizeof(simmuodotv),#0);
 fillchar(simmuodoth,sizeof(simmuodoth),#0);
 ckot:=0;mm:=0;
 for i:=1 to 72 do
  if not (i+1 in [2,3,5,10,12,13,18,19,28,55,64,71]) then continue else
 begin
  mm:=mm+1;
  sijapaat[mm]:=yhtlopsall[i];
 end;
 write('<hr/>',luokat.count,'*');
 lknum:=0;
 readline;
 readline;
 mm:=0;
 WHILE NOT EOF DO
 BEGIN
  templates.clear;
  forms.clear;
   readline;
   if eof then break;
   if forms.count<10 then continue;
   nkot:=strtointdef(copy(forms[0],3,2),0);
   if nkot<>ckot then uusluokka;
   ckot:=nkot;
   //if nkot<=62 then continue;
   //try
   mm:=0;
   for i:=1 to 72 do
   if not (i+1 in [2,3,5,10,12,13,18,19,28,55,64,71]) then continue else
   begin
    mm:=mm+1;
    myforms[mm]:=forms[i+1];
   end;
   //except writeln('###########');end;
   //forms.delete(1);
   ast:=getastekons(forms[0][5],av,ah);
   //if length(av)>0 then continue;
   if pos('#',curlka.mids[1])>0  then  lkon:=myforms[1][length(myforms[1])-1] else lkon:=''; //ad hoc. only for V067
   curlka.pilko(taka(myforms[1]),curlka.mids[1],av,ah,sijapaat[1],stem,lopvok,kk);

//!   writeln('<tr><td>',av,ah,':',stem,':');
//!   write('</td><td>',forms[0],' =',stem,' <b>[',av,ah,']</b>',lopvok,'|'+sijapaat[1],' -',lkon,' ',forms[1],' </td>');//,forms[1],': ');
   for mu:=1 to 12 do
   begin   //move this to func tluokka.getmuoto tms
     wmid:=stringreplace(curlka.mids[mu],'*' ,lopvok,[rfReplaceAll]);
     wmid:=stringreplace(wmid,'#',lkon,[rfReplaceAll]);
     if (curlka.vahva)  then if mu in [2,4,6,8] then kk:=ah else kk:=av;
     if (not curlka.vahva)  then if mu in [2,3,6,7,10] then kk:=av else kk:=ah;
     mystem:=stem;
     if curlka.vahva then  xvok:='' else xvok:=lopvok;
     while pos('-',wmid)=1 do begin delete(wmid,1,1);if kk<>'' then kk:='' else if xvok<>'' then delete(xvok,length(xvok),1) else delete(mystem,length(mystem),1);end;
     if taka(myforms[mu])=mystem+kk+xvok+wmid+sijapaat[mu] then color:='green' else color:='red';
      if pos('/',myforms[mu])>0 then
      begin
        if pos(mystem+kk+xvok+wmid+sijapaat[mu], taka(myforms[mu]))>0 then color:='black' else
        color:='orange';
      end;
      //templates.add(mystem+'*'+'*'+wmid);
      templates.add(mystem+'X'+xvok+wmid);
      //writeln('<td>',stringreplace(templates[te-1],'X',ifs(i=1,ah,av),[rfReplaceAll]),'</td>');
  //    write('<td style="color:',color,'">',myforms[mu],'<br/>=',  mystem+'.'+kk+'|'+xvok+'('+curlka.mids[mu]+')',sijapaat[mu],'</td> ');
    //  write('<td style="color:',color,'">',mu,myforms[mu],'<br/>',mystem+'<b>',kk,'-',xvok, '</b>(',wmid,')<em>',sijapaat[mu],'</em></td> ');
   end;
   //writeln('<li>');
   //for mu:=0 to 11 do write(templates[mu],' ');
   //writeln('</tr><tr>');
//   writeln('<td>',length(av),av,'</td><td style="color:purple">');
   //for te:=0 to templates.count-1 do
   //  write(te,templates[te],'<br/>');
   //write('<td>',te,copy(templates[te],length(stem)+1),'</td>');
//   write('</td>');
    //if  curlka.vahva then continue;
   //if not curlka.vahva then continue;
   for mu:=2 to min(muotoja,forms.count-1) do  //kay l‰pi kaikki muodot ja vertaa jokaista 12 templaattiin
   begin
    hits:='';
    misses:='';
    if pos('/',forms[mu])>0 then continue;
    olijo:=false;
    for te:=0 to templates.count-1 do
     //for i:=1 to 2 do
     begin
      try
          //atpl:=stringreplace(templates[te],'X',ifs(i=1,ah,av),[rfReplaceAll]);
        if curlka.vahva then if te+1 in [2,4,6,8] then i:=2 else i:=1;// i:=1 else i:=2;// muva:=false else muva:=true;
        if not curlka.vahva then if te+1 in [2,3,6,7,10] then i:=1 else i:=2;// muva:=true else muva:=false;
        atpl:=stringreplace(templates[te],'X',ifs(i=1,av,ah),[rfReplaceAll]);
        //write('<td><b>',yhtlopsall[mu-1],' </b> ',atpl,'.',av,ah,'|',mu-1,'</td>');
        //write(atpl,':');
        IF NKOT=58 THEN IF mu=28 THEN writeln('<li>',forms[mu],'=',  atpl+'|',yhtlopsall[mu-1]);
        if  (taka(forms[mu])=atpl+yhtlopsall[mu-1]) then //hits:=hits+'+';
        begin  //hits:=hits+templates[te]+'|'+yhtlopsall[mu-1]+'<br>';
          //IF NKOT=58 THEN IF mu=28 THEN writeln('<li><b>',forms[mu],'=',  atpl+'|',yhtlopsall[mu-1],'</b>');
          olijo:=true;
          if av='' then
          begin
           //IF write(' .',i,',',mu-1,',',te+1,'<br>')
             if curlka.vahva then simmuodotv[3,mu-1,te+1]:=simmuodotv[3,mu-1,te+1]+1
             else simmuodoth[3,mu-1,te+1]:=simmuodoth[3,mu-1,te+1]+1;
          end
          else
          begin hits:=hits+inttostr(te)+'|';
            //if curlka.vahva then
           if curlka.vahva then simmuodotv[i,mu-1,te+1]:=simmuodotv[i,mu-1,te+1]+1
           else                 simmuodoth[i,mu-1,te+1]:=simmuodoth[i,mu-1,te+1]+1;
           //  simmuodotv[i,mu-1,te+1]:=simmuodotv[i,mu-1,te+1]+1;
          //   write(' +',i,',',mu-1,',',te+1,' ','<br>');
             //else
             //begin simmuodoth[mu,te+1]:=simmuodoth[mu,te+1]+1;
           end;// else         begin             simmuodoth[i,mu,te]:=simmuodoth[i,mu,te]+1;
        // if av<>'' then if mu<6 then if te<3 then begin write(' [',i,' ',mu-1,' ',te+1); writeln(atpl,'.',yhtlopsall[mu-1],'<b> ',(forms[mu]),' </b> ', simmuodotv[i,mu-1,te+1],'] ');end;
        end;// else //misses:=misses+'<br>'+templates[te]
      //  write('-',atpl+yhtlopsall[mu-1]);//(' +',i,',',mu-1,',',te+1,' ','<br>');
         //end;// else writeln(' -',te);
      except writeln('<td>!!!!!!!!!!!!!!!!!!</td>'); end;
     //end;
     if av='' then break;
    end;
   // write('</td>');

  {   if hits<>'' then
    writeln('<td>',mu,' ',hits,'</td>')
    else if pos('/',forms[mu])>0 then
    writeln('<td>!</td>')
    else  writeln('<td><b>',mu,forms[mu],'</b><br> ',misses+'<br>'+yhtlopsall[mu-1],'</td>')
    }


   end;
   writeln('</tr>');
 end;
 //listluokat;
for a:=1 to 2 do
 begin
   mm:=0;
   OLIJO:=FALSE;
   write('<h1></h1><hr/><table border="1">');
   if a=2 then  for te:=1 to 12 do for mu:=1 to muotoja  do for i:=1 to 3 do simmuodotv[i,mu,te]:=simmuodoth[i,mu,te];
   for i:=1 to 78 do
   begin
       //if not (i in [2,3,5,10,12,13,18,19,28,55,64,71]) then continue else
     maksiv:=0;
     maksih:=0;
     for te:=1 to 12 do if simmuodotv[1,i,te]>maksiv then maksiv:=simmuodotv[1,i,te];
     for te:=1 to 12 do if simmuodotv[2,i,te]>maksih then maksih:=simmuodotv[2,i,te];
     maksiv:=max(maksih,maksiv);
     //writeln('<tr><td><b>',i,' ',yhtlopsall[i],' ',maksiv,' ',maksih,'</b></td>');
     //for te:=1 to 12 do writeln('<td>',simmuodotv[1,i,te],'/',simmuodotv[2,i,te]);;
     writeln('<tr><td><b>',i,' ',yhtlopsall[i],' ',maksiv,' ',maksih,'</b></td>');
     vmuoto2tpl[i]:=0;hmuoto2tpl[i]:=0;
     olijo:=false;
     for te:=1 to 12 do
     begin
      {muva:=true;
      if (a=1) and (te in [2,4,6,8]) then muva:=false else muva:=true;
      if (a=2) then if (te in [2,3,6,7,10]) then muva:=true else muva:=false;
      if (1=0) and olijo then
      begin
          writeln('<td style="color:#2aa">',a,te,ifs(muva,'*',''),simmuodotv[1,i,te], '/',simmuodotv[2,i,te], '/',simmuodotv[3,i,te],'</td>');
          continue;
      end;}
      style:='';ishit:=false;if olijo then style:='color:green;';
      //if not olijo  then
      begin
       if (simmuodotv[1,i,te]>maksiv-5) then
        begin
           ishit:=true;
           if vmuoto2tpl[i]=0 then
           begin
             vmuoto2tpl[i]:=te;style:=style+'background:pink;';
           end;
        end;
       //if muva then
        if (simmuodotv[2,i,te]>maksiv-5) then
        begin
           ishit:=true;
           if vmuoto2tpl[i]=0 then
           begin
              vmuoto2tpl[i]:=te;
           end;
           style:=style+'border:5px solid black;';
        end;
        if (not ishit)  then  style:='color:gray' else olijo:=true;
        //begin olijo:=true;end;
       end;//writeln('<td>',i,'=',muoto2tpl[i],'<td>');
     writeln('<td style="',style,'">',ifs(muva,'*',''),simmuodotv[1,i,te], '/',simmuodotv[2,i,te], '/',simmuodotv[3,i,te],'</td>');
     end;
      //writeln('<td>',ifs(simmuodot[i,te]>250,inttostr(simmuodot[i,te]),''),'</td>');
     //mm:=1;
     if (i+1 in [2,3,5,10,12,13,18,19,28,55,64,71]) then
     begin
      mm:=mm+1;
      writeln('<tr><td>',mm,sijapaat[mm],'</td>');
     for te:=1 to 12 do  begin
      writeln('<td style="background:#ddd">',te,' ',sijapaat[te]);
      if a=1 then  writeln(' ',te in [2,4,6,8]) else
      writeln(' ',te in [2,3,6,7,10]);

      writeln('</td>'); end;
     end;
     //end;
     writeln('</tr>');
   end;
   writeln('</table>');
   for i:=1 to 78 do writeln('<li>',i,yhtlopsall[i],'=',vmuoto2tpl[i]);//,templates[muoto2tpl[i]]);
   writeln('<hr>');
   for i:=1 to 12 do
   begin
      writeln('<li>',i,':',  i in [2,3,6,7,10]);
      for mu:=1 to 78 do  if vmuoto2tpl[mu]=i then writeln(' ',mu);//,':',yhtlopsall[mu]);
   end;

   for mu:=1 to 78 do begin
    if a=1 then sijat[mu]:=tsija.create((mu<63) or (mu>76),vmuoto2tpl[mu],mu)
    else   begin
     sijat[mu].hparad:=vmuoto2tpl[mu];
     sijat[mu].hv:=vmuoto2tpl[mu] in [2,3,6,7,10];
    end;
   write('.',mu);
  end;


 end; //A 1..2  : ERI TAULUT VAHVOILLE JA HEIKOILLE
writeln('<table border="1"><tr>');
writeln('</tr>');
for mu:=1 to 78 do begin
  if mu mod 10=1 then
  begin writeln('<td></td><td></td>');
   for i:=1 to luokkia-1 do writeln('<td>',i+51,'<b>',xmps[i-1],'</b></td>');
  end;
  writeln('<tr>');//<td>',mu,'</td> ');
   sijat[mu].list(self);
   writeln('</tr>');
 end;
writeln('<table><hr><ul>');
for mu:=1 to 78 do
 sijat[mu].save(mu,self);
end;

{
emme=ut
imme=i

}

{procedure uusluokka;var ii,len,mm:word;outo:boolean;
      begin  try
       //midsb:=midsb+','+inttostr(50+lknum)+':'+amidb;
       writeln('</table><table border="1">');
       lknum:=lknum+1;
       writeln('</table>');//<table border="1">');
       inlk:=0;
       //writeln('</li><li>',lknum+50,' ');
       prevast:='x';
       prevlk:=lk;
       amids:=',';
       curlka:=tluokka.create(lknum);
       if (lknum=1) or (lknum=2) or (lknum+50=63) then
       for ii:=1 to 30 do begin  //lasketaan erikseen vahv ja heik luokille
         theikot[ii]:=0;thudit[ii]:=0;tvahvat[ii]:=0;teiav[ii]:=0;
      end;
       for ii:=1 to 30 do begin  //lasketaan erikseen vahv ja heik luokille
           heikot[ii]:=0;hudit[ii]:=0;vahvat[ii]:=0;eiav[ii]:=0;
      end;
       if (lknum+50  in [59,60,62,63,64,65,68,69,70,71,77]) then curlka.hasav:=false else curlka.hasav:=true;
       if lknum+50 in [66,67,72,74,75] then curlka.hasmaft:=true else curlka.hasmaft:=false;
       curlka.expl:=explain(forms[0]);
       curlka.example:=(forms[1]);
       //move(mids[lknum],curlka.midsbef ,sizeof(mids[lknum]));
       luokat.add(curlka);
       writeln('<h4>',copy(forms[0],3,2),':',mids[lknum,1],'/',mids[lknum,3],'/',explain(forms[0]),curlka.hasmaft,curlka.hasav,'</h4><li>');//,'</h3>',lknum+50,' ',forms.commatext);
       for ii:=1 to muotoja-10 do
        begin
         curlka.midsbef[ii]:=mids[lknum,ii];
         //write(mids[lknum,ii],ii,' ');
        end;

       writeln('luokkia:',luokat.count,'_',curlka.num,'_',lknum,'<table border="1"><tr><td colspan="5">');
       mm:=0;
       for ii:=1 to muotoja-2 do
        if not (ii+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
        begin
         mm:=mm+1;
         writeln('<td>',mids[lknum,mm],'|',yhtlopsall[ii],'</td>');
        end;
       writeln('</tr>');
       except writeln('<li><em>???????',forms[1],'</em></li>');end;

     end;
}

{begin
writeln('findstems<ul>');
curlka:=nil;
while not eof do
begin
   forms.clear;
   readline;
  mm:=0;
for i:=1 to muotoja-2 do
 if not (i+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
 begin
      mm:=mm+1;
      myforms[mm]:=forms[i];
  end;
end;
end;
}

procedure tstemmer.findstems;  //lopussa versio jolla laskettiin n‰‰, nyt raaka toteutus
var alt,lu,mu,elen,lk,prevlk,lknum,mknum,inlk,lopslen,j:word;
 lopslen2,avpos,x:integer;
 stem,prevast,midsa,midsb,amidb,avahva,aheikko,vmuoto,pmuoto,tform,tform3,amids,color,lvok,lkon,mymid:ansistring;
 //hasav,hasmidb:boolean;
 ast:taste;
 curlka:ttaivlka;
 heikot,vahvat,hudit,eiav:array [1..30] of word;
 theikot,tvahvat,thudit,teiav:array [1..30] of word;
 function mats(a,b:ansistring):boolean;
 var i:word;
 begin
 result:=false;
  if length(a)<>length(b) then exit;
  for i:=1 to length(a) do
   if a[i]<>b[i]
    then if pos(b[i],'#*')<1 then exit;
 result:=true;

 end;
 procedure dwrd;var ii,len:word;
var valku,halku,muu,lkloppu,x,theikko:ansistring;heikkoko,huti:boolean;mm:word;
begin
  writeln('<tr><td style="color:',color,'">',tform,'</td><td> ',stem,'</td><td>',avahva,aheikko,'</td><td><b>+'+lvok,'</b></td><td style="border-right:3px solid black">',mids[lknum,1]+' </td>');
  //writeln('<td><b>',lvok,'/',lkon,'</b></td>');
  mm:=0;
  for ii:=1 to muotoja-2 do
   if not (ii+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
  begin

   mm:=mm+1;
   mymid:=stringreplace(mids[lknum,mm],'*',lvok,[rfReplaceAll]);
   mymid:=stringreplace(mymid,'#',lkon,[rfReplaceAll]);
   if lknum+50<64 then lkloppu:='' else lkloppu:=lvok;
   valku:=stem+avahva+lkloppu;
   halku:=stem+aheikko+lkloppu;
   lkloppu:='';
   while pos('-',mymid)=1 do
    begin
     delete(valku,length(valku),1);
     delete(halku,length(halku),1);
     delete(mymid,1,1);
     //writeln('<td>>X',valku,'/',halku,'</td>');
    end;
    if pos('/',forms[ii+1])>0 then forms[ii+1]:=copy(forms[ii+1],pos('/',forms[ii+1])+1);
    //valku:=copy(aheikko,1,length(aheikko)-1);mymid:=copy(mymid,2);end else theikko:=aheikko;
   heikkoko:=false;huti:=false;
   //vsana:=mats(taka(forms[ii+1]),stem+aheikko+lkloppu+mymid+yhtlopsall[ii])
   len:=length(mids[lknum,mm])+length(yhtlopsall[ii]);
     valku:=valku+''+lkloppu+mymid+''+yhtlopsall[ii];
     halku:=halku+''+lkloppu+mymid+''+yhtlopsall[ii];
     if taka(forms[ii+1])=halku then heikkoko:=true else
     if taka(forms[ii+1])=valku then heikkoko:=false else huti:=true;
      if huti then inc(hudit[mm]) else if avahva=aheikko then inc(eiav[mm]) else if heikkoko then heikot[mm]:=heikot[mm]+1 else inc(vahvat[mm]);
     //!if huti then color:='red' else if heikkoko then color:='blue' else color:='green';
     //!if mats(taka(forms[ii+1]),stem+theikko+lkloppu+mymid+yhtlopsall[ii]) then heikkoko:=true else
     //!if mats(taka(forms[ii+1]),stem+avahva+lkloppu+mymid+yhtlopsall[ii]) then heikkoko:=false else huti:=true;
     if huti then color:='red' else if heikkoko then color:='green' else color:='blue';
     writeln(' <td style="color:',color,'">',forms[ii+1]);
     if (huti) or (lknum+50=76) then writeln('\ ',valku,'\ ',halku,heikkoko,color);
     {if pos('*',mids[lknum,mm])>0 then write('*X');
     if pos('#',mids[lknum,mm])>0 then write('#X');
     if pos('-',mids[lknum,mm])>0 then write('-X');][}
     writeln('</td>');
     continue;
     //if tform=stem+aheikko+lvok+mymid+'a' then color:='blue' else color:='red';
     //if taka(forms[ii+1])=taka(copy(forms[ii+1],1,length(forms[ii+1])-len)+mids[lknum,ii]+yhtlopsall[ii]) then color:='black' else color:='red';
     //if mats(taka(forms[ii+1]),taka(copy(forms[ii+1],1,length(forms[ii+1])-len)+mids[lknum,ii]+yhtlopsall[ii])) then color:='black' else color:='red';
     //      if pos('/',forms[ii+1])>0 then color:='blue';
           //!!writeln(' <span style="color:',color,'">',taka(forms[ii+1]),'=',stem+'<b>'+ifs(heikkoko,aheikko,avahva)+'</b>!'+lkloppu+'.'+mymid+'\',yhtlopsall[ii]+'</span> ');
           //writeln(' <span style="color:',color,'">',copy(forms[ii+1],1,length(forms[ii+1])-len),'<b title="',forms[ii+1],'">',mids[lknum,ii],'</b>|',yhtlopsall[ii],'</span> ');
           //writeln(' <li><span style="color:',color,'">',taka(forms[ii+1]),'=',stem+'|'+'<b>'+avahva+'</b>!'+lkloppu+'.'+mymid+'\'+yhtlopsall[ii]+'</span>_',valku,'_&nbsp;');
           //writeln(' <em>',stem+'<b>'+theikko+'</b>!'+lkloppu+'.'+mymid+'\',yhtlopsall[ii]+'</em> <b>! ',mids[lknum,mm],'</b>'+stem+theikko+lkloppu+mymid+yhtlopsall[ii],' _',halku,'_');
  //         writeln(' <li><span style="color:',color,'">',taka(forms[ii+1]),'=',stem+'|'+'<b>'+avahva+'</b>!'+lkloppu+'.'+mymid+'\'+yhtlopsall[ii]+'</span>_',valku,'_&nbsp;');
  //         writeln(' <em>',stem+'<b>'+theikko+'</b>!'+lkloppu+'.'+mymid+'\',yhtlopsall[ii]+'</em> <b>! ',mids[lknum,mm],'</b>'+stem+theikko+lkloppu+mymid+yhtlopsall[ii],' _',halku,'_');
       end;
end;
procedure uusluokka;var ii,len,mm:word;outo:boolean;
      begin  try
       //midsb:=midsb+','+inttostr(50+lknum)+':'+amidb;
       writeln('</table><table border="1">');
        mm:=0;

       for ii:=1 to muotoja-2 do
        if not (ii+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
        begin
          mm:=mm+1;
          outo:=(heikot[mm]>=vahvat[mm])<>(theikot[mm]>=tvahvat[mm]);
          theikot[mm]:=theikot[mm]+heikot[mm];
          tvahvat[mm]:=tvahvat[mm]+vahvat[mm];
          teiav[mm]:=teiav[mm]+eiav[mm];
          thudit[mm]:=thudit[mm]+hudit[mm];
          writeln('<tr><td>', ' ',mids[lknum,mm],yhtlopsall[ii],'</td><td>',forms[ii+1],'</td>',
          '<td style="color:black">',teiav[mm],'+',eiav[mm],' </td>',
          '<td style="color:blue">',tvahvat[mm],'+',vahvat[mm],' ',mm,' </td>',
          '<td style="color:green">',theikot[mm],'+',heikot[mm],' </td>',
          '<td style="color:red">',thudit[mm],'+',hudit[mm],' </td><td>',ifs(outo,'####',''),'</td></tr>');
        end;
       if curlka<>nil then curlka.midsaft[1]:=(amids+'!');
       lknum:=lknum+1;
       writeln('</table>');//<table border="1">');
       inlk:=0;
       //writeln('</li><li>',lknum+50,' ');
       prevast:='x';
       prevlk:=lk;
       amids:=',';
       curlka:=ttaivlka.create(lknum);
       if (lknum=1) or (lknum=2) or (lknum+50=63) then
       for ii:=1 to 30 do begin  //lasketaan erikseen vahv ja heik luokille
         theikot[ii]:=0;thudit[ii]:=0;tvahvat[ii]:=0;teiav[ii]:=0;
      end;
       for ii:=1 to 30 do begin  //lasketaan erikseen vahv ja heik luokille
           heikot[ii]:=0;hudit[ii]:=0;vahvat[ii]:=0;eiav[ii]:=0;
      end;
       if (lknum+50  in [59,60,62,63,64,65,68,69,70,71,77]) then curlka.hasav:=false else curlka.hasav:=true;
       if lknum+50 in [66,67,72,74,75] then curlka.hasmaft:=true else curlka.hasmaft:=false;
       curlka.expl:=explain2(forms[0]);
       curlka.example:=(forms[1]);
       //move(mids[lknum],curlka.midsbef ,sizeof(mids[lknum]));
       luokat.add(curlka);
       writeln('<h4>',copy(forms[0],3,2),':',mids[lknum,1],'/',mids[lknum,3],'/',explain2(forms[0]),curlka.hasmaft,curlka.hasav,'</h4><li>');//,'</h3>',lknum+50,' ',forms.commatext);
       for ii:=1 to muotoja-10 do
        begin
         curlka.midsbef[ii]:=mids[lknum,ii];
         //write(mids[lknum,ii],ii,' ');
        end;

       writeln('luokkia:',luokat.count,'_',curlka.num,'_',lknum,'<table border="1"><tr><td colspan="5">');
       mm:=0;
       for ii:=1 to muotoja-2 do
        if not (ii+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
        begin
         mm:=mm+1;
         writeln('<td>',mids[lknum,mm],'|',yhtlopsall[ii],'</td>');
        end;
       writeln('</tr>');
       except writeln('<li><em>???????',forms[1],'</em></li>');end;

     end;

begin
  writeln('findstems<ul>');
  curlka:=nil;
  while not eof do
  begin
     forms.clear;
     readline;

     if eof then break;
     if forms.count<2 then continue;
     if forms[1]='kerit‰' then continue;
     lk:=strtointdef(copy(forms[0],3,2),0);
     if lk<>prevlk then uusluokka;
     avpos:=0;
     ast:=getastekons(forms[0][5],avahva,aheikko);
     //writeln('<li>%',forms[0],forms[1],ast.f,'-',ast.t,'#');
     tform:=taka(forms[1]);
     tform3:=taka(forms[3]);
     //lastkons(copy(tform,1,length(tform)-1-length(mids[lknum,1])),lopslen2);
     //lopslen2:=length(tform)-lopslen2;
     if lknum+50<64 then
     begin     //****************** vahvan vaihtelun luokat
        //if hasav then
       lopslen:=length(avahva+mids[lknum,1])+1;
        if avahva='' then
        if pos(tform[length(tform)-lopslen],konsonantit)>0 then
        begin avahva:=(tform[length(tform)-lopslen]);aheikko:=avahva;end;
        lopslen:=length(avahva+mids[lknum,1])+1;
        if avahva='!' then writeln('<li>!!:',tform,lopslen);
        //if lknum+50=62 then lopslen:=lopslen-2;
        stem:=copy(tform,1,length(tform)-lopslen);//(length(avahva)-length(aheikko)-1));
        lkon:='';//lastkons(tform[length(tform)-lopslen],x);
        //lvok:=tform[length(tform)-1];
        lvok:=lastvowel(copy(tform,1,length(tform)-1),avpos);
        mymid:=stringreplace(mids[lknum,1],'*',lvok,[rfReplaceAll]);
        pmuoto:=stem+avahva+mymid+'a';//+'|'+avahva+mids[lknum,1]+'a';
         if tform=pmuoto then color:='blue' else color:='red';
//         writeln('<li style="color:',color,'">',tform,' ',stem,'|<b>(',avahva,')</b>[',mymid+']a /');
         mymid:=stringreplace(mids[lknum,2],'*',lvok,[rfReplaceAll]);
         vmuoto:=stem+aheikko+mymid+'n';//+'|'+avahva+mids[lknum,1]+'a';
         if taka(forms[3])=vmuoto then color:='green' else color:='purple';
//         writeln('<span style="color:',color,'">',forms[3],' ',stem,'|<b>!',aheikko,'</b>[',mymid+']n ',mymid,' ',vmuoto,'</span>');
//         writeln('<span style="font-size:1em;color:white;background:',ifs(pos(lvok,mymid)>0,'green','red'),'">&nbsp;',lvok,length(avahva),length(aheikko),lopslen,'</span>');
     end else
     begin  //****************** heikon vaihtelun luokat
        if pos('/',forms[3])>1 then delete(tform3,1,pos('/',forms[3]));
        lvok:='';
        lkon:=tform[length(tform)-1];
        mymid:=stringreplace(mids[lknum,1],'#',lkon,[rfReplaceAll]);
        lopslen2:=length(mymid)+length(avahva)+1;
        if (curlka.hasav) then //and (curlka.hasmaft) then
        begin
          if curlka.hasmaft then //IF AST.T='' THEN LVOK:='*' ELSE
          for j:=1 to min(2,length(aheikko)+1) do
             if (pos(tform[length(tform)-length(mymid)-j],vokaalit)<1) then break
             else lvok:=tform[length(tform)-length(mymid)-j]+lvok;
          lopslen2:=length(mymid)+length(aheikko)+length(lvok)+1;
        end ;//jos luokassa ei AV, yhteisp‰‰tteess‰ on xtravokaalit mukana
        if lknum+50=64 then lvok:=lastvowel(copy(tform,1,length(tform)-1),lopslen2);
        STEM:= copy(taka(forms[1]),1,length(tform)-lopslen2);  //luk
        if tform=stem+aheikko+lvok+mymid+'a' then color:='blue' else color:='red';
        mymid:=stringreplace(mids[lknum,2],'#',lkon,[rfReplaceAll]);
        if tform3=stem+avahva+lvok+mymid+'n' then color:='green' else color:='red';
  //      writeln('<span style="color:',color,'">',tform3,' ',stem,'|<b>',avahva,'</b>/',lvok,'[',mymid+']n  (',lvok,') ',
 //       ' <b>',ast.f,'_',ast.t,'_',lopslen2,'  ',lvok,'</b>');
 //       writeln('<span style="font-size:1em;color:white;background:',ifs(length(lvok)=1,'green','red'),'">&nbsp;',lvok,'</span>');
    end;
     //writeln('<tr><td style="color:',color,'">',tform,'</td><td> ',stem,'</td><td>',avahva,'</td><td>',aheikko,'</td><td>'+lvok,'</td><td>',mids[lknum,1]+'|a</td>');

     dwrd;
     writeln('</tr>');
     if length(amidb)<2 then amids:=amids+amidb+',' else amids:=amids+'<b style="color:red">'+amidb+'</b>,';
  end;
  writeln('<hr><hr><hr>');
  listluokat;
  writeln('<hr><hr><hr>');
end;

procedure tstemmer.oldfindstems;
var alt,lu,mu,elen:word;
stl,all,tuplat:tstringlist;
yhtalku:ansistring;
lknum,len,inlk,lk,prevlk,lopslen,avpos:integer;
prevast,tfor,stem,stem2,stem3,color,title,amid,tmid,tmids,tform,lkon,lvok,avahva,aheikko:ansistring;
lvoks,lkons:array[0..80] of ansistring;
alts:tstringarray;
ast:taste;lpos,cutp:integer;
tuplacounts:array[0..80] of word;
hit,hasav,hasmid:boolean;
procedure tupla(muo:word;amid:ansistring);
begin            try
  if muo>muotoja then exit;
  if pos('/'+amid+'/',tuplat[muo])<1 then
  begin
    tuplat[muo]:=tuplat[muo]+amid+'/';
  end;
  tuplacounts[muo]:=tuplacounts[muo]+1;
except raise;end;
end;
begin


//writeln('********',endpos('kk','kaikkoan'));
//exit;
tuplat:=tstringlist.create;
  //for lu:=1 to luokkia  do
 lknum:=0;
 writeln('findstems');
 writeln('<table>');
   while not eof do
   begin
     forms.clear;
     readline;
     //writeln('findstems');
     if eof then break;
     if forms.count<2 then continue;
     //writeln(forms[1],' ');continue;
     if forms[1]='kerit‰' then continue;
     lk:=strtointdef(copy(forms[0],3,2),0);
     if lk<>prevlk then
     begin  try
       tmids:=tmids+','+inttostr(50+lknum)+':'+tmid;
       writeln('</table>');
       if lknum>1 then for mu:=2 to muotoja do        //if  (mu in [2,3,5,10,12,18,19,28,55,64,71]) then
        if tuplacounts[mu]>1 then write('<li>',yhtlopsall[mu-1],':',tuplat[mu],tuplacounts[mu]);
       lknum:=lknum+1;
//       if lknum+50=72 then for mu:=2 to forms.count-1 do  begin  if pos('ne',forms[mu])>1 then mids[lknum,mu-1]:=mids[lknum,mu-1]+'ne';write(mids[lknum,mu-1]+',');end;
//73,t,,,,,,,,t,t,nn,,,,,,,t,t,t,t,t,t,t,t,t,t,t,,,,,,,,,,,,,,,nn,t,t,,,t,,,,,,,,,,,,,t,t,t,t,,t,t,,,nn,nn,nn,nn,nn,nn,,
       if not (lknum+50  in [59,60,62,63,64,65,68,69,70,71,77]) then hasav:=true else hasav:=false;
       if lknum+50 in [66,67,72,74,75] then hasmid:=true else hasmid:=false;
       writeln('<li>',copy(forms[0],3,2),':',explain2(forms[0]));//,'</h3>',lknum+50,' ',forms.commatext);
       writeln('<table border="1">');
       inlk:=0;
       tuplat.clear;
       fillchar(tuplacounts,sizeof(tuplacounts),#0);
       for mu:=0 to muotoja do tuplat.add('/');
       prevast:='x';
       prevlk:=lk;
       except writeln('<tr><td><em>???????',forms[1],lvok,lkon,'</em></td></tr>');end;

     end;
     try
     ast:=getastekons(forms[0][5],avahva,aheikko);
     //if ast.a='_' then continue;
     //if length(ast.t)>0 then continue;
     except writeln('<tr><td><em>GEATASTE???????',forms[1],lvok,lkon,'</eb></td></tr>');end;
     try
     tform:=taka(forms[1]);
     {lvok:=taka(copy(tform,length(tform)-2,1));
     if pos(lvok,konsonantit)>0 then begin lvok:='';lkon:=copy(tform,length(tform)-1,1);end else
     begin
       lkon:=lastkons(copy(tform,1,length(tform)-length(mids[lknum,1])-1));
       //lkon:=copy(forms[1],length(tform)-2,1);
     end;}
     lkon:=lastkons(tform,avpos);
     tmid:='';
     if lknum+50<63 then
     begin
      //if hasav then
        if avahva='' then begin avahva:=lkon;aheikko:=lkon;end;
      //avpos:=length(tform)-length(MIDS[LKNUM,1])-length(avahva);
      //STEM:=copy(tform,1,avpos-1)+''+avahva+''+MIDS[LKNUM,1]+'a';
      //STEM2:=copy(tform,1,avpos-1)+''+aheikko+''+MIDS[LKNUM,3]+'n';
      lopslen:=length(avahva+mids[lknum,1])-1;
      if lknum+50=62 then lopslen:=lopslen-2;
      STEM:=copy(tform,1,length(tform)-lopslen)+'a';//+'|'+avahva+mids[lknum,1]+'a';
      STEM2:=copy(tform,1,length(tform)-lopslen)+'n';//+'|'+aheikko+''+mids[lknum,3]+'n';
      //STEM2:=copy(tform,1,length(tform)-length(mids[LKNUM,1])-length(avahva)-1)+''+aheikko+''+mids[lknum,3]+'n';
     end else
     begin
       //lkon:=lastkons(copy(tform,1,length(tform)-length(aheikko)-length(MIDS[LKNUM,1])),avpos);
       tform:=taka(forms[3]);
       //tform:=taka(forms[1]);
       //lkon:=lastkons(copy(tform,1,length(tform)-length(aheikko)-length(MIDS[LKNUM,1])-1),avpos);
       //avpos:=avpos-1;
       avpos:=endpos(avahva,tform)-1;//copy(tform,1,length(tform)-length(mids[lknum,3])));
       //if lknum+50=67 then avpos:=avpos+1;
       //if lknum+50=74 then avpos:=avpos-0;
       //avpos:=3;
       tmid:='';
       if hasmid then if ast.a<>'_' then
       begin
       tmid:=copy(tform,avpos+length(avahva)+1);
       tmid:=copy(tmid,1,length(tmid)-length(mids[lknum,3])-1);
       end;
       lopslen:=length(aheikko+mids[lknum,1]+tmid)+1;
       STEM:= copy(taka(forms[1]),1,length(forms[1])-lopslen)+''+aheikko+''+tmid+''+MIDS[LKNUM,1]+'a';
       STEM2:= copy(taka(forms[1]),1,length(forms[1])-lopslen)+''+avahva+''+tmid+''+MIDS[LKNUM,3
       ]+'n';
{       STEM:= copy(tform,1,avpos)+''+aheikko+''+tmid+''+MIDS[LKNUM,1]+'a';
       STEM2:=copy(tform,1,avpos)+''+avahva+''+tmid+''+MIDS[LKNUM,3]+'n';
       //elen:=3;
       if lknum+50=66 then elen:=4;
       //tmid:=tform[length(tform)-elen+1];
}     end;
     //STEM:=copy(tform,1,length(tform)-avpos)+MIDS[LKNUM,2];
     //STEM:=copy(tform,1,length(tform)-length(avahva)-length(MIDS[LKNUM,1])-1)+'|'+avahva+MIDS[LKNUM,1];

     //if lknum+50>62 then stem2:=STEM+''+aheikko+MIDS[LKNUM,2]+'a'
      //else stem2:=STEM+avahva+mids[lknum,2]+'a';//+inttostr(length(ast.f)-length(ast.t)+1);//+copy(stem2,a);  2/2>1 2/1>0 1/1>1

      if taka(forms[1])<>stem then color:='red' else color:='black';
         writeln('<tr style="color:'+color+'"><td>',length(mids[lknum,1])+length(avahva)+length(tmid),'<b>',length(forms[3])-avpos-1,
         ' </b> ',length(forms[3])-avpos-length(mids[lknum,1]),'</td><td>',ast.a,':  <b>',avahva,'\',aheikko,'</b></td><td>',forms[1],
          '</td><td><b>',stem,'</b></td><td>',MIDs[lknum,1],':',MIDs[lknum,3],'</td><td style="color:',ifs(taka(forms[3])=stem2,'blue','green')+'"><b>',stem2,'</b>: ',forms[3],
          '</td><td>'+':',copy(forms[1],1,avpos),';',copy(forms[1],1,length(forms[1])-lopslen),lopslen,
          '</td><td>'+copy(tform,1,avpos)+' <em>'+avahva+'<b>'+tmid+'</b>'+MIDS[LKNUM,3],'n','</em></td><td>',lopslen);//,'/ ',length(tform)-length(tmid)-lopslen2;'</td>');
       //  else
       //  writeln('<tr style="color:red"><td>',ast.a,':',avahva,'/',aheikko,'</td><td>',forms[1]
       //    ,'</td><td>st:[',stem,']</td><td>mid:',MIDs[lknum,2],'</td><td>st2:<b>',stem2,'</b></td><td>',avpos,'</td>');
      //write('<td>?',mids[lknum,1],'_',mids[lknum,2],'</td><td>{',copy(tform,1,length(tform)-length(mids[lknum,1])-1),'}</td>');
      //if taka(forms[3])=stem3+lkon+'n' then
      //writeln(' <td>|&nbsp; ',stem3+lkon,'</td><td>:',mids[lknum,1],' ','!',lkon,'?',avpos,forms[3],'</td></tr>')
      //else writeln(' <td style="color:red">|&nbsp; ',stem3,lkon,'</td><td>:',mids[lknum,1],' ',lknum+50,'!',lkon,'?',avpos,forms[3],'</td></tr>');
     //if avahva='' then begin avahva:=lkon;aheikko:=lkon;end;
     //if ast.f='' then begin ast.f:=lkon;ast.t:=lkon;end;

     writeln('</tr>');
CONTINUE;
     //writeln('<tr>');
      stem:=taka(copy(tform,1,length(tform)-length(mids[lknum,1])-length(yhtlopsall[1])));
      except writeln('<tr><td><em>stem???????',forms[1],lvok,lkon,'</eb></td></tr>');end;
    try
    for mu:=2 to length(yhtlopsall) do
     if pos('?',forms[mu])<1 then //if pos('/',forms[mu])<1 then
    begin  //just fior diagnost
      alts:=taka(forms[mu]).split('/');
      for alt:=0 to length(alts)-1 do
      //stem:=copy(taka(forms[mu]),1,getalku(stem,taka(forms[mu])));
      if pos(mids[lknum,mu-1]+yhtlopsall[mu-1],alts[alt])>1 then  //ignoroi "v‰‰r‰t" p‰‰tteet ollakseet, olemaisillaan (vs ollaksensa, olemaisillansa).. niist‰ tehd‰‰n myˆh omat muotonsa
       //if lknum+50=72 then if (length(alts)>1) and (alt=0) then continue else
       begin
         //if lknum+50=62 then writeln('<td>=',mids[lknum,mu-1],'|', stem,'</td>');
         stem:=copy(taka(alts[alt]),1,  //simplify, this cannot be read:
                getalku(stem,taka(copy(alts[alt],1,length(alts[alt])-length(mids[lknum,mu-1])-length(yhtlopsall[mu-1])))
                ,mids[lknum,mu-1]+'_'+yhtlopsall[mu-1]+'/'+alts[alt]+inttostr(length(alts[alt]))+inttostr(length(mids[lknum,mu-1]))));//,mids[lknum,mu]+'_'+yhtlopsall[mu-1]+'_'+inttostr(length(alts[alt])-length(mids[lknum,mu])-length(yhtlopsall[mu-1]))),forms[mu]);
      end;

      //stem:=copy(taka(forms[mu]),1,getalku(stem,taka(copy(forms[mu],1,length(forms[mu])-length(mids[lknum,mu])-length(yhtlopsall[mu-1]))),mids[lknum,mu]+'\'+yhtlopsall[mu-1]));
      //copy(forms[1],1,length(forms[1])-length(mids[lknum,1])-length(yhtlopsall[1]))
      //stem2:=copy(taka(forms[mu]),getalku(stem,taka(forms[mu]))+1);
    end;   except    writeln('<td>!!!!',stem,'</td><td>',forms[1],'<tr><td>',mids[lknum,1],'|',yhtloput[1],'</tr>');raise;  end;
    try
    //if lknum<63 then astia:=ast.f[length(ast.f)] else astia:=ast.t;
    //if avahva='' then stem2:=
      stem2:=copy(tform,1,length(tform)-length(lvok)-length(lkon)-1);
    //if ast.t='-' then ast.t:='';
    //if length(ast.f)=2 then ast.t:=ast.t[2];
     lastvowel(stem2,avpos);
       //if ast.a='_' then stem2:=stem2+
        // if lknum>62 then stem2:=copy(stem2,1,avpos-(length(ast.t)-length(ast.f))-2)+copy(ast.f,length(ast.f))+copy(stem2,avpos)
        // else stem2:=stem2+ast.t+lvok+inttostr(length(ast.f)-length(ast.t)+1);//+copy(stem2,a);  2/2>1 2/1>0 1/1>1
    //if lknum>62 then stem3:=copy(stem2,1,avpos-(length(aheikko)-length(avahva))-2)+avahva+copy(stem2,avpos)
    if lknum+50>62 then stem3:=copy(stem2,1,avpos-length(avahva)-2)+''+avahva+copy(stem2,avpos)
     else stem3:=copy(stem2,1,length(stem2)-LENGTH(avahva))+aheikko+''+lvok;//+inttostr(length(ast.f)-length(ast.t)+1);//+copy(stem2,a);  2/2>1 2/1>0 1/1>1
       if tform=stem2+lkon+lvok+'a' then
        writeln('<tr><td>',ast.a,':',avahva,'\',aheikko,'</td><td>',forms[1],'</td><td>',stem,'</td><td><b>',stem2,'</b></td><td>',lkon,'|',lvok,'</td>')
        else
        writeln('<tr style="color:red"><td>',ast.a,':',avahva,'/',aheikko,'</td><td>',forms[1],'</td><td>+',stem,'</td><td><b>',stem2,'</b></td><td>',lkon,'|',lvok,'</td>');
     write('<td>?',mids[lknum,1],'_',mids[lknum,2],'</td><td>{',copy(tform,1,length(tform)-length(mids[lknum,1])-1),'}</td>');
     if taka(forms[3])=stem3+lkon+'n' then
     writeln(' <td>|&nbsp; ',stem3+lkon,'</td><td>:',mids[lknum,1],' ','!',lkon,'?',avpos,forms[3],'</td></tr>')
     else writeln(' <td style="color:red">|&nbsp; ',stem3,lkon,'</td><td>:',mids[lknum,1],' ',lknum+50,'!',lkon,'?',avpos,forms[3],'</td></tr>');
    except writeln('<tr><td><em>???????',lknum,forms[1],lvok,lkon,'</em></td><td>:',mids[lknum,1],'</tr>');end;
    continue;
    {if (ast.f<>'') and  (prevast=ast.a) then begin inlk:=1; continue;end;  //tempuillaan sen kanssa paljonko n‰ytet‰‰n
    inlk:=inlk+1;
    prevast:=ast.a;}
    if inlk>2 then begin continue;end;  //vain yksi/astevaihtelutyyppi, paitsi vaihteluttomia 2
    //if inlk>1 then continue;
    //writeln('</tr>');                                                                  c

    writeln('<tr><td style="width:10em">',stem,'</td><td style="width:6em">',copy(forms[1],length(stem)+1),'</td>','</td><td style="width:6em"><b>',ast.f,'_',ast.t,'</b></td>');
    for mu:=2 to length(yhtlopsall) do //forms.count-2 do
    begin
     try
      // if not (mu in [2,3,5,10,12,18,19,28,55,64,71]) then continue;
      title:=forms[mu];
      //if pos('/',forms[mu])>0 then forms[mu]:=copy(forms[mu],1,pos('/',forms[mu])-1);
      alts:=taka(forms[mu]).split('/');
      color:='white';
      if length(alts)>1 then color:='#ccf';  //blue
      for alt:=0 to length(alts)-1 do
      begin
        if lknum+50=72 then if (length(alts)>1) and (alt=0) then continue;
        lopslen:=length(alts[alt])-length(mids[lknum,mu-1]+yhtlopsall[mu-1])-length(stem);  //pituus ilman stemmi‰ ja p‰‰tteit‰
        //writeln('<td>',alts[alt],'#',lopslen,mids[lknum,mu-1],'|',yhtlopsall[mu-1],'</td>');
       //writeln('<td>',length(forms[mu]),' ',length(mids[lknum,mu-1]+yhtlopsall[mu-1]),' ',length(stem),'=',lopslen,'</td>');
       //stem:=copy(stem,1,cutp);
       //for alt:=1 to length(alts)-1 do
       amid:=copy(alts[alt],length(stem)+1,lopslen);//+mids[lknum,mu-1]+yhtlopsall[mu-1];
       if yhtlopsall[mu-1]<>'' then if endpos(yhtlopsall[mu-1],alts[alt])<length(alts[alt])-length(yhtlopsall[mu-1]) then color:='#fcc' //red for AKSENSA, MAISILLANSA
       else if length(alts)>1 then tupla(mu,amid);

       //if ALTS[alt]=stem+amid+mids[lknum,mu-1]+yhtlopsall[mu-1] then
       if pos(mids[lknum,mu-1]+yhtlopsall[mu-1],ALTS[alt])>0 then
       begin //color:='#cfc';
          tmid:=amid;//copy(amid,1,length(amid)-length(mids[lknum,mu-1]+yhtlopsall[mu-1]));
          tform:=alts[alt];
          title:=title+'_'+inttostr(alt)+tform;//booltostr(tform=stem+tmid+mids[lknum,mu-1]+yhtlopsall[mu-1]);
          //break;
       end;// else
       // color:='white';
         //write('<td style="color:red">',alts[alt]);
      end;
       if tform=stem+tmid+mids[lknum,mu-1]+yhtlopsall[mu-1] then color:='#dfa';// else color:='white';
       //if color='white' then if pos('/',title)>0 then color:='gray';
       //writeln('<td style="width:16em;background:',color,'; font-size:0.8em" title="',title,'">',stem,'<b style="font-size:1.4em">&nbsp;'+copy(taka(forms[mu]),length(stem)+1,lopslen)+ '&nbsp;</b><u>',mids[lknum,mu-1],'</u>',yhtlopsall[mu-1],'</td>');
       writeln('<td style="background:',color,'; font-size:0.3em;width:8em" title="',title,'">','<table><tr>');//<td>(',stem,'|',tmid,')','</td>');//<td style="width:0.1em">',stem'</td>'
       //writeln('<td style="width:2em;font-size:1.4em">'+copy(taka(forms[mu]),length(stem)+1,lopslen)+ '</td><td style="width:2em;"><u>',mids[lknum,mu-1],'</u></td><td  style="width:2em;">',yhtlopsall[mu-1],'</td>');
       writeln('<td style="width:2em;font-size:3em"><b>',tmid+ '</b></td><td style="width:1em;"><u>',mids[lknum,mu-1],'</u></td><td  style="width:1em;">',yhtlopsall[mu-1],'</td>');

       writeln('</tr></table>');

       except writeln('<td style="width:12em">',length(stem),stem+'***',yhtlopsall[mu-1],'</td>');end;
    end;
    writeln('</tr>');

   end;
   writeln('</table>!!!!!!!!!!!');
 writeln('<hr>',tmids);
end;

procedure tstemmer.endingsbyclass;
 var i,j,k,m,times:word;st:ansistring;
 ends: array[0..80] of array[1..33] of ansistring;//tstringlist;
   var lk,lknum,len,inlk,prevlk:byte;tfor:ansistring;
begin

//endings:=tstringlist.create;
  lknum:=0;
  prevlk:=1;
  times:=0;
  write('<table border="1">');//,forms[1]);

  while not eof do
  begin
      try
       forms.clear;
       readline;
       //writeln('<li>',forms[0]);
       if eof then break;
       lk:=strtointdef(copy(forms[0],3,2),0);
       //if lknum>8 then eof:=true;
       //writeln(lk,':',forms[0]);
       if lk<>prevlk then
       begin          try
         lknum:=lknum+1;
         inlk:=0;
         fillchar(ends,sizeof(ends),#0);
         //writeln('<li>didread',prevlk,' ',forms.count,'<table><tr>');
         write('<h2>LUOKKA ',lk,'</h2><table border="1">');//,forms[1]);
         for i:=1 to forms.count-1 do //pes‰muna.. k‰‰nteinen j‰rjestys
         begin
            try
              eXMAT[lknum,i]:=(forms[i]);
              for j:=length(forms[i]) downto 1 do // to 12 do if len<j then break else
                 ends[i][length(forms[i])-j+1]:=taka(forms[i][j]);
             len:=length(forms[i])-length(yhtlopsall[i-1]);
             //for j:=1 to 12 do if len<j then break else
             // ends[i,j]:=taka(forms[i][len-j+1]);
            except writeln('!!!!!!!');end;
         end;
       except writeln('!!!!!!!');end;
       end;
       prevlk:=lk;
       //forms[i]:=taka(forms[i]);
       //if times>200 then break;
       times:=times+1;
       inlk:=inlk+1;
      writeln('<tr><td>',forms[1],'</td>');
      //if inlk<15 then
      for i:=2 to forms.count-1 do
      begin        try
        forms[i]:=taka(forms[i]);
        writeln('<td style="width:12em" title="'+forms[i]+'">',inlk);
        st:='';
        for j:=length(forms[i]) downto 1 do
         if forms[i][j]<>ends[i][length(forms[i])-j+1] then
          begin
            //writeln('{',forms[i][j],'/',ends[i][length(forms[i])-j+1],'}',yhtlopsall[i-1],' ');
            ends[i][length(forms[i])-j+1]:=#0;
            break;
          end else st:=forms[i][j]+st;
          mids[lknum][i]:=st;
          writeln(i,'<b>',lknum,mids[lknum][i],'</b><small>|',yhtlopsall[i-1]+' '+forms[i],'</small>');
        writeln('</td>');
        except writeln('ZZZZZZZZZZZZZZZZZZ');end;
      end;
      writeln('<td>didyksluokka</td></tr>');except  writeln('</td><td>DidNOT</td></tr>');end;
  end;
  writeln('</table><hr><h1>DID</h1>');
  for i:=2 to muotoja do
  begin
     st:='';
     writeln('<li>',yhtlopsall[i],':');
    for k:=1 to luokkia do
    write('''',mids[i,k],''',');
    //for j:=1 to 12 do
    //  if mids[i,j]=#0 then break else st:=ends[i,j]+st;
    //write(z'''',st,''',');
  end;
  writeln('<h2>byluokka</h2><xmp>');
  for i:=2 to luokkia do
  begin
     st:='';
     write(51+i,',');
    for k:=2 to muotoja do
    write('''',copy(mids[i,k],1,length(mids[i,k])-length(yhtlopsall[k-1])),''',');
    WRITELN;
    //for j:=1 to 12 do
    //  if mids[i,j]=#0 then break else st:=ends[i,j]+st;
    //write(z'''',st,''',');
  end;
  writeln('</xmp>xxxxxx',luokkia ,'/',muotoja,'<table border="1">');
  for i:=1 to luokkia do
  begin
    writeln('<tr><td>',i+51,'</td> ');
    //for j:=2 to muotoja do writeln('<td><b>'+copy(mids[i,j],1,length(mids[i,j])-length(yhtlopsall[j-1]))+'</b>'+ '|'+yhtlopsall[j-1], '</td>');
    for j:=2 to muotoja do writeln('<td>'+mids[i,j]+'</td>');
   writeln('</tr>');
  end;
  writeln('</table>');
end;

procedure tstemmer.loppuluokat;
 var j,k,m:word;
 stl:tstringlist;
procedure fillb(ind:word;lis:string);
 var i:word;
  begin
   stl.commatext:=lis;
   writeln('{',lis,'}<li>');
  for i:=0 to stl.count-1 do
  begin  ljouknums[ind][i+1]:=strtointdef(stl[i],1)-1;
        write(' [',ind,',',i+1,']=',ljouknums[ind][i+1]);
  end;

    ljouknums[ind][0]:=stl.count;
  end;
procedure fills(ind:word;lis:string);
 var i,j:word;
  begin
   stl.commatext:=lis;
   writeln('<li>');
  for i:=0 to stl.count-1 do begin
    ljouklops[ind][i+1]:=stl[i];
    write(' [',ind,',',i+1,']=',ljouklops[ind][i+1]);
  end;
   ljouklops[ind][0]:=inttostr(stl.count-1);
 // write('<li>',ind,':',lis);
  end;
begin   //FUKKIN BRAINDEAD AIVOPIERU ....MIKS PITI HAJOTTAA JA SIT YHDISTƒƒ TAKASIN
stl:=tstringlist.create;
fillb(1,'2,21,22,23,24,25');
fillb(2,'3,4,6,7,8,9,30,31,32,33,34,35,36,37,38,39,40,41,42,43,47,48,50,51,52,53,54,66,69,70');
fillb(3,'5');
fillb(4,'10,11,45');
fillb(5,'12,44,72,73,74,75,76');
fillb(6,'13,14,15,16,17,18');
fillb(7,'19,20,26,29,46,49,62,68');
fillb(8,'28,27');
fillb(9,'61,56,57,58,59,60');
fillb(10,'64,63,65,67');
fillb(11,'71');
fillb(12,'77');
 fills(1,'a,aksemme,aksenne,akseni,aksesi,akseen,');
 fills(2,'n,t,mme,tte,vat,,matta,malla,masta,maan,massa,man,matta,malla,mista,masta,man,maan,massa,ma,vat,va,maisillaan,maisillamme,maisillanne,maisillani,maisillasi,,minen,mista,');
 fills(3,',');
 fills(4,'a,aan,ut,');
 fills(5,'ut,nut,nette,nevat,nen,net,nee,');
 fills(6,'imme,itte,ivat,in,it,i,');
 fills(7,'tu,tiin,taman,taessa,tu,tava,taisiin,takoon,');
 fills(8,'en,essa,');
 fills(9,'isi,isimme,isitte,isivat,isin,isit,isi,');
 fills(10,'kaa,kaamme,koot,koon,');
 fills(11,'emme,');
 fills(12,',');
 writeln('<hr/><hr/>num/lop<ul>');
 for j:=1 to 12 do
   begin
   writeln('<li>',j,'/',ljouknums[j,0]);
   for k:=1 to ljouknums[j,0] do
   writeln(' (',ljouknums[j,k],'/',ljouklops[j,k],')');
   end;
 writeln('</ul><hr/><ul>');
 //for j:=1 to 77 do endings[
 for m:=1 to 77 do
 begin
   ljoukmbrs[m]:=0;
   writeln('<li>',m,'::');
   for j:=1 to 12 do
   begin
     for k:=1 to 30 do
     if ljouknums[j,k]=0 then break else
       if ljouknums[j,k]=m then
       begin
         writeln(m,'=',j,':',ljouklops[j,k]);
         endings[m]:=ljouklops[j,k];
         ljoukmbrs[m]:=j;

         break;
        end else write('.');
      if ljoukmbrs[m]<>0 then break;

   end;
 end;
 writeln('</ul><hr/><hr/>');
 writeln('<hr/>');
 for j:=1 to 77 do writeln('',j,'=',ljoukmbrs[j],'.',endings[j],' ');
 stl.free;
end;
//'a,n,t,,mme,tte,vat,,a,aan,ut,imme,itte,ivat,in,it,i,tu,tiin,aksemme,aksenne,akseni,aksesi,aksensa,taman,essa,en,taessa,matta,malla,masta,maan,massa,man,matta,malla,mista,masta,man,maan,massa,ma,ut,ut,tu,vat,va,tava,,emaisillamme,emaisillanne,nemaisillani,nemaisillasi,isi,isimme,isitte,isivat,isin,isit,isi,taisiin,kaamme,kaa,koot,,koon,takoon,minen,mista,emme,ette,evat,en,et,ee,,,'
{ 0: a 1
1:
2: a 2 aksemme 21 aksenne 22 akseni 23 aksesi 24 akseen 25
3: n 3 t 4 mme 6 tte 7 vat 8 9 matta 30 malla 31 masta 32 maan 33 massa 34 man 35 matta 36 malla 37 mista 38 masta 39 man 40
  maan 41 massa 42 ma 43 vat 47 va 48 maisillaan 50 maisillamme 51 maisillanne 52 maisillani 53 maisillasi 54 66 minen 69 mista 70
4: 5
5: a 10 aan 11 ut 45
6: nut 12 nut 44 nette 72 nevat 73 nen 74 net 75 nee 76
7: imme 13 itte 14 ivat 15 in 16 it 17 i 18
8: tu 19 tiin 20 taman 26 taessa 29 tu 46 tava 49 taisiin 62 takoon 68
9: EN essa 27 en 28
11: ISI isimme 56 isitte 57 isivat 58 isin 59 isit 60 isi 61
12: kaa kaamme 63 kaa 64 koot 65 koon 67
13: emme 71
14: 77

if not (mu+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue;


2:  2,21,22,23,24,25
3:3,4,6,7,8,9,30,31,32,33,34,35,36,37,38,39,40,41,42,43,47,48,50,51,52,53,54,66,69,70
4:5
5:10,11,45
6:12,44,72,73,74,75,76
7:13,14,15,16,17,18
8:19,20,26,29,46,49,62,68
9:28,27
11: 61,56,57,58,59,60
12: 64,63,65,67
13: 71
14: 77
# vanha 10 oli tupla / virhe ISI

2: a,aksemme,aksenne,akseni,aksesi,akseen,
3: n,t,mme,tte,vat,,matta,malla,masta,maan,massa,man,matta,malla,mista,masta,man,maan,massa,ma,vat,va,maisillaan,maisillamme,maisillanne,maisillani,maisillasi,,minen,mista,
4: ,
5: a,aan,ut,
6: nut,nut,nette,nevat,nen,net,nee,
7: imme,itte,ivat,in,it,i,
8: tu,tiin,taman,taessa,tu,tava,taisiin,takoon,
9: en,essa,
11: isi,isimme,isitte,isivat,isin,isit,isi,
12: kaa,kaamme,koot,koon,
13: emme,
14: ,


/:ansai@0 (/) 	ansai |t |a 	ansai |tse |n 	ansai |tsee | 	5ansai |t |a 	6ansai |nn |ut 	7ansai |ts |i
8ansai |t |tu 	9ansai2 |t |en 	10 ansai |ts |isi 	ansai |t |kaa 	ansai |nn |emme

sortatut muodot kesken‰‰n
}{type tsimmT=class(tobject)
 len:word;
  vals:array OF byte;
 procedure commatext(st:ansistring);
 procedure setval(st:ansistring;ind:word);
 constructor create(l:word);
end;}
  constructor ttaivlka.create(lka:integer);
  begin astecount:=0;num:=lka;wcount:=0;lvoks:=tstringlist.create;
  end;



procedure tstemmer.findmatches(st:string);
var i,j,k:word;
begin
for i:=0 to length(yhtloput)-1 do writeln('<li><b>',yhtloput[i],'</b> ',vforms[i+1]);
end;

procedure tstemmer.luokkainfo;
var w,r,c,muoto,luokka:word;lka,plka,fc:integer;asva,pasva:ansistring;uusluokka:ttaivlka;lcount:word;

begin
 //setlength(luokat,luokkia*8);
 lcount:=0;
 c:=0;
 plka:=-1;
 pasva:='';
 //exit;
 while not eof do
 begin
   forms.clear;
   fc:=readline;
   if eof then break;
   //lka:=copy(forms[0],
   lka:=strtointdef(copy(forms[0],3,2),999);
   //if lka>=10 then continue;
   asva:=(copy(forms[0],5,1));
   if lka<>plka then
   begin
     uusluokka:=ttaivlka.create(lka);
     luokat.add(uusluokka);
     examples.add(forms[1]+INTTOSTR(LKA));
     writeln('zzzzzzzzzzzzzzz');
     if lcount<luokkia then  for mUOTO:=0 to muotoja-2 do begin try exmat[lcount,muoto]:=FORMS[MUOTO] {copy(FORMS[Muoto],length(forms[muoto])-7)};except writeln('<li>failex:',lcount,muoto);end;end;
     //writeln('<li>luokka:',lcount);
     //if lcount<luokkia then try for mUOTO:=0 to 6 do exmat[lcount,muoto]:='x';except writeln('<li>failex:',lcount,muoto);end;
     lcount:=lcount+1;
     //if (lcount>1) then writeln('#(',tluokka(luokat.items[lcount-2]).wcount,'/',inttostr(tluokka(luokat[lcount-2]).astecount)+')');
     //writeln('<li>',copy(forms[0],3,2),':');
     pasva:='';
   end;
   if (pasva<>asva) and (asva<>'0') then
   begin
   //write(lka,'/',asva,'_',lcount,' ');
   ttaivlka(luokat[lcount-1]).astecount:=ttaivlka(luokat[lcount-1]).astecount+1;
   end;
   ttaivlka(luokat[lcount-1]).wcount:=ttaivlka(luokat[lcount-1]).wcount+1;
   pasva:=asva;
   plka:=lka;
   c:=c+1;
   //if c>200 then break;
 end;
 forms.clear;
 writeln('<h1>',lcount,' luokkaa</h1><table border="1">');
 for luokka:=9990 to lcount-1 do
 begin
   writeln('<tr><td>',luokka+51,examples[luokka],'</td>');
   for muoto:=0 to muotoja-1 do writeln('<td>',exmat[luokka,muoto],'</td>');

 end;
end;




procedure tstemmer.matrix;
var r,c,c2,le,s,s2:word;asteet:array[0..100] of integer;loppu,st,TITLE,tithit,td,lopvo:ansistring;
shorts:tstringlist;
 zims: array[0..80] of array[0..80] of byte;
 zimsum:array[0..80] of word;

 simlk:array[0..80] of array[0..40] of byte;
 simlks,ocurr:word;
 isinsim,neword:array[0..80] of byte;
 //ylopu:tstxxarr;
 function vika(s:ansistring):ansichar;begin end;

 function matchends(e1,e2, v1,v2:ansistring):boolean;
 begin
  result:=true;
  if e1=e2 then exit;
  //result:=false;exit;
  if length(e1)<>length(e2) then begin result:=false;exit;end;  //how about '-' ?
  if copy(e1,1)=copy(e2,1) then exit; //too lenient, ignores astevaihtelu always
  //if (copy(e1,2,1)=v1) and (copy(e2,2,1)=v2) then  //no point v1 and v2 are always the same within class
  //  if copy(e1,3)=copy(e2,3) then exit; //
  result:=false;
 end;
var shtit:integer;
begin      ///////////////////////////////////////  *MATRIX* ///////////////////////

  shorts:=tstringlist.create;
  for r:=0 to luokkia-1 do shorts.add('');
  //ylopu:=tstxxarr.create(luokkia,muotoja);
  fillchar(asteet,sizeof(asteet),0);
  fillchar(zims,sizeof(zims),0);
  fillchar(zimsum,sizeof(zimsum),0);
  write('***********');
  writeln('<li>Muodot tiedostosta<hr>');
  for r:=0 to luokkia-1 do
    begin
      //lopmat.commarow(copy(fixes[r],pos('=',fixes[r])+1),r);
      lopmat.commarow(fixes[r],r);
     writeln('<li>X:',exmat[r,14],'  ',r+51,' ',lopmat[r,14]);
     //for c:=1 to muotoja-1 do write('-',lopmat[r,c]);
     //writeln('</tr>');
     for c:=1 to muotoja-1 do try
     begin
       if pos('/',lopmat[r,c])>0 then
       begin
         //writeln('<li>Alts:',lopmat[r,0],'/',c,':',lopmat[r,c]);
            if 2*pos('/',lopmat[r,c])>length(lopmat[r,c]) then  //longer is first
            lopmat[r,c]:=copy(lopmat[r,c],pos('/',lopmat[r,c])+1)  //take second
            else lopmat[r,c]:=copy(lopmat[r,c],1,pos('/',lopmat[r,c])-1); //take first
           // write('==',lopmat[r,c]);
       end;
       st:=lopmat[r,c];
       if (st<>'') and (st[length(st)]='*') then //lopmat[r,c]:=lopmat[r,c]+'!';
       begin
        lopmat[r,c]:='*'+copy(st,1,length(st)-1);
        asteet[c]:=asteet[c]+1;//length(lopmat[r,c])]:='1' ;
       end else lopmat[r,c]:='?'+copy(st,1);
     end
     except writeln('!!!!!!!!!!');end;
    end;
  writeln('<hr>Muodot siivottuina<table border="1">');
  for c:=0 to muotoja-1 do
  begin
    writeln('<tr><td style="width:40em">',c,' ',vforms[c],':');
    yhtloput[c]:=copy(lopmat[1,c],2);
    for r:=1 to luokkia-1 do if (r+51<62) or (r+51>70) then
     begin
       if pos('#',lopmat[r,c])=0 then
       yhtloput[c]:=getsim(lopmat[r,c],yhtloput[c]);
       if pos('-',lopmat[r,c])>0 then write(' !'+lopmat[r,c],r+51,'/',r,':',c);
     end;
    write('<b>',yhtloput[c],'</b></td>');
    for r:=0 to luokkia-1 do
    begin
      {st:=lopmat[r,c];
      if loppu<>'' then for le:=0 to length(loppu)-1 do
       begin if le>=length(st) then begin loppu:=copy(loppu,length(loppu)-le+1);break; end else
       //if st[length(st)-le]<>loppu[length(loppu)-le] then
       begin loppu:=copy(loppu,length(loppu)-le+1);break;end;// else write(
       end;}
      lkfixes[r,c]:=copy(lopmat[r,c],1,length(lopmat[r,c])-length(yhtloput[c]));
      shorts[r]:=shorts[r]+','+copy(lopmat[r,c],1,length(lopmat[r,c])-length(yhtloput[c]));
      write('<td style="width:18em" title="',exmat[r,c],'">',copy(lopmat[r,c],1,length(lopmat[r,c])-length(yhtloput[c])));//,' <small>',yhtloput[c],'</td>');
      //write('<td title="',exmat[r,c],'">',lopmat[r,c],'</td>');
    end;
      //ylopu[
     writeln('</tr>');

  end;
  writeln('</table>xxxxx<hr>SHORTS:');
  writeln(muotoja,'muodot kesken‰‰n<table border="1">');
  for c:=2 to muotoja-1 do
  begin
    zimsum[c]:=0;
    writeln('<tr><td style="width:20em">',vforms[c],'</td><td>',yhtloput[c],'</td>');
    for c2:=2 to muotoja-1 do
    begin
      title:='';
      tithit:='';
      shtit:=0;
      for r:=1 to luokkia-3 do
      begin
       //if (copy(lkfixes[r,c],2)=copy(lkfixes[r,c2],2)) or
       //  ((lopvokst[c+1]=copy(lkfixes[r,c],2,1))
       //   and (lopvokst[c2+1]=copy(lkfixes[r,c2],2,1)))
        if (r+51<>52) and (r+51<>71) then
        if matchends(lkfixes[r,c],lkfixes[r,c2],lopvokst[r,c+1],lopvokst[r,c2+1])
       then begin zims[c,c2]:=zims[c,c2]+1;tithit:=exmat[r,c2]+':'+tithit+'\'+lkfixes[r,c]+'/'+lkfixes[r,0] end
       //else if copy(lkfixes[r,c],2)=copy(lkfixes[r,c2],2) then write('<td style="background:red">XXX</td>')
       else  begin if shtit=0 then shtit:=r;title:=title+exmat[r,c2]+':'+'('+lkfixes[r,c]+lkfixes[r,c2]+lkfixes[r,0]+')';end;
        //if (lkfixes[r,c]=lopvoks[r+1] and lkfixes[r,c2])
      end;
      if zims[c,c2]>19 then
      begin
        zimsum[c]:=zimsum[c]+1;
        write('<td title="',exmat[shtit,c],' ',exmat[shtit,c2],' ',lkfixes[shtit,c],' ',lkfixes[shtit,c2],'" style="width:2em;background:#99f"><b>',zims[c,c2],'</b></td>');
      end // <small>',yhtloput[c],' ',yhtloput[c2], '</small></td>')
      else if zims[c,c2]>18 then //write('<td style="width:2em;background:#eee">',,'</td>');
      write('<td title="',exmat[shtit,c],'/',exmat[shtit,c2],'   ',lkfixes[shtit,c],'  ',lkfixes[shtit,c2],'  ',title,'  ',tithit,'  ',yhtloput[c],' ',yhtloput[c2],'" style="width:2em;background:#f99"><b>',zims[c,c2],'</b></td>')
      else write('<td title="',exmat[shtit,c],'/',exmat[shtit,c2],':',' [',title+']" style="width:2em;background:#fff"><b>',zims[c,c2],'</b></td>');
    end;
     //if pos(lopvokst[r+1],lkfixes[r,c])<1 then write('<td>',lkfixes[r,c],'</td>') else write('<td><b>',lkfixes[r,c],'</b></td>');
    writeln('<td><b>',zimsum[c],'</b></td></tr>');
   end;
  writeln('</table><hr>');
  fillchar(isinsim,sizeof(isinsim),0);
  simlks:=0;
  for c:=1 to muotoja do  //0,1 in fixes are irrelevant/mistakes
  begin
   if isinsim[c]>0 then continue;
   writeln('<br>?',c);
   for s:=c to muotoja do
     if zims[c,s]>19 then
     begin
      isinsim[s]:=simlks;
      write(' <b>',yhtloput[simlks],'</b>',c,'/',s,'->',simlks);
     end;   write('.');
    simlks:=simlks+1;
  end;
  writeln('<hr>');
  ocurr:=1;
  for s:=1 to simlks-1 do
  begin
   writeln('<li>',s,':');
  for c:=1 to muotoja do
    if isinsim[c]=s then
    begin
    neword[ocurr]:=c;
    //write(' <b>',yhtloput[c],' </b>',vforms[c],c);
    write(' <b>',yhtloput[c],', </b>',c);
    ocurr:=ocurr+1;
    end;
  end;
  writeln('sortatut muodot kesken‰‰n',c,'.',neword[1],'<table border="1">');
  for s:=1 to muotoja-1 do
  begin
    c:=neword[s];
    zimsum[c]:=0;
    td:='';
    for s2:=1 to muotoja-1 do
    begin
      c2:=neword[s2];
      title:='';
      tithit:='';
      shtit:=0;
      for r:=1 to luokkia-3 do
      begin
       //if (copy(lkfixes[r,c],2)=copy(lkfixes[r,c2],2)) or
       //  ((lopvokst[c+1]=copy(lkfixes[r,c],2,1))
       //   and (lopvokst[c2+1]=copy(lkfixes[r,c2],2,1)))
        if (r+51<>52) and (r+51<>71) then
        if matchends(lkfixes[r,c],lkfixes[r,c2],lopvokst[c+1],lopvokst[c2+1])
       then begin zims[c,c2]:=zims[c,c2]+0;tithit:=tithit+^j+' +'+exmat[r,c]+'.'+yhtloput[c]+','+exmat[r,c2]+'.'+yhtloput[c2]+lkfixes[r,0]+': '+lkfixes[r,c]+'/ '+lkfixes[r,c2]; end
       else begin if shtit=0 then shtit:=r;title:=title+^j+'!'+exmat[r,c]+'.'+yhtloput[c]+','+exmat[r,c2]+'.'+yhtloput[c2]+lkfixes[r,0]+': '+lkfixes[r,c]+'/ '+lkfixes[r,c2];end;
        //if (lkfixes[r,c]=lopvoks[r+1] and lkfixes[r,c2])
      end;
      if zims[c,c2]>19 then
      begin
        zimsum[c]:=zimsum[c]+1;
        td:=td+^j+'<td title="'+' '+lkfixes[shtit,c]+'_'+lkfixes[shtit,c2]+'" style="width:2em;background:#99f"><b>'+inttostr(zims[c,c2])+'</b></td>';
      end // <small>',yhtloput[c],' ',yhtloput[c2], '</small></td>')
      else if zims[c,c2]>14 then //write('<td style="width:2em;background:#eee">',,'</td>');
      td:=td+^j+('<td title="'+title+' *********** '+^j+tithit+'  '+(yhtloput[c])+' '+yhtloput[c2]+'" style="width:2em;background:#f99"><b>'+inttostr(zims[c,c2])+'</b></td>')
      else td:=td+^j+('<td title="'+title+']" style="width:2em;background:#fff"><b>'+inttostr(zims[c,c2])+'</b></td>');
    end;
     //if pos(lopvokst[r+1],lkfixes[r,c])<1 then write('<td>',lkfixes[r,c],'</td>') else write('<td><b>',lkfixes[r,c],'</b></td>');
     writeln('<tr><td style="width:15em">',vforms[c],'.',isinsim[c],'</td><td  style="width:10em">',yhtloput[c],c,'/','<td><b>',zimsum[c],'</b></td>','</td>'+td);
    writeln('</tr>');
   end;
  writeln('</table><hr>');


  for c:=1 to muotoja do
     writeln('''',yhtloput[c],''',');


  writeln('<hr>',shorts.text);
  for c:=1 to muotoja do
      if c in [1,3,5,10,12,18,19,28,55,64,71] then
     writeln('''',yhtloput[c],''',');


  writeln('<hr>',shorts.text);
  writeln('loput luokittain',lopvo,length(lopvo),'<table border="5"><tr><td></td>');
  for c:=1 to muotoja do
      if c in [1,3,5,10,12,18,19,28,55,64,71] then
  writeln('<td style="width:6em">',c,yhtloput[c],'|',exmat[0,c],' ',vforms[c],'</td>');
  writeln('</tr>');
  ST:=',';
  for r:=0 to luokkia-1 do
  begin
    writeln('<tr><td>',r,lopvokst[r+1],'/',LOPMAT[R,0],'</td>');
  ST:=st+#10;
    for c:=1 to muotoja-1 do
    //begin write('<td>',lopmat[r,c],asteet[c],'</td>');end;
    if c in [1,3,5,10,12,18,19,28,55,64,71] then
    begin
      TITLE:=EXMAT[R,C];

      //IF POS(','+lkfixes[r,c]+',',ST)<1 THEN
      ST:=ST+lkfixes[r,c]+',';
      if pos(lopvokst[r+1],lkfixes[r,c])<1 then write('<td TITLE=',TITLE,'>',lkfixes[r,c],'|',yhtloput[c],'</td>')
       else write('<td TITLE=',TITLE,'><b>',lkfixes[r,c],'|',yhtloput[c],'</b></td>');end;
     writeln('</TR>');//<tr><TD style="width:50em;font-size:3em" colspan="19">',lopvokst[r+1],':',ST,'</td></tr>');

  end;
  writeln('</table><hr><xmp>');
  writeln(st,'</xmp><hr>');
  writeln('loput muodoittain<table border="5">');
    for c:=0 to muotoja-1 do
     if c in [1,3,5,10,12,18,19,28,55,64,71] then
    begin
     //if (c>30) or (c<10) then continue;
    writeln('<tr><td>',c,yhtloput[c],'</td>');
    for r:=0 to luokkia-1 do
   //begin write('<td>',lopmat[r,c],asteet[c],'</td>');end;
     if pos(lopvokst[r+1],lkfixes[r,c])<1 then write('<td>',lkfixes[r,c],'</td>') else write('<td><b>',lkfixes[r,c],'</b></td>');
    writeln('</tr>');
   end;
  writeln('</table><hr>');
end;

constructor tstxxarr.create(r,c,w:word);
  var i,j:word;
  begin
   setlength(vals,r*c*w);//len:=l;
   rows:=r;cols:=c;wlen:=w;
   fillchar(vals[0],cols*rows*w,#0);
   writeln('createdarray ',r,'*',c,'*',w,'=',rows*cols*wlen,'=',length(vals));
  end;

 procedure tstxxarr.setval(r,c:word;st:ansistring);
  var i:word;
  begin
  try
  for i:=0 to wlen-1 do
   if i>=length(st) then
    vals[wlen*(cols*r+c)+i]:=#0
   else vals[wlen*(cols*r+c)+i]:=st[i+1];
   except writeln('<li>failset');end;
end;
  procedure tstxxarr.commarow(st:string;row:word);
  var i,nitem:integer;item:ansistring;
  begin
   nitem:=0;
   for i:=1 to length(st) do
     if nitem>cols then begin writeln('too big index');break;end
     else if st[i]=',' then
     begin
        setval(row,nitem,item);
        //vals(row*cols+8*nitem,i-1)
        //writeln('<li>',row,':',vals[row*cols+8*nitem],'=',item,'!');;
        nitem:=nitem+1;item:='';
     end
     else item:=item+st[i];
     if item<>'' then setval(row,nitem,item);
    //if nitem<cols then setval(row,nitem,#0);//fillchar(vals[row,nitem],1,1);
  end;
  procedure tstxxarr.commacol(st:string;col:word);
  var i,j:integer;begin

  end;
  function tstxxarr.getval(r,c:word):ansistring;
  var i:word;
    begin
    result:='';
    for i:=0 to wlen-1 do
      if vals[wlen*(cols*r+c)+i]=#0 then break else
       result:=result+vals[wlen*(cols*r+c)+i];
    end;

  constructor tstarr.create(l:word);
  begin
   setlength(vals,l);len:=l;
  end;
procedure tstarr.setval(st:string;ind:word);
begin
vals[ind]:=st;
end;
procedure tstarr.commatext(st:ansistring);
var i,item:integer;val:ansistring;
begin
item:=0;
for i:=0 to length(st) do if item>len then begin writeln('too big index');break;end else if st[i]=',' then item:=item+1 else vals[item]:=vals[item]+st[i];
end;



var count:word;


function reverses(s:ansistring):ansistring;
  var p:byte;
  begin
   result:='';
   for p:=1 to length(s) do if s[p]<>'*' then if s[p]='/' then break else result:=s[p]+result;
  end;
function findsims(yhtlop,uus:ansistring):byte;
var k,tamaloppu:word;llet:ansistring;
begin
try
result:=length(yhtlop);
if pos('?',uus)>0 then exit;
tamaloppu:=length(uus);
if tamaloppu=0 then begin result:=0;exit;end;
 if uus[tamaloppu]='*' then begin delete(uus,tamaloppu,1);tamaloppu:=tamaloppu-1;end;
//for k:=1 to min(length(loput[i]),tamaloppu)  do
for k:=1 to length(yhtlop)  do
begin
  //write('..',yhtloput[k],uus[tamaloppu-k+1],'.');
  if (k>tamaloppu) or (yhtloput[k]<>uus[tamaloppu-k+1]) then
  begin
      result:=k-1;exit;
  end;
end;except write('#');end;
end;

procedure veivaa;
begin end;
{procedure verbiloput(fixes:tstringlist);
var   muodot: array[0..200] of tstringlist;muoto,luokka,cut,lreps:word;
 comlens:array[1..75] of byte;st,ll:ansistring;
  ch:ansichar;
begin
  //loput2:=tstringlist.create;
  //loput2.commatext:=('u,a,a,a,a,a,e,e,e,i,d,d,d,d,t,l,d,t,t,d,t,t,t,t,a,a,a,');
  //lopmat2.commarow('a,a,a,a,a,a,e,e,e,i,-,-,-,-,e,e,-,e,e,e,e,a,a,a,a,a,a,e',0);
  //loput:=tstringlist.create;
  //result:=loput;

  for luokka:=0 to fixes.count-1
  do begin //yksi joka taivutusluokalle
   try
    //writeln('<li>x',luokka,'/',fixes.count);
    muodot[luokka]:=tstringlist.create;st:=stringreplace(fixes[luokka],'*','',[rfReplaceAll]);
    muodot[luokka].commatext:=st;
    except on e:exception do write('ERROR:',e.message);
    end;
  end;
  writeln('<h3>ilman *.. miksi?</h3><table border="1" style="table-layout:auto;width="300%">');
  for luokka:=0 to fixes.count-2
  do begin
    writeln('<tr>');
    for muoto:=0 to muodot[0].count-1 do writeln('<td title="',inttostr(luokka+51),':',inttostr(muoto),' ',examples[luokka],'">',muodot[luokka][muoto],'</td>');
    writeln('</tr>');
  end;
  writeln('<tr>');
  //for muoto:=0 to muodot[0].count-1 do writeln('<td>',muoto,' ',vforms[muoto],'</td>');
  //writeln('<tr>');

  writeln('</table><h1>didVERBS</h1>');
  writeln('zzzzzzzzzzzzzzzzzzzz',muodot[1].count);
  for muoto:=0 to muodot[1].count-1 do lopmat.setval(1,muoto,reverses(muodot[1][muoto]));  //pes‰muna
  //for muoto:=0 to muodot[1].count-1 do loput.add(reverses(muodot[1][muoto]));  //pes‰muna
  writeln('<h4>',fixes.count,'*',muodot[1].count,'</h4>');
  for muoto:=2 to (muodot[1]).count-1 do //75 do
  begin //yksi joka taivutusmuodolle
    //writeln('<li>',':',muodot[muoto],'!');
    try
    for luokka:=1 to fixes.count-2
    do begin
     try
      //writeln(luokka);
     if pos('/',muodot[luokka][muoto])>0 then muodot[luokka][muoto]:=copy(muodot[luokka][muoto],1,pos('/',muodot[luokka][muoto])-1);
      cut:=findsims(lopmat.vals[muoto],muodot[luokka][muoto]);
      if  muoto=13 then write('__',reverses(lopmat.vals[muoto]),'!',muodot[luokka][muoto],cut);
      //if muoto=50 then
      //if muodot[luokka][0]='VActInf5PxPl1' then
      //write('<hr>   ',luokka,':',muodot[luokka][0],reverses(loput[muoto]),'/',cut,'/',muodot[luokka][muoto],'=',reverses(copy(loput[muoto],1,cut)),'___ ');
    except write('???:',cut,lopmat.vals[muoto],'/  ',muodot[luokka][muoto],'!',muodot[luokka][0]+'  /',muoto);end;
    try      if cut=0 then lopmat.setval(1,muoto,'') else
      lopmat.setval(1,muoto,copy(lopmat.vals[muoto],1,cut));//:=copy(loput[muoto],1,cut);
    except write('??????????');end;
    end;
    writeln('<li>',muoto,vforms[muoto],'<b>:',reverses(lopmat.vals[muoto]),'</b> ');//,reverses(loput[muoto]),'</b>');

    for luokka:=1 to fixes.count-1 do try   if pos('?',muodot[luokka][muoto])<1 then write(muodot[luokka][muoto][length(muodot[luokka][muoto])-length(lopmat.vals[muoto])],'_') else write('%');
    except write('- ');end;

    except writeln('<li>fail',muoto);end;
  end;
  writeln('<h3>luokittaiset lis‰t ennen kaikille yhteisi‰ muotop‰‰tteit‰ </h3><table border="1" style="width:300%">');
  for muoto:=2 to muodot[1].count-1 do
  begin
    lreps:=0;
    st:=copy(muodot[1][muoto],length(muodot[1][muoto])-2,1);
    writeln('<tr><td>',vforms[muoto],' <b>',reverses(lopmat[1,muoto]),'/'+st,'</b>/'+'</td>');
    for luokka:=1 to fixes.count-2 do
    begin
      try
      ll:=copy(muodot[luokka][muoto],length(muodot[luokka][muoto])-length(lopmat[luokka,muoto])-1,1);
       //if ll=lopmat2.vals[luokka] then begin lreps:=lreps+1;ll:='<b>'+ll+'</b>:'+muodot[luokka][muoto];end;except ll:='***';
       if ll=lopvokst[luokka+1] then begin lreps:=lreps+1;ll:='<b>'+ll+'</b>:';end;except ll:='***';
      end;
      //if ll=loput2[luokka] then ll:='<b>'+ll+'</b>:'+muodot[luokka][muoto];except ll:='***';end;
      writeln('<td title="',inttostr(luokka+51),':',inttostr(muoto),'=',muodot[luokka][muoto],' ',examples[luokka],'">',ll,'<SMALL> ','</td>');
    end;
    if lreps>12 then writeln('</tr><tr><td>!!!',lreps,'</td></tr>');
    writeln('</tr>');
  end;
writeln('</table>VMUOTOT');

end; }
//function saveword(



var testar:tstxxarr;

procedure doit;
var i,j,shorts:word;s:ansistring;
begin
 //testbits;exit;
{writeln('create');
 testar:=tstxxarr.create(5,5);
 writeln('created');
 testar.commarow('a,bbb,ccc,ddd,e,',0);
 testar.commarow('a,b,c,d,eee,',0);
 testar.commarow(',x,y,z,,',4);
 testar[0,0]:='abcdfghijklmn';
 writeln('filled');
 for i:=0 to 4 do
 begin
  writeln('<li>',i,':');
  for j:=0 to 4 do
   writeln(' !',j,testar[i,j]);
 end;
exit;}
//writeln('<style type="text/css"> .muoto {margin-left:5em} .muoto ul {font-size:8px;} .muoto:hover ul {font-size:12px}</style>' );
{matchw('apinat','kinat','',true,nil);
matchw('apinat','akinat','',true,nil);
matchw('pinat','taikinat','',true,nil);
matchw('jupinat','tupenrapinat','',true,nil);
matchw('jupinat','tupenrupinat','',true,nil);
matchw('akrapinat','stapinat','',true,nil);
exit;}
writeln('<hr>alkaa t‰st‰ '+paramstr(1));exit;
hyps:=tstringlist.create;
mulls1:=tstringlist.create;
mulls2:=tstringlist.create;
voks:=tstringlist.create;
kons1:=tstringlist.create;
kons2:=tstringlist.create;
tavus:=tstringlist.create;
alko:=tstringlist.create;
//kons1.sorted:=true;
//kons2.sorted:=true;
//voks.sorted:=true;
//alko.sorted:=true;
//luETAVUT;
writeln('<hr>alkaa t‰st‰ '+paramstr(1));
//listaatavut;exit;
//for i:=1 to 13 do writeln(aste[i].a,aste[i].f,aste[i].t);
//writeln(isdifto('‰','i'));
//  writeln('<pre>');
{writeln(hyphenfi('stratekkia'));
writeln(hyphenfi('traaginen'));
writeln(hyphenfi('aapa'));
writeln(hyphenfi('jinjanjon'));
writeln(hyphenfi('jopajopajopajopajopadoo'));
writeln(hyphenfi('meluaja'));
writeln(hyphenfi('hauis'));
writeln(hyphenfi('aietta'));
writeln(hyphenfi('h‰‰yˆaie'));
writeln(hyphenfi('kaviaari'));
}
{  $codepage 8859-1}
//s:='‰‰‰‰‰‰‰‰‰‰‰‰‰‰‰‰‰‰‰‰‰';
//voks.add('a');voks.add('‰');voks.add('ˆ');writeln(voks.indexof('ˆ'),voks.indexof('‰'),voks[1],voks[2]);
//writeln(s,'ˆˆˆˆˆˆˆˆˆˆˆ');exit;
 count:=0;
 mystems:=tstemmer.create('sanatansi.lst');
//mystems:=tstemmer.create('sanat_osamuodoista.lst');
 writeln(s,'<hr>ˆˆˆˆˆˆˆˆˆˆˆ');

 //exit;
end;
//var nlka:word;

const bfixes:array[0..12] of ansistring =('!','a', 'n', '', 'a', 'nut', 'i', 'tu', 'en', 'isi', 'kaa', 'emme','?');

procedure tutkitavut;
procedure lst(stl:tstringlist);
var i,j,c,cc:integer;prev:ansistring;
begin
   c:=0;cc:=0;prev:='xxx';
   for i:=0 to stl.count-1  do
   if stl[i]=prev then begin c:=c+1; end else
   begin
    writeln('<li>',cc,'&nbsp;&nbsp;&nbsp; ',c,' &nbsp;&nbsp;',prev+' ');c:=1;prev:=stl[i];cc:=cc+1;
   end;
end;
var i,j,len:byte;ifi:textfile;line,ak,v,lk:ansistring;
 vs,lks,aks:tstringlist;
begin
  writeln('tutkitavut');
  assign(ifi,'tavut.lst');
  reset(ifi);
  vs:=tstringlist.create;
  aks:=tstringlist.create;
  lks:=tstringlist.create;
  aks.sorted:=true;
  aks.duplicates:=dupaccept;
  lks.duplicates:=dupaccept;
  lks.sorted:=true;
  vs.duplicates:=dupaccept;
  vs.sorted:=true;
  while not eof(ifi) do
  begin
     readln(ifi,line);
     len:=length(line);
     if len=0 then continue;
     i:=1;
     ak:='';v:='';lk:='';
     i:=1;
     if pos(line[1],konsonantit)>0 then
     begin
      ak:=line[i];
      i:=2;
     end;
     while i<=len do
     if pos(line[i],vokaalit)>0 then
     begin
        v:=v+line[i];
        i:=i+1;
     end else break;
      lk:=copy(line,i);;
     vs.add(v);aks.add(ak);
     if length(lk)<3 then if pos('√',lk)<1 then lks.add(copy('a'+lk,length('a'+lk)-1));
     writeln('<li>',line,':  ',ak,'|',v,'|',lk);
  end;
  writeln('<hr><li>AK: ',aks.count,aks.commatext,'<li>');
  lst(aks);
  writeln('<hr><li>V: ',vs.count,vs.commatext,'<li>');
  lst(vs);
  writeln('<hr><li>LK: ',lks.count,lks.commatext,'<li>');
  lst(lks);
end;
constructor tstemmer.create(fn:ansistring);
var i,j,k:word;fl,aline,sijalist:tstringlist;basends:array[0..10] of ansistring;lopvo:ansistring;
begin

//tutkitavut;exit;
//for i:=1 to 70 do writeln('<li>:',i,' ' ,hyphenfi(yhtlopsall[i],tavus));
fl:=tstringlist.create;
aline:=tstringlist.create;
writeln('<li>param:'+paramstr(1));
//writeln('<br><style type=text/css>', #10,#10, ' table { table-layout:fixed;width:2000px} td { width:100px;overflow:hidden} </style>');
  instr:=tfilestream.create(fn,fmopenread);
  eoff:=false;
  forms:=tstringlist.create;
  forms:=tstringlist.create;
     luokat:=tlist.create;
     lopvo:='auaaaaaeeei----ee-eeeeaaaaaae';
     xmps:=tstringlist.create;
     xmps.commatext:='sanoa,muistaa,huutaa,soutaa,kaivaa,saartaa,laskea,tuntea,l‰hte‰,sallia,voida,saada,juoda,k‰yd‰,rohkaista,tulla,tupakoida,valita,juosta,n‰hd‰,vanheta,salata,katketa,selvit‰,taitaa,kumajaa,kaikaa';
     //52 sanoa,53 muistaa,54 huutaa,55 soutaa,sousi soutaisi,56 kaivaa,57 saartaa,saartoi saartaisi,58 laskea,59 tuntea,60 l‰hte‰,(l‰ksi) l‰htisi,61 sallia,62 voida,63 saada,64 juoda,65 k‰yd‰,66 rohkaista,67 tulla,68 tupakoida,(tupakoitsen) tupakoi,(tupakoitsi) tupakoisi,(tupakoitsisi) tupakoinee,69 valita,70 juosta,71 n‰hd‰,72 vanheta,73 salata,74 katketa,(katkeisi) katkennee,75 selvit‰,76 taitaa,tainnee taitakoon,taitanut taidettiin,77 kumajaa

   // EXmat:=tstxxarr.create(luokkia+10,muotoja,32);
    EXAMPLEs:=tstringlist.create;

  lkfixes:=tstxxarr.create(luokkia,muotoja,16);
  //luokkainfo;
  //INSTR.FREE;
  //instr:=tfilestream.create(fn,fmopenread);
  //readmids;
  newmids;
  writeln('luokat');
  luoluokat;
  luesijat;//matchsijat('xyx',sijalist);//exit;
  writeln('list');
  //listall;  exit;
  luelista;
  writeln('listed');
  //stemmaa;
  exit;
  writeln('<h1>LISTAA</h1>');
  createlist;
  exit;
  testgen;//  generate;
  //findstems;
  writeln('<hr>');
  exit;
  endingsbyclass;
  writeln('WRITEMIDS');
  writemids;
  exit;
  //writeln(NAT');
   eoff:=false;

  instr.free;
    instr:=tfilestream.create(fn,fmopenread);
  purasanat;
  //findendings;
  exit;
  EXAMPLEs:=tstringlist.create;
  fixes:=tstringlist.create;
  xxfixes:=tstringlist.create;
  tavus:=tstringlist.create;
  fixes.loadfromfile('muodotv.lst');
  lopmat:=tstxxarr.create(luokkia,muotoja,32);
 // EXmat:=tstxxarr.create(luokkia,muotoja,32);
  lkfixes:=tstxxarr.create(luokkia,muotoja,16);
  luokkainfo;
  matrix;
 // exit;
  //write('</table>zzzzzzzzzzzzzzxxxxxxxxxxxxxxxxxx');
  {fl.clear;
  fl.loadfromfile('sanat_osamuodoista.lst');
  for i:=0 to fl.count-1 do
  begin
    aline.commatext:=fl[i];
    writeln('<li>',copy(fl[i],2,2),':');
   for j:=0 to 11 do
     writeln('  /',aline[j],'|',mids[strtointdef(copy(fl[i],2,2),0),j],'|',copy(yhtloput[j],2));
  end;
 //exit;
  }
  instr.free;
  instr:=tfilestream.create(fn,fmopenread);EOFf:=FALSE;
  //lopmat2:=tstxxarr.create(luokkia,muotoja);
  //verbiloput(fixes);
  //for i:=0 to loput.len-1 do begin writeln('_',i{loput.vals[i]});;end;
  lkaord:=0;
  fcount:=0;            i:=0;
  //exit;
  //lkord:=0;
  while (fcount<2) and (not eof) do begin write('- ');fcount:=readline;end;  //skip mess at beginning
  WRITELN('TRYLuOKKA',FORMS.COUNT);
  prevlka:=copy(forms[0],1,4);
  while not eof do
  begin
    {WRITELN('<LI>');
    FOR I:=0 TO FORMS.COUNT-1 DO
      if I in [0,1,3,5,10,12,18,19,28,55,64,71] then
         WRITE(FORMS[I],',');
      FORMS.CLEAR;
     READLINE;
    CONTINUE;
    }
      //for i:=1 to fcount-1 do
    {for i:=1 to 1 do //fcount-1 do
    begin
     // writeln('<hr></ul><li>DO:',eof,fcount,forms<>nil,forms.count,'Count<ul>');
      hyphenfi(forms[i]);
    end;}
    if i=0 then
    begin forms.clear;
    fcount:=readline;i:=1;end;
   // FOR I:=0 TO FIXES.COUNT-1 DO
   // writeln('<li>###################',FIXES[I]);
    doluokka;
    lkaord:=lkaord+1;

    //if instr.position>1000 then breaK;
    //i:=1+1;if i>2 then exit ;
  end;
  writeln('<hr><h1>didDO</h1><ul>');
  writeln('<hr><h3>',lops2,'</h1><ul>');
  exit;
  fl:=tstringlist.create;
  for i:=0 to fixes.count-1 do
   fl.values[copy(fixes[i],1,2)]:=copy(fixes[i],pos(':',fixes[i])+2);
  for i:=0 to fl.count-1 do
   writeln('<li>',fl[i]);
  writeln('</ul>zzz');
  fl.savetofile('muodotv.tmp');

end;
var loppu1,loppu2,loppu3:ansistring;

procedure tstemmer.doluokka;
var i:word;st:ansistring;
var ast:taste;lop,lvok,lka,fixst,av,prevav,prevw:ansistring;gotone:BYTE;wcount,acount:word;
begin
  mulls1.clear;
  mulls2.clear;
  prevav:='x';
  tavus.clear;
  writeln('<h1>doluokka</h1>');
  //hyphenfi(forms[1],tavus);
  ast:=getaste(forms[0][5]);
  for i:=1 to forms.count-1 do begin
    tavus.clear;
    hyphenfi(forms[i],tavus);
    if tavus.count>1 then mulls1.add(taka(tavus[1])+taka(tavus[0])) else mulls1.add(taka(tavus[0]));
  end;
  lka:=copy(forms[0],3,2);
  PREVlka:=copy(forms[0],1,4);
  wcount:=1;
  acount:=0;
 // if strtointdef(lka,999)>49 then begin eof:=true;exit;end;
 st:=fixes.values[lka];
 //st:=+yhtloput[;
  mulls2.delimiter:=',';
  mulls2.delimitedtext:=st;
  {for i:=0 to mulls2.count-1 do if pos('/',mulls2[i])<1 then mulls3.add('')
  else
  begin
   mulls3.add(copy(mulls2[i],pos('/',mulls2[i])+1));  //tmp - muodot.lst changed
   mulls2[i]:=copy(mulls2[i],1,pos('/',mulls2[i])-1);  //tmp - muodot.lst changed

  end;}
  masat:=st.split(',');
  writeln('<h2>',lkaord,lopvokst[lkaord+1],' ', copy(forms[0],3,2),' (',ast.a,ast.f,'>',ast.t,') ',forms[1],'  '+explain2(forms[0]),'</h2><table border="1" >');
  //writeln('<h3>ine: ['+Masat[9],']:',length(mASAT),'</h3><table border="1">');
  loppu1:='';loppu2:='';loppu3:='';


  //case
  gotone:=0;
  while (not eof) do
  begin
    //writeln('<li>xxxxxxx',newlka,prevlka,newlka=prevlka,'Count</li>');
   // writeln('<tr><td>',forms.commatext,'</td></tr>');
   try
     lvok:=taka(copy(forms[0],6,1));
     newlka:=copy(forms[0],1,4);//+lvok;
     av:=copy(forms[0],5,1);//+lvok;
    //if instr.position>1000 then breaK;
    //writeln('<tr><td colspan=3>',lka,' /',newlka,'/',prevlka,'/</td>');
    if newlka<>prevlka then
    begin
     writeln('</table><h3>',preVLkA,' ',prevw,' a:',acount,' w:',wcount,' ',loppu3,' \',loppu2,' /',loppu1,'</h3>'); //2:',loppu2,copy(newlka,3,2),'<hr/><hr/>');
      prevlka:=newlka;
      lops2:=lops2+','+loppu2;
      break;
    end;
    lop:=forms[1][length(forms[1])-2];if pos(lop,loppu3)<1 then loppu3:=lop+loppu3;
    lop:=forms[1][length(forms[1])-1];if pos(lop,loppu2)<1 then loppu2:=lop+loppu2;
    lop:=forms[1][length(forms[1])];if pos(lop,loppu1)<1 then loppu1:=lop+loppu1;
    wcount:=wcount+1;
   except writeln('nogoodluokanalku'); end;
    //readline;
    //doword;
   //writeln('<tr><td>G::',GOTONE,'</td></tr>');
   //if (gotone<1) or ((gotone=1) and (copy(forms[0],5,1)<>'0')) then
   TRY
    //IF POS('-',FIXES.values[lka])>0 then
    if prevav<>av then
    begin
    acount:=acount+1;

    doword;//!!!!!!!!!!!!
    end;
    prevav:=av;
    prevw:=forms[1];

    except writeln('</taBLE>failword');end;
    //eof:=true;
    //!!vertaasana;
  //if gotone=0 then gotone:=1;
  //if copy(forms[0],5,1)<>'0' then begin gotone:=2;end;
    prevlka:=newlka;
    //writeln('<tr><td>DID</td></tr>');
    forms.clear;
    //fixes.clear;
    fcount:=readline;
    if eof then break;
  end;
  //writeln('<tr><td colspan=3>',lka,' #',fixes.commatext,'§</td>');
  //for i:=1 to mulls2.count-1 do writeln('<td>',mulls2[i],'</td>');
  fixst:=lka+'=';
  for i:=1 to mulls1.count-1 do fixst:=fixst+mulls1[i]+',';
  xxfixes.add(fixst);
  //writeln('</tr>');

  //for i:=1 to mulls2.count-1 do writeln('<td>',mulls2[i],'</td>');
  writeln('</tr>');
  writeln('</table>');

end;
function karsiloppu(sana,vanhaloppu:ansistring):ansistring;
var i,sl,vl,minl:integer;ch:ansichar;coms,osana:ansistring;
begin   //find common endings
//gfixes.add(copy(forms[i],length(stemguess)+1,9999));
try try
  coms:='';
  if pos('?',sana)>0 then begin result:=vanhaloppu;exit;end;
  vl:=length(vanhaloppu);
  osana:=sana;
  sl:=length(sana);
  minl:=min(sl,vl);
  sana:=copy(taka(sana),sl-minl+1);
  vanhaloppu:=copy(taka(vanhaloppu),vl-minl+1);
  //write('<td>!',sana,sl,'%',vanhaloppu,vl,':',minl);
  result:=vanhaloppu;
  //if vl>sl then exit;
  //if sana='' then exit;
  //for i:=1 to length(vanhaloppu) do
  for i:=minl downto 1 do
  begin  if (sana[i]<>vanhaloppu[i]) then
    begin                    //asdf  bsdf
     coms:=coms+'?'+inttostr(i)+sana+';'+vanhaloppu;
     result:=copy(vanhaloppu,i+1);break;
    end else coms:=coms+'='+vanhaloppu[i]+inttostr(i);
  end;
 except writeln('<tr><td colspan="8">XXXXXXXXX',sana,'!',vanhaloppu,length(vanhaloppu),'</td></tr>'); end;
 finally //if pos('adjek',osana)>0 then
 //write(' !!!!<b>',sana+'/'+vanhaloppu+'='+result+'('+coms+')</b></td>')

 ;end;
end;
function tstemmer.explain2(cla:ansistring):ansistring;
var clanum:word;
begin
 clanum:=strtointdef(copy(cla,2,3),999);
 result:=explain(clanum);
end;

function tstemmer.explain(num:word):ansistring;
var r:ansistring;

begin
case num of
 1,2: r:='o,u ';
 3: r:='o/i+o/e (io400, oe=2,ie=3)';
 4: r:='KKO  ';
 5,6: r:='piiloI - voi olla perusmuodossa ilman  (HUTI v‰‰rin) ';
 7: r:='aina I ';
 8: r:='aina e';
 9: r:='aina a  poikkeus:aika/ajan, ei aian';
 10: r:='aina a?';
 11: r:='aina a (ia,ja) ';
 12,13: r:='aina a ';
 14: r:='aina A astevaihtuva tuplakons';
 15: r:='EA';
 16: r:='MPI komparatiivej‰';
 17: r:='AA UU ==';
 18: r:='kaksoiskonsonantteja';
 19 : r:='suo,tie ... pieni sekava luokka, vokaalivaihtelua !!!';
 20: r:='vierassanoja 2-vok lopussa. bileet ei yks.';
 21: r:='vierassanoja pitk‰n‰ laus vokaaliloppu .';
 22: r:='konsloppuisia kieroja vierassanoja?';
 23,24,26: r:='vaatiiko oman luokan?';
 25: r:='ƒMMƒ ƒNNƒKSI -???!!!';
 27,31: r:='t/s sotkuja; skippaa loppua';
 28: r:='-/si, KANSI ???!!!';
 29: r:='vain lapsi/lasta; skippaa loppua. Vai astev: ps/st';
 30: r:='VEITSi peitsi - nekin erilaisia ???!!!ASTEVAIHTELU TS ST - vrt lapsi';
 32: r:='Suora vai k‰‰nteinen av?';
 33,34,35: r:='N-loppu - astevaihtelu n/m?.  hapAn kuuluu luokkaan  34 !!!';
 36,37: r:='Pelkk‰ vasen N,mpa !!!';
 38: r:='NEN  .. skipataan';
 39: r:='S-loppu - vois olla astevaihtelu KS/S';
 40,41: r:='S-loppu - tipahtelee pois';
 42: r:='MIES vain -Av s/h?';
 //43: r:='T-loppu';
 43: r:='Vain Kev‰t (venat??) eiks menis muuhun luokkaan';
 45: r:='j‰rjhestyslukuja';
 46: r:='vain tuhat?';
 47: r:='NUT partisiippej‰, typist‰ runko ja pitemm‰t p‰‰tteet';
 48: r:='E-loppu';
 49: r:='loppu-e mukana joko perusmuodossa tai ei (auer t/tt puuttuu kotus), XXX';

 52: r:='[AV+Lopvok]. ja OU-alkuiset eri luokkiin, "sortaa" v‰‰r‰ss‰ luokassa';
 53: r:='[AV] sortaa v‰‰r‰ss‰ luokassa';
 54: r:='[AV] ';
 55: r:='[AV] taa Vaihtoehto S (korvaa vaihtelukons. monikkomuodoissa - mids option s/nil ..miten ilmaista?)';
 56: r:='taa ';
 57: r:='[AV? Vaihtoehto S. (vrt 54 .. t‰s‰ vaan S vie  O:n)';
 58: r:='[AV] taa ';
 59: r:='vain yks tuntea +S';
 60: r:='vain yks l‰hte‰';
 61: r:='{AV]';
 62: r:='Ei AV';
 63: r:='Ei AV. Vain j‰‰d‰ myyd‰ saada ';
 64: r:='EI AV. Rankka lyhennys. uo>oi, ie->ei ';
 65: r:='vain yks k‰yd‰';
 66: r:='Sotku. ehk astevaihtelu t/- ja nyt astevaihteleviksi merkatut (h‰p‰ist‰/h‰v‰ist‰,vavista, vapista, rangaista,rankaista) eri sanoja ';
 67: r:='[AV+e] astevaihtelevissa aina ELLA. ?? ';
 68: r:='Ei AV (tai niin paljon av ett‰ hoidettu omalla luokalla) OISKO AHKEROIDA ja AHKEROITSEA vaan eri sanoja? hfstss‰ vaihtoehtojen j‰rjestys vaihtelee; stem tulee lasketuksi v‰‰r‰n vaihtoehdon mukaan';
 69: r:='EI AV. pari muotoa ‰nn‰ll‰ (ansaiNNUT) Kerit‰ sotkua hfst:st‰';
 70: r:='Ei AV - monthfst ei anna pieksisin syˆksisin. Lis‰ksi vain juosta';
 71: r:='Ei AV . vain n‰hd‰ tehd‰';
 72: r:='[AV + loppuvok + s‰l‰‰]. aukenee/aukeaa oikenee/oikeaa sotkevat, s‰l saataisiin yhteisiin. ';
 73: r:='[AV] (hylk‰‰ pelk‰‰ ehk‰ jotain h‰ikk‰‰';
 74: r:='[AV lopvok + s‰l‰‰] Julkea kimmota ep‰s‰‰nnˆllisi‰ vaihtoehtoja';
 75: r:='[AV+lopvok] ';
 76: r:='[vain t/d -AV]. vain taitaa tiet‰‰ VAHVAN VAIHTELUN  LUOKKA';
 77,78: r:='osin taipumattomia (muka)';
 99: r:='join keksinyt ett‰ (ajan)p‰‰st‰ ja (mist‰)kusta ovat adverbej‰';
 79: r:='mik‰ t‰‰ on? ';
 else r:='teonsana';
end;
 result:=r+' /'+inttostr(num);
end;


procedure tstemmer.liimaamuodot;
var i,k,stemlen,tmuot,runlen:word;
  ast:taste;
begin
TRY
tmuot:=strtointdef(copy(forms[0],2,3),999);
//if (tmuot<66) or (tmuot>75) then onsuora:=true else onsuora:=false;
except writeln('<td>FAILa:',copy(forms[i],runlen),'#',fcount ,':',mulls2.commatext,i,'/failed</td>');end;
ast:=getaste(forms[0][5]);

end;
procedure tstemmer.doword;
var i,k,stemlen,tmuot,runlen:word;
xwrd,xstem,xstemguess,xsuffixes,xafix,
  echar,xkons,xvok,
  //runko,
  wrd,perusm,kaantm:ansistring;
stempos,x:integer;
 ast:taste;onsuora,xinstem:boolean;
 //gfixes:tstringlist;//lka,olka,
op:boolean;
alku,keski,loppu:integer;
{function tl1:ansistring;begin result:='';if tavus.count>0 then result:=taka(tavus[0]);end;
function tl2:ansistring;begin result:='';if tavus.count>1 then result:=taka(tavus[1]);end;
function salko:ansistring;var ii:word;begin result:='';if tavus.count>2 then for ii:=2 to tavus.count-1 do result:=taka(tavus[ii]+result);end;
function vperus:ansistring;
begin
 try
   if ast.a='_' then
   begin result:=tl2+tl1;end //copy(tl1,1,length(tl1)-1)  //ei astevaiht
   else if tavus.count=1 then result:=copy(tavus[0],1,length(tavus[0])-2)+ast.f+copy(tavus[0],length(tavus[0])-1)  //vain ien - ikenen
   else if ast.t='-' then result:=tl2+copy(tl1,2) //vika tavu typistyy
   else if length(ast.t)=length(ast.f) then  //vaihda vikan tavun eka kirjain ‰‰h, diftonkit?
       result:=tl2+ast.t[length(ast.t)]+copy(tl1,2,length(tl1)-1)
   else // kk.k poista tokavikan tavun vika
         result:=copy(tl2,1,length(tl2)-1)+tl1;
  except writeln('XXX',ast.a,tavus.count,'!');end;// result:=result+inttostr(tavus.count);
end;
function vperuskaantein:ansistring;
var i:word;
begin try
  if ast.a='_' then
    result:=tl2+tl1 //copy(tl1,1,length(tl1)-1)  //ei astevaiht
  else if tavus.count=1 then
  begin
     if pos(tavus[0][1],vokaalit)>0 then
        result:=copy(tavus[0],1,1)+ast.f+copy(tavus[0],2)
     else result:=copy(tavus[0],1,2)+ast.f+copy(tavus[0],3);
  end
  //else if ast.t='-' then result:=tl2+copy(tl1,1,1)+ast.f+copy(tl1,2)+'xx'+tl2+'-'+tl1 //tavuv‰liin lis‰ys
  else if ast.t='-' then
  begin  //tavuv‰liin lis‰ys, mahd kons siirt‰en:  pyy-h+Kin ‰-Kes o-as o-Kas
    if pos(tl1[1],vokaalit)>0 then result:=tl2+ast.f+tl1
    else result:=tl2+tl1[1]+ast.f+copy(tl1,2);
  end
  else if length(ast.t)=length(ast.f) then  //vaihda vikan tavun eka kirjain ‰‰h, diftonkit?
     result:=tl2+ast.f[length(ast.f)]+copy(tl1,2,length(tl1)-1)  //
  else // kk.k lis‰‰ tokavikan tavun vika
     result:=tl2+ast.f[length(ast.f)]+tl1;
//result:=result+inttostr(tavus.count);
 except result:=tl2+'/'+tl1+'/'+ast.f;end;
end;}
function liimaa(alku,loppu:ansistring):ansistring;
var i:word;lchar:ansichar;x:integer;
begin
result:=alku;
if loppu='' then exit;
//lchar:=loppu(length(loppu)
for i:=1 to length(loppu) do
  if loppu[i]='.' then result:=result+lastvowel(alku,x)
   else if loppu[i]='_' then result:=result+lastkons(alku,x)
    else if loppu[i]='-' then delete(result,length(result),1)
    else result:=result+loppu[i];
//if had then writeln('<td>',alku,'|'+result+'|'+lastvowel(alku)+'</td>')
end;

function liimaa3(al,ke,lo,ll:ansistring):ansistring;
var i:word;lchar:ansichar;
begin
result:=al;
try
if (lo='') then if  ke='' then exit;
//lchar:=loppu(length(loppu)
//keski:=copy(keski,2);
if pos('-',ke)>0 then write('%%');
for i:=2 to length(ke) do
  if ke[i]='.' then result:=result+ll //lastvowel(al)  //not used
   else if ke[i]='_' then result:=result+lastkons(al,x) //not used
    else if ke[i]='-' then begin delete(result,length(result),1);alku:=alku-1 end//only at beginning (after *?), truncates stem (al) ,
    else result:=result+ke[i];
keski:=length(result)-alku;
result:=result+lo;
//if had then writeln('<td>',alku,'|'+result+'|'+lastvowel(alku)+'</td>')
except writeln('<h4>eiliimaa',al,' +',ke,' +',lo,'</h4>');end;
end;



var altforms:tstringlist;sss,pfix,thisform,tmuoto,pfix1,loppuvok:ansistring;asa,thisforms,pfixes:tstringarray;hit,pi,tf,loplen:word;has_s:boolean;
//keskiset: array[0..200] of array[0..200] of ansistring;
mluokka:byte;
cfixes:array[0..80] of ansistring;fixgrp:tstringlist;   //tee: klusteroi taivutusmuodot p‰‰tteen perusteella
procedure debugmiss;var p,t:word;
begin
//for p:=0 to length(pfixes)-1 do
 //   write('<div style="color:red">',liimaa3(tmuoto,lkfixes[lkaord,i],yhtloput[i]),'.ne.',thisform,'</div>');
     //writeln('</td><tr><td style="color:red;width:50em:verflow:visible">',perusm,' ',kaantm,' ',pfix,length(pfixes),pfix1,'<br>',liimaa(kaantm,pfix1),' : ', liimaa(kaantm,pfix),' \ ',liimaa(perusm,pfix1),' : ',liimaa(perusm,pfix),'<br> !<b>!',thisform,length(thisforms),'!</b></td></tr><tr><td>');
end;

begin
TRY
wrd:=forms[1];
tmuot:=strtointdef(copy(forms[0],2,3),999);
if (tmuot<66) or (tmuot>75) then onsuora:=true else onsuora:=false;
except writeln('<td>FAILa:',copy(forms[i],runlen),'#',fcount ,':',mulls2.commatext,i,'/failed</td>');end;
//stemlen:=length(stem);
try
ast:=getaste(forms[0][5]);
except writeln('<TD>!!!!!!!!!!nosuffi</TD>');end;
//if ast.a='_' then exit;
TRY
    kaantm:=taka(wrd);
    //!!!IF TMUOT=52 THEN perusm:=copy(kaantm,1,length(kaantm)-1) else//why? 52 ainoo jossa erilaisia loppu2-vokaaleja (ua,oa)
    //ELSE if not  onsuora then perusm:=copy(kaantm,1,length(kaantm)-2)  //verbit perusm loppuu aina aahan, sit‰ ei sen kummemmin tartte ihmetell‰
      perusm:=copy(kaantm,1,length(kaantm)-2);

    //if perusm[length(perusm)]='d' then perusm:=copy(perusm,1,length(perusm)-1);//+'xxxxxxxxxxxxxxxxxxxxx';
    stempos:=0;
    if ast.t='-' then ast.t:='';
       //if (tmuot=67) then  perusm:=copy(perusm,1,length(perusm)-1); //vakio lla:
       if (tmuot=70) then  perusm:=copy(perusm,1,length(perusm)-1); //vakio sta
       if (tmuot=71) then  perusm:=copy(perusm,1,length(perusm)-1); //vakio hda
    kaantm:=perusm;
except writeln('<td>FAILa:',copy(forms[i],runlen),'#',fcount ,':',mulls2.commatext,i,'/failed</td>');end;
TRY
    loplen:=0;
    if ast.a<>'_' then
    begin
     if (onsuora) then
     begin                   //suora astevaihtelu
      stempos:=rpos(ast.f,perusm);
      loplen:=length(perusm)-stempos-length(ast.f)+1;
      perusm:=copy(perusm,1,stempos-1)+ast.f+copy(kaantm,stempos+length(ast.f)) ;
      kaantm:=copy(kaantm,1,stempos-1 )+ast.t+copy(kaantm,stempos+length(ast.f));
     end else //k‰‰nteinen
     begin                   //toimii vain suoran astevaihtelun luokille, korjataan myˆhemmin
      stempos:=rpos(ast.t,perusm);
      if ast.t='' then begin stempos:=length(perusm);if pos(perusm[stempos],vokaalit)<1 then stempos:=stempos-1;end;
      loplen:=length(perusm)-stempos-length(ast.t)+1;

      perusm:=copy(perusm,1,stempos-1 )+ast.t+copy(perusm,stempos+length(ast.t));
      kaantm:=copy(kaantm,1,stempos-1)+ast.f+copy(kaantm,stempos+length(ast.t));
     end;
    end;
    if (tmuot=63) then kaantm:=copy(kaantm,1,length(kaantm)-1)+'i';
    if (tmuot=64) then kaantm:=copy(kaantm,1,length(kaantm)-2)+kaantm[length(kaantm)]+'i';
except writeln('<td>FAILa:',copy(forms[i],runlen),'#',fcount ,':',mulls2.commatext,i,'/failed</td>');end;
  try
  try
       //if fcount>95 then exit;
       tmuot:=strtointdef(copy(forms[0],2,3),999);
       //writeln('<tr><td>A:',forms[1],' ',tmuot,'?',perusm,'/',kaantm,'/</td>');
      begin
        try
       ast:=getaste(forms[0][5]);
        tavus.clear;
        hyphenfi(forms[1],tavus);   //exit;
        try loppuvok:=copy(forms[1],length(forms[1])-1,1);except loppuvok:='';end;
        if (loplen>0) //and ((pos(kaantm[length(kaantm)],vokaalit)>0) or (pos(perusm[length(perusm)],vokaalit)>0))
        then sss:='@@@'+inttostr(loplen) else sss:='';
        if perusm<>kaantm then writeln(#10,'<td style="width:30em" colspan="3">',sss,'b:',tmuot,perusm+' ',kaantm, ' <b> ('+ast.f+'/'+ast.t+'.'+tavus[0]+')</b></td>')
         else writeln(#10,'<td  style="width:30em" colspan="3">',sss,'b/:',kaantm, '@',loplen,' '+ ' <b>('+ast.f+'/'+ast.t+')</b></td>');
       except writeln('<td>FAIL:',copy(forms[i],runlen),'#',fcount ,':',mulls2.commatext,i,'/failed</td>');end;
  // exit;
  forms.delete(1); //infinitive listed twice by mistake
 for i:=1 to forms.count-1 do
  // if i in [1,3,5,10,12,18,19,28,55,64,71] then
    begin
     thisforms:=forms[i].split('/');
     mluokka:=ljoukmbrs[i]-1;

     // ljouklops:array[0..12] of array[0..30] of ansistring; ljouknums:array[0..12] of array[0..30] of byte;
     // ljoukmbrs:array[0..78] of byte;

     if length(thisforms)=0 then begin setlength(thisforms,1);thisforms[0]:='';end;
      pfixes:=masat[i].split('/');
      if length(pfixes)=0 then begin setlength(pfixes,1);pfixes[0]:='';end;
      //write('<TD style="width:10em;overflow:visible" title="',''.join('/',thisforms),'/',lkfixes[lkaord,i],'+',yhtloput[i],'">');//,thisform,'</td><TD>');
      // write('<TD style="width:8em;overflow:visible" title="',''.join('/',thisforms),'/',mids[lkaord,i-1],'+',yhtloput[i],'">');//,thisform,'</td><TD>');
      write('<TD style="width:14em;overflow:visible" title="',''.join('/',thisforms),'/',mids[lkaord, i],' +',endings[i],'">');//,thisform,'</td><TD>');
      for tf:=0 to min(0,length(thisforms)-1) do
      begin
        hit:=0;
        thisform:=taka(thisforms[tf]);
        pfix1:='';
        for pi:=0 TO min(0,length(pfixes)-1) do  //max one time
        begin try
          pfix:=pfixes[pi];// else pfix:='';
          pfix:=mids[lkaord,mluokka];
          if pos('-', pfix)>0 then has_s:=true else has_s:=false;
          if pos('*',pfix)>0 then begin pfix:=trim(copy(pfix,1,pos('*',pfix)-1));tmuoto:=trim(kaantm);end
          else begin pfix:=trim(pfix);tmuoto:=trim(perusm);end;
          //write('(',length(pfixes),')');
          alku:=length(tmuoto);
          loppu:=length(endings[i]);   //lopmat.vals[i]);
          if pi=0 then pfix1:=pfix;
          //write('<div><b>',length(thisform),'/',alku+1,'/',keski,'\',loppu,tmuoto,'</b></div>');
          //if liimaa(perusm,mulls2[i])=taka(forms[i]) then
          //sss:=liimaa3(tmuoto,lkfixes[lkaord,i],yhtloput[i]);//copy(thisform,alku+1,keski);
          //sss:=liimaa3(tmuoto,mids[lkaord,i-1],yhtloput[mluokka],loppuvok);//copy(thisform,alku+1,keski);
          sss:=liimaa3(tmuoto,mids[lkaord,mluokka],endings[i],loppuvok);//copy(thisform,alku+1,keski);
          //keski:=length(thisform)-alku-loppu;
          //sss:=sss+liima2(
          //if TRIM(liimaa(tmuoto,PFIX))=TRIM(thisform) then
          if TRIM(sss)=TRIM(thisform) then
          begin
            sss:=copy(sss,1,alku)+' |'+copy(sss,alku+1,keski)+' |'+endings[i];
            hit:=hit+1;if pi=0 then
            if pos('*',pfix)>0 then  sss:='<b>'+sss+'</b>' else sss:='<em>'+sss+'</em>';
           //if pos('*',pfixes[pi])>0 then  sss:='<b>'+sss+'</b>' else sss:='<em>'+sss+'</em>';
           //sss:=sss+':'+liimaa3(tmuoto,lkfixes[lkaord,i],yhtloput[i]);
          //if has_s then sss:='<div style="color:red">'+sss+'<br>'+pfixes[pi]+'</div>';
           writeln(sss,'/',mids[lkaord,mluokka],mluokka); //<small>');//,reverses(loput[i]));//,alku,keski,loppu,'<br/>','=',thisform,'</small>');
          end;
          //if copy(sss,1,1)=lopvokst[lkaord+1] then sss:='<small>'+copy(sss,1,1)+'_</small>'+copy(sss,1);
          //writeln('{',liimaa3(tmuoto,lkfixes[lkaord,i],yhtloput[i]),'}');
            //else writeln(sss);//<small>');//,reverses(loput[i]));//,alku,keski,loppu,'<br/>','=',thisform,'</small>');
          //end;
          //if
          {begin hit:=hit+1;if pi=0 then write('<div>',tmuoto,'<b style="color:red;font-size:1.5em">'+copy(thisform,alku+1,keski),'</b>')
          else write('<div style="color:blue"><em>'+tmuoto+' <small>',copy(thisform,1,length(thisform)-length(loput[i])),'</small></em>')
          //begin hit:=hit+1;if pi=0 then write('<div><b>'+pfix,' <small>',thisform,'</small></b></div>')
          //else write('<div style="color:blue">'+pfix,' <small>',thisform,'</small></div>')
            ;end}
            ;//else  write('<div style="color:red"><b>?',pi,tf,tMUOTO,' + ',pfix,' = ',liimaa(tmuoto,PFIX),' ?',THISFORM,'</DIV>');//- ',''.join(' \',pfixes),'</div>');
          //end;
          //  write('#<b>',reverses(loput[i]),'</b></div>');
          //writeln('</div>');
         except write('fail::',i,' ',liimaa3(tmuoto,mids[lkaord,mluokka],endings[i],'X'),'_',thisform,mluokka);end;
        end;
        if hit=0 then
        writeln('<span style="color:red;font-size:1em">',thisform,'<br/>',tmuoto,'+'+mids[lkaord,mluokka],'+',endings[i],'</span>',mluokka,':',pfix);
         //debugmiss;//write('</td><td style="color:red;width:30em"><b>???',LENGTH(PFIXES),length(thisforms),tMUOTO,' + ',pfix,'?'+liimaa(tmuoto,PFIX),' = ',THISFORM,'</td><td>');//- ',''.join(' \',pfixes),'</div>');
        //if hit=0 then and write('</td><td style="color:red;width:30em"><b>???',LENGTH(PFIXES),length(thisforms),tMUOTO,' + ',pfix,'?'+liimaa(tmuoto,PFIX),' = ',THISFORM,'</td><td>');//- ',''.join(' \',pfixes),'</div>');
      end;
      writeln('</td>');
    end;
    writeln('</tr>');
  end;
   //if stem<>stemguess then
  except write('<td>fail!</td></tr>');exit;end;
  finally //altforms.free;
  end;
end;


function tstemmer.diag(f:tstringlist;ast:taste;lchar,stem:ansistring;tmuot:word):ansistring;
var i,j,flen,tlen,asteri:word;dg,hyps,runko:ansistring;pf1:ansichar; al,lo:ansistring;yhtvok,xx:ansistring;

function ltavut:ansistring;  //not needed
var j,len:word;
begin  len:=0;result:='';
  for j:=0 to min(1,tavus.count-1) do
  begin
    if tlen>=length(f[i]) then break;
    result:='/'+copy(tavus[j],1,999)+result;

    len:=len+length(tavus[j]);
    //if tlen+length(tavus[i]>lengt(f[i])
   end;
end;
begin
  try
  result:='';
  flen:=length(ast.f);
  tlen:=length(ast.t);
  //writeln('.');
  yhtvok:=lchar;
  tavus.clear;
  if tmuot>32 then //begin afix:=ast.f;ast.f:=ast.t;ast.t:=afix;writeln('<tr><td>',ast.a,ast.f,'/',ast.t,'   ::',forms.text,'</td></tr>');end;
  begin
    //exit;
     if ast.t='-' then tlen:=0;
     // hyphenfi(stem+f[0],tavus);
     //if length(ast.f)>length(ast.t) then tavus[1]:=copy(tavus[1],1,length(tavus[1])-1);
     //runko:=tavus[1]+'+'+tavus[0];
    for i:=0 to f.Count-1 do
    begin
      if i>12 then break;
      ulos:=false;
      try
          if length(f[i])>0 then pf1:=f[i][1] else pf1:=' ';
          case flen+tlen of
           0: begin asteri:=1;end;
           1: begin  if pf1=ast.f then asteri:=2 else asteri:=1;end;
           2: begin  if pf1=ast.t then asteri:=2 else asteri:=2;end;
           3:  begin if pf1=ast.f[2] then asteri:=2 else asteri:=1;;end;
           4:  begin if pf1=ast.t[2] then asteri:=2  else asteri:=2 ;end;
           else asteri:=1;
          end;
      except dg:='case:';end;
     {try
     if i=0 then
      if length(f[0])>asteri then
      begin
                   if pos(f[0][asteri]      ,    'aeiouy'+#228+#246)>0
                   then    yhtvok:=f[0][asteri]
      end else if length(f[0])>0 then if pos(f[0][length(f[0])],'aeiouy'+#228+#246)>0 then  yhtvok:=f[0][length(f[0])];
      except dg:=dg+'@['+inttostr(asteri)+']'+inttostr(length(f[0]))+f.commatext+'/';raise;end;}
     try xx:='';
     //if yhtvok<>'!' then
       if (yhtvok=f[i][asteri]) then begin asteri:=asteri+1;xx:='*';end;
            //length(f[1])>1 then if f
          al:=copy(f[i],1,asteri-1);
          lo:=copy(f[i],asteri,999);
        except al:=f[i];lo:='';end;
        //hyps:=
        tavus.clear;
        hyphenfi(stem+f[i],tavus);
        hyps:=ltavut;
        result:=result+'<td> <small> '+al+'</small> <b>'+lo+'</b> </td>';
        //result:=result+'<td> <small> '+al+'</small> <b>'+lo+'</b> <small>['+hyps+']</small> </td>';

      end;
  end else
  begin  //suora astevaihtelu
    dg:=':';
    hyphenfi(stem+f[0],tavus);
    try
      if length(ast.f)>length(ast.t) then  begin tavus[1]:=copy(tavus[1],1,length(tavus[1])-1);    runko:=tavus[1]+'('+ast.f[length(ast.f)]+')+'+tavus[0];end
      else if length(ast.t)>0 then begin
      //if ast.t<>'-' then begin
      tavus[0]:=copy(tavus[0],2);    runko:=tavus[1]+'+ ['+ast.t[length(ast.t)]+']'+tavus[0];//end;
      end;
    except runko:='!!'+inttostr(tavus.count)+':'+stem+':'+tavus.commatext; end;
    //runko:=stem+f[0]+'::'+tavus.commatext;
    for i:=0 to f.Count-1 do
    begin
       if i>12 then break;
       try
       if ast.t='-' then tlen:=0;
       if length(f[i])>0 then pf1:=f[i][1] else pf1:=' ';
       case flen+tlen of
        0: begin asteri:=1;end;
        1: begin  if pf1<>ast.f then asteri:=1 else asteri:=2;end;
        2: begin  if pf1<>ast.t then asteri:=2 else asteri:=2;end;
        3:  begin if pf1<>ast.f[2] then asteri:=1 else asteri:=2;;end;
        4:  begin if pf1<>ast.t[2] then asteri:=3  else asteri:=3 ;end;
        else asteri:=1;
       end;
       except dg:=dg+'!CASE'+inttostr(flen)+pf1+inttostr(tlen);raise;end;
       try
        {if i=0 then if length(f[0])>0 then
          begin
                   if pos(f[0][asteri]      ,    'aeiouy'+#228+#246)>0 then    yhtvok:=f[0][asteri]
          end //else result:=result+'<td>'+stem+'</td>';
         else if pos(stem[length(stem)],'aeiouy'+#228+#246)>0 then  yhtvok:=stem[length(stem)];
         }
         yhtvok:=lchar;
       //thisst:=f[i];
     //result:=result+'<td>'+stem+'</td>';
        //if i=0 then if length(f[0])>0 then if pos(f[0][asteri],'aeiouy'+#228+#246)>0 then yhtvok:=f[0][asteri];
        except dg:=dg+'@['+inttostr(asteri)+']';raise;end;
        try
        xx:='';
       //IF I>0 THEN if yhtvok<>'!' then
       if (yhtvok=f[i][asteri]) then begin asteri:=asteri+1;xx:='*';end;
       al:=copy(f[i],1,asteri-1);
       lo:=copy(f[i],asteri,999);
       tavus.clear;
       hyphenfi(stem+f[i],tavus);
       hyps:=ltavut;
        except al:=f[i];lo:='';end;
        //if asteri>length(f
        result:=result+'<td>'+'<small>'+al+'</small><em>'+lo+'</em></td>';//+dg+' <small>['+hyps+']</small></td>'; //+xx+inttostr(asteri)+f[i][asteri]
       //if pos('hetti',stem)>0 then    result:=result+'<td>!'+f[i]+inttostr(pos('et',stem))+'</td>';
       //if dg<>'' then
    end;
  end;
   //  if pos(stem[length(stem)],'aeiouy‰ˆ')>0 then ulos:=true;
        //if flen>1 then if stem[length(stem)]<>ast.f[1] then result:='<td>'+'*******'+stem+'</td>'+result;
  except result:=result+'<td>!!!'+f[0]+'??<b>'+f[1]+dg+'</b></td>';
  end;
  if yhtvok<>lchar then result:=result+'<td>'+yhtvok+'<b>'+lchar+'</b></td>';
  result:='<td>'+runko+'</td>'+result;
{  if flen=0 then
  else if flen=1 then
  begin

  end
  else
  begi n
    //if length(ast
  end;}
end;

function tstemmer.readline:word;
var ch:ansichar;st:ansistring;
begin
  result:=0;st:='';
  while not eoff do
  begin
     //if instr.Position>=instr.Size then begin eof:=true;break; end;
     if instr.Position>=instr.Size then begin writeln('EOFEOF*******');eoff:=true;break; end;
     instr.read(ch,1);
     if ch=#10 then break;
     if ch=',' then begin forms.add(st);st:='';result:=result+1;end else
     st:=st+ch;

  end;
end;

procedure tstemmer.vertaasana;
var i,j,k,k2,k3,xstemlen,stempos,tmuot,runlen:word;viat,wrd,xstem,stemguess,suffixes,afix,asto,echar,kons,vok,runko,kaantm,perusm,etumuoto:ansistring;ast:taste;instem:boolean; gfixes:tstringlist;//lka,olka,
op,onsuora,vaihtari:boolean;
//function tl1:string;begin result:='';if tavus.count>0 then result:=taka(tavus[0]);end;
//function tl2:string;begin result:='';if tavus.count>1 then result:=taka(tavus[1]);end;
//function salko:string;var ii:word;begin result:='';if tavus.count>2 then for ii:=2 to tavus.count-1 do result:=taka(tavus[ii]+result);end;

begin
suffixes:='';
  try
     //stem:=forms[1];
     wrd:=forms[1];
     tmuot:=strtointdef(copy(forms[0],2,3),999);
    if (tmuot<66) or (tmuot>75) then onsuora:=true else onsuora:=false;
     //stemlen:=length(stem);
     try
     ast:=getaste(forms[0][5]);
     except writeln('!!!!!!!!!!nosuffi');end;
     //if ast.a='_' then exit;
    runko:=taka(wrd);
    //IF TMUOT=52 THEN perusm:=copy(runko,1,length(runko)-2) //same as others? how to deal with differnt end-vowels?
    //ELSE
    if not onsuora then perusm:=copy(runko,1,length(runko)-2)  //verbit perusm loppuu aina aahan, sit‰ ei sen kummemmin tartte ihmetell‰
  else perusm:=copy(runko,1,length(runko)-2);

    //if perusm[length(perusm)]='d' then perusm:=copy(perusm,1,length(perusm)-1);//+'xxxxxxxxxxxxxxxxxxxxx';
    stempos:=0;
    if ast.t='-' then ast.t:='';
        //if (tmuot=67) then  perusm:=copy(perusm,1,length(perusm)-1); //vakio lla:
        if (tmuot=70) then  perusm:=copy(perusm,1,length(perusm)-1); //vakio sta
        if (tmuot=71) then  perusm:=copy(perusm,1,length(perusm)-1); //vakio hda

  kaantm:=perusm;
   if ast.a<>'_' then
  begin
      if (onsuora) then
      begin                   //suora astevaihtelu
       stempos:=rpos(ast.f,perusm);
       perusm:=copy(perusm,1,stempos-1)+ast.f+copy(kaantm,stempos+length(ast.f)) ;
       kaantm:=copy(kaantm,1,stempos-1 )+ast.t+copy(kaantm,stempos+length(ast.f));
      end else //k‰‰nteinen, inelegant to do these separately
      begin                   //toimii vain suoran astevaihtelun luokille, korjataan myˆhemmin
       stempos:=rpos(ast.t,perusm);
       if ast.t='' then begin stempos:=length(perusm);end;

       perusm:=copy(perusm,1,stempos-1 )+ast.t+copy(perusm,stempos+length(ast.t));
       kaantm:=copy(kaantm,1,stempos-1)+ast.f+copy(kaantm,stempos+length(ast.t));
      end;
    end;
   if (tmuot=63) then kaantm:=copy(kaantm,1,length(kaantm)-1)+'i';
   if (tmuot=64) then kaantm:=copy(kaantm,1,length(kaantm)-2)+kaantm[length(kaantm)]+'i';
   //!! if (tmuot=65) then delete(kaantm,length(kaantm),1);
    //if tmuot=64 then kaantm:=kaantm[1]+kaantm[3]+'i';
    for i:=1 to forms.count-1 do  //forms[i]:=karsiloppu(forms[i],mulls1[i]);
    if pos('?',forms[i])<1 then
     for j:=1 to min(length(forms[i]),length(runko)) do if forms[i][j]<>runko[j] then
      begin runko:=copy(runko,1,j-1);break;end;

    writeln('<tr><td style="width:20em"><b>',stempos,perusm,' (',ast.f,'/',ast.t,')  ',kaantm,'</b></td>');
   //   writeln('<tr><td>!',runko,'?',perusm,'!</td></tr>');

  //writeln(#10,#10,i,'*',forms[0],'/',stem,len,':');
  viat:='';
  for j:=1 to fcount-1 do  //ignore #o -taivinfo#1 NOM
  begin
    //write('<td>',copy(forms[j],length(runko)+1),'</td>');
     etumuoto:=taka(forms[j]);
     k:=1;wrd:='';
     vaihtari:=false;
     {while k<=length(perusm) do if (etumuoto[k]=perusm[k]) and (onsuora) then k:=k+1
      else if (etumuoto[k]=kaantm[k])  then begin onsuora:=false; k:=k+1;break; end
      else if (ast.t='') or (perusm[k-1]=copy(ast.t,length(ast.t))) then begin onsuora:=false;break;end
       else breaK;
       //voiko jotkut hassut konsonanttien esiintym‰t tehd‰ tepposia}
     if pos(perusm,etumuoto)=1 then wrd:=copy(etumuoto,length(perusm)+1) else
     if pos(kaantm,etumuoto)=1 then begin wrd:=copy(etumuoto,length(kaantm)+1);vaihtari:=true;end else
     begin wrd:='#'+etumuoto;viat:=viat+etumuoto+' ';end;

     //if onsuora then for k2:=k to length(perusm) do wrd:=wrd+'-'
     //else for k2:=k to length(kaantm) do wrd:=wrd+'-' ;
     //for k2:=k to length(etumuoto) do wrd:=wrd+etumuoto[k2];

    write('<td>',wrd,' ');
    if vaihtari then write('*');
    write('</td>');
    afix:=afix+','+wrd;if vaihtari then afix:=afix+'*';
       //if forms[1]='ovi' then writeln('|',stem,'++');
     //if forms[1]='adjektiivi' then  write('<td>',stemlen,forms[i],'</td></tr>');
  end;
  if viat<>'' then writeln('</tr><tr><td colspan="50" style="width:500em;color:red">',viat,'</td>');
  {if forms[0][5]<>'0' then  //astevaihtelua esiintyy
   BEGIN
     //if tmuot<33 then  //suora vaihtelu, , etsit‰‰n l‰htˆmuodon vikan konsonantin ensiesiityminen per‰st‰ p‰in laskien
     if tmuot<65 then  //suora vaihtelu, , etsit‰‰n l‰htˆmuodon vikan konsonantin ensiesiityminen per‰st‰ p‰in laskien
   begin
     for i:=length(forms[1])-1 downto 1 do
     if instem then stemguess:=forms[1][i]+stemguess else
     if (forms[1][i]=ast.f[1]) then instem:=true;
   end else  //k‰‰nteinen astevaih,
   begin
     if ast.t<>'-' then //etsit‰‰n lopusta p‰in eka vaihdetun muodon vikakonsonantti
     begin
      for i:=length(forms[1])-1 downto 1 do
       if instem then stemguess:=forms[1][i]+stemguess else
       if (forms[1][i]=ast.t[length(ast.t)]) then instem:=true;
     end else  //tyhj‰ vaihdettu muoto, runko loppuu loppuvokaaleja edelt‰v‰‰n konsonanttiin
     begin
      for i:=length(forms[1])-1 downto 1 do
       if instem then stemguess:=forms[1][i]+stemguess else
       if (pos(forms[1][i],'aeiou‰ˆ')>0) then
       begin
        //if (i>2) then continue else //and
        if (pos(forms[1][i+1],'aeiou‰ˆ')>0) then begin stemguess:=forms[1][i];instem:=true; end else
          instem:=true;
       end;// else begin end;
     end;
   END; //k‰‰nteinen
   END; //ASTEVAIHTELU,
  }

  finally writeln('</tr><tr><td colspan="20" style="width:500em">',afix,'</td></tr>');fixes.add(inttostr(tmuot)+','+ast.f+':'+afix);end;

end;

end.


var altforms:tstringlist;s:ansistring;asa,MASA:tstringarray;
begin
       altforms:=tstringlist.create;
  try
  try
   if fcount>15 then exit;
   oP:=true;//false;
   tmuot:=strtointdef(copy(masat[0],2,3),999);
  if  op then
  begin
   ast:=getaste(forms[0][5]);
    tavus.clear;
    hyphenfi(forms[1],tavus);
    //writeln('<tr><td>DOWORD:',tmuot,salko,'*',forms[0],'/a:',ast.a,'!</td></tr>');
    if tmuot<32 then begin  runko:=salko+taka(vperus);perusm:=taka(forms[1]); runlen:=length(runko);end
    else begin perusm:=salko+taka(vperuskaantein);runko:=taka(forms[1]);runlen:=length(perusm);end;
    if tmuot=27 then begin runko:=copy(runko,1,length(runko)-2);end;
    if tmuot=28 then begin runko:=copy(runko,1,length(runko)-2);end;
    if tmuot=38 then begin runko:=copy(runko,1,length(runko)-2);end;
    if tmuot=47 then begin runko:=copy(runko,1,length(runko)-2);end;
    if tmuot=19 then begin runko:=runko[length(runko)-2]+runko[length(runko)]+runko[length(runko)-1];end;
    if tmuot=49 then begin if runko[length(runko)]='e' then runko:=copy(runko,1,length(runko)-1);end;
    //writeln('<tr><td>!',runko,'?',perusm,'!</td></tr>');
    //if tmuot=32 then perusm:=perusm+'\\\'+tl2+':'+vperuskaan;
    //perusm:=copy(perusm,1,lengthperusm)-1);
    //runko:=copy(forms[1],1,length(forms[1])-length(runko));
    //perusm:=taka(tavus.commatext);
    try
    //for i:=1 to fcount-1 do  mulls1[i]:=karsiloppu(copy(forms[i],runlen),mulls1[i]);
    except writeln('<td>FAIL:',copy(forms[i],runlen),'#',fcount ,':',mulls2.commatext,i,'/failed</td>');end;
    if perusm<>runko then writeln(#10,'</tr><tr><td colspan="3">!!!',runko+'/',perusm+ ' <b>('+ast.f+'/'+ast.t+'.'+tavus[0]+')</b></td>')
     else writeln(#10,'</tr><tr><td colspan="3">??',runko,FORMS.COUNT,'/'+ ' <b>('+ast.f+'/'+ast.t+')</b></td>');
    {altforms.clear;altforms.add('');
    for i:=1 to forms.count-1 do  //k‰‰nt
      if pos('/',forms[i])<1 then altforms.add('')
      else
      begin
       altforms.add(copy(forms[i],pos('/',forms[i])+1));  //tmp - muodot.lst changed
       forms[i]:=copy(forms[i],1,pos('/',forms[i])-1);  //tmp - muodot.lst changed
      end;
    //sortalts(
     //if pos('/',altforms[i])>0 then altforms[i]:=copy(altforms[i],1,pos('/',altforms[i])-1);
     }
    for i:=1 to forms.count-3 do  //k‰‰nt
    begin
      //if pos('/',forms[i])>0 then forms[i]:=copy(forms[i],1,pos('/',forms[i])-1);
      //for i:=0 to mulls2.count-1 do
      if liimaa(perusm,mulls2[i])=taka(forms[i]) then
       write('<td><b>'+mulls2[i],' <small>',(forms[i]),'<small></b></td>')
      else if liimaa(runko,mulls2[i])=taka(forms[i]) then
        write('<td><em><b>'+mulls2[i],'</b> <small>',(forms[i]),'</small></em></td>')
      else   if liimaa(copy(perusm,1,length(perusm)-1),mulls2[i])=taka(forms[i]) then
       write('<td style="color:blue"><b>'+mulls2[i],'</b> <small>',(forms[i]),'</small></em></td>')
      else if liimaa(copy(runko,1,length(runko)-1),mulls2[i])=taka(forms[i]) then
       write('<td style="color:green"><b>'+mulls2[i],'</b> <small>',(forms[i]),'</small></em></td>')
      else
         write('<td style="color:red"><b>'+mulls2[i],'</b> <small>',(forms[i]),'//',liimaa(runko,mulls2[i]),'+',liimaa(perusm,mulls2[i]),'</small></td>');

      //write('<td style="color:white;background:black">',altforms[i],'::',mulls3[i],'</td>');
      //write('<td style="color:white;background:black">',altforms[i],'::',mulls3[i],'</td>');
      asa:=forms[i].split('/');for j:=0 to length(asa)-1 do
      write('<td style="color:white;background:black">',asa[j],'::');//,mulls3[i],'</td>');
      end;
    writeln('</tr>');
  end;
   //if stem<>stemguess then
  except write('<td>fail!</td>');exit;end;
  finally altforms.free;
  end;
end;

procedure tstemmer.findfuckingstems;
var alt,lu,mu,elen,lk,prevlk,lknum,inlk,lopslen:word;
 lopslen2,avpos,x:integer;
 stem,prevast,midsa,midsb,amidb,avahva,aheikko,vmuoto,pmuoto,tform,tform3,amids,color,lvok,mymid:ansistring;
 //hasav,hasmidb:boolean;
 ast:taste;
 curlka:tluokka;

procedure uusluokka;var ii:integer;
      begin  try
       //midsb:=midsb+','+inttostr(50+lknum)+':'+amidb;
       writeln('<li>AMIDS: ',amids);
       writeln('</ul>');
       if curlka<>nil then curlka.midsaft[1]:=(amids+'!');
       lknum:=lknum+1;
       writeln('<ul>');//<table border="1">');
       inlk:=0;
       prevast:='x';
       prevlk:=lk;
       amids:=',';
       curlka:=tluokka.create(lknum);
       if (lknum+50  in [59,60,62,63,64,65,68,69,70,71,77]) then curlka.hasav:=false else curlka.hasav:=true;
       if lknum+50 in [66,67,72,74,75] then curlka.hasmaft:=true else curlka.hasmaft:=false;
       curlka.expl:=explain(forms[0]);
       curlka.example:=(forms[1]);
       for ii:=1 to muotoja-1 do curlka.midsbef[ii]:=mids[lknum,ii];
       //move(mids[lknum],curlka.midsbef ,sizeof(mids[lknum]));
       luokat.add(curlka);
       writeln('<h4>',copy(forms[0],3,2),':',explain(forms[0]),curlka.hasmaft,curlka.hasav,'</h4>');//,'</h3>',lknum+50,' ',forms.commatext);
       writeln('luokkia:',luokat.count,'_',curlka.num,'_',lknum);
       except writeln('<li><em>???????',forms[1],'</em></li>');end;

     end;

begin
writeln('findstems!!!!!!!!!!!!<ul>');
curlka:=nil;
while not eof do
begin
     forms.clear;
     readline;
     write(' ', forms[1]);continue;
     if eof then break;
     if forms.count<2 then continue;
     if forms[1]='kerit‰' then continue;
     lk:=strtointdef(copy(forms[0],3,2),0);
     writel('<li>',lknum+50);
     if lk<>prevlk then uusluokka;
     avpos:=0;
     ast:=getastekons(forms[0][5],avahva,aheikko);
     tform:=taka(forms[1]);
     tform3:=taka(forms[3]);
     lastkons(copy(tform,1,length(tform)-1-length(mids[lknum,1])),lopslen2);
     lopslen2:=length(tform)-lopslen2;
     if lknum+50<63 then
     begin     //****************** vahvan vaihtelun luokat
      //if hasav then
      lopslen:=length(avahva+mids[lknum,1])+1;
      //if lknum+50=62 then lopslen:=lopslen-2;
      stem:=copy(tform,1,length(tform)-lopslen);
      pmuoto:=stem+avahva+mids[lknum,1]+'a';//+'|'+avahva+mids[lknum,1]+'a';
      vmuoto:=stem+aheikko+mids[lknum,3]+'n';//+'|'+avahva+mids[lknum,1]+'a';
      writeln('<li>',pmuoto,vmuoto);
     end else
     begin  //****************** heikon vaihtelun luokat
      if pos('/',forms[3])>1 then delete(tform3,1,pos('/',forms[3]));
      //if avahva<>'' then
      // avpos:=endpos(avahva,tform3)-1   //quick and dirty.. tutkitaan vahvasta muodosta. jatkossa ei haluta tehd‰ n‰in vaan etsi‰ simple s‰‰ntˆ
      //else    //  if avahva='' then //continue;//
      begin
       mymid:=mids[lknum,1];
        lopslen2:=+length(mymid)+length(avahva)+1;
        STEM:= copy(taka(forms[1]),1,length(tform)-lopslen2);  //luk
        lvok:=copy(taka(forms[1]),length(tform)-lopslen2+1,1);
        mymid:=stringreplace(mymid,'*',lvok,[rfReplaceAll]);
        pmuoto:=stem+aheikko+mymid+'a';
        vmuoto:=stem+avahva+mymid+'n';
        if tform=pmuoto then color:='blue' else color:='red';
        writeln('<li style="color:',color,'">',tform,' ',stem,'|',aheikko,'|',mids[lknum,1]+'a /',mymid);
        mymid:=mids[lknum,3];
        mymid:=stringreplace(mymid,'*',lvok,[rfReplaceAll]);
        if tform3=stem+avahva+mymid+'n' then color:='blue' else color:='red';
        writeln('<span style="color:',color,'">',tform3,' ',stem,'|',avahva,'|',mids[lknum,3]+'n [',lvok,'] ');
      end;
      continue;
      amidb:=copy(tform,avpos+1+length(aheikko));
      amidb:=copy(amidb,1,length(amidb){3}-length(avahva){!}-length(mids[lknum,1]) {2}); //=3 -
      lopslen:=length(aheikko+mids[lknum,1]+amidb)+1;
      lopslen2:=length(aheikko)+length(mids[lknum,1])+length(avahva)-length(aheikko)+1;
      STEM:= copy(taka(forms[1]),1,avpos);  //luk
      pmuoto:=stem+''+aheikko+''+amidb+''+MIDS[LKNUM,1]+'a';
      vmuoto:=stem+''+avahva+''+amidb+''+MIDS[LKNUM,3]+'n';
     end;
    if length(amidb)<2 then amids:=amids+amidb+',' else amids:=amids+'<b style="color:red">'+amidb+'</b>,'
end;
writeln('<hr><hr><hr>');
 listluokat;
 writeln('<hr><hr><hr>');
end;


procedure tstemmer.findstems;
var alt,lu,mu,elen,lk,prevlk,lknum,mknum,inlk,lopslen,j:word;
 lopslen2,avpos,x:integer;
 stem,prevast,midsa,midsb,amidb,avahva,aheikko,vmuoto,pmuoto,tform,tform3,amids,color,lvok,lkon,mymid:ansistring;
 //hasav,hasmidb:boolean;
 ast:taste;
 curlka:tluokka;
 heikot,vahvat,hudit,eiav:array [1..30] of word;
 theikot,tvahvat,thudit,teiav:array [1..30] of word;
 function mats(a,b:ansistring):boolean;
 var i:word;
 begin
 result:=false;
  if length(a)<>length(b) then exit;
  for i:=1 to length(a) do
   if a[i]<>b[i]
    then if pos(b[i],'#*')<1 then exit;
 result:=true;

 end;
procedure dwrd;var ii,len:word;
var valku,halku,muu,lkloppu,x,theikko:ansistring;heikkoko,huti:boolean;mm:word;
begin
  writeln('<tr><td style="color:',color,'">',tform,'</td><td> ',stem,'</td><td>',avahva,aheikko,'</td><td><b>+'+lvok,'</b></td><td style="border-right:3px solid black">',mids[lknum,1]+' </td>');
  //writeln('<td><b>',lvok,'/',lkon,'</b></td>');
  mm:=0;
  for ii:=1 to muotoja-2 do
   if not (ii+1 in [2,3,5,10,12,18,19,28,55,64,71]) then continue else
  begin

   mm:=mm+1;
   mymid:=stringreplace(mids[lknum,mm],'*',lvok,[rfReplaceAll]);
   mymid:=stringreplace(mymid,'#',lkon,[rfReplaceAll]);
   if lknum+50<64 then lkloppu:='' else lkloppu:=lvok;
   valku:=stem+avahva+lkloppu;
   halku:=stem+aheikko+lkloppu;
   lkloppu:='';
   while pos('-',mymid)=1 do
    begin
     delete(valku,length(valku),1);
     delete(halku,length(halku),1);
     delete(mymid,1,1);
     //writeln('<td>>X',valku,'/',halku,'</td>');
    end;
    if pos('/',forms[ii+1])>0 then forms[ii+1]:=copy(forms[ii+1],pos('/',forms[ii+1])+1);
    //valku:=copy(aheikko,1,length(aheikko)-1);mymid:=copy(mymid,2);end else theikko:=aheikko;
   heikkoko:=false;huti:=false;
   //vsana:=mats(taka(forms[ii+1]),stem+aheikko+lkloppu+mymid+yhtlopsall[ii])
   len:=length(mids[lknum,mm])+length(yhtlopsall[ii]);
     valku:=valku+''+lkloppu+mymid+''+yhtlopsall[ii];
     halku:=halku+''+lkloppu+mymid+''+yhtlopsall[ii];
     if taka(forms[ii+1])=halku then heikkoko:=true else
     if taka(forms[ii+1])=valku then heikkoko:=false else huti:=true;
      if huti then inc(hudit[mm]) else if avahva=aheikko then inc(eiav[mm]) else if heikkoko then heikot[mm]:=heikot[mm]+1 else inc(vahvat[mm]);
     //!if huti then color:='red' else if heikkoko then color:='blue' else color:='green';
     //!if mats(taka(forms[ii+1]),stem+theikko+lkloppu+mymid+yhtlopsall[ii]) then heikkoko:=true else
     //!if mats(taka(forms[ii+1]),stem+avahva+lkloppu+mymid+yhtlopsall[ii]) then heikkoko:=false else huti:=true;
     if huti then color:='red' else if heikkoko then color:='green' else color:='blue';
     writeln(' <td style="color:',color,'">',forms[ii+1]);
     if (huti) or (lknum+50=76) then writeln('\ ',valku,'\ ',halku,heikkoko,color);
     {if pos('*',mids[lknum,mm])>0 then write('*X');
     if pos('#',mids[lknum,mm])>0 then write('#X');
     if pos('-',mids[lknum,mm])>0 then write('-X');][}
     writeln('</td>');
     continue;
     //if tform=stem+aheikko+lvok+mymid+'a' then color:='blue' else color:='red';
     //if taka(forms[ii+1])=taka(copy(forms[ii+1],1,length(forms[ii+1])-len)+mids[lknum,ii]+yhtlopsall[ii]) then color:='black' else color:='red';
     //if mats(taka(forms[ii+1]),taka(copy(forms[ii+1],1,length(forms[ii+1])-len)+mids[lknum,ii]+yhtlopsall[ii])) then color:='black' else color:='red';
     //      if pos('/',forms[ii+1])>0 then color:='blue';
           //!!writeln(' <span style="color:',color,'">',taka(forms[ii+1]),'=',stem+'<b>'+ifs(heikkoko,aheikko,avahva)+'</b>!'+lkloppu+'.'+mymid+'\',yhtlopsall[ii]+'</span> ');
           //writeln(' <span style="color:',color,'">',copy(forms[ii+1],1,length(forms[ii+1])-len),'<b title="',forms[ii+1],'">',mids[lknum,ii],'</b>|',yhtlopsall[ii],'</span> ');
           //writeln(' <li><span style="color:',color,'">',taka(forms[ii+1]),'=',stem+'|'+'<b>'+avahva+'</b>!'+lkloppu+'.'+mymid+'\'+yhtlopsall[ii]+'</span>_',valku,'_&nbsp;');
           //writeln(' <em>',stem+'<b>'+theikko+'</b>!'+lkloppu+'.'+mymid+'\',yhtlopsall[ii]+'</em> <b>! ',mids[lknum,mm],'</b>'+stem+theikko+lkloppu+mymid+yhtlopsall[ii],' _',halku,'_');
  //         writeln(' <li><span style="color:',color,'">',taka(forms[ii+1]),'=',stem+'|'+'<b>'+avahva+'</b>!'+lkloppu+'.'+mymid+'\'+yhtlopsall[ii]+'</span>_',valku,'_&nbsp;');
  //         writeln(' <em>',stem+'<b>'+theikko+'</b>!'+lkloppu+'.'+mymid+'\',yhtlopsall[ii]+'</em> <b>! ',mids[lknum,mm],'</b>'+stem+theikko+lkloppu+mymid+yhtlopsall[ii],' _',halku,'_');
       end;
end;

