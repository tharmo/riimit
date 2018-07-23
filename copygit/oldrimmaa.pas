unit oldrimmaa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math;

type tnomlka=record kot,ekakon,vikakon:word;end;
type tnomlkon=record ekavok,vikavok:word;kon:array[0..0] of char;end;
type tnomlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tnomav=record ekasana,vikasana:word;h,v:char;end;
type tsana=string[15];
//type tsana=array[0..15] of ansichar;//record letters:array[0..16] of ansichar;end;

type tnominit=class(tobject)
var
//lmmids:array[0..49] of array[0..24] of array[0..8] oF ANSICHAR;  //would this be more efficient?
lmmids:array[0..49] of array[0..24] of ANSIstring;
 // lk:60 lv:130 av:683
 lkat,lktot,latot,avtot,taivluokkia:word;
 lUOKS:array[0..700] of tnomlka;
 AVS:array[0..700] of tnomav;
 KONS:array[0..160] of tnomlkon;
 VOKS:array[0..160] of tnomlvok;
 //sanat:array[0..27816] of tsana;
 sanat:array[0..30000] of tsana;
 soinnut:array[0..30000] of boolean;
LKA_N,MU_N,kon_n,vok_n,av_n,san_n:word;

procedure etsi;
procedure haesijat(haku:ansistring;sikalauma:tstringlist);
procedure luemuodot(muotofile:string);
procedure lataasanat(lfile:string);
procedure listaasanat;
procedure listaamuodot;
constructor create;
end;

implementation
USES NOMUTILS,strutils;
function riimaako(w1,w2:tsana):boolean;
var len,i:byte;
begin


{   len:=BYTE(w[0]);
   for i:=1 to LEN do
   try
   asana:=sanat[sa];
   sopii:=true;
   for le:=1 to min(15,length(sopiva)) do if sanat[sa][le]=#0 then begin break;end
   else if sopiva[le]<>sanat[sa][le] then
   begin
     //writeln('(NE:',le,sanat[sa][le],sopiva[le],')');
     sopii:=false;break;
   end
   ;//else writeln('[+',le,sanat[sa][le],sopiva[le],'+]');
   if not sopii then continue;
   writeln('<h3>Hit: ');
   for le:=15 downto 1 do if sanat[sa][le]<>#0 then //break else
   write(sanat[sa][le],'');
   writeln(aav,avok,lopkon,amid,alop,'  ',luoks[lu].kot,' ',sa);
   writeln('</h3><li> _',avs[av].v,' ',avs[av].h,' ',voks[vo].vok,' ',kons[ko].kon,' ',lmmids[lu,muoto],' ',paatteet[muoto]);
   except writeln('failhit');end;
}
end;
// writeln('<h2>av:',avcount,' lk:',lkcount,' lv:',lvcount,'</h2>');exit;

constructor tnominit.create;
begin
  lka_n:=50;
  mu_n:=25;
  fillchar(luoks,sizeof(luoks),0);
  fillchar(kons,sizeof(kons),0);
  fillchar(voks,sizeof(voks),0);
  fillchar(avs,sizeof(avs),0);
  fillchar(sanat,sizeof(avs),0);
  luemuodot('muodot3.lst');
  listaamuodot;
  writeln('<li>luettu muodot');
  lataasanat('noms4.csv');
  writeln('<li>ladattu sanat');
 end;


procedure tnominit.haesijat(haku:ansistring;sikalauma:tstringlist);
var i,lk:integer;mylop,alku:ansistring;j:ptrint;a:ansichar;
begin
 // if pos(
for j:=0 to 24 do
 begin
    mylop:=paatteet['{028AAEA3-0363-4DC9-B8AD-FE2E7749347D}'][j]; //hanskaa '*' sijamuodon päätteessä!
    if pos('*',mylop)=1 then
    begin  //illatiivissä
      a:=haku[length(haku)-1];
      if pos(a,vokaalit)>0 then
       if haku[length(haku)-2]=a then
       mylop:=copy(haku,length(haku)-1);
       //lop[1]:=haku[length(haku)-1];
       //if haku='1punokseen' then writeln('xaaaaa:',mylop);
    end;
    //writeln('???',j,haku,'[',mylop,']');
   if matchendvar(haku,mylop,alku) then
   begin
    sikalauma.addobject(alku,tobject(j));
    //writeln('+++',j);
   end;
 end;
end;

function matchmid(haku,mymid:ansistring;var cut,xvok:integer;var alku,lopkon:ansistring):boolean;
begin
  cut:=0;lopkon:='';
  xvok:=0;
  write('<li><b style="color:green">['+mymid,']</b>',length(mymid),haku,length(haku),'-&gt;');
  while pos('-',mymid)=1 do begin delete(mymid,1,1);cut:=cut+1;end;
  try
  if pos('*',mymid)=1 then
  begin     //1sammalee     9   -   2   -0      =7
    lopkon:=haku[length(haku)-length(mymid)+1];
    //writeln('X',haku[length(haku)-length(mymid)],length(haku)-length(mymid),'X');
    //whatever goes instead of *, but it will be checked at next stage. lka 28 miti vielä
   // delete(mymid,1,1);
    mymid[1]:=lopkon[1];
  end;
  if haku<>'' then if pos('_',mymid)=1 then begin xvok:=1;//haku[length(haku)];
     delete(mymid,1,1);
      //mymid[pos('_',mymid)]:=xvok[1]
      end;//whatever goes, and s forgotten
  result:=matchendvar(haku,mymid,alku);
  writeln('<li>',haku,' <b style="color:red">[',mymid,'/',xvok,']</b>/alku',alku,'/lopkon:',lopkon,'/cut:',cut,'</li>')
except writeln('failmatchmid:',haku,'/',mymid);raise;end;
end;

procedure tnominit.etsi;
var ha,lu,si,ko,vo,av,sa,le,salu,i:word;
 hakusanat,sikalauma,resus,riimit:tstringlist;
 hakutaka:boolean;
 hakusana,sika,lopkon,sopiva:ansistring;
 lka_a,kon_a,vok_a,av_a:ansistring;
 amid,avok,aav,asana,alop:ansistring;
 cut,mycut,xvok,muoto:integer;
 avvahvat,sopii,etuko,p:boolean;
begin
 p:=false;
 p:=true;
 hakusanat:=tstringlist.create;
 sikalauma:=tstringlist.create;
 resus:=tstringlist.create;
 haehaku(hakusanat,'haku.lst');
 // exit;
 //lu:=0;ko:=0;vo:=0;av:=0;
     riimit:=tstringlist.create;

 for ha:=0 to hakusanat.count-1 do
 begin
   hakusana:=hakusanat[ha];
   sikalauma.clear;
   haesijat(hakusana,sikalauma);

   if hakusana[1]='1' then hakutaka:=true else hakutaka:=false;
   delete(hakusana,1,1);
   //for salu:=0 to o
   //matchsijat
   if p then writeln('<h2>trysana:',hakusana,'</h2><li>',sikalauma.commatext,'</ul>');
   for si:=0 to sikalauma.count-1 do  //perusmuoto on/ei tilapäis. mukana
   begin
     sika:=sikalauma[si];
     muoto:=ptrint(sikalauma.objects[si]);
    // if muoto<>5 then continue;
     if p then writeln('<li>SIKA:',sika,'#',muoto,'::',sikalauma.commatext,'</li><li>');
     if p then for lu:=0 to 48 do writeln('|',lmmids[lu,muoto]);
     if p then writeln('<li> (',lu,'#',muoto,'/',sika,')x <hr>') ;
     if p then writeln('<ul>');
     for lu:=0 to 48 do //lka_n do
     begin
       //if lu<>40 then continue;
       if muoto=990 then
       begin   //pikkasen esikarsintaa ettei tartte kaikkia perusmuotoja käydä läpi
         if (lu<31) or (lu=47) then if pos(sika[length(sika)],vokaalit)<1 then continue;
         if lu>30 then if pos(sika[length(sika)],konsonantit)<1 then if lu<>47 then continue ;
       end;
       if p then writeln('<li> (',lu,'#',muoto,'/',sika,')x <hr>') ;
       alop:= copy(hakusana,length(sika));
       if (lu<31) then if muoto in [0,2,5,9,13,14,17,21] then avvahvat:=true else avvahvat:=false;
       if (lu>30) then if (muoto in [0,2]) then avvahvat:=false else avvahvat:=true;
       amid:=lmmids[lu,muoto];
       if p then writeln('<h4>lka:',lu+1,'#',muoto,'  ',sika,'/',amid,':',paatteet[muoto],'</h4><ul>');
       lopkon:='';


       if matchmid(sika,lmmids[lu,muoto],cut,xvok,lka_a,lopkon) then
       begin //LKA
         //1samma|1sammalee     9          3
         amid:=copy(sika,length(lka_a)+length(lopkon)+1);
         if p then writeln('<li>OK:<b>',lka_a,'</b>mid:',lmmids[lu,muoto],'(lop:',alop,'!</b> ',luoks[lu].ekakon,'...',luoks[lu].vikakon,'//',lopkon,'\\\<b>',alop,'</b>',hakusana,'--',cut) ;
         for ko:=luoks[lu].ekakon to luoks[lu].vikakon do writeln('(',kons[ko].kon,')');
         if p then writeln('<ul>');
         for ko:=luoks[lu].ekakon to luoks[lu].vikakon do
         begin    //KON
           //lopkon:='';
           kon_a:=lka_a;  //muista luokka 28
           if (lopkon='')  or //(lopkon=kons[ko].kon) then
              (matchendvar(lka_a,lopkon,kon_a)) then
              //if ((lopkon='') and (kons[ko].kon='_')) or matchendvar(lka_a,kons[ko].kon,kon_a) or false then
           begin  //KON
              if p then writeln('<li>kon<b>:',lopkon,'/</b> /alku:'+kon_a,': ',kons[ko].ekavok,'..', kons[ko].vikavok ,' ') ;
              if p then
               for vo:=kons[ko].ekavok to kons[ko].vikavok do
                writeln(' {-',voks[vo].vok,'-} ',cut);
              if p then writeln('<ul>');
              for vo:=kons[ko].ekavok to kons[ko].vikavok do
              begin  //VOK
                mycut:=cut;
                avok:=trim(voks[vo].vok);
                if p then if lu=18 then writeln('*******',avok,'/',lmmids[lu,muoto],' '); //kuinka ad hoc sitä voidaankaan olla. toisaalta, kyseessä kuusi hyvin poikkeavaa sanaa, turha niille keksiä logiikkaa
                if (lu=18) and (pos('--',lmmids[lu,muoto])>0) then  avok:=avok[2] //+'i'
                //if xvok<>avok then continue;
                else
                for i:=1 to mycut do if avok<>'' then begin mycut:=mycut-1;delete(avok,length(avok),1);end;
                if p then write('<li>*(((',avok,length(avok),')))*');
                if matchendvar(kon_a,avok,vok_a) then
                 //if matchendvar(kon_a,copy(voks[vo].vok,1,length(voks[vo].vok)-cut),vok_a) then
                begin  //VOK
                  //aav:= ifs(avvahvat,avs[av].v,avs[av].h)
                  if p then writeln('<li>vok:<b>[',avok,']</b>: ',vok_a,mycut);
                   //    while cut>0 do if myvok<>'' then begin delete(myvok,length(myvok),1);cut:=cut-1;end else break;
                   if p then
                  for av:=voks[vo].ekaav to voks[vo].vikaav do
                   writeln(' (',avs[av].v,'|',avs[av].h,'=',ifs(avvahvat,avs[av].v,avs[av].h),') ');
                  if p then writeln(avok,'<ul>');
                  for av:=voks[vo].ekaav to voks[vo].vikaav do
                  begin
                    //avok:=voks[av].vok;
                    if lu<>18 then for i:=1 to cut do if avok<>'' then begin cut:=cut-1;delete(avok,length(avok),1);end;
                    if matchendvar(vok_a,ifs(avvahvat,avs[av].v,avs[av].h),av_a) or false then
                    begin   //AV
                      //while cut>0 do if thisav<>'' then begin delete(thisav,length(thisav),1);cut:=cut-1;end else break;
                      aav:=trim(ifs(avvahvat,avs[av].v,avs[av].h));
                      if p then writeln('<li>AV:<b>[',avs[av].v,avs[av].h,'=',aav,']</b> ',av_a,' ',avs[av].ekasana,', ',avs[av].vikasana,'=',avok,'!<ul>');
//                      while mycut>0 do if avok<>'' then begin delete(avok,length(avok),1);mycut:=mycut-1;end else break;
                      try
                      sopiva:='';//av_a;s
                      sopii:=false;  //sopii=onko menty ekan konsonantin ohi /ignoroi toiseksi kaksoiskonsonanttien vaaran
                      for le:=2 to length(av_a) do  //  //ignoroi etu/taka-indikaattorin
                      begin
                       if not sopii then sopii:=pos(av_a[le],vokaalit)>0;
                       if sopii then sopiva:=sopiva+av_a[le];
                      end;
                      sopiva:=ansireversestring(sopiva);
                      // while (sopiva<>'') and (pos(sopiva[length(sopiva)],vokssliy)>0) do delete(sopiva,length(sopiva),1);

                      except writeln('?!');end;
                       //if lu=17 //then if sanat[sa]=''        then writeln('<li>try:',' ',sanat[sa],'/',asana,'/',ansireversestring(av_a),sopii,(trim(av_a)='') ,av_a);


                      //writeln('<li>test:',av_a,'/',sopiva,'\%: ');
                      if p then
                      for sa:=avs[av].ekasana to avs[av].ekasana+2 do //min(avs[av].vikasana,avs[av].ekasana+5) do
                      writeln(' +',sanat[sa]);
                      for sa:=avs[av].ekasana to avs[av].vikasana do //min(avs[av].vikasana,avs[av].ekasana+5) do
                      begin  //SANA
                          try
                          //asana:=sanat[sa];
                          //sopii:=true;
                          if (sanat[sa]='') or (pos(sopiva,sanat[sa])=1)  then sopii:=true
                          else
                          begin  //sana  oli lyhkäsempi kuin haku
                            sopii:=false;
                            asana:='';
                             if p then if lu=18 //then if sanat[sa]=''
                              then writeln('<li>try:',avok,'/',sanat[sa],'/',asana,'/',ansireversestring(av_a),sopii,(trim(av_a)='') ,av_a);
                             {if (length(sanat[sa])=1) AND (POS(SANAT[SA][1],konsonantit)>0) then
                             begin
                                sopii:=true;

                             end else}
                            for le:=length(sanat[sa]) downto 1 do  //  //missä etu/taka-indikaattori? itse sanassa ei sitä ole?
                            begin               //sana: 1to
                             if not sopii then sopii:=pos(sanat[sa][le],vokaalit)>0;
                             if sopii then asana:=sanat[sa][le]+asana;
                             //if sopii then writeln('***',asana);
                            end;
                            if (av_a='') or (pos(asana,ansireversestring(av_a))=1) then sopii:=true else sopii:=false;
                            if (length(sanat[sa])=1) AND (POS(SANAT[SA][1],konsonantit)>0) then sopii:=true;
                            if p then if sopii then  writeln('<li>HIT:XXX', ansireversestring(sanat[sa]),'.'
                             ,aav,avok,lopkon,amid,alop,'  ',luoks[lu].kot,' ',sa,paatteet[muoto],'//',asana,'//',av_a,'!');
                          end;
                          if not sopii then  continue;
                          if p then  writeln('<h3>HIT:{',ansireversestring(sanat[sa]),'.',aav,'_',avok,'_',lopkon,'.',amid,'.',alop,'}  ',luoks[lu].kot,' ',sa,paatteet[muoto],length(sanat[sa]));
                          resus.add(ifs(soinnut[sa],'1','0')+ansireversestring(sanat[sa])+aav   +avok+lopkon+amid+alop);
                          writeln('<li>',resus[resus.count-1],'!');
                          {
                          for le:=1 to min(15,length(sopiva)) do if sanat[sa][le]=#0 then begin break;end
                          else if sopiva[le]<>sanat[sa][le] then
                          begin
                            //writeln('(NE:',le,sanat[sa][le],sopiva[le],')');
                            sopii:=false;break;
                          end
                          ;//else writeln('[+',le,sanat[sa][le],sopiva[le],'+]');
                          if not sopii then continue;
                          iteln('<h3>Hit: ');
                          for le:=15 downto 1 do if sanat[sa][le]<>#0 then //break else
                          write(sanat[sa][le],'');
                          writeln(aav,avok,lopkon,amid,alop,'  ',luoks[lu].kot,' ',sa);
                          }
                          if p then writeln('</h3><li> _',avs[av].v,' ',avs[av].h,' ',avok,' ',kons[ko].kon,' ',lmmids[lu,muoto],' ',paatteet[muoto],muoto);

                          except writeln('failhit');end;
                      end;
                      if p then writeln('</ul>');
                    end   //AV
                    ;//else writeln('<li>!',vok_a,avvahvat,avs[av].v,avs[av].h ,'=',ifs(avvahvat,avs[av].v,avs[av].h),'//',av_a,'//',vok_a);
                  end;    //AV
                  if p then writeln('</ul>');
               end; //VOK
              end;  //VOK
              if p then writeln('</ul>');
           end;  //KON
         end;    //KON
         if p then writeln('</ul>');
       end  //LKA
       else
       if p then writeln('<strike>',muoto,sika,lmmids[lu,muoto],'</strike> ');
       if p then writeln('</ul>');
     end;
     if p then writeln('</ul>');
   end;
   //sana:=
   hakusana:=copy(hakusanat[ha],2);
   etuko:=hakusanat[ha][1]='1';
   //hakusana:=ifs(etuko,copy(hakusanat[ha],2),etu(copy(hakusanat[ha],2)));
   if p then writeln('<h1>TULOS:',hakusana,'|',hakusanat[ha],'</h1>');
   writeln('<li>RES:',resus.commatext);

   tsekkaatavut(hakusana,etuko,resus,riimit);
 end;
 writeln('<hr><li>lopputulema:',(riimit.commatext));
 for i:=0 to riimit.count-1 do
   writeln('<li>',riimit[i]);
 resus.clear;
 //for sa:=0 to 100 do writeln(sanat[sa],' ');
end;

procedure tnominit.listaasanat;
var lu,ko,vo,av,sa,le:integer;
begin
 // exit;
 //lu:=0;ko:=0;vo:=0;av:=0;
writeln('<dl>');
 for lu:=0 to 49 do //lka_n do
   for ko:=luoks[lu].ekakon to luoks[lu].vikakon do
    for vo:=kons[ko].ekavok to kons[ko].vikavok do
      for av:=voks[vo].ekaav to voks[vo].vikaav do
        begin
          writeln('<dt>*',lu,'/',ko,'/',vo,'/',av,':',luoks[lu].kot,' :<b>',kons[ko].kon,'.',voks[vo].vok,'.',avs[av].v,'</b>: ',avs[av].ekasana,'..',avs[av].vikasana);
          writeln('<dd>');
          if voks[vo].vok='' then writeln('?????');
          for sa:=avs[av].ekasana to avs[av].vikasana do
          begin
            writeln(' ',ansireversestring(sanat[sa]));
            //for le:=15 downto 1 do if sanat[sa][le]=#0 then continue else   write(sanat[sa][le]);
          //for le:=1 to 15 do if sanat[avs[av].vikasana][le]=#0 then break else   write(sanat[sa][le]);
          end;
        end;
end;

procedure tnominit.luemuodot(muotofile:string);
var ms,mline:tstringlist;i,j,k:word;
begin
 ms:=tstringlist.create;
 mline:=tstringlist.create;
 try
  ms.loadfromfile(muotofile);
  taivluokkia:=ms.count;
  for i:=0 to ms.count-1 do
  begin
   mline.commatext:=ms[i];
   try
   mline.delete(0);
   for j:=0 to mline.count-1 do
    lmmids[i][j]:=mline[j];
     //for k:=1 to min(8,length(mline[j])) do
     //lmmids[i][j][k]:=mline[j][k];
   except writeln('<li>faillka:',j,mline.commatext);end;
  end;
   finally ms.free;mline.free;end;
 end;
procedure tnominit.listaamuodot;
var i,j,k:word;
begin
  for i:=0 to 48 do
  begin
    writeln('<li>',i,' ');
   for j:=0 to 23 do
   begin write(' | ');
    writeln( lmmids[i][j]);
     //for k:=1 to 0 do
     //  writeln( lmmids[i][j][k]);
    end;
  end;
end;

procedure tnominit.lataasanat(lfile:string);  //opetallaan lukemaan listausta tehokkaasti
var //ifile:textfile;
awl,owl:tstringlist;i,j,dif,c,ccc,lka,maxlen:integer;
thisvahva,eka:boolean;
sana,runko,v,h,lopvok,myvok,mymid,lopkon,mylop,mto,av,debst:ansistring;
asana:tsana;
otuscounts:array[0..4] of integer;
listafile:textfile;
pseudolka,clka,cvok,ckon,cav,csana:integer;
cut:integer;
p:boolean;
begin
 p:=false;
  assign(listafile,lfile);
  //nomsall3.csv
  reset(listafile);
  for j:=0 to 4 do otuscounts[j]:=0;
  i:=0;
  maxlen:=0;
 awl:=tstringlist.create;
 owl:=tstringlist.create;
 readln(listafile,sana);
 owl.commatext:=sana;//'0,x,x,x,x,x';//sana;
 //sanat[0]:=aws[5];
 //luoks[0].ekakon=;kons[0].ekavok:=0:voks[0].ekaav:=0;
 luoks[0].kot:=1;kons[0].kon:=owl[1];voks[0].vok:=owl[2];//avs[0].v:=owl[3];//sanat[0]:='adagio';
 if p then writeln('<ul style="line-height: 90%"><li>001<ul><ul><li>_<ul><li>*<ul><li>',sana);
 ccc:=0;
 lka:=0;
 clka:=0;cvok:=0;ckon:=0;cav:=0;csana:=0;
 eka:=true;
 writeln('<ul>');
 while not eof(listafile) do
   begin
      try
      readln(listafile,sana);
      //writeln(' *',sana);
      //if eof(listafile) then begin writeln('<li>EOF:',sana,'<li>',awl.commatext,'<li>',owl.commatext);continue;end;
      awl.commatext:=sana;
      //if eka then begin owl.commatext:=sana;eka:=false;continue;end;
      //if p then if not eka then      write(' ',awl[0],awl[5]);
      if awl.count<5 then begin writeln('<h2>eptayd:',sana,'</h2>');csana:=csana+1;continue;end;
      if length(awl[0])>15 then
       begin  writeln('<h2>LONG:',sana,'</h2>');csana:=csana+1;continue;end; ;
      //if maxlen<length(aw[5]) then maxlen:=length(aw[5]);    if length(aw[5])>15 then writeln('<li>',aw[5]);continue;
      dif:=4;

      //deb:='';
      //if aw[5]='pee' then writeln('<h1>',sana,'</h1>');
      //if p then if awl[0]<>owl[0] then
      // writeln('<h4><b>',clka-1,' </b>',owl.commatext, ' / ',awl.commatext,'</h4>');
      for i:=0 to 3 do
       if awl[i]<>owl[i] then begin dif:=i;break;end;
      //if clka>45  then writeln('<li>',awl.commatext, ' <b>>>',dif,'</b> ',clka,' ',ckon,' ',cvok,' ',cav,' ',csana);
      if (dif<1) then //or eka then  //UUSI TAIVUTUSLUOKKA
      begin
        //if not eka then
         luoks[clka].vikakon:=ckon;
        clka:=clka+1;
        luoks[clka].ekakon:=ckon+1;
        luoks[clka].kot:=strtointdef(awl[0],99);
        //deb:=deb+'L'+inttostr(clka);
        //if p then writeln('<li><b>',clka-1,' </b>',owl.commatext, ' / ',awl.commatext,'</li>');
      end;// else     deb:=deb+'___';

      except writeln('faillka');end;
      try
      if (dif<2) then //or eka then  //UUSI LOPPUKONSONANTTI
      begin
          //if not eka then
           kons[ckon].vikavok:=cvok;
          ckon:=ckon+1;
          //deb:=deb+' k'+inttostr(ckon);
          kons[ckon].ekavok:=cvok+1;
          kons[ckon].kon:=awl[1];end;//  else      deb:=deb+'---';
      except writeln('failkon');end;
      try

      if (dif<3) then //or eka then //UUSI VOKAALI
       begin
         voks[cvok].vikaav:=cav;
         cvok:=cvok+1;
         voks[cvok].ekaav:=cav+1;
         //deb:=deb+' v'+inttostr(ckon);
         //voks[cvok].vok:=ansireversestring(awl[2]);end;//  else      deb:=deb+'___';
         voks[cvok].vok:=(awl[2]);end;//  else      deb:=deb+'___';
      except writeln('failvok');end;
      try
      if (dif<4) then //or eka then //UUSI ASTEVAIHTELULUOKKA
       begin
         avs[cav].vikasana:=csana;
         cav:=cav+1;
         avs[cav].ekasana:=csana+1;
         if length(awl[3])>0 then avs[cav].v:=awl[3][1];
         if length(awl[3])=2 then avs[cav].h:=awl[3][2];
         //deb:=deb+' a'+inttostr(cav);

       end;//  else      deb:=deb+'___';
      except writeln('failav');end;
      //if dif<4 then writeln('<li>',deb);
      try
      //eka:=false;
       //cut:=min(1,15-length(aw[5]));
       //for j:=length(aw[5]) downto 1 do
      csana:=csana+1;// else eka:=false;
      sanat[csana]:=ansireversestring(awl[5]);
       soinnut[csana]:=awl[4]='1';
      // for i:=length(awl[5]) downto 1 do //cut do
       //   if pos(awl[5][i],'aou')>0 then soinnut[csana]:=true;
     //     sanat[csana][length(awl[5])-j+1]:=awl[5][j];
       //if not eka then
      //if clka>45   then writeln( ' <br>///',clka,' ',ckon,' ',cvok,' ',cav,' ',csana,'<li>:Deb: ',deb,'<li>',avs[cav-1].vikasana,'/',avs[cav].ekasana);

       //if csana>2100 then break;
      except writeln('failsana');end;
      owl.commatext:=sana;
     if eof(listafile) then //if 1=0 then
      begin writeln('<li>EOF:',sana,'<li>',awl.commatext,'<li>',owl.commatext);
        luoks[clka].vikakon:=ckon;
        kons[ckon].vikavok:=cvok;
        voks[cvok].vikaav:=cav;
        avs[cav].vikasana:=csana;
        //if clka>45   then writeln( ' <br>///',clka,' ',ckon,' ',cvok,' ',cav,' ',csana,'<li>:Deb: ',deb,'<li>',avs[cav-1].vikasana,'/',avs[cav].ekasana);
        //if clka>45   then writeln( ' <br>///',clka,' ',ckon,' ',cvok,' ',cav,' ',csana,'<li>:Deb: ',deb,'<li>',avs[cav-1].vikasana,'/',avs[cav].ekasana);

        break;
      end;
   end;
//  kon_n:=ckon;vok_n:=cvok;av_n:=cav;san_n:=csana;
   //EXCEPT END;
 end;
end.

